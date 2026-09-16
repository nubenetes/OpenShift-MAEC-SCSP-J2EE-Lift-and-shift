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

### 1.1. Marco Temporal y Contexto Organizativo: La Transición Contractual en el MAEC (Segunda Mitad de 2026)

Esta experiencia de arquitectura y migración se sitúa temporalmente en la **segunda mitad del año 2026**, coincidiendo con una compleja fase de transición de proveedores de servicios TI en el MAEC:
- **La Consultora Saliente (4 Años de Pliego + 2 de Implantación):** Durante seis años continuados, la consultora adjudicataria principal saliente (**Minsait**, en coordinación con socios tecnológicos como **Telefónica** y **Altia**) había desplegado, operado y administrado tanto las **infraestructuras** (CPDs, virtualización, redes y clústeres OpenShift en NubeSARA) como el **software nuclear** del ministerio (el framework *DOPE* y la arquitectura de microservicios de *SINAVI*).
- **Las Consultoras Entrantes y el Traspaso Operativo:** Con la nueva licitación ministerial desembarcó un nuevo conjunto de empresas integradoras: **Alten** (adjudicataria del lote especializado en **DevOps, automatización y QA**), **NTT Data** (responsable de la administración de bases de datos corporativas DBAs y soporte), **Teknei** (desarrollo e integración), entre otras firmas.
- **El Desafío de la Transferencia de Conocimiento (*Handover*):** En este escenario de relevo, los equipos de las adjudicatarias entrantes afrontaron la difícil tarea de **hacerse con el conocimiento y gobierno operativo (*know-how*)** acumulado durante años por la consultora (en principio) saliente. Esta convivencia de múltiples actores en un entorno cerrado y de alta seguridad como NubeSARA condicionó la necesidad de abordar con rigor técnico el desacoplamiento y migración a OpenShift de aplicaciones monolíticas heredadas como SCSP.

#### Inventario Público de Contratación TIC en el MAEC: Mapa de Empresas Consultoras, Pliegos y Asignación de Lotes

| Ámbito / Rol Tecnológico | Entidad / Adjudicataria | Expediente / Instrumento Público | Periodo / Hitos | Asignación de Lote / Alcance Funcional | Fuentes y Registros Oficiales |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Infraestructura, Cloud & Plataforma Base (Saliente)** | **Minsait (Indra Sistemas)** *(en coordinación con Telefónica y Altia)* | Pliego marco de servicios de infraestructura, CPD y cloud ministerial | 4 años pliego + 2 de implantación (hasta 2026) | **Lote de Infraestructura & Lote de Aplicaciones:** Operación de CPDs, clústeres OpenShift en NubeSARA y framework *DOPE* | [PLACSP](https://contrataciondelestado.es/) / [Perfil Contratante MAEC](https://www.exteriores.gob.es/) |
| **Infraestructura TIC y Puestos de Digitalización Consular** | **Telefónica Soluciones de Informática y Comunicaciones, S.A.U.** | Expediente **2024000071** | Formalizado feb. 2025 (BOE-B-2025-5778/5779) | **Lote 1 (5,51 M€):** Hardware, virtualización, seguridad y licencias.<br/>**Lote 2 (2,85 M€):** Puestos de trabajo consular y equipamiento | [BOE-B-2025-5778](https://www.boe.es/diario_boe/xml.php?id=BOE-B-2025-5778) / [BOE-B-2025-5779](https://www.boe.es/diario_boe/xml.php?id=BOE-B-2025-5779) |
| **Infraestructura de Servidores, Almacenamiento & CPD** | **Inetum España, S.A.** *(antigua GFI Informática)* | Licitaciones de renovación de servidores y licencias | Contratos plurianuales (Consolidación hasta 2026) | **Lote Único (art. 99.3 LCSP):** Suministro, soporte y renovación de infraestructura de cómputo, almacenamiento masivo y licencias SUGICYR | [PLACSP](https://contrataciondelestado.es/) / [Portal Transparencia AGE](https://transparencia.gob.es/) |
| **Oficina Técnica y Gestión de Proyectos TIC (Entrante)** | **Teknei Information Technology, S.L.** | Expediente **2024000090** | Formalizado junio 2025 (Ejecución 2025–2026+) | **Lote 1:** Oficina de apoyo, gobernanza y gestión de servicios y proyectos TIC del ministerio | [BOE Formalización](https://www.boe.es/) / [Portal Transparencia AGE](https://transparencia.gob.es/) |
| **Ingeniería DevOps, Automatización & QA (Entrante)** | **Alten Soluciones Productos Auditoría e Ingeniería, S.A.U.** | Expediente **2024000090** | Formalizado junio 2025 (Ejecución 2025–2026+) | **Lote 2:** Control de calidad (QA), aseguramiento metodológico, testing y soporte a ingeniería DevOps | [BOE Formalización](https://www.boe.es/) / [Portal Transparencia AGE](https://transparencia.gob.es/) |
| **Bases de Datos Corporativas (DBAs) & Soporte** | **NTT Data Spain, S.L.U.** | Licitaciones de soporte especializado a sistemas | Periodo 2025–2026 (Transición activa) | **Lote Especializado DBAs / Derivado AM:** Administración de bases de datos corporativas (MS SQL Server en Red SARA) | [PLACSP](https://contrataciondelestado.es/) / [Registro DGRCC](https://www.hacienda.gob.es/) |
| **Evolución y Acompañamiento Aplicativo Consular** | **Indra Soluciones TI (Minsait)** | Expediente **CEA3422/2026** / Exp. Mayo 2026 | Adjudicado mayo y agosto 2026 (799.252 € + 102.300 €) | **Lote Único (art. 99.3 LCSP):** Implantación de la nueva versión de SINAVI y desarrollo de mejoras del aplicativo consular (fondos UE) | [PLACSP Licitaciones](https://contrataciondelestado.es/) / [Junta de Contratación](https://www.hacienda.gob.es/) |
| **Desarrollo y Mejoras de Software Consular** | **Capgemini España, S.L.** | Expedientes de desarrollo aplicativo / SINAVI (ej. CE03573/2023) | Contratos de desarrollo y mejoras (2023–2026) | **Lote de Desarrollo de Sistemas (Acuerdo Marco AGE):** Evolución de módulos del sistema consular SINAVI | [PLACSP](https://contrataciondelestado.es/) / [Hacienda DGRCC](https://www.hacienda.gob.es/) |
| **Digitalización Consular y Entornos de Pruebas** | **Ayesa Advanced Technologies, S.A.** | Licitaciones del Plan de Digitalización Consular | Periodo de implantación 2024–2026 | **Lote de Calidad y Pruebas:** Desarrollo de componentes y adecuación de entornos de validación consular | [PLACSP](https://contrataciondelestado.es/) / [Portal MAEC](https://www.exteriores.gob.es/) |
| **Servicios de Migración e Integración Aplicativa** | **Sopra Steria España, S.A.** | Licitaciones de migración de sistemas (ej. CEA377/2026) | Periodo 2025–2026 | **Lote Único (art. 99.3 LCSP):** Servicios especializados de migración tecnológica e integración entre aplicativos | [PLACSP](https://contrataciondelestado.es/) / [Transparencia AGE](https://transparencia.gob.es/) |
| **Desarrollo y Soporte bajo Acuerdos Marco Centralizados** | **Viewnext / Babel Sistemas de Información** | Contratos derivados de Acuerdos Marco DGRCC (Hacienda) | Periodo 2024–2026+ | **Lotes 1 y 2 del Acuerdo Marco 26/2021 DGRCC:** Desarrollo de sistemas y mantenimiento correctivo/evolutivo | [DGRCC Hacienda](https://www.hacienda.gob.es/) / [PLACSP](https://contrataciondelestado.es/) |

> [!NOTE]
> **¿Por qué no todos los contratos tienen un número de lote propio asignado?**  
> En el marco de la Ley 9/2017 de Contratos del Sector Público (LCSP), conviven tres figuras:  
> 1. **Licitaciones con División Formal en Lotes (Regla General, art. 99.1 LCSP):** Como el exp. **2024000090** (**Lote 1** Teknei, **Lote 2** Alten) o el exp. **2024000071** (**Lote 1** y **Lote 2** Telefónica), diseñadas para permitir la concurrencia de proveedores especializados.  
> 2. **Licitaciones de Lote Único (Excepción Justificada, art. 99.3 LCSP):** Como el exp. **CEA3422/2026** (SINAVI con Minsait) o suministros de CPD con Inetum, donde la prestación no puede escindirse sin riesgo técnico o de seguridad.  
> 3. **Contratos Derivados de Acuerdos Marco Centralizados (DGRCC - Hacienda):** Donde la división en lotes reside en el acuerdo marco estatal matriz (ej. Acuerdo Marco 26/2021 de desarrollo/mantenimiento), adjudicándose contratos basados a consultoras homologadas (NTT Data, Capgemini, Viewnext, Babel).

### 1.2. La Dualidad de Arquitecturas en el MAEC: SINAVI / e-LINCE ("DOPE Framework") vs. Monolitos como SCSP

En el ecosistema tecnológico gobernado por la SUGICYR en NubeSARA coexisten dos realidades arquitectónicas que exigen estrategias de plataforma diferenciadas:

1. **Ecosistema de Microservicios Cloud-Native (DOPE Framework):**  
   Para sistemas modernos de gran envergadura como **SINAVI (Sistema de Información Nacional de Visados)** —utilizado por la red consular española en todo el mundo para la tramitación de visados, conectado con el VIS europeo y el portal **SuTRAMITE Consular** (`sutramiteconsular.maec.es`)— o **e-LINCE** —sistema centralizado para la gestión económica y control de las Cajas Pagadoras en el exterior—, la adjudicataria **Minsait** desarrolló para el ministerio el **"DOPE framework"**. Se trata de un marco altamente personalizado diseñado para orquestar del orden de **100 microservicios** independientes con integración y entrega continua (*CI/CD*) intensiva basada en **Red Hat OpenShift Pipelines (Tekton) + ArgoCD**. Este stack responde perfectamente a ciclos de desarrollo continuo in-house, compilación de código fuente commit a commit, testing automatizado distribuido y despliegues atómicos de APIs desacopladas.

2. **Monolitos Heredados de Terceros (Cliente Ligero SCSP):**  
   En el extremo opuesto se sitúan aplicaciones críticas de intermediación como el **Cliente Ligero SCSP**, suministradas por contratistas como un único entregable binario cerrado (`.war` de Java 8 empaquetado para Tomcat).  
   - Intentar asimilar forzosamente estas aplicaciones de legado a los estándares, CRDs de Tekton y mecanismos del *DOPE framework* constituye un **antipatrón de sobre-ingeniería**: genera dependencias innecesarias, multiplica la superficie de fallo en redes desconectadas y paraliza la migración durante meses.
   - La solución idónea para este perfil no es el rediseño micro-modular ni pipelines complejos con TaskRuns efímeros sobre bastiones aislados, sino el **Lift-and-Shift declarativo pragmático** (S2I / BuildConfig nativo + Sonatype Nexus + GitOps) documentado en esta referencia.

### 1.3. La Criticidad de un Monolito de 20 Años y la Gestión Prudente del Riesgo (Plan B vs. Fase 1)

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
