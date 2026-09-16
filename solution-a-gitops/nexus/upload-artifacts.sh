#!/usr/bin/env bash
# ==============================================================================
# Subida de Artefactos Binarios Heredados (WAR y Driver JDBC) a Sonatype Nexus
# En GitOps estricto: Git almacena código/manifiestos, Nexus almacena binarios.
# ==============================================================================
set -euo pipefail

NEXUS_URL="${NEXUS_URL:-http://nexus.nubesara.local:8081}"
NEXUS_USER="${NEXUS_USER:-admin}"
NEXUS_PASS="${NEXUS_PASS:-PassSeguroNubeSARA!}"
REPO_NAME="scsp-raw"

WAR_FILE="${1:-./scsp.war}"
JDBC_DRIVER="${2:-./mssql-jdbc-8.4.1.jre8.jar}"

echo "======================================================================"
echo " Subiendo binarios de legado a Sonatype Nexus (${REPO_NAME})"
echo "======================================================================"

if [ -f "${WAR_FILE}" ]; then
    echo "-> Subiendo artefacto WAR: ${WAR_FILE}..."
    curl --fail -v -u "${NEXUS_USER}:${NEXUS_PASS}" \
        --upload-file "${WAR_FILE}" \
        "${NEXUS_URL}/repository/${REPO_NAME}/scsp.war"
    echo "WAR subido exitosamente."
else
    echo "AVISO: No se encontró '${WAR_FILE}'. Genera o proporciona el archivo WAR para cargarlo."
fi

if [ -f "${JDBC_DRIVER}" ]; then
    echo "-> Subiendo driver JDBC Microsoft SQL Server: ${JDBC_DRIVER}..."
    curl --fail -v -u "${NEXUS_USER}:${NEXUS_PASS}" \
        --upload-file "${JDBC_DRIVER}" \
        "${NEXUS_URL}/repository/${REPO_NAME}/mssql-jdbc-8.4.1.jre8.jar"
    echo "Driver JDBC subido exitosamente."
else
    echo "AVISO: No se encontró '${JDBC_DRIVER}'. Descárgalo o proporciónalo para cargarlo."
fi

echo "======================================================================"
echo " Verificación en Nexus:"
echo " curl -u ${NEXUS_USER}:**** -I ${NEXUS_URL}/repository/${REPO_NAME}/scsp.war"
echo "======================================================================"
