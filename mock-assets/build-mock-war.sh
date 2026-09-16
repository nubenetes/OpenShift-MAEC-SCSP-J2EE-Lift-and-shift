#!/usr/bin/env bash
# Script para compilar el mock war con Maven o empaquetarlo con jar/zip
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${SCRIPT_DIR}/scsp-sample-war"
OUTPUT_WAR="${SCRIPT_DIR}/scsp.war"

echo "Compilando mock WAR..."
if command -v mvn >/dev/null 2>&1; then
    (cd "${TARGET_DIR}" && mvn clean package -DskipTests)
    cp "${TARGET_DIR}/target/scsp.war" "${OUTPUT_WAR}"
else
    echo "Maven no encontrado, empaquetando archivos web estáticos en scsp.war..."
    (cd "${TARGET_DIR}/src/main/webapp" && jar -cvf "${OUTPUT_WAR}" . 2>/dev/null || zip -r "${OUTPUT_WAR}" .)
fi

echo "Mock WAR generado en: ${OUTPUT_WAR}"
