#!/bin/bash

# Determinar el directorio exacto donde se encuentra este script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Exportar exactamente las variables de entorno de Qt Creator
export QTDIR="/home/ns/Qt5.14.2/5.14.2/gcc_64"
export LD_LIBRARY_PATH="/home/ns/Qt5.14.2/5.14.2/gcc_64/lib:${LD_LIBRARY_PATH}"
export PATH="/home/ns/Qt5.14.2/5.14.2/gcc_64/bin:${PATH}"

# Moverse al directorio del binario para que las rutas relativas funcionen
cd "$DIR"

# Ejecutar el binario
/home/ns/nsp/unikey/build_lin/unikey  "$@"
