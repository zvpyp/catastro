unit contador_datos;

{$codepage utf8}

{ Unidad para conteo de contribuyentes y terrenos guardados.
  Nota: se utiliza esta unit para evitar leer posiciones vacías. }

{--------------------------------}

interface
    uses crt;

    const
        ruta_archivo_contador = './contador_datos.dat';

    type
    t_contador_datos = record
        contribuyentes : cardinal;
        contribuyentes_activos : cardinal;
        terrenos : array [1..5] of cardinal;
    end;
    
    // NOTA: solamente trabajar con posición 1.
    t_archivo_contador = file of t_contador_datos;

    // Abre el archivo contador. Si no existe, lo crea y se setea en default.
    procedure abrir_archivo_contador(var archivo : t_archivo_contador);

    // Syntatic sugar. 
    procedure cerrar_archivo_contador(var archivo : t_archivo_contador);

    // Suma un contribuyente a los datos.
    procedure sumar_contribuyente(var archivo : t_archivo_contador);

    // Suma un terreno a los datos.
    procedure sumar_terreno(var archivo : t_archivo_contador; tipo : byte);

    // Resta un contribuyente a los datos.
    procedure restar_contribuyente(var archivo : t_archivo_contador);

    // Suma uno a los contribuyentes activos.
    procedure sumar_activo(var archivo : t_archivo_contador);

    // Resta un terreno a los datos.
    procedure restar_terreno(var archivo : t_archivo_contador; tipo : byte);

    // Devuelve la cantidad de contribuyentes existentes.
    function cantidad_contribuyentes(var archivo : t_archivo_contador): cardinal;

    // Devuelve la cantidad de terrenos existentes.
    function cantidad_terrenos(var archivo : t_archivo_contador): cardinal;

    // Devuelve la cantidad de contribuyentes activos.
    function cantidad_activos(var archivo : t_archivo_contador): cardinal;

    // Devuelve la cantidad de terrenos de un tipo específico.
    function cantidad_terrenos_tipo(var archivo : t_archivo_contador; tipo : byte): cardinal;

{--------------------------------}

implementation


    procedure abrir_archivo_contador(var archivo : t_archivo_contador);
    var
        contador_default : t_contador_datos;
        i : 1..5;
    begin
        assign(archivo, ruta_archivo_contador);
        
        {$I-} reset(archivo) {$I+};

        // Si el archivo no existe, lo crea.
        if ioresult <> 0 then
        begin
            rewrite(archivo);

            contador_default.contribuyentes := 0;
            for i := 1 to 5 do
                contador_default.terrenos[i] := 0;
            contador_default.contribuyentes_activos := 0;

            seek(archivo, 1);
            write(archivo, contador_default);
        end;
    end;


    procedure cerrar_archivo_contador(var archivo : t_archivo_contador);
    begin
        close(archivo);
    end;


    procedure sumar_contribuyente(var archivo : t_archivo_contador);
    var
        contador_aux : t_contador_datos;
    begin
        seek(archivo, 1);
        read(archivo, contador_aux);

        contador_aux.contribuyentes := contador_aux.contribuyentes + 1;
        contador_aux.contribuyentes_activos := contador_aux.contribuyentes_activos + 1;

        seek(archivo, 1);
        write(archivo, contador_aux);
    end;


    procedure sumar_terreno(var archivo : t_archivo_contador; tipo : byte);
    var
        contador_aux : t_contador_datos;
    begin
        seek(archivo, 1);
        read(archivo, contador_aux);

        contador_aux.terrenos[tipo] := contador_aux.terrenos[tipo] + 1;

        seek(archivo, 1);
        write(archivo, contador_aux);
    end;


    procedure restar_contribuyente(var archivo : t_archivo_contador);
    var
        contador_aux : t_contador_datos;
    begin
        seek(archivo, 1);
        read(archivo, contador_aux);

        contador_aux.contribuyentes_activos := contador_aux.contribuyentes_activos - 1;

        seek(archivo, 1);
        write(archivo, contador_aux);
    end;

    procedure sumar_activo(var archivo : t_archivo_contador);
    var
        contador_aux : t_contador_datos;
    begin
        seek(archivo, 1);
        read(archivo, contador_aux);

        contador_aux.contribuyentes_activos := contador_aux.contribuyentes_activos + 1;

        seek(archivo, 1);
        write(archivo, contador_aux);
    end;

    procedure restar_terreno(var archivo : t_archivo_contador; tipo : byte);
    var
        contador_aux : t_contador_datos;
    begin
        seek(archivo, 1);
        read(archivo, contador_aux);

        contador_aux.terrenos[tipo] := contador_aux.terrenos[tipo] - 1;

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
        i : 1..5;
    begin
        cantidad_terrenos := 0;

        seek(archivo, 1);
        read(archivo, contador_aux);

        for i := 1 to 5 do
            cantidad_terrenos := cantidad_terrenos + contador_aux.terrenos[i];
    end;

    function cantidad_activos(var archivo : t_archivo_contador): cardinal;
    var
        contador_aux : t_contador_datos;
    begin
        seek(archivo, 1);
        read(archivo, contador_aux);

        cantidad_activos := contador_aux.contribuyentes_activos;
    end;

    function cantidad_terrenos_tipo(var archivo : t_archivo_contador; tipo : byte): cardinal;
    var
        contador_aux : t_contador_datos;
    begin
        cantidad_terrenos_tipo := 0;

        seek(archivo, 1);
        read(archivo, contador_aux);

        cantidad_terrenos_tipo := cantidad_terrenos_tipo + contador_aux.terrenos[tipo];
    end;

end.