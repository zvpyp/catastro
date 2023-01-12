unit estadisticas

{$codepage utf8}

{--------------------------------}

interface

    uses
    contador_datos in 'units/varios/contador_datos.pas',
    terreno in 'units/terreno/terreno.pas',
    lista_terrenos in 'units/terreno/lista_terrenos.pas';

    // Muestra en pantalla la cantidad de usuarios dados de baja.
    procedure propietarios_inactivos(var archivo_contador : t_archivo_contador);

    // Muestra en pantalla el porcentaje de terrenos de cada tipo.
    procedure porcentaje_terrenos_tipo(var archivo : t_archivo_contador);

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


end.