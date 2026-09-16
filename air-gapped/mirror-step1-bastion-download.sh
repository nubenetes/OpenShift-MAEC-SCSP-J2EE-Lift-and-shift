#!/usr/bin/env bash
# ==============================================================================
# Paso 1: Descarga de Imágenes y Catálogos en Bastión Externo (Con Internet)
# Herramienta: oc-mirror v2
# ==============================================================================
set -euo pipefail

WORKSPACE_DIR="${1:-/mnt/usb-drive/oc-mirror-workspace}"
CONFIG_FILE="${2:-imageset-config.yaml}"

echo "======================================================================"
echo " [PASO 1] Iniciando descarga con oc-mirror v2 hacia medio extraíble"
echo " Workspace: ${WORKSPACE_DIR}"
echo " Config:    ${CONFIG_FILE}"
echo "======================================================================"

if ! command -v oc-mirror &> /dev/null; then
    echo "ERROR: El plugin 'oc-mirror' (v2) no se encuentra en el PATH."
    echo "Descárgalo desde el portal de clientes de Red Hat o mirror.openshift.com"
    exit 1
fi

mkdir -p "${WORKSPACE_DIR}"

echo "-> Ejecutando oc-mirror v2 con reintentos..."
oc mirror \
    --config="${CONFIG_FILE}" \
    "file://${WORKSPACE_DIR}" \
    --v2 \
    --retry-times 5 \
    --retry-delay 5s

echo "======================================================================"
echo " Descarga completada con éxito en ${WORKSPACE_DIR}."
echo " Por favor, traslada físicamente el medio de almacenamiento a la zona"
echo " interna desconectada de NubeSARA."
echo "======================================================================"
