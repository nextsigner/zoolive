#!/bin/bash

# 1. RUTA A TU INSTALACIÓN DE QT 5.14.2 (Ajusta esta ruta según tu sistema)
QT_DIR="/home/ns/Qt5.14.2/5.14.2/gcc_64" 

# 2. Exportar las variables que usa Qt Creator
export LD_LIBRARY_PATH="$QT_DIR/lib:$LD_LIBRARY_PATH"
export QT_PLUGIN_PATH="$QT_DIR/plugins"
export QML2_IMPORT_PATH="$QT_DIR/qml"

