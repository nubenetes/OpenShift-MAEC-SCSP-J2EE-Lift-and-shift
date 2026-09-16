# 🌐 Integración de Red Hat Advanced Cluster Management (RHACM)

> [!NOTE]
> **ESTADO DE INTEGRACIÓN EN EL PROYECTO REAL (MAEC / NubeSARA):**  
> En la infraestructura de NubeSARA, **OpenShift ACM (Red Hat Advanced Cluster Management)** estaba desplegado como clúster Hub para la administración centralizada de la flota de clústeres, aunque **aún no se encontraba plenamente integrado** en todos los flujos de despliegue continuo de aplicaciones.  
> Este módulo proporciona los manifiestos arquitectónicos que formalizan el puente de integración progresiva entre ACM y OpenShift GitOps (ArgoCD) para los clústeres gestionados de **QA, PRE y PRO**.

---

## 🏛️ Rol de OpenShift ACM en la Arquitectura

1. **Gestión Centralizada de Flota (*Fleet Management*):**
   - Un clúster Hub central de ACM supervisa y gobierna el ciclo de vida de los tres clústeres spoke de NubeSARA:
     - `ocp-qa` (entorno de pruebas y validaciones iniciales).
     - `ocp-pre` (entorno de preproducción y homologación).
     - `ocp-pro` (entorno de producción con confinamiento perimetral).

2. **Gobierno, Riesgo y Cumplimiento (GRC - Esquema Nacional de Seguridad):**
   - A través de directivas declarativas (`Policy`), ACM audita y fuerza la presencia de recursos críticos en los clústeres gestionados, tales como el cortafuegos saliente `EgressNetworkPolicy`, configuraciones de cgroups de JVM y políticas de no-clickops.

3. **Orquestación de GitOps Multi-Clúster:**
   - El recurso `GitOpsCluster` de ACM vincula la instancia central de OpenShift GitOps (ArgoCD) con los `ManagedCluster`, permitiendo que los despliegues de Kustomize (`overlays/qa`, `overlays/pre`, `overlays/prod`) se distribuyan automáticamente según las etiquetas del clúster (`Placement`).

---

## 📁 Manifiestos Incluidos

- [`managed-clusters-placement.yaml`](managed-clusters-placement.yaml): Definición del `Placement` de ACM que selecciona dinámicamente los clústeres en base a sus etiquetas (`environment: qa | pre | prod`).
- [`gitopscluster-binding.yaml`](gitopscluster-binding.yaml): Recurso `GitOpsCluster` que conecta el controlador de ArgoCD con el plano de control de ACM.
- [`policy-ens-egress.yaml`](policy-ens-egress.yaml): Política de gobernanza de ACM para auditar y forzar el cumplimiento del bloqueo Egress requerido por SUGICYR / ENS Nivel Alto en el clúster PRO.
