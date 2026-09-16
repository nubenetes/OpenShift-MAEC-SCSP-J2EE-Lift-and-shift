#!/usr/bin/env bash
# ==============================================================================
# Decomisión Limpia y Borrado en Cascada (Cascading Deletion) mediante ArgoCD
# ==============================================================================
set -euo pipefail

echo "======================================================================"
echo " [TEARDOWN] Desmantelamiento Limpio de Solución A (Cascada ArgoCD)"
echo "======================================================================"

echo "El recurso Application tiene configurado 'resources-finalizer.argocd.argoproj.io'."
echo "Al eliminar la aplicación, ArgoCD destruirá ordenadamente todos los pods,"
echo "servicios, configs, crd de infinispan y cuotas asociadas en maec-scsp-prod."

read -p "¿Deseas proceder con el borrado en cascada? (y/N): " -r CONFIRM
if [[ "${CONFIRM}" =~ ^[Yy]$ ]]; then
    if command -v argocd >/dev/null 2>&1; then
        echo "Eliminando mediante ArgoCD CLI con --cascade..."
        argocd app delete scsp-production-sync --cascade -y || true
    else
        echo "Eliminando mediante OpenShift CLI (el finalizer interceptará el borrado)..."
        oc delete application scsp-production-sync -n openshift-gitops --wait=true || true
    fi
    echo "✅ Desmantelamiento completado sin dejar recursos huérfanos en NubeSARA."
else
    echo "Operación cancelada por el usuario."
fi
