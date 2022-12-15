unit menu;

{ Unidad de menús y submenús. }

{--------------------------------}

interface

    uses crt;

    type
        t_puntero_opcion = ^t_opcion;

        t_opcion = record
            mensaje : string;
            indice : byte;
            anterior : t_puntero_opcion;
            siguiente : t_puntero_opcion;
            valida : boolean;
        end;

        t_menu = record
            mensaje_superior : string;
            seleccionada : t_puntero_opcion;
            ultimo : t_puntero_opcion;
        end;

        //
        function crear_menu(mensaje_superior : string): t_menu;

        //
        function crear_opcion(mensaje : string; indice : byte; valida : boolean): t_opcion;

        //
        procedure agregar_opcion(var menu : t_menu; opcion : t_opcion);

        // Espera a que el usuario elija una opción válida, y la retorna como una string de 3 letras.
        // Teclas que retorna: arriba, abajo, izquierda, derecha, enter, escape.
        function leer_opcion(): string;

{--------------------------------}

implementation

        function crear_menu(mensaje_superior : string): t_menu;
        begin
            crear_menu.mensaje_superior := mensaje_superior;
        end;

        function crear_opcion(mensaje : string; indice : byte; valida : boolean): t_opcion;
        begin
            crear_opcion.mensaje := mensaje;
            crear_opcion.indice := indice;
            crear_opcion.valida := valida;
        end;

        procedure agregar_opcion(var menu : t_menu; opcion : t_opcion);
        var
            puntero_auxiliar : t_puntero_opcion;
        begin
            new(puntero_auxiliar);
            puntero_auxiliar^ := opcion;

            menu.ultimo^.siguiente := puntero_auxiliar;
            puntero_auxiliar^.anterior := menu.ultimo;

            menu.ultimo := puntero_auxiliar;
        end;

        function leer_opcion(): string;
        var
            boton_presionado : byte;
        begin
            boton_presionado := 0;

            // Espera a que se presione una tecla válida
            while (boton_presionado <> 13) and (boton_presionado <> 27) and (boton_presionado <> 72) and
                  (boton_presionado <> 75) and (boton_presionado <> 77) and (boton_presionado <> 80) do
            begin
                boton_presionado := ord(readkey);
            end;

            case boton_presionado of
                13: leer_opcion := 'enter';
                27: leer_opcion := 'escape';
                72: leer_opcion := 'arriba';
                75: leer_opcion := 'izquierda';
                77: leer_opcion := 'derecha';
                80: leer_opcion := 'abajo';
            end;
        end;

end.