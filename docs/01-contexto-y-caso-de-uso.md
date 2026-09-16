# 🏛️ Contexto Estratégico, Auditoría Contractual y Caso de Uso: MAEC y Cliente Ligero SCSP

---

<p align="center">
  <b>Página Anterior:</b> <span>⏮️ <i>(Inicio)</i></span> &nbsp;|&nbsp;
  <b><a href="../README.md">🏠 <b>Home / README</b></a></b> &nbsp;|&nbsp;
  <b>Página Siguiente:</b> <a href="02-comparativa-soluciones.md"><b>02. Comparativa de Soluciones ➡️</b></a>
</p>

---

> [!WARNING]
> **⚠️ PLANTILLA DIDÁCTICA Y REFERENCIA ARQUITECTÓNICA CONCEPTUAL:**  
> Esta arquitectura de referencia y documentación técnica ha sido generada con **Gemini 3.8 Flash** como plantilla didáctica y de ingeniería conceptual, tomando como base técnica y de arquitectura mi artículo publicado en formato newsletter en LinkedIn: [**"Despliegue de SCSP en OpenShift 4.x: Arquitecturas para Entornos Aislados"**](https://www.linkedin.com/pulse/despliegue-de-scsp-en-openshift-4x-arquitecturas-para-i%C3%B1aki-fernandez-hns6e/). **NO ha sido probado, validado ni depurado en un clúster OpenShift real en producción dentro de NubeSARA.**

> [!IMPORTANT]
> **🔒 RESTRICCIÓN DE IA EN ENTORNOS ENS / AIR-GAPPED Y METODOLOGÍA "OUTSIDE-IN":**  
> En perímetros altamente protegidos bajo el **Esquema Nacional de Seguridad (ENS - Categoría Alta)** y en aislamiento perimetral estricto (**Air-Gapped**) como **NubeSARA**, **NO está permitido el uso de agentes de Inteligencia Artificial en la nube** (como Gemini, Claude, Copilot o ChatGPT) debido a la ausencia de conectividad a Internet, la estricta confidencialidad de la información pública y las directrices del CCN-CERT.  
> **El patrón metodológico acelerador:** Este repositorio pone en valor un flujo de trabajo pragmático y legítimo: como profesional de la ingeniería puedo apoyarme en agentes avanzados de IA generativa desde mi **equipo personal o red personal externa** para concebir, diseñar y estructurar con código toda la arquitectura de referencia, scripts de automatización, Kustomize y manifiestos GitOps. Posteriormente, este repositorio limpio se descarga y transfiere de forma segura al **entorno corporativo desconectado**, donde el equipo de ingeniería ministerial puede **evolucionar, validar, iterar, depurar y ajustar** la solución sobre los clústeres OpenShift reales (**QA, PRE y PRO**) sin comprometer la seguridad perimetral.

---

## 📑 Tabla de Contenidos del Monográfico

1. [El Marco Institucional y Normativo: SGAD, SCSP y Ley 39/2015](#1-el-marco-institucional-y-normativo-sgad-scsp-y-ley-392015)
2. [Marco Temporal y Contexto Organizativo: La Transición Contractual en el MAEC (2026)](#2-marco-temporal-y-contexto-organizativo-la-transicion-contractual-en-el-maec-2026)
3. [Inventario Público de Contratación TIC en el MAEC: Empresas, Pliegos, Lotes y Presupuestos](#3-inventario-publico-de-contratacion-tic-en-el-maec-empresas-pliegos-lotes-y-presupuestos)
4. [La Dualidad de Arquitecturas en el MAEC: SINAVI / e-LINCE ("DOPE Framework") vs. Monolitos como SCSP](#4-la-dualidad-de-arquitecturas-en-el-maec-sinavi--e-lince-dope-framework-vs-monolitos-como-scsp)
5. [Asignaciones de Gobernanza CI/CD (sin Acceso CLI), Alerta de Obsolescencia y Soporte de Red Hat](#5-asignaciones-de-gobernanza-cicd-sin-acceso-cli-alerta-de-obsolescencia-y-soporte-de-red-hat)
6. [Crónica de una Migración Interrumpida: Rigor Técnico vs. Atajos Cosméticos](#6-cronica-de-una-migracion-interrumpida-rigor-tecnico-vs-atajos-cosmeticos)
7. [Reflexión Cívica, Económica y Ética: Esfuerzo Fiscal, Empleo Tecnológico y Fondos Públicos](#7-reflexion-civica-economica-y-etica-esfuerzo-fiscal-empleo-tecnologico-y-fondos-publicos)
8. [Un Año Después: El Caso IndraMind, la Interconexión del Sector y la Soberanía Técnica](#8-un-ano-despues-el-caso-indramind-la-interconexion-del-sector-y-la-soberania-tecnica)
9. [El Sentido y Legitimidad de este Repositorio: Soberanía Técnica frente a los Filtros de Conveniencia](#9-el-sentido-y-legitimidad-de-este-repositorio-soberania-tecnica-frente-a-los-filtros-de-conveniencia)
10. [Especificaciones Técnicas del Software Heredado y del Entorno NubeSARA Air-Gapped](#10-especificaciones-tecnicas-del-software-heredado-y-del-entorno-nubesara-air-gapped)

---

<a id="1-el-marco-institucional-y-normativo-sgad-scsp-y-ley-392015"></a>
## 1. El Marco Institucional y Normativo: SGAD, SCSP y Ley 39/2015

Dentro del **Ministerio de Asuntos Exteriores, Unión Europea y Cooperación (MAEC)** de España, la transformación digital y modernización de las plataformas consulares, diplomáticas y de atención al ciudadano representa un cometido de máxima responsabilidad técnica e institucional, gobernado operativamente bajo la supervisión de la **SUGICYR (Subdirección General de Informática, Comunicaciones y Redes)**.

La **Ley 39/2015, de 1 de octubre, del Procedimiento Administrativo Común de las Administraciones Públicas**, en su artículo 28.2, consagra el derecho fundamental de la ciudadanía a **no aportar documentos que ya obren en poder de la Administración actuante o hayan sido elaborados por cualquier otra Administración**.

Para hacer vinculante este precepto legal, la **Secretaría General de Administración Digital (SGAD)** —dependiente del Ministerio para la Transformación Digital y de la Función Pública— diseñó y desplegó la infraestructura de la **Plataforma de Intermediación de Datos (PID)** y definió la especificación del estándar **SCSP (Sustitución de Certificados en Soporte Papel)**.

### Especificaciones Técnicas y Operativas del Protocolo SCSP

El **Cliente Ligero SCSP** analizado en este repositorio constituye el componente cliente homologado que permite a las aplicaciones del MAEC interrogar los servicios de intermediación del Estado de forma desasistida:

1. **Protocolo y Estándares de Mensajería:**  
   Implementa la especificación **SCSP v3**, basada en servicios web **SOAP 1.1 / 1.2** sobre transporte seguro HTTPS. Cada intercambio de datos requiere el cumplimiento de estándares **WS-Security (WSS)**, incluyendo la firma criptográfica digital de la petición mediante **XML-DSig** con certificados electrónicos de componente de software homologados por el Esquema Nacional de Interoperabilidad (ENI), garantizando el no repudio y la integridad del mensaje.
2. **Mutual TLS y Autenticación en Red SARA:**  
   El canal de comunicación se establece mediante autenticación mutua cliente-servidor (mTLS / SSL handshake bidireccional) a través de los nodos de la **Red SARA** (Sistemas de Aplicaciones y Redes para las Administraciones), exigiendo la gestión y custodia estricta de almacenes de claves Java (`keystore.jks` y `truststore.jks`).
3. **Catálogo de Servicios de Verificación e Intermediación Consultados:**
   - **Identidad y Residencia:** Consultas en tiempo real a la Dirección General de la Policía (DGP - verificación de datos de identidad y filiación) y al Instituto Nacional de Estadística (INE - padrón municipal).
   - **Justicia:** Interrogación telemática del Registro Central de Penados y del Registro Central de Delincuentes Sexuales (requisito legal mandatorio para la expedición de visados nacionales de residencia, trabajo y estudios, expedientes de nacionalidad por carta de naturaleza y contrataciones de personal consular en el exterior).
   - **Educación:** Verificación de títulos universitarios y no universitarios ante las bases de datos del Ministerio de Educación.
   - **Hacienda y Seguridad Social:** Comprobación automatizada del estado de corrientes de pago ante la Agencia Tributaria (AEAT) y la Tesorería General de la Seguridad Social (TGSS).

### Criticidad Operativa e Impacto de Caída

La indisponibilidad o fallo en la comunicación del Cliente Ligero SCSP paraliza de forma fulminante la tramitación consular y diplomática en más de **200 Embajadas y Consulados Generales de España en todo el mundo**. Un colapso en este componente obligaría a retrotraer los procedimientos administrativos a la exigencia de aportación presencial de certificados físicos en papel expedidos en España, provocando una paralización masiva de expedientes de extranjería, visados y notarías consulares en flagrante vulneración del ordenamiento jurídico.

---

<a id="2-marco-temporal-y-contexto-organizativo-la-transicion-contractual-en-el-maec-2026"></a>
## 2. Marco Temporal y Contexto Organizativo: La Transición Contractual en el MAEC (2026)

Esta experiencia técnica de ingeniería se sitúa cronológicamente en la **segunda mitad del año 2026**, en un momento de singular trascendencia organizativa, tecnológica y contractual dentro del MAEC:

El entorno tecnológico ministerial se encontraba inmerso en un proceso de **relevo y transición global de proveedores de servicios TI**, tras la culminación de un ciclo contractual plurianual de **4 años de pliego licitado en total**, cuyos **dos últimos años correspondieron a la compleja fase de implantación y modernización de la plataforma cloud** (la cual requirió dos tentativas consecutivas y dos versiones/soluciones arquitectónicas hasta lograr su estabilización):

- **La Consultora Saliente y la Construcción del Ecosistema:**  
  A lo largo de los cuatro años del pliego, la consultora adjudicataria principal saliente (**Minsait**, con la participación coordinada de otras firmas de referencia como **Telefónica** y **Altia**) había sido la responsable directa de diseñar, desplegar y administrar tanto las **infraestructuras** de sistemas (CPDs, virtualización, redes y clústeres Red Hat OpenShift en NubeSARA) como el **parque aplicativo** nuclear del ministerio (desarrollo in-house, el framework *DOPE* y la arquitectura de microservicios de *SINAVI*). Asimismo, Minsait gestionaba el clúster de desarrollo (DEV) alojado en su propia suscripción en la nube pública de **Microsoft Azure** para este proyecto (y posiblemente compartido con otras iniciativas del proveedor), si bien la propia Minsait recomendaba formalmente al MAEC que desplegara su propio clúster OCP DEV dentro del perímetro ministerial.
- **Las Consultoras Entrantes y el Reto de la Transferencia de Conocimiento:**  
  Con la adjudicación del nuevo acuerdo marco y la redistribución de los lotes de servicio, desembarcó un nuevo consorcio de empresas integradoras que debían asumir las diferentes áreas de responsabilidad técnica:
  - **Alten:** adjudicataria responsable del lote especializado de **DevOps, automatización de despliegues y aseguramiento de la calidad (QA)**.
  - **NTT Data:** asumiendo responsabilidades en la administración especializada de bases de datos corporativas (DBAs) y soporte a sistemas.
  - **Teknei:** asumiendo servicios de desarrollo, soporte e integración adicionales, entre otras firmas del sector.
- **El Complejo Proceso de Traspaso (*Handover*):**  
  Este escenario de relevo implicaba un reto técnico, metodológico y de gestión de primer orden: los equipos de las consultoras entrantes tenían la difícil misión de **hacerse con el conocimiento y el gobierno operativo (*know-how*)** acumulado a lo largo de los cuatro años de contrato por la adjudicataria (en principio) saliente. En este contexto de transición concurrente —caracterizado por la convivencia de múltiples proveedores, la asimilación acelerada de procesos en infraestructuras altamente restringidas (NubeSARA Air-Gapped) y la necesidad imperativa de garantizar la continuidad de servicios consulares críticos— se abordó la modernización hacia OpenShift de aplicaciones clave como el Cliente Ligero SCSP.

---

<a id="3-inventario-publico-de-contratacion-tic-en-el-maec-empresas-pliegos-lotes-y-presupuestos"></a>
## 3. Inventario Público de Contratación TIC en el MAEC: Empresas, Pliegos, Lotes y Presupuestos

De conformidad con los principios de publicidad y transparencia activa consagrados en la **Ley 9/2017 de Contratos del Sector Público (LCSP)** y las exigencias de auditoría de los **Fondos Europeos Next-Generation EU**, a continuación se detalla la matriz ampliada de expedientes públicos, empresas consultoras, asignación de lotes y presupuestos oficiales vinculados a la plataforma tecnológica ministerial:

| Ámbito / Rol Tecnológico | Entidad / Adjudicataria | Expediente / Instrumento Público | Asignación de Lote / Alcance Funcional | Presupuesto / Importe Oficial (sin IVA) | Fuentes y Registros Oficiales |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Infraestructura, Cloud & Plataforma Base (Saliente)** | **Minsait (Indra Sistemas)** *(en coordinación con Telefónica y Altia)* | Pliego marco de servicios de infraestructura, CPD y cloud ministerial | **Lotes de Infraestructura & Aplicaciones:** Operación de CPDs, clústeres OpenShift en NubeSARA y framework *DOPE* | **> 25.000.000,00 €** *(Pliego de 4 años en total; 2 últimos de implantación en 2 versiones)* | [PLACSP](https://contrataciondelestado.es/) / [Perfil Contratante MAEC](https://www.exteriores.gob.es/) |
| **Infraestructura TIC y Virtualización Consular** | **Telefónica Soluciones de Informática y Comunicaciones, S.A.U.** | Expediente **2024000071** | **Lote 1:** Hardware TIC, virtualización, seguridad y licenciamiento | **5.511.675,16 €** *(Adjudicado BOE-B-2025-5778)* | [BOE-B-2025-5778](https://www.boe.es/diario_boe/xml.php?id=BOE-B-2025-5778) / [PLACSP](https://contrataciondelestado.es/) |
| **Puestos de Digitalización y Representaciones Consulares** | **Telefónica Soluciones de Informática y Comunicaciones, S.A.U.** | Expediente **2024000071** | **Lote 2:** Puestos de trabajo consular y equipamiento de digitalización | **2.852.799,12 €** *(Adjudicado BOE-B-2025-5779)* | [BOE-B-2025-5779](https://www.boe.es/diario_boe/xml.php?id=BOE-B-2025-5779) / [PLACSP](https://contrataciondelestado.es/) |
| **Oficina Técnica y Gestión de Proyectos TIC (Entrante)** | **Teknei Information Technology, S.L.** | Expediente **2024000090** | **Lote 1:** Oficina de apoyo, gobernanza y gestión de proyectos TIC | **1.325.620,00 €** *(Adjudicado BOE-B-2025-20633)* | [BOE-B-2025-20633](https://www.boe.es/diario_boe/xml.php?id=BOE-B-2025-20633) / [Transparencia AGE](https://transparencia.gob.es/) |
| **Ingeniería DevOps, Automatización & QA (Entrante)** | **Alten Soluciones Productos Auditoría e Ingeniería, S.A.U.** | Expediente **2024000090** | **Lote 2:** Control de calidad (QA), testing y soporte a ingeniería DevOps | **786.100,00 €** *(Adjudicado BOE-B-2025-20750)* | [BOE-B-2025-20750](https://www.boe.es/diario_boe/xml.php?id=BOE-B-2025-20750) / [Transparencia AGE](https://transparencia.gob.es/) |
| **Evolución y Acompañamiento Aplicativo Consular (SINAVI)** | **Indra Soluciones TI (Minsait)** | Expediente **CEA3422/2026** | **Lote Único (art. 99.3 LCSP):** Implantación nueva versión sistema SINAVI | **799.252,00 €** *(Base: 1.042.961,30 € - Fondos UE)* | [PLACSP Licitaciones](https://contrataciondelestado.es/) / [Junta Contratación](https://www.hacienda.gob.es/) |
| **Desarrollo de Mejoras del Sistema Consular (SINAVI)** | **Indra Soluciones TI (Minsait)** | Expediente Mayo 2026 | **Lote Único (art. 99.3 LCSP):** Mejoras y evolución funcional de SINAVI | **102.300,00 €** *(Adjudicado mayo 2026 - Fondos IGFV)* | [PLACSP](https://contrataciondelestado.es/) / [Perfil Contratante](https://www.exteriores.gob.es/) |
| **Infraestructura de Servidores, Almacenamiento & CPD** | **Inetum España, S.A.** *(antigua GFI Informática)* | Licitaciones de renovación de servidores y licencias | **Lote Único (art. 99.3 LCSP):** Cómputo, cabinas de almacenamiento y soporte | **\~ 3.000.000,00 €** *(Estimación acumulada plurianual)* | [PLACSP](https://contrataciondelestado.es/) / [Portal Transparencia](https://transparencia.gob.es/) |
| **Bases de Datos Corporativas (DBAs) & Soporte** | **NTT Data Spain, S.L.U.** | Licitaciones de soporte especializado a sistemas | **Lote Especializado DBAs / Derivado AM:** MS SQL Server en Red SARA | **\~ 1.000.000,00 €** *(Contratos de servicio y órdenes derivadas)* | [PLACSP](https://contrataciondelestado.es/) / [Registro DGRCC](https://www.hacienda.gob.es/) |
| **Desarrollo y Mejoras de Software Consular** | **Capgemini España, S.L.** | Expedientes desarrollo aplicativo / SINAVI (ej. CE03573/2023) | **Lote Desarrollo (Acuerdo Marco AGE):** Evolución de componentes | **\~ 500.000,00 €** *(Contratos basados en Acuerdo Marco AGE)* | [PLACSP](https://contrataciondelestado.es/) / [Hacienda DGRCC](https://www.hacienda.gob.es/) |
| **Digitalización Consular y Entornos de Pruebas** | **Ayesa Advanced Technologies, S.A.** | Licitaciones del Plan de Digitalización Consular | **Lote de Calidad y Pruebas:** Entornos de validación y digitalización | **\~ 2.000.000,00 €** *(Envolvente Plan Digitalización Consular)* | [PLACSP](https://contrataciondelestado.es/) / [Portal MAEC](https://www.exteriores.gob.es/) |
| **Servicios de Migración e Integración Aplicativa** | **Sopra Steria España, S.A.** | Licitaciones de migración de sistemas (ej. CEA377/2026) | **Lote Único (art. 99.3 LCSP):** Migración tecnológica e integración de apps | **\~ 400.000,00 €** *(Licitaciones específicas de modernización)* | [PLACSP](https://contrataciondelestado.es/) / [Transparencia AGE](https://transparencia.gob.es/) |
| **Desarrollo y Mantenimiento bajo Acuerdo Marco Central** | **Viewnext / Babel Sistemas de Información** | Contratos derivados del Acuerdo Marco 26/2021 DGRCC | **Lotes 1 y 2 del AM 26/2021:** Desarrollo y mantenimiento correctivo | **\~ 400.000 € / año** *(Consumo ministerial por órdenes de servicio)* | [DGRCC Hacienda](https://www.hacienda.gob.es/) / [PLACSP](https://contrataciondelestado.es/) |

> [!NOTE]
> **¿Por qué no todos los contratos tienen un número de lote propio asignado?**  
> En el marco del Derecho de la Contratación Pública en España (Ley 9/2017 - LCSP), coexisten tres modelos jurídicos de licitación:  
> 1. **Licitaciones con División Formal en Lotes (Regla General, art. 99.1 LCSP):** Contratos diseñados específicamente para abrir la competencia a diferentes proveedores especializados (por ejemplo, el expediente **2024000090**, estructurado en **Lote 1** para Teknei y **Lote 2** para Alten; o el **2024000071**, con **Lote 1** y **Lote 2** adjudicados a Telefónica).  
> 2. **Licitaciones de Lote Único (Excepción Justificada, art. 99.3 LCSP):** Contratos de objeto indivisible donde una fragmentación técnica o funcional pondría en riesgo la continuidad del servicio o la compatibilidad de una solución propietaria (por ejemplo, el contrato **CEA3422/2026** para la implantación de la nueva versión de SINAVI con Minsait, o suministros específicos de CPD con Inetum).  
> 3. **Contratos Derivados de Acuerdos Marco Centralizados (DGRCC - Ministerio de Hacienda):** Instrumentos de compra agregada donde la división en lotes reside en el **Acuerdo Marco matriz** a nivel estatal (por ejemplo, el **Acuerdo Marco 26/2021** para Desarrollo de Sistemas de Información, que cuenta con sus propios lotes de desarrollo, mantenimiento o pruebas). Las órdenes de servicio que activa el MAEC para consultoras homologadas (como NTT Data, Capgemini, Viewnext o Babel) se rigen por los lotes del acuerdo marco central.

---

<a id="4-la-dualidad-de-arquitecturas-en-el-maec-sinavi--e-lince-dope-framework-vs-monolitos-como-scsp"></a>
## 4. La Dualidad de Arquitecturas en el MAEC: SINAVI / e-LINCE ("DOPE Framework") vs. Monolitos como SCSP

En el ecosistema tecnológico gobernado por la SUGICYR en NubeSARA coexisten dos realidades arquitectónicas que exigen estrategias de plataforma radicalmente diferenciadas:

### 1. Ecosistema de Microservicios Cloud-Native (DOPE Framework de Minsait)
Para sistemas modernos de gran envergadura como **SINAVI (Sistema de Información Nacional de Visados)** —utilizado por la red consular española en todo el mundo para la tramitación de visados, conectado con el VIS europeo y el portal **SuTRAMITE Consular** (`sutramiteconsular.maec.es`)— o **e-LINCE** —sistema centralizado para la gestión económica y control de las Cajas Pagadoras en el exterior—, la adjudicataria **Minsait** desarrolló para el ministerio el **"DOPE framework"** (*DevOps Platform Ecosystem*). Se trata de un marco altamente personalizado diseñado para orquestar del orden de **100 microservicios** independientes mediante dos capas desacopladas sobre OpenShift:
- **Capa CI con Red Hat OpenShift Pipelines (Motor Tekton):** Tuberías automatizadas declaradas mediante CRDs de Kubernetes (`Tasks`, `Pipelines`, `PipelineRuns`, `TriggerTemplates`, `EventListeners`). Cada commit desencadena la ejecución de tareas en pods efímeros aislados: clonado Git seguro, compilación multi-módulo (Maven/Node.js), análisis estático de código y calidad (SonarQube), verificación de dependencias y vulnerabilidades (SCA), empaquetado de contenedores OCI con Buildah en modo *rootless*, y publicación en el registro interno (Quay/Nexus), compartiendo cachés mediante volúmenes multi-escritura (`PVC RWX`).
- **Capa CD con Red Hat OpenShift GitOps (Motor ArgoCD):** Entrega continua declarativa con Git como única fuente de verdad. Emplea patrones de gran escala como **ApplicationSet** y **App-of-Apps** para gobernar las dependencias y el ciclo de vida de los cerca de 100 microservicios, reconciliando continuamente el estado deseado contra los clústeres independientes de NubeSARA (**QA**, **PRE**, **PRO**) con auto-sanación (`selfHeal: true`) y sincronización desatendida.

### 2. Monolitos Heredados de Terceros (Cliente Ligero SCSP)
En el extremo opuesto se sitúan aplicaciones críticas de intermediación como el **Cliente Ligero SCSP**, suministradas por contratistas como un único entregable binario cerrado (`.war` de Java 8 empaquetado para Tomcat).  
- Intentar asimilar forzosamente estas aplicaciones de legado a los estándares, CRDs de Tekton y mecanismos del *DOPE framework* constituye un **antipatrón de sobre-ingeniería**: genera dependencias innecesarias, multiplica la superficie de fallo en redes desconectadas y paraliza la migración durante meses.
- La solución idónea para este perfil no es el rediseño micro-modular ni pipelines complejos con TaskRuns efímeros sobre bastiones aislados, sino el **Lift-and-Shift declarativo pragmático** (S2I / BuildConfig nativo + Sonatype Nexus + GitOps) documentado en esta referencia.

---

<a id="5-asignaciones-de-gobernanza-cicd-sin-acceso-cli-alerta-de-obsolescencia-y-soporte-de-red-hat"></a>
## 5. Asignaciones de Gobernanza CI/CD (sin Acceso CLI), Alerta de Obsolescencia y Soporte de Red Hat

En el marco del nuevo contrato y la entrada de nuevos perfiles de ingeniería, el desempeño técnico en este ecosistema ministerial requirió acometer retos de gobernanza de extraordinaria complejidad técnica y procedimental:

1. **Mi Asignación Operativa: Gobernanza del Ecosistema CI/CD sin Acceso CLI:**  
   Dentro de las asignaciones prioritarias que se me encomendaron al incorporarme como ingeniero DevOps entrante, figuraba la absorción, aprendizaje y gobernanza de todo el complejísimo ecosistema de integración y entrega continua (CI/CD) de la plataforma ministerial. Tuve que acometer esta labor bajo severas limitaciones de entorno: **sin disponer de accesos por línea de comandos (CLI)** ni privilegios de terminal interactiva sobre los nodos o clústeres, viéndome obligado a desentrañar y auditar la arquitectura de los pipelines exclusivamente a través de interfaces gráficas web y consolas con permisos fuertemente acotados. La plataforma orquestaba la entrega de aplicaciones de enorme criticidad y volumen como **SINAVI** (con cerca de un centenar de microservicios distribuidos a nivel consular mundial bajo el *DOPE framework* de Minsait) y **e-LINCE** (sistema centralizado para la gestión económica y control de Cajas Pagadoras en el exterior), entre otros aplicativos ministeriales.

2. **Mi Detección y Alerta Temprana de Obsolescencia en la Plataforma OpenShift:**  
   Durante mi proceso de inmersión y análisis de gobernanza, identifiqué y trasladé formalmente a la dirección técnica —con honda preocupación técnica por la estabilidad operativa de los servicios del Estado— una situación de alto riesgo: **los clústeres de Red Hat OpenShift en NubeSARA no estaban siendo debidamente actualizados**, acumulando un retraso de mantenimiento que los situaba al borde de la pérdida inminente de soporte oficial del fabricante (**End of Life / expiración de soporte EUS**). La gravedad del hallazgo radicaba en que **la práctica totalidad de los pipelines de CI/CD (Tekton, operadores, frameworks y tareas automatizadas)** presentaban dependencias y acoplamientos directos con las APIs de la versión de OpenShift en obsolescencia, amenazando con bloquear la entrega continua y dejar sin cobertura de soporte del fabricante al ministerio ante cualquier fallo crítico o vulnerabilidad de seguridad.

3. **Mi Escalado Proactivo a Red Hat, Superación de Restricciones Air-Gapped (ENS Alto) y Soporte Extraordinario:**  
   Ante el riesgo de descuelgue tecnológico de plataformas esenciales, asumí la iniciativa técnica de **escalar de forma proactiva la situación directamente a Red Hat**:
   - Para ello, tuve que sortear y superar complejas dificultades técnicas y organizativas derivadas del aislamiento estricto de la infraestructura (**NubeSARA Air-Gapped** sin salida a Internet), el cumplimiento riguroso de las directrices del **Esquema Nacional de Seguridad (ENS - Categoría Alta)** y la carencia de terminal CLI en los clústeres para la extracción convencional de trazas.
   - Mediante un riguroso procedimiento de recopilación y custodia a través de los circuitos autorizados de exportación, logré extraer y transferir con éxito la información diagnóstica esencial (*must-gather*, métricas de operadores y logs de estado del clúster) para su carga en el portal oficial de soporte de **Red Hat**.
   - Esta aportación diagnóstica permitió a los ingenieros de Red Hat llevar a cabo un primer análisis proactivo integral de compatibilidad y conceder una ventana de **soporte extraordinario del fabricante**, protegiendo la resiliencia y la continuidad operativa del ministerio mientras **Minsait (Indra)**, en calidad de proveedora de infraestructura y plataforma base, gestionaba y planificaba internamente el complejo proyecto de actualización de versiones de OpenShift.

---

<a id="6-cronica-de-una-migracion-interrumpida-rigor-tecnico-vs-atajos-cosmeticos"></a>
## 6. Crónica de una Migración Interrumpida: Rigor Técnico vs. Atajos Cosméticos

Este testimonio trasciende el ámbito estrictamente técnico: es también una crónica documentada de una realidad recurrente en la consultoría tecnológica aplicada al sector público y un alegato ético en favor de la transparencia, la honestidad profesional y la buena gobernanza.

### 1. El Vacío de Soporte del Proveedor y Mi Propuesta del "Plan B"
El mandato estratégico del MAEC era migrar el Cliente Ligero SCSP hacia los clústeres corporativos de **Red Hat OpenShift en NubeSARA**. Sin embargo, esta exigencia encerraba una paradoja de alto riesgo técnico y contractual:
- **Cero Soporte y Vacío Documental del Fabricante para Contenedores:** La empresa adjudicataria responsable del desarrollo y mantenimiento del software **no ofrecía soporte alguno para entornos basados en contenedores, Kubernetes u OpenShift**. Su documentación técnica, matrices de compatibilidad y guías de homologación estaban concebidas única y exclusivamente para entornos tradicionales no contenerizados (máquinas virtuales o servidores físicos con Apache Tomcat tradicional).
- **La Prudencia Técnica de un DevOps Senior (Mi Propuesta del "Plan B"):** Ante semejante brecha documental y el riesgo de paralizar un servicio crítico de Estado, desde mi experiencia como perfil **DevOps Senior** acostumbrado a gobernar riesgos en infraestructuras críticas, **propuse formalmente un "Plan B"**: no descartar y preparar en paralelo una vía de despliegue sobre infraestructura tradicional (máquinas virtuales con Tomcat dedicado) como red de seguridad institucional amparada por el soporte del fabricante. Dicha recomendación preventiva no llegó a implementarse por parte de la gestión, a pesar de que meses atrás otro profesional de **NTT Data** había intentado infructuosamente durante varios meses hacer funcionar el despliegue sin conseguirlo.

### 2. La Validación Exitosa de la Fase 1 en una Ventana de 4–5 Semanas Multitarea
Pese a no contar finalmente con ese respaldo preventivo en paralelo y tras el precedente de meses de intentos fallidos de terceros, la solución de ingeniería de **Fase 1 (S2I Binario CLI con configuración desacoplada)** que diseñé y desarrollé demostró que la migración a OpenShift era perfectamente factible: logré que el Cliente Ligero SCSP comenzara a funcionar de forma estable y satisfactoria en el primer clúster de pruebas de OpenShift en NubeSARA, desacoplando la configuración y la base de datos externa de Red SARA sin alterar una sola línea del binario entregado por el fabricante. Este logro técnico lo materialicé en una **estricta ventana temporal de apenas 4 a 5 semanas**, compatibilizando este esfuerzo con otros cometidos ministeriales de máxima relevancia y criticidad que asumí simultáneamente (como el aprendizaje y gobierno del ecosistema CI/CD sin accesos CLI, la alerta por obsolescencia de los clústeres OpenShift y la tramitación del soporte extraordinario con Red Hat).

### 3. La Interrupción de la Fase 1: Arquitectura Real vs. Falsa Apariencia de Entrega
Sin embargo, en el contexto de la presión habitual en los relevos de contratas por evidenciar avances rápidos e inmediatos ante los gestores ministeriales, dinámicas políticas internas, luchas de poder y una deficiente gestión de proyecto truncaron su culminación:
- **La Priorización del Atajo Inviable y la Proliferación de Antipatrones:** Bajo la premisa de "mostrar un entregable rápido a toda costa para cubrir el expediente", se impulsó en paralelo una vía alternativa desarrollada por otro compañero de la misma consultora entrante reasignado desde otro proyecto anterior. Dicho perfil intentó posicionarse y venderse como presunto experto mediante el uso recurrente de vocabulario técnico y jerga especializada que, sin embargo, resultaba carente de corrección técnica elemental; para cualquiera que conociese de verdad la tecnología, quedaba en evidencia de forma inmediata la ausencia total de experiencia práctica y conocimiento real en la materia. Esta carencia condujo a graves antipatrones de diseño:
  - **Recompilación Forzada de Artefactos Homologados vs. Inmutabilidad Nativa en Kubernetes:**  
    El software del Cliente Ligero SCSP suministrado al MAEC era un artefacto binario (`.war`) cerrado, desarrollado y entregado bajo contrato por una empresa adjudicataria externa. Dicho binario constituía el único entregable formalmente validado en bancos de prueba y amparado por la garantía contractual y el soporte técnico del proveedor, quien únicamente ofrecía soporte y documentación para entornos tradicionales no contenerizados (máquinas virtuales o servidores físicos con Apache Tomcat), sin cobertura alguna para plataformas de contenedores ni OpenShift.  
    A pesar de ello, la solución alternativa recurrió al grave error de modificar y recompilar todo el código fuente Java cada vez que se requería ajustar un parámetro de configuración (URLs, credenciales o flags de entorno):
    - *Por qué recompilar el artefacto es un antipatrón crítico:* Recompilar un binario entregado por terceros anula de inmediato la garantía y el soporte técnico contractual del fabricante original; además, introduce una fuente impredecible de regresiones al depender de versiones de compilador, dependencias transitivas de librerías obsoletas y opciones de build no certificadas por el proveedor, imposibilitando auditar criptográficamente (mediante hashes SHA-256) el artefacto en producción bajo las exigencias del ENS.
    - *La brecha entre la experiencia DevOps Senior y el desarrollo web:* Para un ingeniero de sistemas o **DevOps Senior**, curtido en el despliegue de infraestructuras críticas a través de sucesivas generaciones tecnológicas (desde hierro físico y servidores de aplicaciones corporativos J2EE hasta la orquestación cloud), es una regla de oro innegociable que **el artefacto binario homologado es inmutable y la configuración debe externalizarse por completo**. Por el contrario, para un perfil con trayectoria centrada en el desarrollo web en lenguajes interpretados (como PHP) y alejado de las complejidades de la infraestructura de sistemas empresariales, resulta más difícil dimensionar el impacto de alterar el ciclo de vida del software, cayendo en la inercia de editar y recompilar el proyecto como si se tratase de un script local en desarrollo.
    - *La flexibilidad arquitectónica de OpenShift/Kubernetes aplicada en este repo:* Lejos de requerir recompilaciones, la arquitectura de Kubernetes y OpenShift ofrece una flexibilidad extraordinaria concebida precisamente para resolver este desafío de manera limpia: el `.war` original se despliega íntegro e inalterado en la imagen certificada de JBoss Web Server (Tomcat 9), mientras que la configuración ambiental (`context.xml`, `hotrod-client.properties`) se inyecta dinámicamente en el arranque mediante volúmenes de *ConfigMaps* y *Secrets*, desacoplando la topología mediante *Services* y *Endpoints*. Es exactamente este patrón riguroso, que respeta la garantía del fabricante y la inmutabilidad de la carga de trabajo, el que se implementa y defiende en este repositorio.
  - **Base de Datos Efímera en Pod vs. Base de Datos Corporativa:** La directriz del cliente ministerial era nítida e incontestable desde el inicio: el requisito arquitectónico mandatorio era **conectar a la base de datos externa Microsoft SQL Server asociada a cada entorno** en la intranet de Red SARA. Para cumplir con esta exigencia real de producción, tuve que investigar a fondo y conseguir, no sin esfuerzo, perseverancia técnica y gestiones de interlocución, los parámetros de red, credenciales y rutas de conectividad hacia dicha base de datos (labor en la que conté además con la valiosa y profesional colaboración de compañeros de otras empresas adjudicatarias como **NTT Data**, que ejercían el rol de DBAs corporativos). Frente a esta realidad ineludible, la solución paralela optó por el atajo cosmético de levantar un entorno autocontenido con una base de datos efímera dentro del propio pod en local. Esta vía carecía por completo de sentido: ¿qué justificación técnica tenía malgastar tiempo y recursos en simular una base de datos de juguete en un pod aislado cuando ya estábamos desbrozando y resolviendo la conectividad con el SQL Server real del ministerio? Toda esta dinámica irracional de actuar a espaldas del equipo dinamitó lo que debería haber sido una práctica elemental de ingeniería: sentarse a debatir abiertamente, compartir la información obtenida y alinearse en un diseño conjunto, funcional y homologable.
- **La Simulación como Maniobra de Conveniencia:** En lugar de evaluar ambas alternativas bajo criterios objetivos de ingeniería de sistemas, esa falsa apariencia de rapidez se utilizó como pretexto para propiciar mi salida forzada, siendo el profesional con mayor preparación y experiencia técnica contrastada en estas tecnologías (mientras otros perfiles partían de cero). En organizaciones donde la gestión premia la complacencia burocrática por encima de la excelencia, cuando defiendo un criterio técnico independiente, advierto de los riesgos de diseño y no me presto a simulaciones cosméticas, paso a ser percibido como un obstáculo ("hacer sombra"), orquestándose mi salida mediante maniobras de conveniencia.

### 4. Rechazo Frontal al Antipatrón del Enfrentamiento entre Profesionales y el Despilfarro de Recursos
Un aspecto medular de esta reflexión es la crítica a un modelo de gestión destructivo e ineficiente:
- **El Despropósito de los Silos Paralelos y la Falta de Alineación:** Supone una grave falta de profesionalidad y un despilfarro flagrante de recursos públicos y humanos que dos o más personas de un mismo equipo trabajen en paralelo sobre la misma tarea en absoluto aislamiento y sin comunicarse entre sí, compitiendo en una carrera artificial por ver "quién llega antes". En lugar de debatir técnicamente, coordinar esfuerzos y alinear al equipo sobre la información ya recabada (como los accesos a bases de datos y requisitos de red de SARA), esta dinámica viciada premia la primera maqueta que aparenta funcionar en local, aunque sea técnicamente inviable y desaconsejable para producción, aprovechándose de que el interlocutor ministerial suele tener un perfil gestor y administrativo, no técnico de infraestructura.
- **Cultura de Cooperación y Diálogo Bidireccional:** La verdadera ingeniería de software y la arquitectura cloud crecen sobre la base del aprendizaje mutuo, la mentoría honesta y la puesta en común de conocimiento. Me opongo frontalmente a competir con mis compañeros; el valor profesional se demuestra colaborando, compartiendo hallazgos y remando juntos hacia el éxito del proyecto. Fomentar rivalidades internas para dirimir cuotas de influencia o tapar carencias formativas degrada el talento y condena a las organizaciones a decisiones técnicas erráticas que tarde o temprano colapsan en producción.

### 5. Honestidad Técnica vs. Retórica Comercial: La Cultura de los Hechos frente a la Apariencia
- **La Sobre-Venta de Perfiles y la Erosión de la Confianza:** En la consultoría tecnológica es comprensible una actitud de seguridad y proactividad comercial, pero cuando esta actitud se exagera hasta desfigurar la realidad técnica, resulta profundamente incómoda y destructiva. Intentar vender una falsa maestría mediante palabrería técnica conduce con frecuencia a falsear la realidad de lo que realmente se entrega, sembrando desconfianza en el equipo y comprometiendo la viabilidad de la infraestructura.
- **Humildad Intelectual y Predisposición para Aprender:** Nadie tiene por qué saberlo todo. La solvencia técnica legítima se apoya en la honestidad de reconocer los límites del conocimiento propio, la predisposición constante a aprender y la madurez de dejarse guiar por los profesionales que acreditan mayor experiencia en una tecnología determinada. Resulta profundamente frustrante e injusto que ciertas dinámicas corporativas prioricen perfiles que basan su avance en la fachada comercial, postergando a los profesionales que actúan con rigor y transparencia.
- **Ingeniería Basada en Hechos, no en Palabrería:** Creo firmemente en una forma de trabajar: esforzarme al máximo para que la tecnología funcione de la manera más robusta, eficiente y elegante posible, demostrando las soluciones con hechos contrastables, código limpio y sistemas en funcionamiento, y no con artificios retóricos o promesas vacías.

---

<a id="7-reflexion-civica-economica-y-etica-esfuerzo-fiscal-empleo-tecnologico-y-fondos-publicos"></a>
## 7. Reflexión Cívica, Económica y Ética: Esfuerzo Fiscal, Empleo Tecnológico y Fondos Públicos

Las iniciativas de modernización y transformación digital en los Ministerios de la Administración General del Estado —en gran medida impulsadas y financiadas por los **Fondos Europeos Next-Generation EU (Plan de Recuperación, Transformación y Resiliencia)** y el presupuesto ordinario del Estado— exigen una reflexión ética y social que conecte de manera constructiva dos perspectivas indisociables: **mi mirada como ciudadano contribuyente** y **mi experiencia directa como profesional de la ingeniería de software**:

### 1. La Perspectiva Cívica: El Esfuerzo Fiscal Ciudadano y la Legítima Exigencia de Buen Gobierno
- Como contribuyente, resulta inevitable observar con honda preocupación cómo se administran los recursos públicos. La ciudadanía española afronta un contexto socioeconómico de notable tensión: un coste de vida tensionado por la inflación acumulada de los últimos años, un encarecimiento generalizado de los bienes esenciales y una presión impositiva considerable que absorbe una parte sustancial del fruto del trabajo diario.
- Un ejemplo elocuente y cercano para millones de familias y jóvenes profesionales es la extraordinaria barrera de acceso a la vivienda: adquirir una **primera vivienda habitual** exige desembolsar entre un **6% y un 10% adicional exclusivamente en impuestos indirectos autonómicos** (Impuesto sobre Transmisiones Patrimoniales - ITP, o Actos Jurídicos Documentados - AJD, sumados al IVA en obra nueva), lo que a menudo supone el ahorro íntegro de varios años de esfuerzo personal solo para liquidar tributos, antes siquiera de amortizar un euro de hipoteca.
- Cuando un ciudadano asume de forma solidaria ese riguroso compromiso fiscal, lo hace bajo el pacto constitucional implícito de que cada euro recaudado debe retornar a la sociedad con la **máxima eficiencia, transparencia, probidad y excelencia en la gestión**. Por consiguiente, presenciar cómo en proyectos públicos dotados con licitaciones millonarias se toleran inercias de gestión ineficientes, atajos cosméticos para "cumplir el expediente" o contrataciones donde el rigor técnico pasa a un plano secundario, no solo resulta frustrante en el plano profesional, sino que interpela directamente a la conciencia ética ciudadana sobre el buen uso del dinero de todos.

### 2. La Realidad Laboral en el Sector Tecnológico: Cadenas de Subcontratación y Devaluación del Talento
Al trasladar esta inquietud al terreno operativo de los proyectos públicos de tecnologías de la información (TIC), emerge un contraste que merece un análisis sosegado y riguroso:
- **La Paradoja de los Macro-Presupuestos vs. las Condiciones del Talento Técnico:** Mientras los pliegos de contratación pública licitan importes de muchos millones de euros para la modernización digital, el modelo imperante de licitación y adjudicación fomenta con frecuencia **largas cadenas de subcontratación en cascada**. A lo largo de los sucesivos estratos de intermediación corporativa y consultoría, una porción sustancial de los recursos económicos se disuelve en márgenes de gestión administrativa, provocando que la dotación que finalmente llega al ingeniero, arquitecto o administrador de sistemas —quien efectivamente diseña, asegura y levanta la infraestructura crítica del Estado en turnos de máxima exigencia técnica— se encuentre significativamente mermada.
- **Impacto en los Salarios y Retención de Profesionales Cualificados:** En un entorno urbano tensionado donde los alquileres y los precios inmobiliarios han escalado a cotas históricas, este esquema de subcontratación precarizada y bandas salariales comprimidas repercute directamente en la calidad de vida de los profesionales TIC en España. Resulta difícil consolidar equipos estables y de alta capacitación técnica cuando las retribuciones no reflejan el nivel de responsabilidad asumido (como salvaguardar sistemas consulares o sanitarios de misión crítica) ni compensan el esfuerzo formativo continuo que demanda la tecnología cloud.
- **Cultura del Atajo vs. Vocación de Calidad:** Cuando las organizaciones priorizan la rentabilidad inmediata de la intermediación sobre la solidez de la ingeniería, se generan incentivos perversos: se premia la entrega apresurada de maquetas que aparentan funcionar de cara a la galería, en detrimento de soluciones arquitectónicas inmutables, robustas, auditables y duraderas que protegen al organismo a largo plazo.

### 3. El Modelo "Time & Materials" y la Inmaterialidad Lógica frente a la Obra Física
La consultoría tecnológica y la provisión de servicios IT en el sector público presentan una singularidad económica determinante respecto a otros sectores tradicionales de contratación:
- **Inmaterialidad Lógica frente a Infraestructuras Físicas:** A diferencia de la obra civil, el transporte o la construcción de equipamientos —donde las obras se plasman en infraestructuras físicas de mensurabilidad visual y peritaje directo (kilómetros de firme, estructuras de acero, metros cúbicos de hormigón)—, la arquitectura cloud y la ingeniería de software operan sobre constructos lógicos de naturaleza abstracta e inmaterial. La resiliencia de un clúster, la inmutabilidad de un binario o el aislamiento perimetral de red quedan ocultos tras consolas y líneas de código. Para gestores públicos con formación predominantemente jurídica o administrativa, discernir entre una solución arquitectónicamente blindada y una maqueta provisional levantada a espaldas de los estándares supone una brecha de asimetría informativa casi insalvable.
- **La Facturación por Horas (*Time & Materials*) y sus Incentivos Perversos:** Buena parte de los contratos de consultoría IT pública se estructuran bajo la modalidad de asistencia técnica por dedicación horaria (*Time & Materials* o bolsas de horas), en lugar de compromisos cerrados vinculados a hitos funcionales contrastables y auditorías de resultado. Este esquema introduce una severa desalineación: se retribuye y fiscaliza administrativamente el volumen de horas consumidas e imputadas (*timesheets*) y la presencia de perfiles, en lugar de la eficiencia o la excelencia resolutiva del diseño. Paradójicamente, un ingeniero que resuelve una disfunción compleja de raíz mediante automatizaciones limpias que minimizan el consumo futuro de horas puede resultar comercialmente menos "rentable" para el modelo de negocio que quien recurre a sobre-ingenierías intrincadas o parches continuos que justifican la permanencia indefinida de equipos de soporte y facturación continuada.
- **Opacidad, Redes de Afinidad y Dinámicas de Complacencia:** Cuando el objeto del contrato es inmaterial y la métrica de cobro es la imputación de tiempo, la justificación del gasto tiende a reducirse a una mera conformidad documental de horas. En este caldo de cultivo, resulta extraordinariamente fácil que las decisiones operativas, la asignación de roles clave y la continuidad de los profesionales queden condicionadas por criterios de afinidad personal, conveniencia corporativa y acuerdos tácitos, en lugar de por el mérito o la verdad técnica. Quien advierte anomalías, rechaza atajos inviables o propone arquitecturas rigurosas que desvelan ineficiencias corre el riesgo de amenazar la continuidad plácida del circuito de facturación horaria, activando mecanismos informales de desplazamiento o exclusión, mientras se premia la docilidad que garantiza que la maquinaria de asistencia siga rodando sin cuestionamientos.

### 4. Una Llamada Constructiva a la Equidad, la Meritocracia y la Transparencia Pública
- Esta reflexión no nace del reproche individual ni de la crítica estéril, sino de una firme convicción compartida por miles de profesionales y ciudadanos: **el sector público debe ser el catalizador del empleo de calidad, la meritocracia real y la excelencia técnica**.
- Los fondos públicos —y muy especialmente los fondos de recuperación europeos Next-Generation EU, concebidos para transformar el tejido productivo y dotar a las nuevas generaciones de un futuro más próspero— no pueden convertirse en un mero canalizador de gasto burocrático o de simulaciones cosméticas. Deben gestionarse con una pulcritud ejemplar, garantizando que:
  - Se reconozca, valore y proteja el criterio técnico independiente y bien argumentado.
  - Se establezcan mecanismos de control que verifiquen la entrega técnica real y funcional (compromisos de resultado y auditorías de arquitectura verificables), y no solo la justificación documental de horas de asistencia técnica.
  - Se promueva una contratación más justa y directa que dignifique las condiciones del talento tecnológico que moderniza las instituciones públicas.
- Defender la excelencia técnica en la Administración Pública no es una cuestión meramente informática: es un acto de respeto democrático hacia el contribuyente y una contribución activa a la sostenibilidad de los servicios públicos esenciales.

---

<a id="8-un-ano-despues-el-caso-indramind-la-interconexion-del-sector-y-la-soberania-tecnica"></a>
## 8. Un Año Después: El Caso IndraMind, la Interconexión del Sector y la Soberanía Técnica

Transcurrido un año desde mi experiencia en NubeSARA, mi trayectoria profesional me llevó a incorporarme como consultor externo a otra iniciativa de máxima relevancia estratégica: **IndraMind** (ecosistema integral de IA soberana presentado por el **Grupo Indra** el 12 de marzo de 2025 para infraestructuras críticas y defensa). Mi **paso fugaz** por el proyecto —enmarcado en una cobertura coyuntural estival— me aportó un valioso contraste arquitectónico y sociológico sobre la realidad de las plataformas en España:

### 1. Arquitectura del IDP (Pragmatismo Cloud vs. Sobre-Ingeniería)
Frente a la hiper-personalización extrema de Tekton en NubeSARA, IndraMind combinó estándares consolidados de código abierto sobre **Red Hat OpenShift on AWS (ROSA)** con **Traefik OSS** (routing perimetral), **Spotify Backstage** (portal CNCF), **Forgejo** (Git soberano), **Tuleap** (trazabilidad ALM), **Keycloak + HashiCorp Vault** (IAM y gestión de secretos), **Jenkins + ArgoCD** (CI/CD GitOps), **Project Quay** (registry OCI) y una suite DevSecOps con **Grype** (en sustitución de Trivy), **OWASP ZAP**, **DefectDojo** e **IA soberana con arquitectura RAG** para soporte técnico contextual.

### 2. Auditoría Técnica en Plena Transición y Resolución de Enrutamiento (Traefik Ingress FQDN)
En la práctica, mi labor me transmitió la clara impresión de acometer una **auditoría técnica y estabilización en un momento de transición y cambios organizativos**. Más allá del diagnóstico, resolví problemas clave de gestión técnica y arquitectura de red, singularmente en torno a **Traefik Ingress** y el enrutamiento interno de endpoints FQDN, asegurando la conectividad y el aislamiento tanto del tráfico perimetral exterior-interior (**North-South**) como de la intercomunicación entre los servicios de la plataforma (**East-West**), entre otros requerimientos operativos.

### 3. Iniciativa Documental con IA ante el Vacío Escrito
Pese a no existir documentación previa por la juventud del proyecto (la transferencia era puramente oral por Teams), resolví esta carencia de forma proactiva: generé entre **21 y 23 documentos técnicos exhaustivos en Confluence** enriquecidos con infografías y vídeos explicativos elaborados con Gemini, y estructuré notas minuciosas en los tickets de **Jira** (formato Jira / MediaWiki) con el soporte del Copilot web corporativo, garantizando un rastro transparente de auditoría y requisitos.

### 4. Onboarding, Dinámica de Equipo y Desencuentro Inicial
Junto a un compañerismo y acogida excelentes con mis compañeros de base, mi interacción técnica directa se limitó a **una única conversación inicial** con el referente técnico que había levantado la plataforma en solitario (sin activación de cámara). Este interlocutor actuó asumiendo un rol de mando jerárquico como si fuera mi jefe en cliente —sin ostentar dicha condición formal ni haberse comunicado relación de subordinación alguna—, proyectando una urgencia desmedida bajo un cuadro verosímil de *burnout*. Mi legítima queja formal ante la dirección —motivada por el rigor y mi comprensible inquietud ante la inestabilidad laboral por fricciones injustificadas desde el inicio— permitió reconducir el proyecto: no volví a tener contacto con dicho interlocutor y dos compañeros de equipo asumieron con gran solvencia mi guía cotidiana.

### 5. La Interconexión del Ecosistema TIC, la Gestión Relacional del Talento y la Inquietud Deontológica
Más allá del plano operativo, la concurrencia de estas vivencias —el rigor técnico en NubeSARA frente a la obsolescencia y la singular acogida en IndraMind un año después— me suscitó una honda reflexión sobre la **sociología interna y la alta concentración de la consultoría tecnológica en el sector público**.  
En un mercado dominado por un reducido círculo de integradoras que gestionan y rotan en las infraestructuras críticas del Estado (desde la acción exterior consular hasta la defensa), los mecanismos de selección, continuidad y promoción a menudo se ven permeados por lógicas alejadas de la estricta solvencia técnica:
- *Redes de Afinidad frente a Excelencia Diagnóstica:* En estructuras fuertemente jerarquizadas e intermediadas, el reconocimiento, la asignación de responsabilidades nucleares y las oportunidades de desarrollo tienden con frecuencia a recompensar la adhesión a narrativas corporativas de conveniencia y la docilidad organizativa por encima de la capacidad de detección de anomalías o la resolución objetiva de problemas. Quien señala disfunciones estructurales o cuestiona atajos técnicos suele ser percibido no como una garantía de resiliencia, sino como un elemento discordante frente al *status quo*.
- *La Circularidad de los Vasos Comunicantes y los Filtros Tácitos:* La densa interconexión de cuadros directivos y mandos intermedios opera a menudo como un sistema informal de vasos comunicantes donde fluyen valoraciones subjetivas y filtros relacionales difícilmente fiscalizables. Me resulta difícil eludir una legítima perplejidad deontológica al percibir cómo haber ejercido un criterio técnico independiente y de alerta fundamentada el año anterior parece proyectar sutiles inercias o predisposiciones atípicas en proyectos posteriores dentro del mismo tejido empresarial, condicionando oportunidades mediante barreras invisibles.
- *La Paradoja Institucional del Talento:* Se genera así una notable distorsión: mientras los pliegos públicos apelan formalmente a la captación de perfiles altamente cualificados con presupuestos millonarios, las dinámicas internas de conveniencia pueden acabar desincentivando precisamente a aquellos ingenieros que demostramos mayor autonomía de criterio, rigor metodológico y compromiso ético con el resultado duradero.

---

<a id="9-el-sentido-y-legitimidad-de-este-repositorio-soberania-tecnica-frente-a-los-filtros-de-conveniencia"></a>
## 9. El Sentido y Legitimidad de este Repositorio: Soberanía Técnica frente a los Filtros de Conveniencia

Es precisamente este periplo —culminado tras mi revelador y fugaz paso por IndraMind casi un año después de lo acontecido en el MAEC— lo que otorga su pleno sentido ético, técnico y cívico a mi decisión de publicar este proyecto:

Cuando los entornos corporativos operan mediante lógicas relacionales opacas, acuerdos tácitos de conveniencia o dinámicas donde el alineamiento formal pesa más que la verdad de la ingeniería, **el software libre y la publicación abierta se erigen para mí como el espacio supremo de restitución profesional, soberanía técnica y transparencia pública**. 

Frente a cualquier mecanismo informal de amortiguación del mérito o juicios emitidos a puerta cerrada, publico este repositorio para devolver el debate al terreno inexpugnable de los hechos:
- He documentado la arquitectura al milímetro sin omisiones.
- Entrego código completamente funcional, reproducible y verificable por pares.
- Las decisiones técnicas que he implementado responden a estándares abiertos de la industria (CNCF, Red Hat, OIDC, GitOps, ENS) y defienden el erario público.

Al poner mi trabajo a disposición de la comunidad, de las administraciones públicas y de la ingeniería, demuestro que **la verdadera solvencia de un profesional no depende de la complacencia ante circuitos relacionales cerrados, sino de la calidad demostrable de su trabajo, la honestidad en el diagnóstico y la vocación innegociable de servicio al bien común**.

---

<a id="10-especificaciones-tecnicas-del-software-heredado-y-del-entorno-nubesara-air-gapped"></a>
## 10. Especificaciones Técnicas del Software Heredado y del Entorno NubeSARA Air-Gapped

### Naturaleza del Software Heredado (Legacy Monolith)
El Cliente Ligero SCSP analizado responde a un patrón arquitectónico clásico de la era **J2EE (Java 2 Platform, Enterprise Edition)**:
1. **Plataforma Java 8:** Dependencia estricta de bibliotecas compiladas con bytecode Java 1.8 y servlets 3.1.
2. **Servidor de Aplicaciones:** Diseñado originalmente para Apache Tomcat 7/8 o JBoss EAP, actualmente soportado sobre **Red Hat JBoss Web Server (JWS) 5.4** (Tomcat 9 sobre RHEL 8).
3. **Estado de Sesión en Memoria (Stateful / Sticky Sessions):** El flujo de navegación del usuario y la tramitación de expedientes almacenan objetos complejos en la `HttpSession` de Java.
4. **Base de Datos Relacional Externa:** Utiliza **Microsoft SQL Server** para auditoría de transacciones, logs de intermediación y parametrización de certificados de firma electrónica.
5. **Drivers JDBC Propietarios:** Requiere el conector con licencia cerrada `mssql-jdbc-8.4.1.jre8.jar`, el cual no viene incluido en imágenes base de software libre.

### El Entorno Desconectado: Red SARA y NubeSARA
**NubeSARA** es la nube privada gubernamental donde se alojan clústeres de **Red Hat OpenShift Container Platform (OCP)**. Por estrictas directrices de seguridad del **Centro Criptológico Nacional (CCN-CERT)** y del **Esquema Nacional de Seguridad (ENS - Categoría Alta)**, esta infraestructura opera en modo **Air-Gapped** (completamente aislada de Internet público):
- **Sin resolución DNS pública:** Prohibición de acceso a registros comerciales como Docker Hub, Quay.io o Red Hat Registry.
- **Sin acceso saliente general:** Restricción perimetral absoluta del tráfico de red saliente desde los contenedores (normativa SUGICYR).
- **Prohibición de ClickOps:** Todos los cambios en producción deben ser auditables, trazables y preferiblemente gestionados mediante código declarativo.
- **Topología Multi-Clúster y Ausencia de Clúster DEV en NubeSARA:** En el perímetro ministerial de NubeSARA no existía un clúster de desarrollo (DEV) propio. Dicho entorno pertenecía a Minsait y estaba alojado en Microsoft Azure para este y otros proyectos, si bien la propia Minsait recomendaba formalmente al MAEC desplegar su propio clúster OCP DEV interno en NubeSARA. Por ello, el clúster de QA asumía en el ministerio el papel de primer banco de pruebas.

### Retos Clave de la Migración "Lift-and-Shift" a Contenedores

| Reto Clave | Causa Técnica | Impacto Sin Solución Cloud-Native |
| :--- | :--- | :--- |
| **Amnesia de Sesión** | Los pods de Kubernetes son efímeros y se recrean dinámicamente. | Si un pod se reinicia o escala, el funcionario o ciudadano pierde el trámite en curso (*Session Lost*). |
| **Aislamiento de Registro** | No hay acceso a `registry.redhat.io`. | Fallo en la descarga de imágenes base y operadores (`ImagePullBackOff`). |
| **Incompatibilidad cgroups JVM** | Java 8 ignora límites de contenedores Linux cgroups v1/v2 por defecto. | La JVM consume la RAM del nodo físico y es aniquilada por el `OOMKiller`. |
| **CrashLoopBackOff en Arranque** | Monolitos J2EE tardan 40-70 segundos en inicializar el pool JDBC y validar contextos. | Probes por defecto de Kubernetes matan el contenedor prematuramente creyendo que falló. |
| **Seguridad Egress** | Los pods tienen red abierta saliente por defecto en clústeres no protegidos. | Incumplimiento de la política perimetral SUGICYR / ENS de Red SARA. |

### El Arquetipo Común: De la Experiencia MAEC al Patrón Universal
Aunque este monográfico se enmarca en la experiencia técnica real del **MAEC** y el **Cliente Ligero SCSP**, las restricciones descritas constituyen el **arquetipo idéntico al que se enfrentan los departamentos de arquitectura en la gran empresa**:
1. **Banca Transaccional (PCI-DSS):** Aplicaciones core de créditos o pasarelas de pago que no pueden perder la sesión del cliente al escalar y deben conectarse de forma segura a Oracle RAC o mainframes DB2 externos.
2. **Aseguradoras (Insurtech):** Tarifadores complejos multi-etapa con retención de presupuestos en `HttpSession`.
3. **Sistemas Hospitalarios (HealthTech):** Estaciones clínicas y receta electrónica 24/7 donde un CrashLoopBackOff o un corte de sesión paraliza la atención sanitaria.
4. **Telecomunicaciones y Utilities:** Portales de autoservicio y provisión masiva sobre redes restringidas.

---

<p align="center">
  <b>Página Anterior:</b> <span>⏮️ <i>(Inicio)</i></span> &nbsp;|&nbsp;
  <b><a href="../README.md">🏠 <b>Home / README</b></a></b> &nbsp;|&nbsp;
  <b>Página Siguiente:</b> <a href="02-comparativa-soluciones.md"><b>02. Comparativa de Soluciones ➡️</b></a>
</p>

---
