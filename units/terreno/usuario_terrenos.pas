unit usuario_terrenos;

{$codepage utf8}

{ Unidad de alta, baja, modificación y consulta de terrenos. }

{--------------------------------}

interface

    uses
        terreno in 'units/terreno/terreno.pas',
        contribuyente in 'units/contribuyente/contribuyente.pas',
        arbol in 'units/arbol.pas',
        contador_datos in 'units/varios/contador_datos.pas',
        u_menu in 'units/u_menu.pas',
        validacion_entradas in 'units/varios/validacion_entradas.pas',
        compara_fechas in 'units/varios/compara_fechas.pas',
        lista_terrenos in 'units/terreno/lista_terrenos.pas',
        crt, sysutils;


    // Busca un terreno en una lista. Si lo encuentra, lo retorna.
    // Sino, por predeterminado retorna un terreno vacío, con índice 0.
    function buscar_terreno(var lista : t_lista_terrenos): t_terreno;

    // Pide los datos y crea el terreno (con el nro de contribuyente obtenido con anterioridad).
    procedure alta_terreno(var archivo_terrenos : t_archivo_terrenos;
                           var archivo_contador : t_archivo_contador;
                           var lista : t_lista_terrenos;
                               nro_contribuyente : string);
    
    // Elimina un terreno de una lista y un archivo. Lo descuenta del archivo contador.
    procedure borrar_terreno(var archivo : t_archivo_terrenos;
                                var archivo_contador : t_archivo_contador;
                                var lista : t_lista_terrenos;
                                terreno : t_terreno);

    // Se le debe pasar el terreno que se desea eliminar.
    procedure baja_terreno(var archivo : t_archivo_terrenos;
                            var archivo_contador : t_archivo_contador;
                            var lista : t_lista_terrenos;
                            var terreno : t_terreno);
    
    // Pasar por parámetro el terreno a modificar.
    procedure modificar_terreno(var archivo_terrenos : t_archivo_terrenos;
                                var archivo_contador : t_archivo_contador;
                                var lista : t_lista_terrenos;
                                var terreno : t_terreno);
    
    // Imprime en pantalla todos los datos del terreno.
    procedure mostrar_terreno(terreno : t_terreno);

    // Muestra un menú con las propiedades del contribuyente y retorna la seleccionada.
    function seleccionar_terreno(var lista : t_lista_terrenos; nro_contribuyente : string) : t_terreno;

{--------------------------------}

implementation

    uses
    usuario_contribuyentes in 'units/contribuyente/usuario_contribuyentes.pas';

    // TODO: estilizar.



    procedure mostrar_terreno(terreno : t_terreno);
    begin
        clrscr;
        if terreno.indice <> 0 then
        begin
            writeln('Domicilio parcelario: ', terreno.domicilio_parcelario);
            writeln('Número de plano: ', terreno.nro_plano);
            writeln('Número de contribuyente: ', terreno.nro_contribuyente);
            writeln('Avalúo: $', terreno.avaluo:0:1);
            writeln('Fecha de inscripción: ', terreno.fecha_inscripcion);
            writeln('Superficie: ', terreno.superficie:0:0, ' m2');
            writeln('Zona: ', terreno.zona);
            writeln('Tipo de edificación: ', terreno.tipo_edificacion);
        end
        else Writeln('Terreno inexistente');

            writeln('');
            writeln('Presione una tecla para continuar...');
            readkey;
    end;


    function buscar_terreno(var lista : t_lista_terrenos): t_terreno;
    var
        clave : string;
        encontrado : boolean;
    begin
        clave := leer_entrada('Ingrese el domicilio parcelario del terreno', 30, 'normal');
        terreno_default(buscar_terreno);

        encontrado := secuencial_terreno(lista, clave, 'domicilio');

        if encontrado then
            recuperar_lista_terrenos(lista, buscar_terreno);

        // en cualquier caso, retornar con el domicilio parcelario dado
        buscar_terreno.domicilio_parcelario := clave;
    end;


    procedure crear_terreno(var archivo : t_archivo_terrenos;
                            var archivo_contador : t_archivo_contador;
                            var lista : t_lista_terrenos;
                            terreno : t_terreno);
    begin
        // Añadir a la lista
        enlistar_terreno(lista, terreno);

        // Añadir al archivo
        escribir_terreno(archivo, terreno, terreno.indice);
        
        // Contar el terreno
        sumar_terreno(archivo_contador, terreno.tipo_edificacion);
    end;


    // Retorna un número de contribuyente existente. Hasta que no lo encuentre o no se cree, no retorna.
    function leer_numero_contribuyente(var archivo_contribuyentes : t_archivo_contribuyentes; 
                                        var archivo_contador : t_archivo_contador;
                                        var arbol_contribuyentes_dni : t_puntero_arbol;
                                        var arbol_contribuyentes_nombre : t_puntero_arbol): string;
    var
        puntero_propietario : t_puntero_arbol;
        propietario : t_dato_arbol;
        opcion_consulta : byte;
        tipo_busqueda : string;
    begin
        repeat
            opcion_consulta := menu_consulta();

            case opcion_consulta of
                1:  tipo_busqueda := 'dni';
                2:  tipo_busqueda := 'nombre';
            end;

            puntero_propietario := buscar_contribuyente(archivo_contribuyentes, arbol_contribuyentes_dni, arbol_contribuyentes_nombre, tipo_busqueda);
            propietario := info_raiz(puntero_propietario);

            if propietario.indice = 0 then
            begin
                if leer_si_no('El propietario no existe. ¿Desea crearlo?') = 's' then
                begin
                    alta_contribuyente(archivo_contribuyentes, archivo_contador, arbol_contribuyentes_dni, arbol_contribuyentes_nombre, puntero_propietario, tipo_busqueda);
                end;
            end;
        until (propietario.indice <> 0);

        leer_numero_contribuyente := propietario.clave;
    end;


    // pide un número de plano al usuario. Si ya existe en la lista, lo vuelve a pedir.
    function leer_numero_plano(var lista : t_lista_terrenos): string;
    begin
        leer_numero_plano := leer_entrada('Ingrese el número de plano', 15, 'normal');

        // Vuelve a pedir hasta que no lo encuentre.
        while secuencial_terreno(lista, leer_numero_plano, 'plano') do
            leer_numero_plano := leer_entrada('Número de plano ya existente. Por favor, ingrese un número de plano distinto', 15, 'normal');
    end;


    procedure alta_terreno(var archivo_terrenos : t_archivo_terrenos;
                           var archivo_contador : t_archivo_contador;
                           var lista : t_lista_terrenos;
                               nro_contribuyente : string);
    var 
        terreno : t_terreno;
        edif_porc, zona_porc, valor_m2 : real; 
    begin
        valor_m2 := 12308.6;
            
        terreno.nro_contribuyente := nro_contribuyente;
        terreno.nro_plano := leer_numero_plano(lista);
        terreno.fecha_inscripcion := leer_fecha('Ingrese la fecha de inscripción');
        terreno.domicilio_parcelario := leer_entrada('Ingrese el domicilio parcelario', 30, 'normal');
        terreno.superficie := strToFloat(leer_entrada('Ingrese la superficie en km cuadrados', 255, 'real_positivo'));
        terreno.zona := menu_seleccion_zona();
        terreno.tipo_edificacion := menu_seleccion_tipo_edificacion();

        case terreno.zona of
            1: zona_porc := 1.5;
            2: zona_porc := 1.1;
            3: zona_porc := 0.7;
            4: zona_porc := 0.4;
            5: zona_porc := 0.1;
        end;

        case terreno.tipo_edificacion of
            1: edif_porc := 1.7;
            2: edif_porc := 1.3;
            3: edif_porc := 1.1;
            4: edif_porc := 0.8;
            5: edif_porc := 0.5;
        end;

        // Calculamos el avalúo.
        terreno.avaluo := valor_m2 * terreno.superficie * zona_porc * edif_porc;

        terreno.indice := cantidad_terrenos(archivo_contador) + 1;

        crear_terreno(archivo_terrenos, archivo_contador, lista, terreno);

        clrscr;
        writeln('Terreno creado satisfactoriamente :)');
        readkey;
    end;


    procedure borrar_terreno(var archivo : t_archivo_terrenos;
                                var archivo_contador : t_archivo_contador;
                                var lista : t_lista_terrenos;
                                terreno : t_terreno);
    var
        ultimo_terreno : t_terreno;
    begin

        // Borrar del archivo (desplazar el último e insertarlo en posición del antiguo)
        ultimo_terreno := leer_terreno(archivo, cantidad_terrenos(archivo_contador));
        ultimo_terreno.indice := terreno.indice; // Actualizar el índice del último terreno.
        escribir_terreno(archivo, ultimo_terreno, terreno.indice);

        {writeln('Terreno eliminado del archivo'); readkey;} // TEST

        // Borrar de la lista.
        desenlistar_terreno(lista, terreno.nro_plano);

        {writeln('Terreno desenlistado'); readkey;} // TEST

        // Actualizar el índice del último terreno en la lista.
        if not(lista_vacia_terrenos(lista)) then
        begin
            desenlistar_terreno(lista, ultimo_terreno.nro_plano);
            enlistar_terreno(lista, ultimo_terreno);

            {writeln('Ultimo terreno actualizado en lista'); readkey;} // TEST
        end;

        // Descontar un terreno
        restar_terreno(archivo_contador, terreno.tipo_edificacion);

    end;


    procedure baja_terreno(var archivo : t_archivo_terrenos;
                            var archivo_contador : t_archivo_contador;
                            var lista : t_lista_terrenos;
                            var terreno : t_terreno);
    begin
        clrscr;

        // Mostrar el terreno a eliminar
        writeln('Terreno a eliminar: ');
        writeln('');
        mostrar_terreno(terreno);

        if (leer_si_no('¿Quiere eliminar el terreno?') = 's') then
            borrar_terreno(archivo, archivo_contador, lista, terreno);
    end;


    procedure modificar_terreno(var archivo_terrenos : t_archivo_terrenos;
                                var archivo_contador : t_archivo_contador;
                                var lista : t_lista_terrenos;
                                var terreno : t_terreno);
    var
        nuevo_terreno : t_terreno;
        opt : byte;
        edif_porc, zona_porc, valor_m2 : real;
    begin
        valor_m2 := 12308.6;

        nuevo_terreno := terreno;
        clrscr;

        // Menú de modificación
        repeat
            opt := menu_modificar_terreno();

            case opt of
                1:  nuevo_terreno.superficie := strToFloat(leer_entrada('Superficie', 255, 'real_positivo'));
                2:  nuevo_terreno.zona := menu_seleccion_zona();
                3:  nuevo_terreno.tipo_edificacion := menu_seleccion_tipo_edificacion();
            end;
        until ((opt = 0) or (opt = 4));

        case terreno.zona of
            1: zona_porc := 1.5;
            2: zona_porc := 1.1;
            3: zona_porc := 0.7;
            4: zona_porc := 0.4;
            5: zona_porc := 0.1;
        end;

        case terreno.tipo_edificacion of
            1: edif_porc := 1.7;
            2: edif_porc := 1.3;
            3: edif_porc := 1.1;
            4: edif_porc := 0.8;
            5: edif_porc := 0.5;
        end;

        nuevo_terreno.avaluo := valor_m2 * terreno.superficie * zona_porc * edif_porc;

        writeln('Datos actualizados:');
        writeln('');
        mostrar_terreno(nuevo_terreno);

        if (leer_si_no('¿Desea guardar los cambios?') = 's') then
            begin
                // Borrar datos viejos.
                borrar_terreno(archivo_terrenos, archivo_contador, lista, terreno);

                // Agregar datos nuevos.
                crear_terreno(archivo_terrenos, archivo_contador, lista, nuevo_terreno);

                clrscr;
                writeln('Terreno actualizado satisfactoriamente :)');
                writeln('Presione una tecla para continuar...');
                readkey;
            end;
    end;

    function lista_terrenos_contribuyente(var lista : t_lista_terrenos; nro_contribuyente : string) : t_lista_terrenos;
    var
        terreno_actual : t_terreno;
    begin
      crear_lista_terrenos(lista_terrenos_contribuyente);
      primero_lista_terrenos(lista);
      while not (fin_lista_terrenos(lista)) do
        begin

        recuperar_lista_terrenos(lista, terreno_actual);
        
        if terreno_actual.nro_contribuyente = nro_contribuyente then
          enlistar_terreno(lista_terrenos_contribuyente, terreno_actual);

        siguiente_lista_terrenos(lista);
        end;

    end;


    function seleccionar_terreno(var lista : t_lista_terrenos; nro_contribuyente : string) : t_terreno;
    var
        lista_propiedades_contribuyente : t_lista_terrenos;
        menu : t_menu;
        terreno_actual : t_terreno;
        opt, i : cardinal;
    begin
        // Inicializa el terreno.
        terreno_default(seleccionar_terreno);
        // Genera una lista con solo los terrenos del propietario.
        lista_propiedades_contribuyente := lista_terrenos_contribuyente(lista, nro_contribuyente);
        
        
        // Genera el menú
        menu := crear_menu('Seleccione un terreno');
        // Crea las opciones.
        primero_lista_terrenos(lista_propiedades_contribuyente);
        while not (fin_lista_terrenos(lista_propiedades_contribuyente)) do
          begin
            recuperar_lista_terrenos(lista_propiedades_contribuyente, terreno_actual);
            agregar_opcion(menu, (terreno_actual.domicilio_parcelario + ' ($' + FloatToStr(terreno_actual.avaluo) + ')'));
            siguiente_lista_terrenos(lista_propiedades_contribuyente);
          end;

        if lista_propiedades_contribuyente.tam <> 0 then
        begin
            repeat
                opt := seleccion_menu(menu);
            until (opt <> 0); // Evitar salir con escape.
            
            // Retorna el terreno seleccionado.
            primero_lista_terrenos(lista_propiedades_contribuyente);
            
            if opt > 1 then
                begin
                    for i := 2 to opt do
                    siguiente_lista_terrenos(lista_propiedades_contribuyente);
                end; 

            recuperar_lista_terrenos(lista_propiedades_contribuyente, seleccionar_terreno);
        end
        else
        begin  
            Writeln('El usuario no es propietario de ningún terreno');
            Writeln('');
            Writeln('Presione una tecla para continuar...');
            readkey;
        end;
    end;

end.