# 🏛️ Contexto Estratégico y Caso de Uso: MAEC y Cliente Ligero SCSP

---

<p align="center">
  <b>Página Anterior:</b> <span>⏮️ <i>(Inicio)</i></span> &nbsp;|&nbsp;
  <b><a href="../README.md">🏠 <b>Home / README</b></a></b> &nbsp;|&nbsp;
  <b>Página Siguiente:</b> <a href="02-comparativa-soluciones.md"><b>02. Comparativa de Soluciones ➡️</b></a>
</p>

---

> [!WARNING]
> **Aviso:** Esta arquitectura de referencia y documentación técnica ha sido generada con **Gemini 3.8 Flash** como plantilla didáctica y de ingeniería conceptual, tomando como base técnica y de arquitectura la publicación en LinkedIn: [**"Despliegue de SCSP en OpenShift 4.x: Arquitecturas para Entornos Aislados"**](https://www.linkedin.com/pulse/despliegue-de-scsp-en-openshift-4x-arquitecturas-para-i%C3%B1aki-fernandez-hns6e/). No ha sido validada ni depurada en un entorno real de producción de NubeSARA.

> [!IMPORTANT]
> **Restricción de IA en Entornos ENS / Air-Gapped y Flujo de Trabajo "Outside-In":**  
> En perímetros aislados (Air-Gapped) bajo el **Esquema Nacional de Seguridad (ENS - Categoría Alta)** como NubeSARA, **no está permitido el uso de agentes de IA en la nube**. Sin embargo, los profesionales de ingeniería pueden diseñar y acelerar la creación de esta referencia de arquitectura desde un equipo o red personal externa utilizando herramientas avanzadas de IA, para luego exportar e incorporar el repositorio limpio al entorno corporativo desconectado, donde el equipo ministerial podrá evolucionar, validar, depurar e iterar sobre los clústeres reales de OpenShift (QA, PRE y PRO).

---

## 1. El Marco Institucional: MAEC y la Ley 39/2015

Dentro del **Ministerio de Asuntos Exteriores, Unión Europea y Cooperación (MAEC)** de España, la transformación digital de los servicios consulares, diplomáticos y de tramitación ciudadana representa un desafío crítico gestionado bajo la gobernanza técnica de la **SUGICYR (Subdirección General de Informática, Comunicaciones y Redes)**.

La **Ley 39/2015, de 1 de octubre, del Procedimiento Administrativo Común de las Administraciones Públicas**, en su artículo 28, consagra el derecho de la ciudadanía a no aportar documentos que ya obren en poder de las Administraciones Públicas o hayan sido elaborados por estas.

Para materializar este mandato legal, la Secretaría General de Administración Digital (SGAD) impulsó la plataforma **SCSP (Sustitución de Certificados en Soporte Papel)**. El **Cliente Ligero SCSP** es una aplicación que permite a cualquier organismo interrogar los servicios de intermediación de datos del Estado (consultas de identidad en DGP, títulos universitarios en el Ministerio de Educación, antecedentes penales en Justicia, corrientes de pago en TGSS/AEAT, etc.) sin necesidad de requerir fotocopias físicas al administrado.

### 1.1. La Dualidad de Arquitecturas en el MAEC: SINAVI / e-LINCE ("DOPE Framework") vs. Monolitos como SCSP

En el ecosistema tecnológico gobernado por la SUGICYR en NubeSARA coexisten dos realidades arquitectónicas que exigen estrategias de plataforma diferenciadas:

1. **Ecosistema de Microservicios Cloud-Native (DOPE Framework):**  
   Para sistemas modernos de gran envergadura como **SINAVI (Sistema de Información Nacional de Visados)** —utilizado por la red consular española en todo el mundo para la tramitación de visados, conectado con el VIS europeo y el portal **SuTRAMITE Consular** (`sutramiteconsular.maec.es`)— o **e-LINCE** —sistema centralizado para la gestión económica y control de las Cajas Pagadoras en el exterior—, la adjudicataria **Minsait** desarrolló para el ministerio el **"DOPE framework"**. Se trata de un marco altamente personalizado diseñado para orquestar del orden de **100 microservicios** independientes con integración y entrega continua (*CI/CD*) intensiva basada en **Red Hat OpenShift Pipelines (Tekton) + ArgoCD**. Este stack responde perfectamente a ciclos de desarrollo continuo in-house, compilación de código fuente commit a commit, testing automatizado distribuido y despliegues atómicos de APIs desacopladas.

2. **Monolitos Heredados de Terceros (Cliente Ligero SCSP):**  
   En el extremo opuesto se sitúan aplicaciones críticas de intermediación como el **Cliente Ligero SCSP**, suministradas por contratistas como un único entregable binario cerrado (`.war` de Java 8 empaquetado para Tomcat).  
   - Intentar asimilar forzosamente estas aplicaciones de legado a los estándares, CRDs de Tekton y mecanismos del *DOPE framework* constituye un **antipatrón de sobre-ingeniería**: genera dependencias innecesarias, multiplica la superficie de fallo en redes desconectadas y paraliza la migración durante meses.
   - La solución idónea para este perfil no es el rediseño micro-modular ni pipelines complejos con TaskRuns efímeros sobre bastiones aislados, sino el **Lift-and-Shift declarativo pragmático** (S2I / BuildConfig nativo + Sonatype Nexus + GitOps) documentado en esta referencia.

### 1.2. La Criticidad de un Monolito de 20 Años y la Gestión Prudente del Riesgo (Plan B vs. Fase 1)

El Cliente Ligero SCSP es una aplicación con cerca de dos décadas de vida en el ecosistema de la administración pública española. Lejos de ser un sistema secundario, constituye una **pieza de infraestructura crítica de primer orden** para el MAEC:
- **Impacto Operativo Global:** Al ser la pasarela obligatoria para consultar telemáticamente identidades (DGP), antecedentes penales y delitos sexuales (Justicia), titulaciones universitarias (Educación) y corrientes de pago (AEAT y Seguridad Social), cualquier caída o incompatibilidad técnica paralizaría de forma fulminante la actividad de los consulados y embajadas en todo el mundo (visados Schengen, expedientes de nacionalidad, pasaportes y notarías), obligando a los ciudadanos a recabar certificados en papel en España en flagrante vulneración de la Ley 39/2015.
- **El Vacío de Soporte del Proveedor:** El cliente ministerial exigía migrar esta aplicación a **Red Hat OpenShift en NubeSARA**. Sin embargo, la empresa adjudicataria responsable del software **no ofrecía soporte alguno para contenedores, Kubernetes u OpenShift**. Toda su documentación, guías de instalación y homologaciones estaban circunscritas a servidores físicos o máquinas virtuales tradicionales con Apache Tomcat.
- **La Recomendación del "Plan B" Tradicional:** Ante semejante nivel de riesgo y la ausencia total de documentación del proveedor para contenedores, la prudencia técnica de un perfil **DevOps Senior** exigía no jugar a la ruleta rusa con un servicio crítico: se propuso formalmente mantener y no descartar un **"Plan B"** de despliegue sobre infraestructura tradicional (máquinas virtuales con Tomcat dedicado) como red de seguridad amparada por el soporte del fabricante. Si bien esta recomendación preventiva no llegó a implementarse por parte de la gestión —a pesar de que meses atrás otro profesional de **NTT Data** había intentado infructuosamente durante varios meses hacer funcionar el despliegue sin conseguirlo—, ponía de manifiesto el rigor metodológico necesario ante sistemas de misión crítica.
- **La Validación de la Fase 1:** Pese a no contar con ese respaldo preventivo en paralelo y superando los meses de intentos fallidos previos de terceros, la arquitectura implementada en este repositorio (Fase 1: S2I Binario CLI con inyección externa de configuración) logró validar y estabilizar con éxito la ejecución de la aplicación en el primer clúster de pruebas de OpenShift en NubeSARA, demostrando que era viable modernizar el monolito sin alterar su binario ni violar la garantía del fabricante.

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

---

## 5. El Arquetipo Común: De la Experiencia MAEC al Patrón Universal

Aunque este documento se enmarca en la experiencia técnica real del **MAEC** y el **Cliente Ligero SCSP**, las restricciones descritas constituyen el **arquetipo idéntico al que se enfrentan los departamentos de arquitectura en la gran empresa**:

1. **Banca Transaccional (PCI-DSS):** Aplicaciones core de créditos o pasarelas de pago que no pueden perder la sesión del cliente al escalar y deben conectarse de forma segura a Oracle RAC o mainframes DB2 externos.
2. **Aseguradoras (Insurtech):** Tarifadores complejos multi-etapa con retención de presupuestos en `HttpSession`.
3. **Sistemas Hospitalarios (HealthTech):** Estaciones clínicas y receta electrónica 24/7 donde un CrashLoopBackOff o un corte de sesión paraliza la atención sanitaria.
4. **Telecomunicaciones y Utilities:** Portales de autoservicio y provisión masiva sobre redes restringidas.

En todos estos casos, **este diseño de referencia proporciona la receta cloud-native probada para migrar el monolito sin reescribir código.**

---

<p align="center">
  <b>Página Anterior:</b> <span>⏮️ <i>(Inicio)</i></span> &nbsp;|&nbsp;
  <b><a href="../README.md">🏠 <b>Home / README</b></a></b> &nbsp;|&nbsp;
  <b>Página Siguiente:</b> <a href="02-comparativa-soluciones.md"><b>02. Comparativa de Soluciones ➡️</b></a>
</p>

---
