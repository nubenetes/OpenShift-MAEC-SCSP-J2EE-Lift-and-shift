# ⚙️ Calibración de la JVM Java 8 y Sondas de Resiliencia

> [!WARNING]
> **Aviso:** Documentación generada con **Gemini 3.8 Flash** como blueprint didáctico conceptual.

---

## 1. El Conflicto Histórico entre Java 8 y los cgroups de Linux

La versión 8 de Java fue diseñada en una época donde los servidores eran máquinas dedicadas con acceso a la memoria RAM física completa. Al ejecutarse dentro de un contenedor en Kubernetes con restricciones de cgroups (ej. `limits: memory: 3Gi`), versiones antiguas de Java leían la memoria del nodo anfitrión (ej. 128 GB) y dimensionaban un Heap del 25-50% del nodo (32-64 GB), provocando que el kernel matara el proceso mediante el **OOMKiller**.

### Solución Declarativa en JBoss Web Server (JWS 5.4):
Las imágenes certificadas de Red Hat JWS incorporan scripts de inicio que procesan variables de entorno porcentuales:

```yaml
env:
  - name: JAVA_MAX_MEM_RATIO
    value: "70.0"
  - name: JAVA_OPTS_APPEND
    value: "-XX:+UseG1GC -Djava.security.egd=file:/dev/./urandom -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager"
resources:
  requests:
    memory: "1.5Gi"
    cpu: "500m"
  limits:
    memory: "3Gi"
    cpu: "2"
```

### Desglose Matemático del Reparto de Memoria:
- **Límite total del pod:** 3.0 GiB (3072 MB).
- **Heap Máximo (`JAVA_MAX_MEM_RATIO=70.0` / `-XX:MaxRAMPercentage=70.0`):** 70% de 3072 MB = **2150 MB (~2.1 GiB)**.
- **Colchón de Seguridad Off-Heap (30% restante = ~922 MB):** Reservado estrictamente para:
  - Metaspace de clases Java.
  - Memoria nativa de hilos de ejecución de Tomcat (Stack per thread: `-Xss1m`).
  - Buffers de sockets y protocolo de red HotRod hacia Infinispan.
  - Procesamiento criptográfico de certificados digitales de firma X.509.
  - Overhead del sistema operativo RHEL 8 base.

---

## 2. Calibración de Sondas de Resiliencia (Liveness y Readiness)

Los monolitos J2EE pesados presentan tiempos de arranque asimétricos (*slow warm-up*). En el inicio, Tomcat debe desplegar el WAR, inicializar pools de conexiones JDBC hacia SQL Server y verificar la conectividad con Infinispan.

Una sonda demasiado agresiva (`initialDelaySeconds: 5` o `10`) provocaría una condición de **CrashLoopBackOff**, donde Kubernetes reinicia el contenedor antes de que haya terminado de arrancar.

### Configuración Calibrada para SCSP:

```yaml
livenessProbe:
  httpGet:
    path: /scsp/management/health
    port: 8080
    scheme: HTTP
  initialDelaySeconds: 90
  periodSeconds: 15
  timeoutSeconds: 5
  successThreshold: 1
  failureThreshold: 4

readinessProbe:
  httpGet:
    path: /scsp/management/ready
    port: 8080
    scheme: HTTP
  initialDelaySeconds: 60
  periodSeconds: 10
  timeoutSeconds: 5
  successThreshold: 1
  failureThreshold: 3
```

### Comportamiento Operativo:
- **Readiness (Preparación):** Concede **60 segundos** iniciales. Hasta que `/scsp/management/ready` no devuelva código HTTP 200, el pod no recibe tráfico del Service ni de la Route de OpenShift, evitando que peticiones ciudadanas caigan en un contenedor no inicializado.
- **Liveness (Vitalidad):** Concede **90 segundos** de gracia. Si tras el arranque el contenedor sufre un interbloqueo (*deadlock*) y falla 4 comprobaciones consecutivas (60 segundos de fallos continuos), el orquestador reinicia el pod automáticamente.
