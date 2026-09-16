#!/usr/bin/env bash
# ==============================================================================
# Paso 3: Aplicación de Directivas de Redirección (IDMS / ITMS / CatalogSource)
# ==============================================================================
set -euo pipefail

RESULTS_DIR="${1:-/mnt/usb-drive/oc-mirror-workspace/cluster-resources}"

echo "======================================================================"
echo " [PASO 3] Aplicando ImageDigestMirrorSet, ITMS y CatalogSource al Clúster"
echo " Directorio de manifiestos: ${RESULTS_DIR}"
echo "======================================================================"

if [ ! -d "${RESULTS_DIR}" ]; then
    # Intentar buscar subdirectorio results-* generado por oc-mirror v2
    AUTODISCOVER=$(find /mnt/usb-drive/oc-mirror-workspace -maxdepth 2 -type d -name "results-*" -o -name "cluster-resources" 2>/dev/null | head -n 1 || true)
    if [ -n "${AUTODISCOVER}" ] && [ -d "${AUTODISCOVER}" ]; then
        RESULTS_DIR="${AUTODISCOVER}"
        echo "-> Detectado directorio de recursos: ${RESULTS_DIR}"
    else
        echo "ERROR: No se encontró el directorio de recursos de clúster."
        echo "Asegúrate de indicar la ruta correcta generada por oc-mirror v2."
        exit 1
    fi
fi

echo "-> Aplicando IDMS (ImageDigestMirrorSet)..."
if [ -f "${RESULTS_DIR}/imageDigestMirrorSet.yaml" ]; then
    oc apply -f "${RESULTS_DIR}/imageDigestMirrorSet.yaml"
fi

echo "-> Aplicando ITMS (ImageTagMirrorSet)..."
if [ -f "${RESULTS_DIR}/imageTagMirrorSet.yaml" ]; then
    oc apply -f "${RESULTS_DIR}/imageTagMirrorSet.yaml"
fi

echo "-> Aplicando Catálogos de Operadores (CatalogSource)..."
if [ -f "${RESULTS_DIR}/catalogSource.yaml" ]; then
    oc apply -f "${RESULTS_DIR}/catalogSource.yaml"
elif [ -f "${RESULTS_DIR}/catalogSource-cs-redhat-operator-index.yaml" ]; then
    oc apply -f "${RESULTS_DIR}/catalogSource-"*.yaml
fi

echo "======================================================================"
echo " Recursos aplicados. El Machine Config Operator (MCO) reiniciará los"
echo " nodos secuencialmente para aplicar /etc/containers/registries.conf."
echo " Comprueba el estado con: oc get mcp"
echo "======================================================================"
