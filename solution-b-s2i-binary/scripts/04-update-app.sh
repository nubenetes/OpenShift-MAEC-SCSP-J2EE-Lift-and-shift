#!/usr/bin/env bash
# ==============================================================================
# Paso 4: Actualización Día 2 en Solución B (Re-construcción S2I sin downtime)
# ==============================================================================
set -euo pipefail

NEW_WAR="${1:-}"
NAMESPACE="maec-scsp-s2i"
WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../workspace-template" && pwd)"

if [ -z "${NEW_WAR}" ] || [ ! -f "${NEW_WAR}" ]; then
    echo "Uso: $0 <ruta-al-nuevo-war>"
    exit 1
fi

echo "======================================================================"
echo " [DÍA 2 - S2I] Actualizando aplicación con nuevo WAR: ${NEW_WAR}"
echo "======================================================================"

cp "${NEW_WAR}" "${WORKSPACE_DIR}/deployments/scsp.war"

echo "-> Lanzando nueva construcción binaria..."
oc start-build scsp-app-core \
    --from-dir="${WORKSPACE_DIR}" \
    --follow \
    -n "${NAMESPACE}"

echo "-> OpenShift detectará el nuevo ImageStreamTag y ejecutará un Rolling Update."
oc rollout status deploy/scsp-frontend -n "${NAMESPACE}"
echo "✅ Actualización completada sin caída de servicio."
