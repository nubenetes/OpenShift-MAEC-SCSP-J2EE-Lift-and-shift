#!/usr/bin/env bash
# ==============================================================================
# Paso 2: Carga en el Registro Privado Interno de NubeSARA (Sin Internet)
# Herramienta: oc-mirror v2
# ==============================================================================
set -euo pipefail

WORKSPACE_DIR="${1:-/mnt/usb-drive/oc-mirror-workspace}"
TARGET_REGISTRY="${2:-docker://registro.nubesara.local:8443/maec-scsp}"

echo "======================================================================"
echo " [PASO 2] Inyectando imágenes al registro interno desconectado"
echo " Origen:  ${WORKSPACE_DIR}"
echo " Destino: ${TARGET_REGISTRY}"
echo "======================================================================"

if [ ! -d "${WORKSPACE_DIR}" ]; then
    echo "ERROR: El directorio de trabajo ${WORKSPACE_DIR} no existe."
    exit 1
fi

echo "-> Cargando imágenes hacia ${TARGET_REGISTRY}..."
oc mirror \
    --from="${WORKSPACE_DIR}" \
    "${TARGET_REGISTRY}" \
    --v2

echo "======================================================================"
echo " Carga al registro privado finalizada con éxito."
echo "======================================================================"
