unit usuario_listados_estadisticas;

{ Unidad de tipo de interacción con usuario del submenú de listados y estadísticas. }

{--------------------------------}

interface

uses
    contribuyente in 'units/contribuyente/contribuyente.pas',
    contador_datos in 'units/varios/contador_datos.pas';

{---------------Listados---------------}

{---------------Estadísticas---------------}

// Muestra la cantidad de contribuyentes dados de baja.
Procedure propietarios_dados_de_baja(var archivo_contribuyentes : t_archivo_contribuyentes; var archivo_contador : t_archivo_contador);

// Muestra la cantidad de terrenos por tipo de edificación y
// su % respecto al total.
Procedure porc_por_tipo_edif(var archivo_terrenos : t_archivo_terrenos; var archivo_contador : t_archivo_contador);

{--------------------------------}

implementation

{---------------Listados---------------}

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

{---------------------------------------------}
// TODO:
// AÑADIR RECORRIDO PREORDEN SOBRE EL ARBOL DE CONTRIBUYENTES:
// procedure listado_contribuyentes_propiedades();

// HACER RECORRIDO EN LISTA POR FECHAS JEJEJE
// procedure listado_fecha_inscripciones();

// PRIMERO HAY QUE CREAR UN ARRAY DE TERRENOS
// QUE CONTENGA UN RECORD DE ESTILO ZONA1, ZONA2, ZONA3...
// LUEGO RECORRERLO Y LISTO (ENTENDISTE EL CHISTE?¿¿¿!¿)
// procedure listado_zona_terrenos();

// DESPUÉS DE TODAS, ESTA ES LA MÁS FÁCIL XD.
// procedure mostrar_estadisticas();

end.