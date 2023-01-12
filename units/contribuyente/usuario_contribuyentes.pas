unit usuario_contribuyentes;

{$codepage utf8}

{ Unidad de alta, baja, modificación y consulta de contribuyentes. }

{--------------------------------}

interface

    uses
        contribuyente in 'units/contribuyente/contribuyente.pas',
        arbol in 'units/arbol.pas',
        contador_datos in 'units/varios/contador_datos.pas',
        u_menu in 'units/u_menu.pas',
        validacion_entradas in 'units/varios/validacion_entradas.pas',
        terreno in 'units/terreno/terreno.pas',
        lista_terrenos in 'units/terreno/lista_terrenos.pas',
        usuario_terrenos in 'units/terreno/usuario_terrenos.pas',
        crt, sysutils;

    // Le pide una clave al usuario (tipo dni o nombre). Retorna un dato con clave e índice, si existe.
    // En caso de no existir, el índice es 0 y la clave es vacío.
    // tipo determina el tipo de orden que se usa en el árbol.
    // tipos: 'dni', 'nombre'
    function buscar_contribuyente(var archivo : t_archivo_contribuyentes;
                                    raiz_dni : t_puntero_arbol;
                                    raiz_nombre : t_puntero_arbol;
                                    tipo : string): t_puntero_arbol;

    // Muestra todos los datos de un contribuyente.
    procedure mostrar_contribuyente(contribuyente : t_contribuyente);

    // Pide datos al usuario. Crea un nuevo contribuyente y lo añade al archivo.
    // Se deben ingresar los 3 árboles ordenados.
    // Se utiliza el nro de contribuyente pedido con anterioridad.
    procedure alta_contribuyente(var archivo : t_archivo_contribuyentes;
                                 var archivo_contador : t_archivo_contador;
                                 var raiz_dni : t_puntero_arbol;
                                 var raiz_nombre : t_puntero_arbol;
                                 var raiz_nro_contribuyente : t_puntero_arbol;
                                     nro_contribuyente : string);

    // Da de baja a un contribuyente dado.
    // Borra también todas sus propiedades.
    procedure baja_contribuyente(var archivo_contribuyentes : t_archivo_contribuyentes;
                                 var archivo_terrenos : t_archivo_terrenos;
                                 var archivo_contador : t_archivo_contador;
                                 var lista_terrenos : t_lista_terrenos;
                                 var raiz_nro_contribuyente : t_puntero_arbol;
                                     nro_contribuyente : string);

    // Modifica un contribuyente dado.
    procedure modificar_contribuyente(var archivo : t_archivo_contribuyentes;
                                      var raiz_nro_contribuyente : t_puntero_arbol;
                                          nro_contribuyente : string);

    // Busca el contribuyente en el árbol e imprime sus datos.
    procedure consultar_contribuyente(var archivo : t_archivo_contribuyentes;
                                      var raiz_nro_contribuyente : t_puntero_arbol;
                                          nro_contribuyente : string);

     procedure activar_contribuyente(var archivo : t_archivo_contribuyentes; contribuyente : t_contribuyente; indice : cardinal);                           

{--------------------------------}

implementation

    // TODO: estilizar.
    procedure mostrar_contribuyente(contribuyente : t_contribuyente);
    begin
        if contribuyente.activo then
            begin
                writeln('Nombre completo: ', contribuyente.nombre, ' ', contribuyente.apellido);
                writeln('DNI: ', contribuyente.dni);
                writeln('Número de contribuyente: ', contribuyente.numero);
                writeln('Dirección: ', contribuyente.direccion);
                writeln('Ciudad: ', contribuyente.ciudad);
                writeln('Fecha de Nacimiento: ', contribuyente.fecha_nacimiento);
                writeln('Teléfono: ', contribuyente.tel);
                writeln('Email: ', contribuyente.email);

                writeln('');
                writeln('Presione una tecla para continuar...');
                readkey;
            end
        else
            begin
                writeln('Contribuyente inactivo');

                writeln('');
                writeln('Presione una tecla para continuar...');
                readkey;
            end;
    end;


    // Genera un menú de contribuyentes a partir de un árbol con elementos con claves iguales.
    function menu_buscar_contribuyente(mensaje : string; raiz : t_puntero_arbol; var archivo : t_archivo_contribuyentes): t_menu;
    var
        menu : t_menu;
        nodo_actual : t_puntero_arbol;
        dato_actual : t_dato_arbol;
        contribuyente : t_contribuyente;
        mensaje_opcion : string;
    begin
        menu := crear_menu(mensaje);

        nodo_actual := raiz;

        // opciones de la forma "calle (dni: 12345678)"
        while not(arbol_vacio(nodo_actual)) do
        begin
            dato_actual := info_raiz(nodo_actual);
            contribuyente := leer_contribuyente(archivo, dato_actual.indice);
            mensaje_opcion := contribuyente.direccion + ' (DNI: ' + contribuyente.dni + ')';

            agregar_opcion(menu, mensaje_opcion);
            
            nodo_actual := hijo_derecho(nodo_actual);
        end;

        menu_buscar_contribuyente := menu;

    end;

    
    function buscar_contribuyente(var archivo : t_archivo_contribuyentes;
                                    raiz_dni : t_puntero_arbol;
                                    raiz_nombre : t_puntero_arbol;
                                    tipo : string): t_puntero_arbol;
    var
        clave : string;
        cantidad : cardinal; // utilizado en caso de múltiples encontrados.
        mensaje : string;
        opt : byte;
        i : byte;
        menu : t_menu;
    begin
        if tipo = 'dni' then 
        begin
            // Solo acepta número natural para dni.
            clave := leer_entrada('Ingrese el DNI del contribuyente', 10, 'natural');
            buscar_contribuyente := preorden(raiz_dni, clave);
        end
        else if tipo = 'nombre' then
        begin
            cantidad := 0;

            // Límite 61 (nombre y apellido, incluye espacio);
            clave := leer_entrada('Ingrese el nombre completo del contribuyente', 61, 'normal');
            
            // Encontrar todos los que concuerdan.
            preorden_multiple(raiz_nombre, clave, buscar_contribuyente, cantidad);
            
            writeln('la cantidad de encontrados es ', cantidad);
            readkey;

            if cantidad >= 2 then
            begin
                clrscr;
                mensaje := 'Se han encontrado ' + intToStr(cantidad) + ' contribuyentes llamados ' + clave + ' (listado por dirección y dni):';

                // Generar el menú a partir de los contribuyentes de misma clave.
                menu := menu_buscar_contribuyente(mensaje, buscar_contribuyente, archivo);

                repeat
                    opt := seleccion_menu(menu);
                until (opt <> 0); // Evitar salir con escape.

                // Seleccionar el contribuyente según el número.
                i := 1; 
                while i < opt do
                begin
                    buscar_contribuyente := hijo_derecho(buscar_contribuyente);
                    i := i + 1;
                end;
            end;
        end;
    end;

    procedure activar_contribuyente(var archivo : t_archivo_contribuyentes; contribuyente : t_contribuyente; indice : cardinal);
    begin
        contribuyente.activo := true;
        escribir_contribuyente(archivo, contribuyente, indice);
        writeln('Contribuyente activado con éxito:');
        writeln('');
        mostrar_contribuyente(contribuyente);
    end;


    procedure alta_contribuyente(var archivo : t_archivo_contribuyentes;
                                 var archivo_contador : t_archivo_contador;
                                 var raiz_dni : t_puntero_arbol;
                                 var raiz_nombre : t_puntero_arbol;
                                 var raiz_nro_contribuyente : t_puntero_arbol;
                                     nro_contribuyente : string);
    var
        contribuyente : t_contribuyente;
        indice : cardinal;
        dato : t_dato_arbol;
    begin
        clrscr;
    
        contribuyente.numero := nro_contribuyente; // Le pasamos el nro de contribuyente que se pidió antes.
        contribuyente.dni := leer_entrada('DNI', 10, 'natural');
        contribuyente.nombre := leer_entrada('Nombre', 30, 'normal');
        contribuyente.apellido := leer_entrada('Apellido', 30, 'normal');
        contribuyente.direccion := leer_entrada('Dirección', 30, 'normal');
        contribuyente.ciudad := leer_entrada('Ciudad', 40, 'normal');
        contribuyente.fecha_nacimiento := leer_fecha('Fecha de nacimiento');
        contribuyente.tel := leer_entrada('Teléfono', 15, 'natural');
        contribuyente.email := leer_entrada('Email', 40, 'normal'); // TODO: crear un leer separado para email.
        contribuyente.activo := true;

        // Asignar automáticamente el índice en el archivo.
        indice := cantidad_contribuyentes(archivo_contador) + 1;

        // Añadirlo al archivo
        escribir_contribuyente(archivo, contribuyente, indice);

        dato.indice := indice;
        dato.clave := contribuyente.dni;            
        //Test: {writeln('dato.clave: ', dato.clave);}
        agregar_hijo(raiz_dni, dato);
        dato.clave  := contribuyente.nombre + ' ' + contribuyente.apellido;
        agregar_hijo(raiz_nombre, dato);
        dato.clave := contribuyente.numero;
        agregar_hijo(raiz_nro_contribuyente, dato);

        // Cuenta un nuevo contribuyente.
        sumar_contribuyente(archivo_contador);

        clrscr;
        writeln('Contribuyente creado satisfactoriamente :)');
        readkey;
    end;


    procedure baja_contribuyente(var archivo_contribuyentes : t_archivo_contribuyentes;
                                 var archivo_terrenos : t_archivo_terrenos;
                                 var archivo_contador : t_archivo_contador;
                                 var lista_terrenos : t_lista_terrenos;
                                 var raiz_nro_contribuyente : t_puntero_arbol;
                                     nro_contribuyente : string);
    var
        contribuyente : t_contribuyente;
        nodo : t_puntero_arbol;
        indice : cardinal;
        terreno_encontrado : t_terreno;
    begin
        clrscr;

        nodo := preorden(raiz_nro_contribuyente, nro_contribuyente);
        indice := nodo^.info.indice;
        
        contribuyente := leer_contribuyente(archivo_contribuyentes, indice);
        contribuyente.activo := false;

        escribir_contribuyente(archivo_contribuyentes, contribuyente, indice);
        restar_contribuyente(archivo_contador); // resta 1 al contador de activos.

        // Borrar las propiedades de ese contribuyente.
        while secuencial_terreno(lista_terrenos, contribuyente.numero, 'contribuyente') do
        begin
            recuperar_lista_terrenos(lista_terrenos, terreno_encontrado);

            writeln('Borrando: ', terreno_encontrado.domicilio_parcelario); readkey; // Test
                    
            borrar_terreno(archivo_terrenos, archivo_contador, lista_terrenos, terreno_encontrado);
        end;

        writeln('Contribuyente dado de baja satisfactoriamente :)');
        writeln('');
        writeln('Presione una tecla para continuar...');
        readkey;
    end;


    procedure modificar_contribuyente(var archivo : t_archivo_contribuyentes;
                                      var raiz_nro_contribuyente : t_puntero_arbol;
                                          nro_contribuyente : string);
    var
        contribuyente : t_contribuyente;
        nodo : t_puntero_arbol;
        dato : t_dato_arbol;
        opt : byte;
        indice : cardinal;
    begin
        clrscr;

        nodo := preorden(raiz_nro_contribuyente, nro_contribuyente);
        indice := nodo^.info.indice;

        // Cargar datos del contribuyente
        contribuyente := leer_contribuyente(archivo, indice);

        if contribuyente.activo then
        begin
            // Menú de modificación
            repeat
                clrscr;
                writeln('Datos actualizados del contribuyente:');
                mostrar_contribuyente(contribuyente);
                
                opt := menu_modificar_contribuyente();

                case opt of
                1:  contribuyente.direccion := leer_entrada('Dirección', 30, 'normal');
                2:  contribuyente.ciudad := leer_entrada('Ciudad', 40, 'normal');
                3:  contribuyente.tel := leer_entrada('Teléfono', 15, 'natural');
                4:  contribuyente.email := leer_entrada('Email', 40, 'normal');
                end;

            until ((opt = 0) or (opt = 5)); // Opciones de salir.

            clrscr;
            writeln('Datos actualizados del contribuyente:');
            mostrar_contribuyente(contribuyente);

            // guardar los cambios en el archivo y en el árbol.
            if (leer_si_no('¿Desea guardar los cambios?') = 's') then
            begin
                escribir_contribuyente(archivo, contribuyente, indice);
                writeln('Contribuyente modificado satisfactoriamente :)');
            end;
        end
        else
        begin
            if (leer_si_no('Contribuyente inactivo. ¿Desea activarlo?') = 's') then
                activar_contribuyente(archivo, contribuyente, indice);
        end;

        writeln('Presione una tecla para continuar...');
        readkey;
    end;

    procedure consultar_contribuyente(var archivo : t_archivo_contribuyentes;
                                      var raiz_nro_contribuyente : t_puntero_arbol;
                                          nro_contribuyente : string);
    var
        contribuyente : t_contribuyente;
        nodo : t_puntero_arbol;
        indice : cardinal;
        
    begin
        nodo := preorden(raiz_nro_contribuyente, nro_contribuyente);
        indice := nodo^.info.indice;

        contribuyente := leer_contribuyente(archivo, indice);
        mostrar_contribuyente(contribuyente);
    end;

end.
