#!/usr/bin/env bash
# ==============================================================================
# Paso 2: Ensamblaje Binario Source-to-Image (S2I) en OpenShift
# Inyecta scsp.war, driver JDBC y context.xml directamente desde directorio local
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="${1:-${SCRIPT_DIR}/../workspace-template}"
NAMESPACE="maec-scsp-s2i"
BUILD_NAME="scsp-app-core"

echo "======================================================================"
echo " [SOLUCIÓN B - PASO 2] Construcción Binaria S2I JBoss Web Server (JWS 5.4)"
echo " Espacio de trabajo: ${WORKSPACE_DIR}"
echo " Namespace:          ${NAMESPACE}"
echo "======================================================================"

# Verificar si existe el WAR en deployments
if [ ! -f "${WORKSPACE_DIR}/deployments/scsp.war" ]; then
    echo "AVISO: No se encontró '${WORKSPACE_DIR}/deployments/scsp.war'."
    echo "Creando un paquete WAR simulado temporal para permitir el ensamblado..."
    mkdir -p /tmp/mock-war/WEB-INF
    cat << 'WAR_WEBXML' > /tmp/mock-war/WEB-INF/web.xml
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" version="3.1">
  <display-name>Cliente Ligero SCSP</display-name>
</web-app>
WAR_WEBXML
    echo "<h1>Cliente Ligero SCSP Mock - OK</h1>" > /tmp/mock-war/index.html
    (cd /tmp/mock-war && jar -cvf "${WORKSPACE_DIR}/deployments/scsp.war" . >/dev/null 2>&1 || tar -cf "${WORKSPACE_DIR}/deployments/scsp.war" .)
    rm -rf /tmp/mock-war
fi

# 1. Crear la definición BuildConfig binaria si no existe
if ! oc get bc "${BUILD_NAME}" -n "${NAMESPACE}" >/dev/null 2>&1; then
    echo "-> Creando BuildConfig binario '${BUILD_NAME}'..."
    oc new-build --binary=true \
        --image-stream=openshift/jboss-webserver54-openjdk8-tomcat9-openshift-rhel8:latest \
        --name="${BUILD_NAME}" \
        -n "${NAMESPACE}" || {
            echo "AVISO: ImageStream openshift/jboss-webserver54 no encontrado, usando registro local:"
            oc new-build --binary=true \
                --to="${BUILD_NAME}:latest" \
                --image-stream=jboss-webserver54-openjdk8-tomcat9-openshift-rhel8:latest \
                --name="${BUILD_NAME}" \
                -n "${NAMESPACE}"
        }
fi

# 2. Iniciar la construcción binaria enviando el directorio local
echo "-> Transfiriendo workspace e iniciando construcción S2I..."
oc start-build "${BUILD_NAME}" \
    --from-dir="${WORKSPACE_DIR}" \
    --follow \
    -n "${NAMESPACE}"

echo "======================================================================"
echo " ✅ Construcción finalizada. Imagen ensamblada: ${BUILD_NAME}:latest"
echo "======================================================================"
