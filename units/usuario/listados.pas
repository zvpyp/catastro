unit listados;

{$codepage utf8}

{--------------------------------}

uses
    terreno in 'units/terreno/terreno.pas';
    lista_terrenos in 'units/terreno/lista_terrenos.pas';

interface

    // Muestra todas las inscripciones de terrenos dadas en un año.
    procedure inscripciones_anio(var lista : t_lista_terrenos; t_anio : string);

{--------------------------------}

implementation


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