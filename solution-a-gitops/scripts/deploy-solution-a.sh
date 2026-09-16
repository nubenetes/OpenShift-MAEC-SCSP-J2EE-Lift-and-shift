#!/usr/bin/env bash
# ==============================================================================
# Despliegue Automatizado de Solución A: OpenShift GitOps (ArgoCD) + Nexus
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

echo "======================================================================"
echo " [SOLUCIÓN A] Despliegue Automatizado con OpenShift GitOps (ArgoCD)"
echo "======================================================================"

# 1. Verificar prerrequisitos de CLI
command -v oc >/dev/null 2>&1 || { echo "ERROR: 'oc' CLI no encontrado."; exit 1; }

echo "-> 1. Verificando suscripción del Operador OpenShift GitOps..."
oc apply -f "${ROOT_DIR}/solution-a-gitops/argocd/gitops-operator-subscription.yaml"

echo "-> 2. Esperando a que el operador y el namespace openshift-gitops estén listos..."
oc wait --for=condition=Ready pod -l app.kubernetes.io/name=openshift-gitops-server -n openshift-gitops --timeout=180s 2>/dev/null || {
    echo "AVISO: El servidor de ArgoCD aún se está iniciando o estás en modo simulación."
}

echo "-> 3. Creando secreto de credenciales de base de datos en maec-scsp-prod si no existe..."
oc create namespace maec-scsp-prod --dry-run=client -o yaml | oc apply -f -
if ! oc get secret scsp-sql-credentials -n maec-scsp-prod >/dev/null 2>&1; then
    echo "Creando secreto 'scsp-sql-credentials'..."
    oc create secret generic scsp-sql-credentials \
        --from-literal=DB_USERNAME="user_scsp_app" \
        --from-literal=DB_PASSWORD="Tr@nsaccion3sSeguras2026!" \
        --from-literal=DB_NAME="SCSP_PROD_NUBESARA" \
        -n maec-scsp-prod
fi

echo "-> 4. Aplicando manifiesto maestro ArgoCD Application..."
oc apply -f "${ROOT_DIR}/solution-a-gitops/argocd/scsp-application.yaml"

echo "======================================================================"
echo " ✅ Aplicación ArgoCD 'scsp-production-sync' registrada exitosamente."
echo " ArgoCD conciliará el estado de forma continua y autónoma."
echo " Consulta el estado con: oc get application scsp-production-sync -n openshift-gitops"
echo "======================================================================"
