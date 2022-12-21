unit u_menu;

{$codepage utf8}

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
    
    function menu_principal(): byte;

    // Menú genérico para las opciones agregar, borrar, modificar, consultar.
    function menu_ABMC(nombre_menu : string): byte;

    function menu_modificar_terreno(): byte;

    function menu_modificar_contribuyente(): byte;

    function menu_listados(): byte;

    function menu_estadisticas(): byte;
{--------------------------------}

implementation

        // Retorna un menú sin opciones.
        function crear_menu(mensaje_superior : string): t_menu;
        begin
            crear_menu.mensaje_superior := mensaje_superior;
            crear_menu.cabecera := nil;
            crear_menu.actual := nil;
            crear_menu.seleccionada := nil;
            crear_menu.ultima := nil;
            crear_menu.tam := 0;
        end;

        // retorna una opción
        function crear_opcion(mensaje : string; indice : byte): t_opcion;
        begin
            crear_opcion.mensaje := mensaje;
            crear_opcion.indice := indice;
            crear_opcion.anterior := nil;
            crear_opcion.siguiente := nil;
        end;

        // añade una opción al menú.
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

        // Espera a que el usuario elija una opción válida, y la retorna como una string de 3 letras.
        // Teclas que retorna: arriba, abajo, izquierda, derecha, enter, escape.
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

        // Escribe el menú con una interfaz bonita.
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

        // Espera a que el usuario seleccione una opción
        // luego la retorna.
        // Escape siempre retorna 0;
        function seleccion_menu(menu : t_menu) : byte;
        var
            opt : string;
        begin
            opt := '';

            // en caso de escape, es 0 por predeterminado.
            seleccion_menu := 0;

            while (opt <> 'enter') and (opt <> 'escape') do
            begin
                mostrar_menu(menu);

                opt := leer_opcion();

                if opt = 'abajo' then
                    opcion_siguiente(menu);
                
                if opt = 'arriba' then
                    opcion_anterior(menu);
                
                clrscr;
            end;

            // si se usó enter, retorna el índice correspondiente
            if opt = 'enter' then
                seleccion_menu := menu.seleccionada^.indice;
        end;

        function menu_principal(): byte;
        var
            menu : t_menu;
        begin
            menu := crear_menu('Bienvenido a Catastro, del equipo 10 ¿Qué desea hacer? :)');
            agregar_opcion(menu, 'Alta');                       // 1
            agregar_opcion(menu, 'Baja');                       // 2
            agregar_opcion(menu, 'Modificación');               // 3
            agregar_opcion(menu, 'Consulta');                   // 4
            agregar_opcion(menu, 'Listas e impresión de datos');// 5
            agregar_opcion(menu, 'Estadísticas');               // 6
            agregar_opcion(menu, 'Salir');                      // 7

            menu_principal := seleccion_menu(menu);
        end;

        function menu_ABMC(nombre_menu : string): byte;
        var
            menu : t_menu;
        begin
            menu := crear_menu('Usted se encuentra en el menú de ', nombre_menu, '. Elija una opción:');
            agregar_opcion(menu, 'Contribuyente');      // 1
            agregar_opcion(menu, 'Terreno');            // 2
            agregar_opcion(menu, 'Volver');             // 3

            menu_ABMC := seleccion_menu(menu);
        end;

        function menu_listados(): byte;
        var
            menu : t_menu;
        begin
            menu := crear_menu('Usted se encuentra en el menú de listas e impresión de datos. Elija una opción');
            agregar_opcion(menu, 'Lista de contribuyentes y sus propiedades valorizadas');  // 1
            agregar_opcion(menu, 'Lista de inscripciones en un año');                       // 2
            agregar_opcion(menu, 'Lista de terrenos por zona');                             // 3
            agregar_opcion(menu, 'Impresión de comprobante');                               // 4
            agregar_opcion(menu, 'Volver');                                                 // 5

            menu_listados := seleccion_menu(menu);
        end;

        function menu_estadisticas(): byte;
        var
            menu : t_menu;
        begin
            menu := crear_menu('Usted se encuentra en el menú de estadísticas. Elija una opción');
            agregar_opcion(menu, 'Cantidad de inscripciones entre dos fechas');                     // 1
            agregar_opcion(menu, 'Porcentaje de propietarios con más de una propiedad');            // 2
            agregar_opcion(menu, 'Porcentaje de propietarios por tipo de edificación');             // 3
            agregar_opcion(menu, 'Cantidad de propietarios dados de baja');                         // 4
            agregar_opcion(menu, 'Volver');                                                         // 5

            menu_estadisticas := seleccion_menu(menu);
        end;

        function menu_modificar_terreno(): byte;
        var
            menu : t_menu;
        begin
            menu := crear_menu('¿Qué desea modificar?');        
            agregar_opcion(menu, 'Número de contribuyente');    // 1
            agregar_opcion(menu, 'Número de plano');            // 2
            agregar_opcion(menu, 'Fecha de inscripción');       // 3
            agregar_opcion(menu, 'Domicilio parcelario');       // 4
            agregar_opcion(menu, 'Superficie');                 // 5
            agregar_opcion(menu, 'Zona');                       // 6
            agregar_opcion(menu, 'Tipo de edificación');        // 7
            agregar_opcion(menu, 'Volver');                     // 8

            menu_modificar_terreno := seleccion_menu(menu);
        end;

        function menu_modificar_contribuyente(): byte;
        var
            menu : t_menu;
        begin
            menu := crear_menu('¿Qué desea modificar?');
            agregar_opcion(menu, 'Número de contribuyente');    // 1
            agregar_opcion(menu, 'Apellido');                   // 2
            agregar_opcion(menu, 'Nombre');                     // 3
            agregar_opcion(menu, 'Dirección');                  // 4
            agregar_opcion(menu, 'Ciudad');                     // 5
            agregar_opcion(menu, 'DNI');                        // 6
            agregar_opcion(menu, 'Fecha de nacimiento');        // 7
            agregar_opcion(menu, 'Teléfono');                   // 8
            agregar_opcion(menu, 'Email');                      // 9
            agregar_opcion(menu, 'Volver');                     // 10

            menu_modificar_contribuyente := seleccion_menu(menu);
        end;

end.