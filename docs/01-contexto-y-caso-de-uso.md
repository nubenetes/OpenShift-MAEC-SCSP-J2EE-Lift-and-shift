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
- **La Consultora Saliente (Pliego de 4 Años, con los 2 Últimos de Implantación):** A lo largo del ciclo contractual completo de cuatro años —cuyos dos últimos años se dedicaron intensivamente a la implantación y modernización de la plataforma cloud (requiriendo dos tentativas y dos versiones/soluciones sucesivas hasta su estabilización)—, la consultora adjudicataria principal saliente (**Minsait**, en coordinación con socios tecnológicos como **Telefónica** y **Altia**) había desplegado, operado y administrado tanto las **infraestructuras** (CPDs, virtualización, redes y clústeres OpenShift en NubeSARA) como el **software nuclear** del ministerio (el framework *DOPE* y la arquitectura de microservicios de *SINAVI*).
- **Las Consultoras Entrantes y el Traspaso Operativo:** Con la nueva licitación ministerial desembarcó un nuevo conjunto de empresas integradoras: **Alten** (adjudicataria del lote especializado en **DevOps, automatización y QA**), **NTT Data** (responsable de la administración de bases de datos corporativas DBAs y soporte), **Teknei** (desarrollo e integración), entre otras firmas.
- **El Desafío de la Transferencia de Conocimiento (*Handover*):** En este escenario de relevo, los equipos de las adjudicatarias entrantes afrontaron la difícil tarea de **hacerse con el conocimiento y gobierno operativo (*know-how*)** acumulado durante los cuatro años de contrato por la consultora (en principio) saliente. Esta convivencia de múltiples actores en un entorno cerrado y de alta seguridad como NubeSARA condicionó la necesidad de abordar con rigor técnico el desacoplamiento y migración a OpenShift de aplicaciones monolíticas heredadas como SCSP.

#### Inventario Público de Contratación TIC en el MAEC: Mapa de Empresas Consultoras, Pliegos y Asignación de Lotes

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
> En el marco de la Ley 9/2017 de Contratos del Sector Público (LCSP), conviven tres figuras:  
> 1. **Licitaciones con División Formal en Lotes (Regla General, art. 99.1 LCSP):** Como el exp. **2024000090** (**Lote 1** Teknei, **Lote 2** Alten) o el exp. **2024000071** (**Lote 1** y **Lote 2** Telefónica), diseñadas para permitir la concurrencia de proveedores especializados.  
> 2. **Licitaciones de Lote Único (Excepción Justificada, art. 99.3 LCSP):** Como el exp. **CEA3422/2026** (SINAVI con Minsait) o suministros de CPD con Inetum, donde la prestación no puede escindirse sin riesgo técnico o de seguridad.  
> 3. **Contratos Derivados de Acuerdos Marco Centralizados (DGRCC - Hacienda):** Donde la división en lotes reside en el acuerdo marco estatal matriz (ej. Acuerdo Marco 26/2021 de desarrollo/mantenimiento), adjudicándose contratos basados a consultoras homologadas (NTT Data, Capgemini, Viewnext, Babel).

### 1.2. La Dualidad de Arquitecturas en el MAEC: SINAVI / e-LINCE ("DOPE Framework") vs. Monolitos como SCSP

En el ecosistema tecnológico gobernado por la SUGICYR en NubeSARA coexisten dos realidades arquitectónicas que exigen estrategias de plataforma diferenciadas:

1. **Ecosistema de Microservicios Cloud-Native (DOPE Framework):**  
   Para sistemas modernos de gran envergadura como **SINAVI (Sistema de Información Nacional de Visados)** —utilizado por la red consular española en todo el mundo para la tramitación de visados, conectado con el VIS europeo y el portal **SuTRAMITE Consular** (`sutramiteconsular.maec.es`)— o **e-LINCE** —sistema centralizado para la gestión económica y control de las Cajas Pagadoras en el exterior—, la adjudicataria **Minsait** desarrolló para el ministerio el **"DOPE framework"** (*DevOps Platform Ecosystem*). Se trata de un marco altamente personalizado diseñado para orquestar del orden de **100 microservicios** independientes mediante dos capas desacopladas sobre OpenShift:
   - **Capa CI con Red Hat OpenShift Pipelines (Motor Tekton):** Tuberías automatizadas declaradas mediante CRDs de Kubernetes (`Tasks`, `Pipelines`, `PipelineRuns`, `TriggerTemplates`, `EventListeners`). Cada commit desencadena la ejecución de tareas en pods efímeros aislados: clonado Git seguro, compilación multi-módulo (Maven/Node.js), análisis estático de código y calidad (SonarQube), verificación de dependencias y vulnerabilidades (SCA), empaquetado de contenedores OCI con Buildah en modo *rootless*, y publicación en el registro interno (Quay/Nexus), compartiendo cachés mediante volúmenes multi-escritura (`PVC RWX`).
   - **Capa CD con Red Hat OpenShift GitOps (Motor ArgoCD):** Entrega continua declarativa con Git como única fuente de verdad. Emplea patrones de gran escala como **ApplicationSet** y **App-of-Apps** para gobernar las dependencias y el ciclo de vida de los cerca de 100 microservicios, reconciliando continuamente el estado deseado contra los clústeres independientes de NubeSARA (**QA**, **PRE**, **PRO**) con auto-sanación (`selfHeal: true`) y sincronización desatendida.

2. **Monolitos Heredados de Terceros (Cliente Ligero SCSP):**  
   En el extremo opuesto se sitúan aplicaciones críticas de intermediación como el **Cliente Ligero SCSP**, suministradas por contratistas como un único entregable binario cerrado (`.war` de Java 8 empaquetado para Tomcat).  
   - Intentar asimilar forzosamente estas aplicaciones de legado a los estándares, CRDs de Tekton y mecanismos del *DOPE framework* constituye un **antipatrón de sobre-ingeniería**: genera dependencias innecesarias, multiplica la superficie de fallo en redes desconectadas y paraliza la migración durante meses.
   - La solución idónea para este perfil no es el rediseño micro-modular ni pipelines complejos con TaskRuns efímeros sobre bastiones aislados, sino el **Lift-and-Shift declarativo pragmático** (S2I / BuildConfig nativo + Sonatype Nexus + GitOps) documentado en esta referencia.

### 1.2.1. Asignaciones de Gobernanza CI/CD (sin Acceso CLI), Alerta de Obsolescencia en OpenShift y Soporte Extraordinario de Red Hat

En el contexto de la incorporación de nuevos perfiles de ingeniería al MAEC, el gobierno operativo de la plataforma planteó desafíos técnicos y de seguridad de primer orden:

1. **La Asignación Operativa: Gobernanza del Ecosistema CI/CD sin Acceso CLI:**  
   Dentro de las asignaciones prioritarias encomendadas al perfil de ingeniería DevOps entrante, figuraba la absorción, aprendizaje y gobernanza de todo el complejísimo ecosistema de integración y entrega continua (CI/CD) de la plataforma ministerial. Esta labor debía acometerse bajo severas limitaciones de entorno: **sin disponer de accesos por línea de comandos (CLI)** ni privilegios de terminal interactiva sobre los nodos o clústeres, viéndose obligado a desentrañar y auditar la arquitectura de los pipelines exclusivamente a través de interfaces gráficas web y consolas con permisos fuertemente acotados. La plataforma orquestaba la entrega de aplicaciones de enorme criticidad y volumen como **SINAVI** (con cerca de un centenar de microservicios distribuidos a nivel consular mundial bajo el *DOPE framework* de Minsait) y **e-LINCE** (sistema centralizado para la gestión económica y control de Cajas Pagadoras en el exterior), entre otros aplicativos ministeriales.

2. **Detección y Alerta Temprana de Obsolescencia en la Plataforma OpenShift:**  
   Durante el proceso de inmersión y análisis de gobernanza, el ingeniero identificó y trasladó formalmente a la dirección técnica —no sin honda preocupación técnica por la estabilidad operativa de los servicios del Estado— una situación de alto riesgo: **los clústeres de Red Hat OpenShift en NubeSARA no estaban siendo debidamente actualizados**, acumulando un retraso de mantenimiento que los situaba al borde de la pérdida inminente de soporte oficial del fabricante (**End of Life / expiración de soporte EUS**). La gravedad del hallazgo radicaba en que **la práctica totalidad de los pipelines de CI/CD (Tekton, operadores, frameworks y tareas automatizadas)** presentaban dependencias y acoplamientos directos con las APIs de la versión de OpenShift en obsolescencia, amenazando con bloquear la entrega continua y dejar sin cobertura de soporte del fabricante al ministerio ante cualquier fallo crítico o vulnerabilidad de seguridad.

3. **Escalado Proactivo a Red Hat, Superación de Restricciones Air-Gapped (ENS Alto) y Soporte Extraordinario:**  
   Ante el riesgo de descuelgue tecnológico de plataformas esenciales, el profesional asumió la iniciativa técnica de **escalar de forma proactiva la situación directamente a Red Hat**:
   - Para ello, tuvo que sortear y superar complejas dificultades técnicas y organizativas derivadas del aislamiento estricto de la infraestructura (**NubeSARA Air-Gapped** sin salida a Internet), el cumplimiento riguroso de las directrices del **Esquema Nacional de Seguridad (ENS - Categoría Alta)** y la carencia de terminal CLI en los clústeres para la extracción convencional de trazas.
   - Mediante un riguroso procedimiento de recopilación y custodia a través de los circuitos autorizados de exportación, logró extraer y transferir con éxito la información diagnóstica esencial (*must-gather*, métricas de operadores y logs de estado del clúster) para su carga en el portal oficial de soporte de **Red Hat**.
   - Esta aportación diagnóstica permitió a los ingenieros de Red Hat llevar a cabo un primer análisis proactivo integral de compatibilidad y conceder una ventana de **soporte extraordinario del fabricante**, protegiendo la resiliencia y la continuidad operativa del ministerio mientras **Minsait (Indra)**, en calidad de proveedora de infraestructura y plataforma base, gestionaba y planificaba internamente el complejo proyecto de actualización de versiones de OpenShift.

### 1.3. La Criticidad de un Monolito de 20 Años y la Gestión Prudente del Riesgo (Plan B vs. Fase 1)

El Cliente Ligero SCSP es una aplicación con cerca de dos décadas de vida en el ecosistema de la administración pública española. Lejos de ser un sistema secundario, constituye una **pieza de infraestructura crítica de primer orden** para el MAEC:
- **Impacto Operativo Global:** Al ser la pasarela obligatoria para consultar telemáticamente identidades (DGP), antecedentes penales y delitos sexuales (Justicia), titulaciones universitarias (Educación) y corrientes de pago (AEAT y Seguridad Social), cualquier caída o incompatibilidad técnica paralizaría de forma fulminante la actividad de los consulados y embajadas en todo el mundo (visados Schengen, expedientes de nacionalidad, pasaportes y notarías), obligando a los ciudadanos a recabar certificados en papel en España en flagrante vulneración de la Ley 39/2015.
- **El Vacío de Soporte del Proveedor:** El cliente ministerial exigía migrar esta aplicación a **Red Hat OpenShift en NubeSARA**. Sin embargo, la empresa adjudicataria responsable del software **no ofrecía soporte alguno para contenedores, Kubernetes u OpenShift**. Toda su documentación, guías de instalación y homologaciones estaban circunscritas a servidores físicos o máquinas virtuales tradicionales con Apache Tomcat.
- **La Recomendación del "Plan B" Tradicional:** Ante semejante nivel de riesgo y la ausencia total de documentación del proveedor para contenedores, la prudencia técnica de un perfil **DevOps Senior** exigía no jugar a la ruleta rusa con un servicio crítico: se propuso formalmente mantener y no descartar un **"Plan B"** de despliegue sobre infraestructura tradicional (máquinas virtuales con Tomcat dedicado) como red de seguridad amparada por el soporte del fabricante. Si bien esta recomendación preventiva no llegó a implementarse por parte de la gestión —a pesar de que meses atrás otro profesional de **NTT Data** había intentado infructuosamente durante varios meses hacer funcionar el despliegue sin conseguirlo—, ponía de manifiesto el rigor metodológico necesario ante sistemas de misión crítica.
- **La Validación de la Fase 1 en una Ventana de 4–5 Semanas Multitarea:** Pese a no contar con ese respaldo preventivo en paralelo y superando los meses de intentos fallidos previos de terceros, la arquitectura implementada en este repositorio (Fase 1: S2I Binario CLI con inyección externa de configuración) logró validar y estabilizar con éxito la ejecución de la aplicación en el primer clúster de pruebas de OpenShift en NubeSARA en una **estrecha ventana de apenas 4 a 5 semanas**, compatibilizando este esfuerzo con otras asignaciones ministeriales de máxima criticidad y urgencia simultáneas (gobernanza del ecosistema CI/CD sin acceso CLI, alerta de fin de soporte de OCP y gestión del soporte extraordinario con Red Hat), demostrando que era viable modernizar el monolito sin alterar su binario ni violar la garantía del fabricante.

### 1.4. Reflexión Cívica y Ética: Esfuerzo Fiscal, Empleo Tecnológico y Fondos Públicos

Este ejercicio de ingeniería abierta no puede desvincularse de la responsabilidad cívica intrínseca a todo proyecto público financiado con el erario común y los fondos europeos **Next-Generation EU**:

- **La Mirada Cívica del Contribuyente:** La ciudadanía asume un notable esfuerzo tributario cotidiano (con ejemplos tan elocuentes como los gravámenes de entre el 6% y el 10% en ITP/AJD al adquirir una primera vivienda habitual) en un contexto tensionado por la inflación y el coste de vida. Este compromiso colectivo exige, como correlato ético e institucional, que los fondos públicos se gestionen con la máxima pulcritud, rigor técnico y orientación al resultado duradero, evitando que los presupuestos se diluyan en soluciones cosméticas o entregables de mera justificación formal.
- **La Dignificación del Empleo Tecnológico y el Fin de la Precarización:** La proliferación de cadenas de subcontratación multinivel en las licitaciones públicas de consultoría IT devalúa con frecuencia las condiciones y salarios de los perfiles de ingeniería que asumen la responsabilidad técnica real en la infraestructura crítica del Estado. Fomentar la meritocracia, la contratación justa y la cultura de los hechos técnicos frente a la retórica comercial es indispensable para retener el talento tecnológico y asegurar la resiliencia de los sistemas públicos.

### 1.5. Un Año Después: El Caso IndraMind, la Interconexión del Sector y la Soberanía Técnica

Transcurrido un año desde la experiencia en NubeSARA, la trayectoria del autor le llevó a incorporarse como consultor externo a otra iniciativa de máxima relevancia estratégica: **IndraMind** (ecosistema integral de IA soberana presentado por el **Grupo Indra** el 12 de marzo de 2025 para infraestructuras críticas y defensa). Este **paso fugaz** —enmarcado en una cobertura coyuntural estival— aportó un valioso contraste arquitectónico y sociológico sobre la realidad de las plataformas en España:

- **Arquitectura del IDP (Pragmatismo Cloud vs. Sobre-Ingeniería):** Frente a la hiper-personalización extrema de Tekton en NubeSARA, IndraMind combinó estándares consolidados de código abierto sobre **Red Hat OpenShift on AWS (ROSA)** con **Traefik OSS** (routing perimetral), **Spotify Backstage** (portal CNCF), **Forgejo** (Git soberano), **Tuleap** (trazabilidad ALM), **Keycloak + HashiCorp Vault** (IAM y gestión de secretos), **Jenkins + ArgoCD** (CI/CD GitOps), **Project Quay** (registry OCI) y una suite DevSecOps con **Grype** (en sustitución de Trivy), **OWASP ZAP**, **DefectDojo** e **IA soberana con arquitectura RAG** para soporte técnico contextual.
- **Auditoría Técnica en Plena Transición y Resolución de Enrutamiento (Traefik Ingress FQDN):**  
  En la práctica, la labor desarrollada transmitió la clara impresión de acometer una **auditoría técnica y estabilización en un momento de transición y cambios organizativos**. Más allá del diagnóstico, el profesional resolvió problemas clave de gestión técnica y arquitectura de red, singularmente en torno a **Traefik Ingress** y el enrutamiento interno de endpoints FQDN, asegurando la conectividad y el aislamiento tanto del tráfico perimetral exterior-interior (**North-South**) como de la intercomunicación entre los servicios de la plataforma (**East-West**), entre otros requerimientos operativos.
- **Iniciativa Documental con IA ante el Vacío Escrito:** Pese a no existir documentación previa por la juventud del proyecto (la transferencia era puramente oral por Teams), el profesional resolvió esta carencia de forma proactiva: generó entre **21 y 23 documentos técnicos exhaustivos en Confluence** enriquecidos con infografías y vídeos explicativos generados con Gemini, y estructuró notas minuciosas en los tickets de **Jira** (formato Jira / MediaWiki) con el soporte del Copilot web corporativo, garantizando un rastro transparente de auditoría y requisitos.
- **Onboarding, Dinámica de Equipo y Desencuentro Inicial:** Junto a un compañerismo y acogida excelentes con los ingenieros de base, la interacción técnica directa se limitó a **una única conversación inicial** con el referente técnico que había levantado la plataforma en solitario (sin activación de cámara). Este interlocutor actuó asumiendo un rol de mando jerárquico como si fuera el jefe en cliente —sin ostentar dicha condición formal ni haberse comunicado relación de subordinación alguna—, proyectando una urgencia desmedida bajo un cuadro verosímil de *burnout*. La legítima queja formal del profesional ante la dirección —motivada por el rigor y la comprensible inquietud ante la inestabilidad laboral por fricciones injustificadas desde el inicio— permitió reconducir el proyecto: no hubo más contacto con dicho interlocutor y dos compañeros de equipo asumieron con gran solvencia la guía cotidiana.
- **La Interconexión del Ecosistema TIC y la Inquietud Deontológica:**  
  Más allá del plano operativo, esta vivencia suscitó una honda reflexión sobre la **alta concentración y estrecha circularidad de la consultoría IT en el ámbito público**. En un entorno donde un selecto grupo de integradoras gestiona las infraestructuras críticas del Estado (desde el MAEC hasta defensa), los canales informales de referencias, los cuadros directivos compartidos y las relaciones corporativas funcionan a menudo como vasos comunicantes. Resulta difícil eludir la perplejidad y la preocupación deontológica al constatar cómo haber mantenido una postura de firmeza ética, rigor técnico y alerta frente a la obsolescencia en un proyecto ministerial el año anterior parece proyectar sutiles ecos o predisposiciones atípicas en iniciativas posteriores vinculadas al mismo ecosistema empresarial. Esto suscita un interrogante ético inevitable: ¿se prioriza el talento y la resolución de problemas, o se condiciona de manera informal a aquellos perfiles que ejercen un criterio técnico independiente y rechazan las narrativas de complacencia?

### 1.6. El Sentido y Legitimidad de este Repositorio

Es precisamente este periplo —culminado tras ese revelador y fugaz paso por IndraMind casi un año después de lo acontecido en el MAEC— lo que otorga su pleno sentido ético, técnico y cívico a la publicación de este proyecto:

Cuando los canales corporativos operan con opacidad, circularidad o filtros no técnicos, **el software libre y la publicación abierta se erigen como el espacio supremo de restitución profesional, soberanía técnica y transparencia pública**. Frente a cualquier narrativa de conveniencia o dinámicas de exclusión informal, este repositorio pone a disposición de la comunidad, de las administraciones públicas y de la ingeniería una solución completa, verificable y libre de atajos para la modernización de monolitos J2EE en OpenShift, demostrando que la verdadera valía de un profesional reside en los hechos técnicos, en el código operativo y en el servicio riguroso al bien común.

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
- **Topología Multi-Clúster y Ausencia de Clúster DEV en NubeSARA:** En el perímetro ministerial de NubeSARA no existía un clúster de desarrollo (DEV) propio. Dicho entorno pertenecía a Minsait y estaba alojado en Microsoft Azure para este y otros proyectos, si bien la propia Minsait recomendaba formalmente al MAEC desplegar su propio clúster OCP DEV interno en NubeSARA. Por ello, el clúster de QA asumía en el ministerio el papel de primer banco de pruebas.

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
