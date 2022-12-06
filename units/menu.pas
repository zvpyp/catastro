unit menu;

interface

uses crt;

// Muestra el menú principal. Devuelve la opción elegida.
function menu_principal(): char;

// Muestra un submenú de AMBC genérico. Devuelve la opción elegida.
function submenu_ambc(submenu_nombre : string): char;

// Muestra el submenú de listados y estadísticas. Devuelve la opción elegida.
function submenu_listados_estadisticas(): char;

implementation

    // Escribe un mensaje a partir de las coordenadas x, y.
    procedure escribir_alineado(mensaje : string; x : byte, y : byte);
    begin
        gotoxy(x, y);
        writeln(mensaje);
    end;

    // Pide una entrada al usuario entre dos valores ASCII hasta obtener un valor válido.
    // Luego lo retorna.
    function pedir_input(valido_desde : char, valido_hasta : char): char;
    var
    begin
        repeat
            pedir_input := readkey;
        until ((valido_desde <= pedir_input) and (pedir_input <= valido_hasta));
    end;

    // TODO: hacerlo más lindo.
    function menu_principal(): char;
    begin
        writeln('Seleccione una opción para continuar:');
        writeln();

        writeln('1 - Contribuyentes');
        writeln('2 - Terrenos');
        writeln('3 - Listados y estadísticas');
        writeln();
        writeln('4 - Salir')

        menu_principal = pedir_input('1', '4');
    end;

    // TODO: hacerlo más lindo.
    function submenu_ambc(submenu_nombre : string): char;
    begin
        writeln('Usted se encuentra en el menú de ', submenu_nombre, ':');
        writeln();

        writeln('1 - Agregar');
        writeln('2 - Borrar');
        writeln('3 - Modificar');
        writeln('4 - Consultar');
        writeln();
        writeln('5 - Regresar');

        submenu_ambc = pedir_input('1', '5');
    end;
    
    // TODO: hacerlo más lindo.
    function submenu_listados_estadisticas(): char;
    begin
        writeln('Usted se encuentra en el menú de listados y estadísticas:');
        writeln();

        writeln('1 - Lista de contribuyentes y sus propiedades');
        writeln('2 - Lista de inscripciones por año');
        writeln('3 - Lista de terrenos por zona');
        writeln('4 - Estadísticas');
        writeln();
        writeln('5 - Regresar');

        submenu_listados_estadisticas = pedir_input('1', '5');
    end;

end.