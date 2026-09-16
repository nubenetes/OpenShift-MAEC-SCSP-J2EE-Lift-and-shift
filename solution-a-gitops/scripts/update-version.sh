#!/usr/bin/env bash
# ==============================================================================
# Flujo Operativo de Actualización Día 2 en GitOps
# Paso 1: Subida de nuevo binario a Nexus (ej. scsp-v2.war)
# Paso 2: Actualización de BuildConfig en Git -> Commit -> Push
# Paso 3: ArgoCD detecta drift y concilia -> Disparo de build inmutable
# ==============================================================================
set -euo pipefail

NEW_WAR_FILE="${1:-./scsp-v2.war}"
NEXUS_WAR_NAME="${2:-scsp-v2.war}"

echo "======================================================================"
echo " [DÍA 2] Actualización de Versión de SCSP mediante GitOps"
echo " Nuevo binario local: ${NEW_WAR_FILE}"
echo " Destino en Nexus:    ${NEXUS_WAR_NAME}"
echo "======================================================================"

if [ ! -f "${NEW_WAR_FILE}" ]; then
    echo "ERROR: No existe el archivo '${NEW_WAR_FILE}'."
    exit 1
fi

# 1. Subida a Nexus
echo "-> 1. Subiendo nueva versión a Sonatype Nexus..."
curl --fail -s -u "admin:PassSeguroNubeSARA!" \
    --upload-file "${NEW_WAR_FILE}" \
    "http://nexus.nubesara.local:8081/repository/scsp-raw/${NEXUS_WAR_NAME}"

echo "-> 2. El operador debe actualizar la referencia en 'solution-a-gitops/kustomize/base/buildconfig.yaml':"
echo "      http://nexus.nubesara.local:8081/repository/scsp-raw/${NEXUS_WAR_NAME}"
echo "-> 3. Realizar: git commit -am 'chore: upgrade scsp to ${NEXUS_WAR_NAME}' && git push"
echo "-> 4. ArgoCD detectará el drift y actualizará el BuildConfig."
echo "-> 5. Disparar construcción inmutable si no es automático:"
echo "      oc start-build scsp-app-build -n maec-scsp-prod --follow"
echo "======================================================================"
