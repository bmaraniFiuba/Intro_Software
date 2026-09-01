#!/bin/bash

existe_archivo() {
   [ -f ~/EPNro1/salida/$FILENAME.txt ]
}

borrar_entorno() {
    if [ -f "$HOME/EPNro1/consolidar.pid" ]; then
        # Leer el PID del archivo y matar el proceso si está en ejecución
        pid="$(cat "$HOME/EPNro1/consolidar.pid")"
        # PID número de proceso del script consolidar.sh
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid"
            echo "Proceso $pid finalizado."
        fi
        rm -f "$HOME/EPNro1/consolidar.pid"
    fi

    if [ -d "$HOME/EPNro1" ]; then
        rm -rf "$HOME/EPNro1"
        echo "Entorno fue eliminado."
    else
        echo "No existe el entorno."
    fi
}


opcion=0
if [ -z "${FILENAME:-}" ]; then # Comprobamos la existencia de FILENAME
    echo "Error: la variable de ambiente FILENAME no está definida."
    echo "Debe ejecutarse por consola el comando: export FILENAME=(nombre a elección)"
    exit 1 #ver si va
elif [ "${1:-}" == "-d" ]; then
    # $1 es el primer argumento pasado al script
    borrar_entorno
    exit 0
else
    while [ $opcion -ne 7  ]; do 
        echo "---------------------------------"
        echo "Menú EPNro1"
        echo "1) Crear entorno"
        echo "2) Correr proceso"
        echo "3) Listar alumnos por padrón"
        echo "4) Top 10 notas"
        echo "5) Buscar alumno por padrón"
        echo "6) Visualizar log"
        echo "7) Salir"
        echo "---------------------------------"
        read -p "Seleccione una opción: " opcion
        #muestra el texto y guarda la opcion en la variable opcion

        case $opcion in #compara el valor de la opc contra cada patron
            1)
                if [ ! -d ~/EPNro1 ]; then
                    mkdir -p ~/EPNro1/{entrada,salida,procesado}
                    cp "./consolidar.sh" "$HOME/EPNro1/"
                    chmod +x "$HOME/EPNro1/consolidar.sh"
                    echo "Entorno se creo exitosamente."
                    
                else
                    echo "El entorno ya existe."
                fi
                ;;
            2)
                # if [ -z "$FILENAME" ]; then
                #     echo "Error: la variable FILENAME no se definió. Por favor, defínala antes de correr el proceso."
                # else
                # nohup ~/EPNro1/consolidar.sh & #nohup bash "$HOME/EPNro1/consolidar.sh" > /dev/null 2>&1 &
                #     #lanza el script en background
                # echo $! > ~/EPNro1/consolidar.pid
                #     #guarda el PID del proceso en un archivo
                #     #PID= identificador de proceso.
                # echo "Proceso consolidar.sh iniciado en background (PID $!)"
                "$HOME/EPNro1/consolidar.sh" &
                #lanza el script en background
                echo $! > "$HOME/EPNro1/consolidar.pid"
                #guarda el PID del proceso en un archivo
                #PID= identificador de proceso.
                echo "Proceso consolidar.sh iniciado en background (PID $!)"
            
            ;;
    
            3)
                if ! existe_archivo; then
                    echo "No existe el archivo $FILENAME.txt en la carpeta salida."
                else
                    sort -n -k1 ~/EPNro1/salida/$FILENAME.txt
                    #-n ordena numericamente
                    #-k1 ordena desde la 1er columna
                fi
                ;;
            4)
                if ! existe_archivo; then
                    echo "No existe el archivo $FILENAME.txt en la carpeta salida."
                else
                    echo "Las 10 Notas mas altas son: "
                    sort -n -r -k5 ~/EPNro1/salida/$FILENAME.txt | head 
                    #-r lo lee de mayor a menor
                fi
                ;;
                
            5)
                if ! existe_archivo; then
                    echo "No existe el archivo $FILENAME.txt en la carpeta salida."
                else
                    read -p "Ingrese padron: " padron
                    
                    resPadron=$(grep "^$padron " ~/EPNro1/salida/$FILENAME.txt) #ver bien como se usa
                    
                    if [ -z "$resPadron" ]; then
                        echo "Error: el $padron no se encuentra en el archivo $FILENAME.txt"
                    else
                        echo $resPadron
                    fi
                fi
                ;;
            6)
                echo "Elegiste: Visualizar log"
                if [ ! -f ~/EPNro1/procesado.log ]; then
                    echo "NO se procesaron archivos aún"
                else
                    cat ~/EPNro1/procesado.log
                fi
                ;;
            7)
                echo "Saliendo del menú..."
                exit 0 #corta la ejecucion del script completo
                ;;
            *)
                echo "Opción inválida. Por favor, seleccione una opción válida."
                ;;
        esac
    done
fi


