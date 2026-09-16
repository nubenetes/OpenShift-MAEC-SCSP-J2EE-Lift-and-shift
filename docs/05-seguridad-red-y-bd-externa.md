# 🛡️ Seguridad Perimetral y Abstracción de Base de Datos Externa

---

<p align="center">
  <b>Página Anterior:</b> <a href="04-gestion-sesiones-infinispan.md"><b>⬅️ 04. Gestión de Sesiones con Infinispan</b></a> &nbsp;|&nbsp;
  <b><a href="../README.md">🏠 <b>Home / README</b></a></b> &nbsp;|&nbsp;
  <b>Página Siguiente:</b> <a href="06-tuning-jvm-y-probes.md"><b>06. Tuning JVM y Probes ➡️</b></a>
</p>

---

> [!WARNING]
> **Aviso:** Documentación generada con **Gemini 3.8 Flash** como blueprint didáctico conceptual.

---

## 1. Abstracción Topológica de Base de Datos Externa (Service + Endpoints)

El servidor **Microsoft SQL Server** donde reside la base de datos de SCSP no se migra a contenedores, sino que se mantiene en la infraestructura clásica de máquinas virtuales / bare-metal en la Red SARA con la IP fija `10.50.25.105:1433`.

### El Antipatrón Evitado:
Codificar la IP `10.50.25.105` en el código Java, en el archivo `web.xml` o en la URL JDBC del descriptor `context.xml` fragmenta la inmutabilidad: si la base de datos migra a otra IP o entorno de contingencia, habría que reconstruir la imagen del contenedor.

### El Patrón Cloud-Native Implementado:
Se crea un **Kubernetes Service sin selector** acompañado de un objeto **Endpoints** emparejado con el mismo nombre exacto:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: scsp-database-gateway
  namespace: maec-scsp-prod
spec:
  ports:
    - name: tds
      protocol: TCP
      port: 1433
      targetPort: 1433
---
apiVersion: v1
kind: Endpoints
metadata:
  name: scsp-database-gateway
  namespace: maec-scsp-prod
subsets:
  - addresses:
      - ip: 10.50.25.105
    ports:
      - name: tds
        port: 1433
```

El servidor DNS interno de OpenShift (CoreDNS) resolverá el nombre lógico `scsp-database-gateway` directamente hacia la IP externa. La cadena de conexión en `context.xml` queda desacoplada de la topología física:
```text
jdbc:sqlserver://scsp-database-gateway:1433;databaseName=${DB_NAME};sendStringParametersAsUnicode=false
```

---

## 2. Cortafuegos de Salida (EgressNetworkPolicy) en OVN-Kubernetes

Por diseño, Kubernetes permite a los pods enviar tráfico saliente hacia cualquier destino accesible en la red. En la Administración Pública española, las directrices de la **SUGICYR** exigen confinamiento estricto (*zero-trust egress*).

Mediante **`EgressNetworkPolicy`**, Open vSwitch (OVS) intercepta cada paquete emitido a nivel de pod veth:

```yaml
apiVersion: network.openshift.io/v1
kind: EgressNetworkPolicy
metadata:
  name: scsp-egress-lockdown
  namespace: maec-scsp-prod
spec:
  egress:
    # 1. Permitir conexión hacia la IP única del SQL Server de Red SARA
    - type: Allow
      to:
        cidrSelector: 10.50.25.105/32
    # 2. Permitir tráfico interno al rango de Services (CoreDNS, Infinispan)
    - type: Allow
      to:
        cidrSelector: 172.30.0.0/16
    # 3. Denegar cualquier otro tráfico hacia redes internas o externas
    - type: Deny
      to:
        cidrSelector: 0.0.0.0/0
```

Cualquier intento de conexión no autorizada, escaneo de puertos o vector de exfiltración lateral es descartado silenciosamente por el kernel de Linux a nivel de flujo de red virtual.

---

<p align="center">
  <b>Página Anterior:</b> <a href="04-gestion-sesiones-infinispan.md"><b>⬅️ 04. Gestión de Sesiones con Infinispan</b></a> &nbsp;|&nbsp;
  <b><a href="../README.md">🏠 <b>Home / README</b></a></b> &nbsp;|&nbsp;
  <b>Página Siguiente:</b> <a href="06-tuning-jvm-y-probes.md"><b>06. Tuning JVM y Probes ➡️</b></a>
</p>

---
