unit listados;

{$codepage utf8}

{--------------------------------}

interface

    uses
    terreno in 'units/terreno/terreno.pas',
    lista_terrenos in 'units/terreno/lista_terrenos.pas';

    // Muestra los terrenos según la zona que le corresponda.
    procedure terrenos_por_zona(lista : t_lista_terrenos);

    // Muestra todas las inscripciones de terrenos dadas en un año.
    procedure inscripciones_anio(var lista : t_lista_terrenos; t_anio : string);

{--------------------------------}

implementation


    // TODO?: hacer ver como grilla
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

            while not(fin_lista_terrenos(lista_actual)) do
            begin
                recuperar_lista_terrenos(lista_actual, terreno_actual);
                writeln(terreno_actual.domicilio_parcelario);
                siguiente_lista_terrenos(lista_actual);
            end;

            writeln('');
            writeln('Presione una tecla para continuar...');
            clrscr;
        end;
    end;


    procedure inscripciones_anio(var lista : t_lista_terrenos; t_anio : string);
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
            siguiente_lista_terrenos(lista);
            recuperar_lista_terrenos(lista, terreno_actual);
            fecha_actual := terreno_actual.fecha_inscripcion;
        end;

        // Cuenta las inscripciones de ese año
        while not (fin_lista_terrenos(lista)) and (fecha_es_menor(fecha_actual, fecha2)) do
        begin
            cantidad := cantidad + 1;
            siguiente_lista_terrenos(lista);
            recuperar_lista_terrenos(lista, terreno_actual);
            fecha_actual := terreno_actual.fecha_inscripcion;
        end;

        writeln('En el año ', anio, 'se han inscripto ', cantidad, ' propiedades');
        writeln('Presione una tecla para continuar...');
        readkey;
    end;


end.