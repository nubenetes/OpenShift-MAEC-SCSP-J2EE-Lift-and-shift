# 📊 Galería de Diagramas de Arquitectura (Mermaid)

---

<p align="center">
  <b><a href="../../README.md">🏠 Home / README</a></b> &nbsp;|&nbsp;
  <b><a href="../02-comparativa-soluciones.md">⚖️ 02. Comparativa de Soluciones</a></b>
</p>

---

Este directorio aloja los ficheros fuente `.mermaid` originales utilizados en la documentación técnica del repositorio. A continuación se presentan renderizados interactivamente mediante bloques desplegables para su visualización directa en GitHub.

---

## 1. 🏛️ Arquitectura Global del Sistema (`architecture-overview.mermaid`)

Topología general del despliegue en **Red SARA / NubeSARA Air-Gapped**, integrando el clúster Red Hat OpenShift 4.x, zona de servicios compartidos (Quay, Nexus), caché distribuida (Infinispan), seguridad perimetral (Egress) y conexión a Microsoft SQL Server externo.

<details>
<summary><b>🏛️ Ver Diagrama Global de la Arquitectura (NubeSARA Air-Gapped)</b> (clic para desplegar)</summary>

```mermaid
graph TB
    subgraph RedSARA["Red SARA / NubeSARA (Air-Gapped)"]
        subgraph BastionZone["Zona Bastión Interno"]
            Quay["Mirror Registry Privado<br/>registro.nubesara.local:8443"]
            Nexus["Sonatype Nexus (Raw Hosted)<br/>nexus.nubesara.local:8081"]
        end

        subgraph OCPCluster["Clúster Red Hat OpenShift 4.x"]
            subgraph ControlPlane["Operadores / GitOps"]
                ArgoCD["OpenShift GitOps (ArgoCD 1.19+)<br/>namespace: openshift-gitops"]
                MCO["Machine Config Operator (MCO)<br/>IDMS / ITMS Registries Rewriting"]
                DataGridOp["Red Hat Data Grid Operator"]
            end

            subgraph WorkloadNS["Namespace: maec-scsp-prod"]
                Route["OpenShift Route (TLS Edge)<br/>scsp.apps.nubesara.local"]
                Service["Service: scsp-frontend:8080"]
                
                subgraph AppPods["SCSP Pods (JBoss Web Server 5.4 - Tomcat 9)"]
                    Pod1["SCSP Pod 1<br/>Heap: 70% (2.1GB) / G1GC<br/>Probes: 90s/60s"]
                    Pod2["SCSP Pod 2<br/>Heap: 70% (2.1GB) / G1GC<br/>Probes: 90s/60s"]
                end

                subgraph CacheTier["Caché de Sesiones Distribuida (Infinispan)"]
                    Infinispan1["Infinispan Replica 1<br/>HotRod :11222"]
                    Infinispan2["Infinispan Replica 2<br/>HotRod :11222"]
                end

                subgraph NetworkSecurity["Seguridad y Abstracción"]
                    Egress["EgressNetworkPolicy<br/>Allow: SQL Server + Services<br/>Deny: 0.0.0.0/0"]
                    DBService["Service: scsp-database-gateway:1433<br/>(Sin Selectores)"]
                    DBEndpoints["Endpoints: 10.50.25.105:1433"]
                end
            end
        end

        subgraph LegacyInfra["Infraestructura Externa (Red SARA)"]
            SQLServer[("Microsoft SQL Server<br/>IP: 10.50.25.105:1433<br/>SCSP_PROD_NUBESARA")]
        end
    end

    Route --> Service
    Service --> Pod1
    Service --> Pod2
    Pod1 -.->|HotRod TCP| Infinispan1
    Pod2 -.->|HotRod TCP| Infinispan2
    Infinispan1 <--> Infinispan2
    Pod1 -->|JDBC TDS| DBService
    Pod2 -->|JDBC TDS| DBService
    DBService --> DBEndpoints
    DBEndpoints -->|Red SARA| SQLServer
    Egress -.->|Filtrado OVS<br/>en veth| Pod1
    Egress -.->|Filtrado OVS<br/>en veth| Pod2
    ArgoCD --->|Reconciliación<br/>GitOps| WorkloadNS
    Quay --->|Pull de imágenes<br/>base| AppPods
    Nexus --->|Inyección de binarios<br/>en build| AppPods
```

</details>

---

## 2. ☸️ Flujo de Secuencia: Solución A - GitOps (`solution-a-gitops-flow.mermaid`)

Diagrama de secuencia del ciclo de despliegue declarativo automatizado con **OpenShift GitOps (ArgoCD 1.19+)** y **Sonatype Nexus**, demostrando la inmutabilidad de la construcción, reconciliación continua y borrado en cascada con finalizadores.

<details>
<summary><b>☸️ Ver Diagrama de Secuencia: Despliegue Declarativo GitOps (ArgoCD + Nexus)</b> (clic para desplegar)</summary>

```mermaid
sequenceDiagram
    autonumber
    actor Dev as Equipo Desarrollo / Release
    actor Admin as Administrador de Plataforma
    participant Nexus as Sonatype Nexus (scsp-raw)
    participant Git as Repositorio Git (scsp-gitops)
    participant ArgoCD as OpenShift GitOps (ArgoCD)
    participant OCP as OpenShift API / OLM
    participant Build as Pod Constructor (BuildConfig)
    participant Pods as Pods SCSP (JWS Tomcat 9)
    participant DG as Infinispan Data Grid
    participant DB as MS SQL Server (10.50.25.105)

    Dev->>Nexus: 1. Sube scsp-v2.war y mssql-jdbc.jar vía REST
    Admin->>Git: 2. Actualiza URL de binario en buildconfig.yaml y hace Push
    ArgoCD->>Git: 3. Detecta cambio (Polling / Webhook) y concilia estado
    ArgoCD->>OCP: 4. Aplica BuildConfig, Infinispan CR, Egress y Deployment
    OCP->>Build: 5. Ejecuta build inmutable descargando binario de Nexus
    Build->>OCP: 6. Publica nueva imagen en ImageStream (scsp-frontend:latest)
    OCP->>Pods: 7. Ejecuta Rolling Update sin caída de servicio
    Pods->>DG: 8. Conecta sesión a scsp-session-cache:11222 (HotRod)
    Pods->>DB: 9. Conecta pool JDBC a scsp-database-gateway:1433
    Note over ArgoCD,Pods: Con resources-finalizer, el borrado de Application destruye todo en cascada
```

</details>

---

## 3. 🚀 Flujo de Secuencia: Solución B - S2I Binario CLI (`solution-b-s2i-flow.mermaid`)

Diagrama de secuencia del ciclo de despliegue pragmático e imperativo mediante **Source-to-Image (S2I)** en modo binario directo por CLI (`oc start-build --from-dir`) y scripts de ciclo de vida.

<details>
<summary><b>🚀 Ver Diagrama de Secuencia: Despliegue Imperativo S2I Binario CLI</b> (clic para desplegar)</summary>

```mermaid
sequenceDiagram
    autonumber
    actor Admin as Administrador Bastión CLI
    participant Workspace as Workspace Local (deployments, lib, conf)
    participant OCP as OpenShift API
    participant S2I as S2I Builder Pod
    participant Registry as Registro Interno OCP
    participant Pods as SCSP Frontend Pods

    Admin->>Workspace: 1. Deposita scsp.war, mssql-jdbc.jar y context.xml
    Admin->>OCP: 2. Ejecuta 01-setup-prerequisites.sh (ns, operator, infinispan, db, egress)
    Admin->>OCP: 3. Ejecuta 02-build-s2i-binary.sh (oc new-build & oc start-build --from-dir)
    OCP->>S2I: 4. Transfiere tar binario por HTTP POST al pod constructor
    S2I->>Registry: 5. Ensambla y almacena scsp-app-core:latest
    Admin->>OCP: 6. Ejecuta 03-deploy-app.sh (Deployment, Service, Route)
    OCP->>Pods: 7. Despliega pods con JAVA_MAX_MEM_RATIO=70.0 y probes
    Pods-->>OCP: 8. Supera Liveness (90s) y Readiness (60s) -> Enrutado en Route
```

</details>

---

<p align="center">
  <b><a href="../../README.md">🏠 Volver al README Principal</a></b>
</p>
