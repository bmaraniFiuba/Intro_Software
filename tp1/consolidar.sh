#!/bin/bash
shopt -s nullglob
cd ~/EPNro1 #para que el script trabaje siempre en esta carpeta

while true;
do
    for archivo in entrada/*.txt #recorro cada archivo .txt dentro de entrada/
    do
        # echo "Encontŕe el archivo: $archivo" creo que no va,
        if [ -f "$archivo" ]; then
        #1
            cat "$archivo" >> "salida/$FILENAME.txt"
        #cat imprime el contenido del archivo y lo manda al final de salida $Filename.txt
        
        #2
            fecha=$(date +"%d/%m/%Y %H:%M:%S")
            echo "$fecha - Procesado archivo $(basename "$archivo")" >> procesado.log 
        #opc6 #archivo.log cumple funcion de bitacora, guardo la fecha y el nombre del archivo procesado en procesado.log
        #basename extrae solo el nombre de un archivo en una ruta completa
            mv "$archivo" procesado/ #muevo el archivo desde entrada a procesado
        fi
    done

    sleep 5 #para 5 segundos antes de volver a buscar archivos en entrada/
done
