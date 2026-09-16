#!/usr/bin/env bash
# ==============================================================================
# Paso 1: Configuración de Prerrequisitos de Infraestructura (Solución B - S2I)
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFESTS_DIR="$(cd "${SCRIPT_DIR}/../manifests" && pwd)"
NAMESPACE="maec-scsp-s2i"

echo "======================================================================"
echo " [SOLUCIÓN B - PASO 1] Desplegando prerrequisitos en namespace '${NAMESPACE}'"
echo "======================================================================"

echo "-> Creando Namespace..."
oc apply -f "${MANIFESTS_DIR}/00-namespace.yaml"

echo "-> Instalando Operador Red Hat Data Grid (Infinispan)..."
oc apply -f "${MANIFESTS_DIR}/01-datagrid-operator.yaml"

echo "-> Esperando a que el operador DataGrid esté listo..."
sleep 5
oc wait --for=condition=Established crd/infinispans.infinispan.org --timeout=120s 2>/dev/null || {
    echo "AVISO: Esperando registro del CRD infinispan..."
}

echo "-> Desplegando clúster de caché de sesiones Infinispan (2 réplicas)..."
oc apply -f "${MANIFESTS_DIR}/02-datagrid-infinispan.yaml"

echo "-> Desplegando abstracción de red hacia SQL Server externo (Service + Endpoints)..."
oc apply -f "${MANIFESTS_DIR}/03-external-db.yaml"

echo "-> Aplicando política estricta de salida perimetral (EgressNetworkPolicy)..."
oc apply -f "${MANIFESTS_DIR}/04-egress-firewall.yaml"

echo "-> Creando Secret con credenciales de base de datos..."
if ! oc get secret scsp-sql-credentials -n "${NAMESPACE}" >/dev/null 2>&1; then
    oc create secret generic scsp-sql-credentials \
        --from-literal=DB_USERNAME="user_scsp_app" \
        --from-literal=DB_PASSWORD="Tr@nsaccion3sSeguras2026!" \
        --from-literal=DB_NAME="SCSP_PROD_NUBESARA" \
        -n "${NAMESPACE}"
fi

echo "======================================================================"
echo " ✅ Prerrequisitos desplegados exitosamente en '${NAMESPACE}'."
echo "======================================================================"
