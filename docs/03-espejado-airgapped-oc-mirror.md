# 🔒 Ingeniería del Espejado Air-Gapped con oc-mirror v2

> [!WARNING]
> **Aviso:** Documentación generada con **Gemini 3.8 Flash** como blueprint didáctico conceptual.

---

## 1. El Desafío de la Red Desconectada

En el centro de datos de NubeSARA, la red no tiene ruta por defecto (`0.0.0.0/0`) hacia Internet. Cuando OpenShift intenta arrancar un pod o instalar un operador, la petición hacia `registry.redhat.io` expira en tiempo de espera (*Connection Timed Out*).

Para alimentar el registro interno corporativo (`registro.nubesara.local:8443`), se emplea el plugin **`oc-mirror` versión 2 (v2)**.

---

## 2. Ventajas Arquitectónicas de oc-mirror v2

A diferencia de la versión 1 y de las herramientas genéricas (`skopeo`, `podman`), la v2 ofrece:
- **Fragmentación automática por tamaño (`archiveSize: 16`):** Genera archivos `.tar` no superiores a 16 GB, adaptándose al tamaño de dispositivos cifrados homologados por el CCN o restricciones de diodos de red unidireccionales.
- **Generación de IDMS e ITMS:** OpenShift 4.14+ reemplazó el obsoleto CRD `ImageContentSourcePolicy` (ICSP) por dos recursos mucho más precisos:
  - `ImageDigestMirrorSet` (IDMS): Mapea peticiones basadas en hash SHA-256 (`@sha256:...`).
  - `ImageTagMirrorSet` (ITMS): Mapea peticiones basadas en etiqueta (`:latest`, `:v1.0`).
- **Caché diferencial basada en base de datos local SQLite:** Evita re-descargar capas de imágenes ya transferidas en sincronizaciones anteriores.

---

## 3. Manifiesto Maestro `imageset-config.yaml`

El archivo define exactamente el subconjunto de operadores e imágenes necesarios para el stack SCSP:

```yaml
kind: ImageSetConfiguration
apiVersion: mirror.openshift.io/v2alpha1
archiveSize: 16
mirror:
  platform:
    channels:
      - name: stable-4.17
        type: ocp
  operators:
    - catalog: registry.redhat.io/redhat/redhat-operator-index:v4.17
      packages:
        - name: datagrid
          channels:
            - name: 8.4.x
        - name: jws-operator
          channels:
            - name: stable
        - name: openshift-gitops-operator
          channels:
            - name: gitops-1.19
  additionalImages:
    - name: registry.redhat.io/jboss-webserver-5/webserver54-openjdk8-tomcat9-openshift-rhel8:latest
    - name: registry.redhat.io/ubi8/ubi-minimal:latest
```

---

## 4. Reescritura Criptográfica en los Nodos (MCO)

Al aplicar `imageDigestMirrorSet.yaml` e `imageTagMirrorSet.yaml` en el clúster:
```bash
oc apply -f /mnt/usb-drive/oc-mirror-workspace/cluster-resources/imageDigestMirrorSet.yaml
oc apply -f /mnt/usb-drive/oc-mirror-workspace/cluster-resources/imageTagMirrorSet.yaml
```

El **Machine Config Operator (MCO)** detecta el cambio, reescribe el archivo `/etc/containers/registries.conf` de CoreOS en los nodos maestros y de cómputo, y aplica un reinicio secuencial controlado (*graceful node reboot*). De esta forma, cualquier referencia interna en manifiestos hacia `registry.redhat.io/...` es redirigida transparentemente por CRI-O hacia `registro.nubesara.local:8443/...`.
