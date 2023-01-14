unit listados;

{$codepage utf8}

{--------------------------------}

interface

    uses
    terreno in 'units/terreno/terreno.pas',
    contribuyente in 'units/contribuyente/contribuyente.pas',
    lista_terrenos in 'units/terreno/lista_terrenos.pas',
    crt, sysutils,
    comprobante in 'units/usuario/comprobante.pas',
    arbol in 'units/arbol.pas',
    compara_fechas in 'units/varios/compara_fechas.pas';

    // Muestra los terrenos según la zona que le corresponda.
    procedure terrenos_por_zona(lista : t_lista_terrenos);

    // Muestra todas las inscripciones de terrenos dadas en un año.
    procedure inscripciones_anio(var lista : t_lista_terrenos; anio : string);

    procedure listado_contribuyentes_propiedades(raiz : t_puntero_arbol;
                                                    lista : t_lista_terrenos;
                                                    var archivo_contribuyentes : t_archivo_contribuyentes);

{--------------------------------}

implementation

    // TODO: hacer ver como grilla
    procedure listado_contribuyentes_propiedades(raiz : t_puntero_arbol;
                                                    lista : t_lista_terrenos;
                                                    var archivo_contribuyentes : t_archivo_contribuyentes);
    var
        dato : t_dato_arbol;
        nombre : string;
        nro_contribuyente : string;
        terreno : t_terreno;
    begin
        // Ignorar nodos nulos.
        if raiz <> nil then
        begin
            listado_contribuyentes_propiedades(hijo_izquierdo(raiz), lista, archivo_contribuyentes);

            // Carga los datos.
            dato := info_raiz(raiz);
            nombre := dato.clave;
            nro_contribuyente := leer_contribuyente(archivo_contribuyentes, dato.indice).numero;

            writeln(nombre);

            // Escribe los terrenos que le corresponden a ese número de contribuyente.
            primero_lista_terrenos(lista);
            while not(fin_lista_terrenos(lista)) do
            begin
                recuperar_lista_terrenos(lista, terreno);

                if terreno.nro_contribuyente = nro_contribuyente then
                    writeln(terreno.domicilio_parcelario, '(', terreno.avaluo:0:2 ,')');

                siguiente_lista_terrenos(lista);
            end;
            readkey;
            clrscr;


            listado_contribuyentes_propiedades(hijo_derecho(raiz), lista, archivo_contribuyentes);
        end;
    end;

    // TODO: hacer ver como grilla
    procedure terrenos_por_zona(lista : t_lista_terrenos);
    var
        vector_por_zona : t_vector_listas;
        lista_actual : t_lista_terrenos;
        terreno_actual : t_terreno;
        i : 1..5;
    begin
        vector_por_zona := generar_vector_por_zona(lista);
    
        for i := 1 to 5 do
        begin
            writeln('Zona ', i, ':');
            writeln('');

            lista_actual := vector_por_zona[i];
            primero_lista_terrenos(lista_actual);

            if lista_actual.tam <> 0 then
            begin
                while not(fin_lista_terrenos(lista_actual)) do
                begin
                    recuperar_lista_terrenos(lista_actual, terreno_actual);
                    writeln(terreno_actual.domicilio_parcelario);
                    siguiente_lista_terrenos(lista_actual);
                end;
            end else Writeln('No se encontró ningún terreno perteneciente a esta zona');
            writeln('');
            writeln('Presione una tecla para continuar...');
            readkey;
            clrscr;
        end;
    end;


    procedure inscripciones_anio(var lista : t_lista_terrenos; anio : string);
    var
        anio_con_ceros : string;
        ceros : byte;
        i : byte;
        terreno_actual : t_terreno;
        fecha1, fecha2, fecha_actual : string;
        cantidad : cardinal;
    begin
        cantidad := 0;

        // Convertir a string de 4 dígitos en caso de ser necesario.
        ceros := 4 - length(anio);
        anio_con_ceros := anio;
        if ceros > 0 then
        begin
            for i := 1 to ceros do
                anio_con_ceros := '0' + anio_con_ceros;
        end;

        // Las fechas corresponden al primer día del año y al último.
        fecha1 := anio_con_ceros + '-01-01';
        fecha2 := anio_con_ceros + '-12-31';
        fecha_actual := '0001-01-01'; // por predeterminado, la fecha mínima posible
        
        primero_lista_terrenos(lista);

        // Ignora las inscripciones de años anteriores
        while not(fin_lista_terrenos(lista)) and (fecha_es_menor(fecha_actual, fecha1)) do
        begin
            recuperar_lista_terrenos(lista, terreno_actual);
            fecha_actual := terreno_actual.fecha_inscripcion;
            siguiente_lista_terrenos(lista);
            if fecha_es_mayor_igual(fecha_actual, fecha1) and fecha_es_menor_igual(fecha_actual, fecha1) then
              cantidad := cantidad + 1;
        end;
        
       { // Cuenta las inscripciones de ese año
        while (not(fin_lista_terrenos(lista))) and (fecha_es_menor_igual(fecha_actual, fecha2)) do
        begin
            writeln('Hola estoy aca?');
            readkey;
            cantidad := cantidad + 1;
            siguiente_lista_terrenos(lista);
            recuperar_lista_terrenos(lista, terreno_actual);
            fecha_actual := terreno_actual.fecha_inscripcion;
        end;}

        clrscr;
        writeln('En el año ', anio, ' se ha/n inscripto ', cantidad, ' propiedade/s');
        writeln();
        writeln('Presione una tecla para continuar...');
        readkey;
    end;


end.