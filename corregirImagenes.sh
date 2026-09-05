#!/bin/bash

# Define la carpeta de imágenes (usa la ruta actual o pásala como parámetro)
TARGET_DIR="${1:-imgs}"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: La carpeta '$TARGET_DIR' no existe."
    exit 1
fi

echo "================================================="
echo " Verificando e instalando herramientas... "
echo "================================================="

# Verificar si mogrify (ImageMagick) está instalado
if ! command -v mogrify &> /dev/null; then
    echo "ImageMagick no está instalado. Instalando..."
    sudo apt-get update && sudo apt-get install -y imagemagick
fi

# Verificar si svgo está instalado (opcional para optimizar/limpiar SVGs)
HAS_SVGO=false
if command -v svgo &> /dev/null; then
    HAS_SVGO=true
else
    echo "Aviso: 'svgo' no está instalado. Se usarán métodos alternativos para SVG."
    echo "Si deseas instalarlo: sudo apt install node-svgo (o npm install -g svgo)"
fi

echo ""
echo "================================================="
echo " Procesando archivos en: $TARGET_DIR"
echo "================================================="

# 1. Procesar imágenes PNG
echo "-> Limpiando perfiles ICC de archivos PNG..."
find "$TARGET_DIR" -type f -iname "*.png" -exec mogrify -strip {} +
echo "   PNGs procesados correctamente."

# 2. Procesar imágenes GIF
echo "-> Limpiando perfiles ICC de archivos GIF..."
find "$TARGET_DIR" -type f -iname "*.gif" -exec mogrify -strip {} +
echo "   GIFs procesados correctamente."

# 3. Procesar imágenes SVG
echo "-> Limpiando metadatos y perfiles en archivos SVG..."
if [ "$HAS_SVGO" = true ]; then
    find "$TARGET_DIR" -type f \( -iname "*.svg" -o -iname "*._isvg" \) -exec svgo {} +
else
    # mogrify también elimina perfiles en SVG cuando existen bloques ICC incrustados
    find "$TARGET_DIR" -type f \( -iname "*.svg" -o -iname "*._isvg" \) -exec mogrify -strip {} +
fi
echo "   SVGs procesados correctamente."

echo ""
echo "================================================="
echo " ¡Proceso completado exitosamente!"
echo "================================================="
