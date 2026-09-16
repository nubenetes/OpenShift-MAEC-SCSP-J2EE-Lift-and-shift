#!/usr/bin/env bash
# ==============================================================================
# Paso 3: Despliegue de la Aplicación, Tuning de JVM y Probes
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFESTS_DIR="$(cd "${SCRIPT_DIR}/../manifests" && pwd)"
NAMESPACE="maec-scsp-s2i"

echo "======================================================================"
echo " [SOLUCIÓN B - PASO 3] Desplegando Deployment, Service y Route"
echo " Namespace: ${NAMESPACE}"
echo "======================================================================"

echo "-> Aplicando Deployment (con cuotas, tuning JVM 70% y probes)..."
oc apply -f "${MANIFESTS_DIR}/06-deployment.yaml"

echo "-> Aplicando Service..."
oc apply -f "${MANIFESTS_DIR}/07-service.yaml"

echo "-> Creando Route TLS Edge..."
oc apply -f "${MANIFESTS_DIR}/08-route.yaml"

echo "-> Esperando a que el despliegue esté disponible..."
oc rollout status deploy/scsp-frontend -n "${NAMESPACE}" --timeout=180s || true

echo "======================================================================"
echo " ✅ Aplicación SCSP desplegada con éxito en '${NAMESPACE}'."
echo " Route URL: https://$(oc get route scsp-frontend -n ${NAMESPACE} -o jsonpath='{.spec.host}' 2>/dev/null || echo 'scsp-frontend.apps.nubesara.local')"
echo "======================================================================"
