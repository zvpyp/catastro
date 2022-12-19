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
        end;

        t_menu = record
            mensaje_superior : string;
            cabecera : t_puntero_opcion;
            actual : t_puntero_opcion;
            seleccionada : t_puntero_opcion;
            ultima : t_puntero_opcion;
            tam : byte;
        end;

        // Genera un menú sin opciones.
        function crear_menu(mensaje_superior : string): t_menu;

        // añade una opción al menú.
        procedure agregar_opcion(var menu : t_menu; mensaje : string);

        // Espera a que el usuario elija una opción válida, y la retorna como una string de 3 letras.
        // Teclas que retorna: arriba, abajo, izquierda, derecha, enter, escape.
        function leer_opcion(): string;

        // Escribe el menú con una interfaz bonita.
        procedure mostrar_menu(menu : t_menu);

        // BORRAR ESTOS DOS:
        procedure opcion_siguiente(var menu : t_menu);

        procedure opcion_anterior(var menu : t_menu);

{--------------------------------}

implementation

        function crear_menu(mensaje_superior : string): t_menu;
        begin
            crear_menu.mensaje_superior := mensaje_superior;
            crear_menu.cabecera := nil;
            crear_menu.actual := nil;
            crear_menu.seleccionada := nil;
            crear_menu.ultima := nil;
            crear_menu.tam := 0;
        end;

        function crear_opcion(mensaje : string; indice : byte): t_opcion;
        begin
            crear_opcion.mensaje := mensaje;
            crear_opcion.indice := indice;
            crear_opcion.anterior := nil;
            crear_opcion.siguiente := nil;
        end;

        procedure agregar_opcion(var menu : t_menu; mensaje : string);
        var
            puntero_auxiliar : t_puntero_opcion;
        begin
            
            menu.tam := menu.tam + 1;

            new(puntero_auxiliar);
            puntero_auxiliar^ := crear_opcion(mensaje, menu.tam);

            puntero_auxiliar^.anterior := menu.ultima;

            if menu.cabecera = nil then
            begin
                menu.cabecera := puntero_auxiliar;
                menu.seleccionada := menu.cabecera;
            end;

            if menu.ultima <> nil then
                menu.ultima^.siguiente := puntero_auxiliar;

            menu.ultima := puntero_auxiliar;
        end;

        function leer_opcion(): string;
        var
            boton_presionado : byte;
        begin
            boton_presionado := 0;

            // Espera a que se presione una tecla válida
            while (boton_presionado <> 13) and (boton_presionado <> 27) and
                  (boton_presionado <> 72) and (boton_presionado <> 80) do
            begin
                boton_presionado := ord(readkey);
            end;

            case boton_presionado of
                13: leer_opcion := 'enter';
                27: leer_opcion := 'escape';
                72: leer_opcion := 'arriba';
                80: leer_opcion := 'abajo';
            end;
        end;

        procedure opcion_siguiente(var menu : t_menu);
        begin
            if menu.seleccionada^.siguiente <> nil then
                menu.seleccionada := menu.seleccionada^.siguiente;
        end;

        procedure opcion_anterior(var menu : t_menu);
        begin
            if menu.seleccionada^.anterior <> nil then
                menu.seleccionada := menu.seleccionada^.anterior;
        end;

        procedure inicio_menu(var menu : t_menu);
        begin
            menu.actual := menu.cabecera;
        end;

        procedure mostrar_menu(menu : t_menu);
        begin
            inicio_menu(menu);

            writeln(menu.mensaje_superior);

            while menu.actual <> nil do
            begin
                if menu.actual^.indice = menu.seleccionada^.indice then
                    writeln('>', menu.actual^.mensaje)
                else
                    writeln(' ',menu.actual^.mensaje);

                menu.actual := menu.actual^.siguiente;
            end;
        end;

end.