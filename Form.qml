import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    id: r
    color: 'black'
    width: parent.width
    height: parent.height
    visible: false
    property int fs: r.width * 0.065
    property bool loadingCoords: false
    property real uLat: -1.0
    property real uLon: -1.0
    property int uAlt: 0 // Agregado
    property int uGmt: 0 // Valor por defecto

    MouseArea {
        anchors.fill: parent
        //onClicked: r.visible = false
    }

    Column {
        id: col
        spacing: r.fs * 0.25
        //anchors.centerIn: parent // Centrar el formulario
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: r.fs*2
        width: r.width * 0.9

        Text{
            text:'<b>Cargar Datos</b>'
            font.pixelSize: r.fs*1.2
            color: 'white'
        }
        // --- Fila Nombre ---
        Row {
            spacing: r.fs * 0.25
            anchors.horizontalCenter: parent.horizontalCenter
            Text { id: titNom; text: 'Nombre:'; color: 'white'; font.pixelSize: r.fs * 0.8; anchors.verticalCenter: parent.verticalCenter }
            Rectangle {
                clip: true
                width: col.width - titNom.width - r.fs; height: r.fs * 1.5; color: 'transparent'; border.color: 'white'
                TextInput { id: tiNom; anchors.fill: parent; color: 'white'; font.pixelSize: r.fs * 0.8; verticalAlignment: Text.AlignVCenter; /*leftPadding: 5*/ }
            }
        }

        // --- Fila Fecha y Hora ---
        Row {
            spacing: r.fs * 0.2
            anchors.horizontalCenter: parent.horizontalCenter
            Text { text: 'Fecha:'; color: 'white'; font.pixelSize: r.fs * 0.8; anchors.verticalCenter: parent.verticalCenter }

            // Día
            Rectangle { width: r.fs * 1.5; height: r.fs * 1.5; color: 'transparent'; border.color: 'white'
                TextInput { id: tiDia; anchors.fill: parent; color: 'white'; text: "20"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }
            // Mes
            Rectangle { width: r.fs * 1.5; height: r.fs * 1.5; color: 'transparent'; border.color: 'white'
                TextInput { id: tiMes; anchors.fill: parent; color: 'white'; text: "6"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }
            // Año
            Rectangle { width: r.fs * 2.5; height: r.fs * 1.5; color: 'transparent'; border.color: 'white'
                TextInput { id: tiAnio; anchors.fill: parent; color: 'white'; text: "1975"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }

            Text { text: ' Hora:'; color: 'white'; font.pixelSize: r.fs * 0.8; anchors.verticalCenter: parent.verticalCenter }
            // Hora
            Rectangle { width: r.fs * 1.5; height: r.fs * 1.5; color: 'transparent'; border.color: 'white'
                TextInput { id: tiHora; anchors.fill: parent; color: 'white'; text: "23"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }
            // Minuto
            Rectangle { width: r.fs * 1.5; height: r.fs * 1.5; color: 'transparent'; border.color: 'white'
                TextInput { id: tiMin; anchors.fill: parent; color: 'white'; text: "4"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }
        }

        // --- Fila Lugar ---
        Row {
            spacing: r.fs * 0.25
            anchors.horizontalCenter: parent.horizontalCenter
            Text { id: titLugar; text: 'Lugar:'; color: 'white'; font.pixelSize: r.fs * 0.8; anchors.verticalCenter: parent.verticalCenter }
            Rectangle {
                width: col.width - titLugar.width - r.fs; height: r.fs * 1.5; color: 'transparent'; border.color: 'white'
                TextInput {
                    id: tiLugar; anchors.fill: parent; color: 'white'; font.pixelSize: r.fs * 0.7; verticalAlignment: Text.AlignVCenter; /*leftPadding: 5*/
                    onTextChanged: {
                        if(!tObtenerCoords.omitir)status.text='Buscando coordenadas...'
                        tObtenerCoords.restart()
                    }
                    Timer{
                        id: tObtenerCoords
                        running: false
                        repeat: false
                        interval: 2500
                        property bool omitir: false
                        onTriggered: {
                            if(!omitir)obtenerCoordenadasGeoNames(tiLugar.text)
                            omitir=false
                        }
                    }
                }
            }
        }

        // --- Fila Coordenadas ---
        Row {
            spacing: r.fs * 0.25
            anchors.horizontalCenter: parent.horizontalCenter
            Text { text: 'Lat:'; color: 'white'; font.pixelSize: r.fs * 0.6; anchors.verticalCenter: parent.verticalCenter }
            Rectangle {clip: true; width: r.fs * 3; height: r.fs * 1.2; color: 'transparent'; border.color: 'white'
                TextInput { id: tiLat; anchors.fill: parent; color: 'white'; font.pixelSize: r.fs*0.7; horizontalAlignment: Text.AlignHCenter } }

            Text { text: 'Lon:'; color: 'white'; font.pixelSize: r.fs*0.6; anchors.verticalCenter: parent.verticalCenter }
            Rectangle {clip: true; width: r.fs * 3.5; height: r.fs * 1.2; color: 'transparent'; border.color: 'white'
                TextInput { id: tiLon; anchors.fill: parent; color: 'white'; font.pixelSize: r.fs * 0.7; horizontalAlignment: Text.AlignHCenter } }

            Text { text: 'Alt:'; color: 'white'; font.pixelSize: r.fs * 0.6; anchors.verticalCenter: parent.verticalCenter }
            Rectangle {clip: true; width: r.fs * 2; height: r.fs * 1.2; color: 'transparent'; border.color: 'white'
                TextInput { id: tiAlt; anchors.fill: parent; color: 'white'; font.pixelSize: r.fs * 0.7; horizontalAlignment: Text.AlignHCenter } }



        }

        Row {
            spacing: r.fs * 0.25
            anchors.horizontalCenter: parent.horizontalCenter
            Text { text: 'GMT:'; color: 'white'; font.pixelSize: r.fs * 0.6; anchors.verticalCenter: parent.verticalCenter }
            Rectangle {clip: true; width: r.fs * 1.2; height: r.fs * 1.2; color: 'transparent'; border.color: 'white'
                TextInput { id: tiGmt; anchors.fill: parent; color: 'white'; font.pixelSize: r.fs * 0.8; horizontalAlignment: Text.AlignHCenter } }
        }
        Text {
            id: status
            font.pixelSize: r.fs * 0.6
            color: 'yellow'
            width: parent.width
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }

        Row{
            spacing: r.fs
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                text: 'Crear'
                anchors.verticalCenter: parent.verticalCenter
                enabled: !(tiNom.text === "" || tiLugar.text === "" || tiDia.text === "" || tiAnio.text === "")
                onClicked: {
                    if (tiNom.text === "" || tiLugar.text === "" || tiDia.text === "" || tiAnio.text === "") {
                        status.text = "Error: Por favor completa todos los campos."
                    } else {
                        let j = crearJson()
                        status.text = "JSON Creado con éxito."
                        //status.text+=JSON.stringify(j, null, 2)
                        let fileName=tiNom.text.replace(/ /g, '_')+'.json'
                        //let folder=u.getPath(4)+'/jsons'
                        let folder=app.currentFilesFolder//u.getPath(3)+'/Zool'
                        if(!u.folderExist(folder)){
                            u.mkdir(folder)
                        }
                        u.setFile(folder+'/'+fileName, JSON.stringify(j, null, 2))
                        if(!u.fileExist(folder+'/'+fileName)){
                            status.text='El archivo no ha sido creado en '+folder+'/'+fileName
                        }else{
                            status.text='Se ha archivo no ha sido creado en '+folder+'/'+fileName
                            updateFileList()
                            getDataFromFile(folder+'/'+fileName, tiNom.text)
                            r.visible=false
                        }
                    }
                }
            }
            Button {
                text: 'Cancelar'
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    r.visible=false
                }
            }

        }
    }

    function crearJson() {
        let timestamp = new Date().getTime()
        // Formato extId: id_d_m_a_h_min_gmt_lat_lon_alt_t_hsys
        let externalId = "id_" + tiDia.text + "_" + tiMes.text + "_" + tiAnio.text + "_" +
            tiHora.text + "_" + tiMin.text + "_" + r.uGmt + "_" +
            tiLat.text + "_" + tiLon.text + "_" + tiAlt.text + "_vn_T"

        let json = {
            "params": {
                "t": "vn",
                "ms": timestamp,
                "n": tiNom.text,
                "g": "m", // Género por defecto, podrías añadir un Switch
                "f": true,
                "data": "",
                "d": parseInt(tiDia.text),
                "m": parseInt(tiMes.text),
                "a": parseInt(tiAnio.text),
                "h": parseInt(tiHora.text),
                "min": parseInt(tiMin.text),
                "gmt": r.uGmt,
                "lat": parseFloat(tiLat.text),
                "lon": parseFloat(tiLon.text),
                "alt": parseInt(tiAlt.text),
                "c": tiLugar.text,
                "hsys": "T",
                "shared": false,
                "extId": externalId,
                "nc": tiNom.text,
                "msmod": timestamp
            },
            "exts": []
        }
        return json
    }

    //Geonames
    function obtenerCoordenadasGeoNames(lugar) {
        if (lugar.length < 3) return;
        status.text = 'Buscando coordenadas...'

        var xhr = new XMLHttpRequest();
        var url = "http://api.geonames.org/searchJSON?q=" + encodeURIComponent(lugar)
                + "&maxRows=1&username=qtpizarro&style=FULL";

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText);
                    if (response.geonames && response.geonames.length > 0) {
                        var data = response.geonames[0];
                        tiLat.text = parseFloat(data.lat).toFixed(2);
                        tiLon.text = parseFloat(data.lng).toFixed(2);
                        tiAlt.text = parseInt(data.elevation) || 0;
                        if(!data.gmtOffSet){
                            if (data.timezone) {
                                // Aquí se podría calcular el GMT exacto si la API lo devuelve,
                                // por ahora mantenemos el default o lo que devuelva el objeto.
                                tiGmt.text=parseInt(data.timezone.gmtOffset)
                                r.uGmt = data.timezone.gmtOffset || -3;
                            }
                        }else{
                            tiGmt.text=parseInt(data.gmtOffSet)
                            r.uGmt=parseInt(data.gmtOffSet)
                        }
                        status.text = 'Ubicación encontrada.'
                    } else {
                        status.text = "No se encontró el lugar."
                    }
                }
            }
        }
        xhr.open("GET", url);
        xhr.send();
    }
    //openstreetmap
    function obtenerCoordenadasOpenstreetmap(lugar) {
        return new Promise((resolve, reject) => {
                               const xhr = new XMLHttpRequest();
                               const url = `https://nominatim.openstreetmap.org/search?q=${encodeURIComponent(lugar)}&format=json`;


                               xhr.open('GET', url);

                               xhr.onload = function() {
                                   if (xhr.status >= 200 && xhr.status < 300) {
                                       try {
                                           //log.lv('obtenerCoordenadas('+lugar+'): '+xhr.responseText)
                                           const respuesta = JSON.parse(xhr.responseText);
                                           if(respuesta && respuesta.length > 0) {
                                               tiLat.text=parseFloat(respuesta[0].lat).toFixed(2);
                                               tiLon.text = parseFloat(respuesta[0].lon).toFixed(2);
                                               status.text = 'Ubicación encontrada.'
                                               /*const latitud = parseFloat(respuesta[0].lat);
                                               const longitud = parseFloat(respuesta[0].lon);
                                               //zpn.logTemp('Latitud: '+latitud, 10000)
                                               //zpn.logTemp('Longitud: '+longitud, 10000)
                                               if(!r.loadingCoords)return
                                               r.lat=parseFloat(latitud)
                                               r.ulat=r.lat
                                               r.lon=parseFloat(longitud)
                                               r.ulon=r.lon
                                               r.loadingCoords=false
                                               rLoadingError.visible=false*/
                                           }else{
                                               status.text = 'No se pudo encontrar la ubicación.'
                                               //reject('No se encontraron coordenadas para el lugar especificado.');
                                               //log.clear()
                                               //zpn.logTemp('OpenStreet.ort NO se encontraron las coordenadas de geolocalización de '+tiCiudad.text+'\nBuscando con el sistema GeoNames...', 10000)
                                               //r.loadingCoords=true
                                               //obtenerCoordenadasGeoNames(lugar)
                                               /*if(Qt.platform.os==='linux' && u.folderExist('/home/ns')){
                                                   //if(Qt.platform.os==='linux'){
                                                   searchCoordsTurbo()
                                               }*/
                                           }
                                       } catch (error) {
                                           //reject('Error al parsear la respuesta JSON.');
                                           //log.clear()
                                           //zpn.logTemp('Busqueda de coordenadas con OpenStreet: Hay un error de red en estos momentos. Error al solicitar las coordenadas de geolocalización de '+tiCiudad.text, 10000)
                                           obtenerCoordenadasGeoNames(lugar)
                                           //                                           if(Qt.platform.os==='linux' && u.folderExist('/home/ns')){
                                           //                                               //if(Qt.platform.os==='linux'){
                                           //                                               searchCoordsTurbo()
                                           //                                           }
                                       }
                                   }else{
                                       //reject(`Error en la petición: Código de estado ${xhr.status}`);
                                       //log.clear()
                                       //zpn.logTemp('Busqueda de coordenadas con OpenStreet: Hay un error de red en estos momentos. Error al solicitar las coordenadas de geolocalización de '+tiCiudad.text, 10000)
                                       obtenerCoordenadasGeoNames(lugar)
                                   }
                               };

                               xhr.onerror = function() {
                                   //reject('Error de red al realizar la petición.');
                                   //log.clear()
                                   //zpn.logTemp('Busqueda de coordenadas con OpenStreet: Hay un error de red en estos momentos. Error al solicitar las coordenadas de geolocalización de '+tiCiudad.text, 10000)
                                   obtenerCoordenadasGeoNames(lugar)
                               };

                               xhr.send();
                           });
    }
    function loadForEditFromParams(p){
        tiNom.text=p.n?p.n:'Nuevo Archivo'
        tObtenerCoords.omitir=true
        tiLugar.text=p.c?p.c:'United Kingdom'
        tiLat.text=p.lat
        tiDia.text=p.d
        tiMes.text=p.m
        tiAnio.text=p.a
        tiHora.text=p.h
        tiMin.text=p.min
        tiLon.text=p.lon
        tiAlt.text=p.alt
        tiGmt.text=p.gmt
        r.visible=true

    }
    function loadForEdit(filePath){
        let fd=u.getFile(filePath)
        let p=JSON.parse(fd).params
        tiNom.text=p.n
        tObtenerCoords.omitir=true
        tiLugar.text=p.c
        tiLat.text=p.lat
        tiDia.text=p.d
        tiMes.text=p.m
        tiAnio.text=p.a
        tiHora.text=p.h
        tiMin.text=p.min
        tiLon.text=p.lon
        tiAlt.text=p.alt
        tiGmt.text=p.gmt
        r.visible=true

    }
}
