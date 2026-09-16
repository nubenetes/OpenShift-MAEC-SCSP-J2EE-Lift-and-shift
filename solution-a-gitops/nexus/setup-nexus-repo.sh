#!/usr/bin/env bash
# ==============================================================================
# Configuración del Repositorio Raw en Sonatype Nexus (NubeSARA) vía REST API
# ==============================================================================
set -euo pipefail

NEXUS_URL="${NEXUS_URL:-http://nexus.nubesara.local:8081}"
NEXUS_USER="${NEXUS_USER:-admin}"
NEXUS_PASS="${NEXUS_PASS:-PassSeguroNubeSARA!}"
REPO_NAME="scsp-raw"

echo "======================================================================"
echo " Configurando repositorio hosted raw '${REPO_NAME}' en Sonatype Nexus"
echo " Nexus URL: ${NEXUS_URL}"
echo "======================================================================"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -u "${NEXUS_USER}:${NEXUS_PASS}" "${NEXUS_URL}/service/rest/v1/repositories/raw/hosted/${REPO_NAME}" || true)

if [ "${HTTP_CODE}" -eq 200 ]; then
    echo "El repositorio '${REPO_NAME}' ya existe en Nexus."
else
    echo "Creando repositorio '${REPO_NAME}'..."
    curl -fail -s -X POST \
        -u "${NEXUS_USER}:${NEXUS_PASS}" \
        -H "Content-Type: application/json" \
        -d @- "${NEXUS_URL}/service/rest/v1/repositories/raw/hosted" <<JSON_PAYLOAD
{
  "name": "${REPO_NAME}",
  "online": true,
  "storage": {
    "blobStoreName": "default",
    "strictContentTypeValidation": false,
    "writePolicy": "ALLOW_ONCE"
  }
}
JSON_PAYLOAD
    echo "Repositorio '${REPO_NAME}' creado correctamente."
fi
