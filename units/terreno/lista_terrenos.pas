unit lista_terrenos;

{$codepage utf8}
    
{ Unidad de lista de terrenos. }

{--------------------------------}

interface

    uses terreno in 'units/terreno/terreno.pas',
         compara_fechas in 'units/varios/compara_fechas.pas';

    type

        t_puntero_terreno = ^t_nodo_terreno;

        t_nodo_terreno = record
            info : t_terreno;
            siguiente : t_puntero_terreno;
        end;

        t_lista_terrenos = record
            cabecera : t_puntero_terreno;
            actual : t_puntero_terreno;
            tam : cardinal;
        end;

        t_vector_listas = array [1..5] of t_lista_terrenos;
    
    function lista_vacia_terrenos(lista : t_lista_terrenos): boolean;
    function fin_lista_terrenos(lista : t_lista_terrenos): boolean;
    procedure siguiente_lista_terrenos(var lista : t_lista_terrenos);
    procedure primero_lista_terrenos(var lista : t_lista_terrenos);
    procedure recuperar_lista_terrenos(lista : t_lista_terrenos; var recuperado : t_terreno);
    procedure enlistar_terreno(var lista : t_lista_terrenos; terreno : t_terreno);
    procedure desenlistar_terreno(var lista : t_lista_terrenos; buscado : string);
    procedure crear_lista_terrenos(var lista : t_lista_terrenos);

    // A partir de un archivo de terrenos, retorna una lista ordenada por número de plano.
    function lista_terrenos_desde_archivo(var archivo : t_archivo_terrenos;
                                              cantidad_terrenos : cardinal): t_lista_terrenos;
    
    // A partir de una lista, genera un array cuya lísta de índice i contiene terrenos de la zona i.
    function generar_vector_por_zona(lista : t_lista_terrenos): t_vector_listas;
    
{--------------------------------}

implementation

    function lista_vacia_terrenos(lista : t_lista_terrenos): boolean;
    begin
        lista_vacia_terrenos := (lista.tam = 0);
    end;

    function fin_lista_terrenos(lista : t_lista_terrenos): boolean;
    begin
        fin_lista_terrenos := (lista.actual = nil);
    end;

    procedure siguiente_lista_terrenos(var lista : t_lista_terrenos);
    begin
        lista.actual := lista.actual^.siguiente;
    end;

    procedure primero_lista_terrenos(var lista : t_lista_terrenos);
    begin
        lista.actual := lista.cabecera;
    end;

    procedure recuperar_lista_terrenos(lista : t_lista_terrenos; var recuperado : t_terreno);
    begin
        recuperado := lista.actual^.info;
    end;

    procedure crear_lista_terrenos(var lista : t_lista_terrenos);
    begin
        lista.cabecera := nil;
        lista.actual := nil;
        lista.tam := 0;
    end;

    procedure enlistar_terreno(var lista : t_lista_terrenos; terreno : t_terreno);
    var
        anterior, puntero_nuevo : t_puntero_terreno;
    begin
        new(puntero_nuevo);
        puntero_nuevo^.info := terreno;

        if (lista.cabecera = nil) or 
           (fecha_es_mayor(lista.cabecera^.info.fecha_inscripcion, terreno.fecha_inscripcion)) then
        begin
            puntero_nuevo^.siguiente := lista.cabecera;
            lista.cabecera := puntero_nuevo; 
        end
        else
        begin
            anterior := lista.cabecera;
            lista.actual := anterior^.siguiente;

            while (not(fin_lista_terrenos(lista))) and
                  (fecha_es_mayor(terreno.fecha_inscripcion, lista.actual^.info.fecha_inscripcion)) do
            begin
                anterior := lista.actual;
                siguiente_lista_terrenos(lista);
            end;

            puntero_nuevo^.siguiente := lista.actual;
            anterior^.siguiente := puntero_nuevo;
        end;

        lista.tam := lista.tam + 1;

    end;

    procedure desenlistar_terreno(var lista : t_lista_terrenos; buscado : string);
    var
        puntero_aux, anterior : t_puntero_terreno;
    begin
        
        if (buscado = lista.cabecera^.info.nro_plano) then
        begin
            puntero_aux := lista.cabecera;
            lista.cabecera := lista.cabecera^.siguiente;
            dispose(puntero_aux);

            lista.tam := lista.tam - 1;
        end
        else
        begin
            anterior := lista.cabecera;
            lista.actual := anterior^.siguiente;

            while (not(fin_lista_terrenos(lista))) and
                  (buscado <> lista.actual^.info.nro_plano) do
            begin
                anterior := lista.actual;
                siguiente_lista_terrenos(lista);
            end;

            if (lista.actual <> nil) then
            begin
                if (lista.actual^.info.fecha_inscripcion = buscado) then
                begin
                    anterior^.siguiente := lista.actual^.siguiente;
                    dispose(lista.actual);
                    lista.tam := lista.tam - 1;
                end;
            end;
        end;
    end;

    function lista_terrenos_desde_archivo(var archivo : t_archivo_terrenos;
                                              cantidad_terrenos : cardinal): t_lista_terrenos;
    var
        terreno_actual : t_terreno;
        i : cardinal;
    begin
        crear_lista_terrenos(lista_terrenos_desde_archivo);
        if cantidad_terrenos > 0 then
        begin
            for i := 1 to cantidad_terrenos do
            begin
                terreno_actual := leer_terreno(archivo, i);

                enlistar_terreno(lista_terrenos_desde_archivo, terreno_actual);
            end;
        end;
    end;

    function generar_vector_por_zona(lista : t_lista_terrenos): t_vector_listas;
    var
        actual : t_terreno;
    begin
        primero_lista_terrenos(lista);

        while not(fin_lista_terrenos(lista)) do
        begin
            recuperar_lista_terrenos(lista, actual);
            enlistar_terreno(generar_vector_por_zona[actual.zona], actual);
            siguiente_lista_terrenos(lista);
        end;
    end;
    
end.