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

    { Funciones de menús }
    
    function menu_principal(): byte;

    // Acciones a realizar sobre el contribuyente encontrado.
    function menu_encontrado(): byte;

    function menu_consulta(): byte;

    function menu_modificar_terreno(): byte;

    function menu_modificar_contribuyente(): byte;

    function menu_listados(): byte;

    function menu_estadisticas(): byte;

    // Opciones de consulta por DNI o por nombre y apellido.
    function menu_consulta_contribuyente(): byte;

    // Pide al usuario seleccionar una zona para un terreno.
    function menu_seleccion_zona(): byte;

    // Pide al usuario seleccionar un tipo de edificación para un terreno.
    function menu_seleccion_tipo_edificacion(): byte;


    { Funciones y procedimientos para crear un menú desde cero
      Nota: utilizar solamente si se desconocen las opciones de antemano. }

    // Retorna un menú sin opciones. Mensaje superior es el título del menú.
    function crear_menu(mensaje_superior : string): t_menu;

    // añade una opción a un menú existente, con un mensaje.
    procedure agregar_opcion(var menu : t_menu; mensaje : string);


    // Espera a que el usuario seleccione una opción
    // luego la retorna como entero, según el orden.
    // Escape siempre retorna 0;
    function seleccion_menu(menu : t_menu) : byte;

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


        // retorna una opción
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


        function seleccion_menu(menu : t_menu) : byte;
        var
            opt : string;
        begin
            clrscr;

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
            menu := crear_menu('Bienvenido al Catastro del equipo 10 ¿Qué desea hacer? :)');
            agregar_opcion(menu, 'Ingresar número de contribuyente');  // 1
            agregar_opcion(menu, 'Consulta');                          // 2
            agregar_opcion(menu, 'Listas e impresión de datos');       // 3
            agregar_opcion(menu, 'Estadísticas');                      // 4
            agregar_opcion(menu, 'Salir');                             // 5

            menu_principal := seleccion_menu(menu);
        end;

        function menu_encontrado(): byte;
        var
            menu : t_menu;
        begin
            menu := crear_menu('¿Qué desea realizar?');
            agregar_opcion(menu, 'Modificación');      // 1
            agregar_opcion(menu, 'Baja');              // 2
            agregar_opcion(menu, 'Ver terrenos');      // 3
            agregar_opcion(menu, 'Agregar terreno');   // 4
            agregar_opcion(menu, 'Modificar terreno'); // 5
            agregar_opcion(menu, 'Eliminar terreno');  // 6
            agregar_opcion(menu, 'Volver');             // 7

            menu_encontrado := seleccion_menu(menu);
        end;

        function menu_consulta(): byte;
        var
            menu : t_menu;
        begin
            menu := crear_menu('¿Qué desea consultar?');
            agregar_opcion(menu, 'Contribuyente');      // 1
            agregar_opcion(menu, 'Terreno');            // 2
            agregar_opcion(menu, 'Volver');             // 3

            menu_consulta := seleccion_menu(menu);
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
            agregar_opcion(menu, 'Superficie');                 // 1
            agregar_opcion(menu, 'Zona');                       // 2
            agregar_opcion(menu, 'Tipo de edificación');        // 3
            agregar_opcion(menu, 'Volver');                     // 4

            menu_modificar_terreno := seleccion_menu(menu);
        end;


        function menu_modificar_contribuyente(): byte;
        var
            menu : t_menu;
        begin
            menu := crear_menu('¿Qué desea modificar?');
            agregar_opcion(menu, 'Dirección');                  // 1
            agregar_opcion(menu, 'Ciudad');                     // 2
            agregar_opcion(menu, 'Teléfono');                   // 3
            agregar_opcion(menu, 'Email');                      // 4
            agregar_opcion(menu, 'Volver');                     // 5

            menu_modificar_contribuyente := seleccion_menu(menu);
        end;


        function menu_consulta_contribuyente(): byte;
        var
            menu : t_menu;
        begin
            menu := crear_menu('¿Cómo desea realizar la consulta?');
            agregar_opcion(menu, 'Por DNI');                // 1
            agregar_opcion(menu, 'Por nombre completo');    // 2
            agregar_opcion(menu, 'Volver');                 // 3

            menu_consulta_contribuyente := seleccion_menu(menu);
        end;


        function menu_seleccion_zona(): byte;
        var
            menu : t_menu;
        begin
            menu := crear_menu('Seleccione la zona del terreno:');
            agregar_opcion(menu, 'Zona 1 (150%)');    // 1
            agregar_opcion(menu, 'Zona 2 (110%)');    // 2
            agregar_opcion(menu, 'Zona 3 (70%)');     // 3
            agregar_opcion(menu, 'Zona 4 (40%)');     // 4
            agregar_opcion(menu, 'Zona 5 (10%)');     // 5

            // Evitar salir con escape.
            repeat
                menu_seleccion_zona := seleccion_menu(menu);
            until (menu_seleccion_zona <> 0);
        end;


        function menu_seleccion_tipo_edificacion(): byte;
        var
            menu : t_menu;
        begin
            menu := crear_menu('Seleccione el tipo de edificación:');
            agregar_opcion(menu, 'Categoría 1 (170%)');    // 1
            agregar_opcion(menu, 'Categoría 2 (130%)');    // 2
            agregar_opcion(menu, 'Categoría 3 (110%)');    // 3
            agregar_opcion(menu, 'Categoría 4 (80%)');     // 4
            agregar_opcion(menu, 'Categoría 5 (50%)');     // 5

            // Evitar salir con escape.
            repeat
                menu_seleccion_tipo_edificacion := seleccion_menu(menu);
            until (menu_seleccion_tipo_edificacion <> 0);
        end;

end.
