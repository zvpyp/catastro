unit usuario_listados_estadisticas;

{ Unidad de tipo de interacción con usuario del submenú de listados y estadísticas. }

{--------------------------------}

interface

uses
    contribuyente in 'units/contribuyente/contribuyente.pas',
    contador_datos in 'units/varios/contador_datos.pas',
    compara_fechas in 'units/varios/compara_fechas.pas',
    lista_terrenos in 'units/varios/lista_terrenos.pas';

{---------------Listados---------------}

{---------------Estadísticas---------------}

// Muestra la cantidad de contribuyentes dados de baja.
Procedure propietarios_dados_de_baja(var archivo_contribuyentes : t_archivo_contribuyentes; var archivo_contador : t_archivo_contador);

// Muestra la cantidad de terrenos por tipo de edificación y
// su % respecto al total.
Procedure porc_por_tipo_edif(var archivo_terrenos : t_archivo_terrenos; var archivo_contador : t_archivo_contador);

// Escribe en pantalla cuántas inscripciones se dieron entre dos fechas. El orden no importa B).
procedure cantidad_inscripciones_entre_fechas(lista : t_lista_terrenos; fecha1, fecha2 : string);

{------------------------------------------}

implementation

{-----------------Listados-----------------}

// TODO: hacer lindo.
procedure listado_zona_terrenos(terrenos_por_zona : t_vector_listas);
var
    i : 1..5;
    lista := lista_terrenos;
begin
    for i := 1 to 5 do
    begin
        writeln('ZONA ', i);
        lista := terrenos_por_zona[i];
        primero_lista_terrenos(lista);
        while not(fin_lista_terrenos(lista)) do
        begin
            writeln(lista.actual^.info.domicilio_parcelario, ' $', lista.actual^.info.avaluo);
            siguiente_lista_terrenos(terrenos_por_zona[i]);
        end;
        readkey;
    end;
end;

procedure listado_inscripciones_anio(lista : t_lista_terrenos; anio : string);
fecha1, fecha2 : string;
terreno_actual : t_terreno;
begin
    fecha1 := anio + '-01-01';
    fecha2 := anio + '-12-31';

    recuperar_lista_terrenos(lista, terreno_actual);

    while fecha_es_menor(terreno_actual.fecha_inscripcion, fecha1) do
    begin
        siguiente_lista_terrenos(lista);
        recuperar_lista_terrenos(lista, terreno_actual);
    end;

    while fecha_es_mayor_igual(terreno_actual.fecha_inscripcion, fecha1) and fecha_es_menor_igual(terreno_actual.fecha_inscripcion, fecha2) do
    begin
        writeln(terreno_actual.fecha_inscripcion, ' ', terreno_actual.domicilio_parcelario, ' $', terreno_actual.avaluo);

        siguiente_lista_terrenos(lista);
        recuperar_lista_terrenos(lista, terreno_actual);
    end;


end;

{---------------Estadísticas---------------}

Procedure propietarios_dados_de_baja(var archivo_contribuyentes : t_archivo_contribuyentes; var archivo_contador : t_archivo_contador);
var
i, fin, dados_de_baja : cardinal;
contribuyente_aux : t_contribuyente; 
begin
    dados_de_baja := 0;
    fin := cantidad_contribuyentes(t_archivo_contador);
    if fin > 0 then
    begin
        for i := 1 to fin do
            begin
                contribuyente_aux := leer_contribuyente(archivo_contribuyentes, i);
                if (not contribuyente_aux.activo) then
                dados_de_baja := dados_de_baja + 1;
            end;
        end;
        Writeln('Cantidad de usuarios dados de baja: ',dados_de_baja);
        readkey;
end;

Procedure porc_por_tipo_edif(var archivo_terrenos : t_archivo_terrenos; var archivo_contador : t_archivo_contador);
var
i, fin, edif_1, edif_2, edif_3, edif_4, edif_5 : cardinal;
contribuyente_aux : t_contribuyente; 
begin
    edif_1 := 0;
    edif_2 := 0;
    edif_3 := 0;
    edif_4 := 0;
    edif_5 := 0;
    fin := cantidad_contribuyentes(t_archivo_contador);
    if fin > 0 then
    begin
    for i := 1 to fin do
        begin
            contribuyente_aux := leer_contribuyente(archivo_terrenos, i);
            Case contribuyente_aux.tipo_edificacion of
                1: edif_1 := edif_1 + 1;
                2: edif_2 := edif_2 + 1;
                3: edif_3 := edif_3 + 1;
                4: edif_4 := edif_4 + 1;
                5: edif_5 := edif_5 + 1;
            end;
        Writeln('Existen ',fin,' terrenos, de los cuales hay:');
        if edif_1 <> 0 then
                Writeln('Tipo de edificación 1: ',edif_1, ' (',edif_1/fin*100,'%)')
        else Writeln('No existe ningún terreno con tipo de edificación 1.');

        if edif_2 <> 0 then
                Writeln('Tipo de edificación 2: ',edif_2, ' (',edif_2/fin*100,'%)')
        else Writeln('No existe ningún terreno con tipo de edificación 2.');

        if edif_3 <> 0 then
                Writeln('Tipo de edificación 3: ',edif_3, ' (',edif_3/fin*100,'%)')
        else Writeln('No existe ningún terreno con tipo de edificación 3.');

        if edif_4 <> 0 then
            Writeln('Tipo de edificación 4: ',edif_4, ' (',edif_4/fin*100,'%)')
        else Writeln('No existe ningún terreno con tipo de edificación 4.');

        if edif_5 <> 0 then
            Writeln('Tipo de edificación 5: ',edif_5, ' (',edif_5/fin*100,'%)')
        else Writeln('No existe ningún terreno con tipo de edificación 5.');
        end;
    end;    
end;

procedure cantidad_inscripciones_entre_fechas(lista : t_lista_terrenos; fecha1, fecha2 : string);
aux_fecha : string;
terreno_actual : t_terreno;
contador : cardinal;
begin
    primero_lista_terrenos(lista);

    contador := 0;

    if fecha_es_mayor(fecha2, fecha1) then
    begin
        aux_fecha := fecha1;
        fecha1 := fecha2;
        fecha2 := aux_fecha;
    end;

    recuperar_lista_terrenos(lista, terreno_actual);

    while fecha_es_menor(terreno_actual.fecha_inscripcion, fecha1) do
    begin
        siguiente_lista_terrenos(lista);
        recuperar_lista_terrenos(lista, terreno_actual);
    end;

    
    
    while fecha_es_mayor_igual(fecha2, terreno_actual.fecha_inscripcion)then
    begin
        contador := contador + 1;
        siguiente_lista_terrenos(lista);
        recuperar_lista_terrenos(lista, terreno_actual);
    end;

    writeln('Entre ', fecha1, ' y ', fecha2, ' se inscribieron ', contador, ' terrenos :)');

end;

{---------------------------------------------}
// TODO:
// AÑADIR RECORRIDO PREORDEN SOBRE EL ARBOL DE CONTRIBUYENTES:
// procedure listado_contribuyentes_propiedades();


// DESPUÉS DE TODAS, ESTA ES LA MÁS FÁCIL XD.
// procedure mostrar_estadisticas();

end.