unit contador_datos;

{$codepage utf8}

{ Unidad para conteo de contribuyentes y terrenos guardados.
  Nota: se utiliza esta unit para evitar leer posiciones vacías. }

{--------------------------------}

interface
    const
        ruta_archivo_contador = './contador_datos.dat';

    type
    t_contador_datos = record
        contribuyentes : cardinal;
        terrenos : cardinal;
        end;
    
    // NOTA: solamente trabajar con posición 1.
    t_archivo_contador = file of t_contador_datos;

    // Abre el archivo contador. Si no existe, lo crea y se setea en default.
    procedure abrir_archivo_contador(var archivo : t_archivo_contador);

    // Syntatic sugar. 
    procedure cerrar_archivo_contador(var archivo : t_archivo_contador);

    // Suma un contribuyente a los datos.
    procedure contar_contribuyente(var archivo : t_archivo_contador);

    // Suma un terreno a los datos.
    procedure contar_terreno(var archivo : t_archivo_contador);

    // Resta un contribuyente a los datos.
    procedure restar_contribuyente(var archivo : t_archivo_contador);

    // Resta un terreno a los datos.
    procedure restar_terreno(var archivo : t_archivo_contador);

    // Devuelve la cantidad de contribuyentes del archivo.
    function cantidad_contribuyentes(var archivo : t_archivo_contador): cardinal;

    // Devuelve la cantidad de terrenos del archivo.
    function cantidad_terrenos(var archivo : t_archivo_contador): cardinal;

{--------------------------------}

implementation

    procedure abrir_archivo_contador(var archivo : t_archivo_contador);
    var
        contador_default : t_contador_datos;
    begin
        assign(archivo, ruta_archivo_contador);
        
        {$I-} reset(archivo) {$I+};

        // Si el archivo no existe, lo crea.
        if ioresult <> 0 then
        begin
            rewrite(archivo);

            contador_default.contribuyentes := 0;
            contador_default.terrenos := 0;

            seek(archivo, 1);
            write(archivo, contador_default);
        end;
    end;

    procedure cerrar_archivo_contador(var archivo : t_archivo_contador);
    begin
        close(archivo);
    end;

    procedure contar_contribuyente(var archivo : t_archivo_contador);
    var
        contador_aux : t_contador_datos;
    begin
        seek(archivo, 1);
        read(archivo, contador_aux);

        contador_aux.contribuyentes := contador_aux.contribuyentes + 1;

        seek(archivo, 1);
        write(archivo, contador_aux);
    end;

    procedure contar_terreno(var archivo : t_archivo_contador);
    var
        contador_aux : t_contador_datos;
    begin
        seek(archivo, 1);
        read(archivo, contador_aux);

        contador_aux.terrenos := contador_aux.terrenos + 1;

        seek(archivo, 1);
        write(archivo, contador_aux);
    end;

    procedure restar_contribuyente(var archivo : t_archivo_contador);
    var
        contador_aux : t_contador_datos;
    begin
        seek(archivo, 1);
        read(archivo, contador_aux);

        contador_aux.contribuyentes := contador_aux.contribuyentes - 1;

        seek(archivo, 1);
        write(archivo, contador_aux);
    end;

    procedure restar_terreno(var archivo : t_archivo_contador);
    var
        contador_aux : t_contador_datos;
    begin
        seek(archivo, 1);
        read(archivo, contador_aux);

        contador_aux.terrenos := contador_aux.terrenos - 1;

        seek(archivo, 1);
        write(archivo, contador_aux);
    end;


    function cantidad_contribuyentes(var archivo : t_archivo_contador): cardinal;
    var
        contador_aux : t_contador_datos;
    begin
        seek(archivo, 1);
        read(archivo, contador_aux);

        cantidad_contribuyentes := contador_aux.contribuyentes;
    end;

    function cantidad_terrenos(var archivo : t_archivo_contador): cardinal;
    var
        contador_aux : t_contador_datos;
    begin
        seek(archivo, 1);
        read(archivo, contador_aux);

        cantidad_terrenos := contador_aux.terrenos;
    end;
    
end.