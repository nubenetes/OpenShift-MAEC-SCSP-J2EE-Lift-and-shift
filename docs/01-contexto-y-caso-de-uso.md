# 🏛️ Contexto Estratégico y Caso de Uso: MAEC y Cliente Ligero SCSP

> [!WARNING]
> **Aviso:** Esta arquitectura de referencia y documentación técnica ha sido generada con **Gemini 3.8 Flash** como plantilla didáctica y de ingeniería conceptual. No ha sido validada ni depurada en un entorno real de producción de NubeSARA.

---

## 1. El Marco Institucional: MAEC y la Ley 39/2015

Dentro del **Ministerio de Asuntos Exteriores, Unión Europea y Cooperación (MAEC)** de España, la transformación digital de los servicios consulares, diplomáticos y de tramitación ciudadana representa un desafío crítico. 

La **Ley 39/2015, de 1 de octubre, del Procedimiento Administrativo Común de las Administraciones Públicas**, en su artículo 28, consagra el derecho de la ciudadanía a no aportar documentos que ya obren en poder de las Administraciones Públicas o hayan sido elaborados por estas.

Para materializar este mandato legal, la Secretaría General de Administración Digital (SGAD) impulsó la plataforma **SCSP (Sustitución de Certificados en Soporte Papel)**. El **Cliente Ligero SCSP** es una aplicación que permite a cualquier organismo interrogar los servicios de intermediación de datos del Estado (consultas de identidad en DGP, títulos universitarios en el Ministerio de Educación, antecedentes penales en Justicia, corrientes de pago en TGSS/AEAT, etc.) sin necesidad de requerir fotocopias físicas al administrado.

---

## 2. Naturaleza del Software Heredado (Legacy Monolith)

El Cliente Ligero SCSP analizado responde a un patrón arquitectónico clásico de la era **J2EE (Java 2 Platform, Enterprise Edition)**:

1. **Plataforma Java 8:** Dependencia estricta de bibliotecas compiladas con bytecode Java 1.8 y servlets 3.1.
2. **Servidor de Aplicaciones:** Diseñado originalmente para Apache Tomcat 7/8 o JBoss EAP, actualmente soportado sobre **Red Hat JBoss Web Server (JWS) 5.4** (Tomcat 9 sobre RHEL 8).
3. **Estado de Sesión en Memoria (Stateful / Sticky Sessions):** El flujo de navegación del usuario y la tramitación de expedientes almacenan objetos complejos en la `HttpSession` de Java.
4. **Base de Datos Relacional Externa:** Utiliza **Microsoft SQL Server** para auditoría de transacciones, logs de intermediación y parametrización de certificados de firma electrónica.
5. **Drivers JDBC Propietarios:** Requiere el conector con licencia cerrada `mssql-jdbc-8.4.1.jre8.jar`, el cual no viene incluido en imágenes base de software libre.

---

## 3. El Entorno Desconectado: Red SARA y NubeSARA

La **Red SARA** (Sistemas de Aplicaciones y Redes para las Administraciones) interconecta a los ministerios, comunidades autónomas y ayuntamientos españoles, así como a las instituciones europeas a través de TESTA (Trans European Services for Telematics between Administrations).

**NubeSARA** es la nube privada gubernamental donde se alojan clústeres de **Red Hat OpenShift Container Platform (OCP)**. Por estrictas directrices de seguridad del **Centro Criptológico Nacional (CCN-CERT)** y del **Esquema Nacional de Seguridad (ENS - Categoría Alta)**, esta infraestructura opera en modo **Air-Gapped** (completamente aislada de Internet público):

- **Sin resolución DNS pública:** Prohibición de acceso a registros comerciales como Docker Hub, Quay.io o Red Hat Registry.
- **Sin acceso saliente general:** Restricción perimetral absoluta del tráfico de red saliente desde los contenedores (normativa SUGICYR).
- **Prohibición de ClickOps:** Todos los cambios en producción deben ser auditables, trazables y preferiblemente gestionados mediante código declarativo.

---

## 4. Retos de la Migración "Lift-and-Shift" a Contenedores

| Reto Clave | Causa Técnica | Impacto Sin Solución Cloud-Native |
| :--- | :--- | :--- |
| **Amnesia de Sesión** | Los pods de Kubernetes son efímeros y se recrean dinámicamente. | Si un pod se reinicia o escala, el funcionario o ciudadano pierde el trámite en curso (*Session Lost*). |
| **Aislamiento de Registro** | No hay acceso a `registry.redhat.io`. | Fallo en la descarga de imágenes base y operadores (`ImagePullBackOff`). |
| **Incompatibilidad cgroups JVM** | Java 8 ignora límites de contenedores Linux cgroups v1/v2 por defecto. | La JVM consume la RAM del nodo físico y es aniquilada por el `OOMKiller`. |
| **CrashLoopBackOff en Arranque** | Monolitos J2EE tardan 40-70 segundos en inicializar el pool JDBC y validar contextos. | Probes por defecto de Kubernetes matan el contenedor prematuramente creyendo que falló. |
| **Seguridad Egress** | Los pods tienen red abierta saliente por defecto en clústeres no protegidos. | Incumplimiento de la política perimetral SUGICYR / ENS de Red SARA. |
