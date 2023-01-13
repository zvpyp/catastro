unit estadisticas

{$codepage utf8}

{--------------------------------}

interface

    uses
    contador_datos in 'units/varios/contador_datos.pas',
    terreno in 'units/terreno/terreno.pas',
    lista_terrenos in 'units/terreno/lista_terrenos.pas',
    validacion_entradas in 'units/varios/validacion_entradas.pas',
    compara_fechas in 'units/varios/compara_fechas.pas';

    // Muestra en pantalla la cantidad de usuarios dados de baja.
    procedure propietarios_inactivos(var archivo_contador : t_archivo_contador);

    // Muestra en pantalla el porcentaje de terrenos de cada tipo.
    procedure porcentaje_terrenos_tipo(var archivo : t_archivo_contador);

    // Pide dos fechas al usuario. Muestre todas las inscripciones entre ambas fechas.
    procedure inscripciones_entre_fechas(lista : t_lista_terrenos);

{--------------------------------}

implementation


    procedure propietarios_inactivos(var archivo_contador : t_archivo_contador);
    var
        inactivos : cardinal;
    begin
        clrscr;
        inactivos := cantidad_contribuyentes(archivo_contador) - cantidad_activos(archivo_contador);

        writeln('Propietarios dados de baja: ', inactivos);
        writeln('Presione una tecla para continuar...');
        readkey;
    end;


    procedure porcentaje_terrenos_tipo(var archivo : t_archivo_contador);
    var
        i : 1..5;
        total, actual : cardinal;
    begin
        clrscr;

        total := cantidad_terrenos(archivo);

        if total > 0 then
        begin
            for i := 1 to 5 do
            begin
                actual := cantidad_terrenos_tipo(archivo, i);
                writeln('Tipo ', i, ': ', (actual * 100 / total), '%');
            end;
        end
        else
            writeln('No hay terrenos en la base de datos.');
        
        writeln('Presione una tecla para continuar...');
        readkey;
    end;


    procedure inscripciones_entre_fechas(lista : t_lista_terrenos);
    var
        fecha1, fecha2, fecha_aux : string;
        terreno_actual : t_terreno;
        contador : cardinal;
    begin
        contador := 0;

        fecha1 := leer_fecha('Ingrese la primera fecha');
        fecha2 := leer_fecha('Ingrese la segunda fecha');

        // Las ordena en caso de estar en orden incorrecto.
        if fecha_es_menor(fecha1, fecha2) then
        begin
            fecha_aux := fecha1;
            fecha1 := fecha2;
            fecha2 := fecha_aux;
        end;

        primero_lista_terrenos(lista);
        fecha_aux := '0001-01-01'; // para que lea la primera iteración siempre si la lista no está vacía.

        // Cuenta los terrenos entre ambas fechas.
        while not(fin_lista_terrenos(lista)) and (fecha_es_menor_igual(fecha_aux, fecha2)) do
        begin
            recuperar_lista_terrenos(lista, terreno_actual);
            fecha_aux := terreno_actual.fecha_inscripcion;

            if fecha_es_mayor_igual(fecha_aux, fecha1) then
                contador := contador + 1;

            siguiente_lista_terrenos(lista);
        end;

        // Muestra los resultados.
        writeln('Entre el ', fecha1, ' y el ', fecha2, ' hubo ', contador, ' inscripciones');

        pedir_tecla();
    end;

end.