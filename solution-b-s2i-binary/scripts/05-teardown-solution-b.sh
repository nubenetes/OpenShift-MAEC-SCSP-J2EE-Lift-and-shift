#!/usr/bin/env bash
# ==============================================================================
# Paso 5: Limpieza y Eliminación de Recursos de la Solución B
# ==============================================================================
set -euo pipefail

NAMESPACE="maec-scsp-s2i"

echo "======================================================================"
echo " [TEARDOWN] Eliminación de recursos de la Solución B en '${NAMESPACE}'"
echo "======================================================================"

read -p "¿Confirmas la eliminación del namespace '${NAMESPACE}' y todos sus recursos? (y/N): " -r CONFIRM
if [[ "${CONFIRM}" =~ ^[Yy]$ ]]; then
    echo "Eliminando namespace '${NAMESPACE}'..."
    oc delete namespace "${NAMESPACE}" --wait=true || true
    echo "✅ Entorno de Solución B desmantelado completamente."
else
    echo "Operación cancelada."
fi
