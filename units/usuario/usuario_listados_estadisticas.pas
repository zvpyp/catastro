unit usuario_listados_estadisticas;

{$codepage utf8}

{ Unidad de tipo de interacción con usuario del submenú de listados y estadísticas. }

{--------------------------------}

interface

uses
    contribuyente in 'units/contribuyente/contribuyente.pas',
    contador_datos in 'units/varios/contador_datos.pas',
    compara_fechas in 'units/varios/compara_fechas.pas',
    lista_terrenos in 'units/varios/lista_terrenos.pas',
    arbol in 'units/arbol/arbol.pas',
    terreno in 'units/terreno/terreno.pas',
    arbol_contribuyentes in 'units/arbol/arbol_contribuyentes.pas',
    validacion_entradas in './units/varios/validacion_entradas.pas',
    crt;

{-----------------Listados-----------------}

// A partir de un árbol ordenado por nombres, cada uno de sus nodos (contribuyente) teniendo la lista que le corresponde,
// Muestra en pantalla las propiedades de cada contribuyente.
// Para ello, hace un recorrido preorden, y por cada nodo hace un recorrido secuencial.
procedure listado_contribuyentes_propiedades(arbol : t_arbol);

// Muestra todas las zonas y los terrenos que les corresponden.
procedure listado_zona_terrenos(terrenos_por_zona : t_vector_listas);

// Pide un año al usuario y muestra un listado de las inscripciones en dicho año.
procedure listado_inscripciones_anio(lista : t_lista_terrenos);

{---------------Estadísticas---------------}

// Muestra la cantidad de contribuyentes dados de baja.
Procedure propietarios_dados_de_baja(var archivo_contribuyentes : t_archivo_contribuyentes; var archivo_contador : t_archivo_contador);

// Muestra la cantidad de terrenos por tipo de edificación y
// su % respecto al total.
Procedure porc_por_tipo_edif(lista_terrenos : t_lista_terrenos; var archivo_contador : t_archivo_contador);

// Escribe en pantalla cuántas inscripciones se dieron entre dos fechas. El orden no importa B).
procedure cantidad_inscripciones_entre_fechas(lista : t_lista_terrenos);

// Recibe árbol con las listas cargadas y el archivo contador. Muestra en pantalla el porcentaje de propietarios con más de una propiedad.
procedure porc_propietarios_mult_propiedades(var arbol : t_arbol; var archivo_contador : t_archivo_contador);

{------------------------------------------}

implementation

{-----------------Listados-----------------}

// TODO: hacer lindo.
procedure listado_contribuyentes_propiedades(arbol : t_arbol);
var
    terreno_actual : t_terreno;
begin
    if tiene_hijo_izq(arbol) then
        listado_contribuyentes_propiedades(arbol.si^);

    writeln(arbol.clave);
    primero_lista_terrenos(arbol.lista);
    while not(fin_lista_terrenos(arbol.lista)) do
    begin
        recuperar_lista_terrenos(arbol.lista, terreno_actual);
        writeln(terreno_actual.domicilio_parcelario, ' $', terreno_actual.avaluo);
        siguiente_lista_terrenos(arbol.lista);
    end;

    if tiene_hijo_der(arbol) then
        listado_contribuyentes_propiedades(arbol.sd^);
end;

// TODO: hacer lindo.
procedure listado_zona_terrenos(terrenos_por_zona : t_vector_listas);
var
    i : 1..5;
    lista : t_lista_terrenos;
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

// Muestra las inscripciones en un año determinado.
procedure mostrar_inscripciones_anio(lista : t_lista_terrenos; anio : string);
var
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

procedure listado_inscripciones_anio(lista : t_lista_terrenos);
var
    anio : string;
begin
    clrscr;

    repeat
        writeln('Ingrese un año, por favor: ');
        readln(anio);
    until (string_numerica(anio) and (length(anio) = 4));

    mostrar_inscripciones_anio(lista, anio);
end;
{---------------Estadísticas---------------}

Procedure propietarios_dados_de_baja(var archivo_contribuyentes : t_archivo_contribuyentes; var archivo_contador : t_archivo_contador);
var
    i, fin, dados_de_baja : cardinal;
    contribuyente_aux : t_contribuyente; 
begin
    dados_de_baja := 0;
    fin := cantidad_contribuyentes(archivo_contador);
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

Procedure porc_por_tipo_edif(lista_terrenos : t_lista_terrenos; var archivo_contador : t_archivo_contador);
var
    fin, edif_1, edif_2, edif_3, edif_4, edif_5 : cardinal;
    terreno_aux : t_terreno; 
begin
    edif_1 := 0;
    edif_2 := 0;
    edif_3 := 0;
    edif_4 := 0;
    edif_5 := 0;
    fin := cantidad_terrenos(archivo_contador);
    if fin > 0 then
    begin
        primero_lista_terrenos(lista_terrenos);

        while not fin_lista_terrenos(lista_terrenos) do
        begin
            recuperar_lista_terrenos(lista_terrenos, terreno_aux);

            case terreno_aux.tipo_edificacion of
                1: edif_1 := edif_1 + 1;
                2: edif_2 := edif_2 + 1;
                3: edif_3 := edif_3 + 1;
                4: edif_4 := edif_4 + 1;
                5: edif_5 := edif_5 + 1;
            end;
            siguiente_lista_terrenos(lista_terrenos);
        end;

        Writeln('Existen ', fin,' terrenos, de los cuales hay:');
        if edif_1 <> 0 then
                Writeln('Tipo de edificación 1: ',edif_1, ' (',(edif_1/fin*100):2:0,'%)')
        else Writeln('No existe ningún terreno con tipo de edificación 1.');

        if edif_2 <> 0 then
                Writeln('Tipo de edificación 2: ',edif_2, ' (',(edif_2/fin*100):2:0,'%)')
        else Writeln('No existe ningún terreno con tipo de edificación 2.');

        if edif_3 <> 0 then
                Writeln('Tipo de edificación 3: ',edif_3, ' (',(edif_3/fin*100):2:0,'%)')
        else Writeln('No existe ningún terreno con tipo de edificación 3.');

        if edif_4 <> 0 then
            Writeln('Tipo de edificación 4: ',edif_4, ' (',(edif_4/fin*100):2:0,'%)')
        else Writeln('No existe ningún terreno con tipo de edificación 4.');

        if edif_5 <> 0 then
            Writeln('Tipo de edificación 5: ',edif_5, ' (',(edif_5/fin*100):2:0,'%)')
        else Writeln('No existe ningún terreno con tipo de edificación 5.');
    end
    else 
    begin
        Writeln('Archivo de terrenos vacío.');
        Writeln('Por favor, introduzca algunos terrenos antes de usar esta funcionalidad');
        readkey;
    end;
end;

// No retorna hasta que se ingrese una fecha válida.
function pedir_fecha(): string;
begin
    repeat
        writeln('Por favor, ingrese una fecha válida');

        readln(pedir_fecha);
        clrscr;
        
    until (es_fecha_valida(pedir_fecha));
end;

procedure cantidad_inscripciones_entre_fechas(lista : t_lista_terrenos);
var
    fecha1, fecha2 : string;
    aux_fecha : string;
    terreno_actual : t_terreno;
    contador : cardinal;
begin
    primero_lista_terrenos(lista);

    contador := 0;

    // pide las fechas
    writeln('Ingrese la primera fecha:');
    fecha1 := pedir_fecha();
    writeln('Ingrese la segunda fecha:');
    fecha2 := pedir_fecha();

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

    while fecha_es_mayor_igual(fecha2, terreno_actual.fecha_inscripcion) do
    begin
        contador := contador + 1;
        siguiente_lista_terrenos(lista);
        recuperar_lista_terrenos(lista, terreno_actual);
    end;

    writeln('Entre ', fecha1, ' y ', fecha2, ' se inscribieron ', contador, ' terrenos :)');

end;

function cant_propietarios_mult_propiedades(arbol : t_arbol): cardinal;
begin
    if arbol.lista.tam > 1 then 
        cant_propietarios_mult_propiedades := cant_propietarios_mult_propiedades + 1;

    if tiene_hijo_izq(arbol) then
        cant_propietarios_mult_propiedades := cant_propietarios_mult_propiedades + cant_propietarios_mult_propiedades(arbol.si^);

    if tiene_hijo_der(arbol) then
        cant_propietarios_mult_propiedades := cant_propietarios_mult_propiedades + cant_propietarios_mult_propiedades(arbol.sd^);
end;

procedure porc_propietarios_mult_propiedades(var arbol : t_arbol; var archivo_contador : t_archivo_contador);
var
    total_propietarios, propietarios_mult : cardinal;
begin
  total_propietarios := cantidad_contribuyentes(archivo_contador);
  propietarios_mult := cant_propietarios_mult_propiedades(arbol);

  if (total_propietarios <> 0) or (propietarios_mult <> 0) then
    begin
    if propietarios_mult <> 0 then
    Writeln('De los ',total_propietarios,' propietarios, ',propietarios_mult,', un' ,(propietarios_mult * 100 / total_propietarios),'% tienen más de una propiedad.')
    else Writeln('Ningún propietario tiene más de una propiedad');
    end;
end;

end.
