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


end.