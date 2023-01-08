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

    // Toma un terreno buscado. Si el terreno ya existe, muestra los datos.
    // Si no existe, pide datos al usuario y lo crea.
    procedure alta_terreno(var archivo_terrenos : t_archivo_terrenos;
                            var archivo_contribuyentes : t_archivo_contribuyentes;
                            var archivo_contador : t_archivo_contador;
                            var lista : t_lista_terrenos;
                            var arbol_contribuyentes_dni : t_puntero_arbol;
                            var arbol_contribuyentes_nombre : t_puntero_arbol;
                            terreno : t_terreno);
    
    // Elimina un terreno de una lista y un archivo. Lo descuenta del archivo contador.
    procedure borrar_terreno(var archivo : t_archivo_terrenos;
                                var archivo_contador : t_archivo_contador;
                                var lista : t_lista_terrenos;
                                terreno : t_terreno);

    // Pide al usuario un terreno. Si existe, lo borra.
    procedure baja_terreno(var archivo : t_archivo_terrenos;
                            var archivo_contador : t_archivo_contador;
                            var lista : t_lista_terrenos);
    
    // Pide al usuario un terreno. Si existe, pide datos para modificarlo.
    // Si no existe, pregunta para darlo de alta.
    procedure modificar_terreno(var archivo_terrenos : t_archivo_terrenos;
                                var archivo_contribuyentes : t_archivo_contribuyentes;
                                var archivo_contador : t_archivo_contador;
                                var lista : t_lista_terrenos;
                                var arbol_contribuyentes_dni : t_puntero_arbol;
                                var arbol_contribuyentes_nombre : t_puntero_arbol);
    
    // Pide al usuario un terreno. Si existe, lo muestra en pantalla.
    // Si no existe, pregunta para darlo de alta.
    procedure consultar_terreno(var archivo_terrenos : t_archivo_terrenos;
                                var archivo_contribuyentes : t_archivo_contribuyentes;
                                var archivo_contador : t_archivo_contador;
                                var lista : t_lista_terrenos;
                                var arbol_contribuyentes_dni : t_puntero_arbol;
                                var arbol_contribuyentes_nombre : t_puntero_arbol);

{--------------------------------}

implementation

    uses
    usuario_contribuyentes in 'units/contribuyente/usuario_contribuyentes.pas';

    // TODO: estilizar.
    procedure mostrar_terreno(terreno : t_terreno);
    begin
        writeln('Domicilio parcelario: ', terreno.domicilio_parcelario);
        writeln('Número de plano: ', terreno.nro_plano);
        writeln('Número de contribuyente: ', terreno.nro_contribuyente);
        writeln('Avalúo: ', terreno.avaluo);
        writeln('Fecha de inscripción: ', terreno.fecha_inscripcion);
        writeln('Superficie: ', terreno.superficie);
        writeln('Zona: ', terreno.zona);
        writeln('Tipo de edificación: ', terreno.tipo_edificacion);

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

        leer_numero_contribuyente := propietario.numero;
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
                            var archivo_contribuyentes : t_archivo_contribuyentes;
                            var archivo_contador : t_archivo_contador;
                            var lista : t_lista_terrenos;
                            var arbol_contribuyentes_dni : t_puntero_arbol;
                            var arbol_contribuyentes_nombre : t_puntero_arbol;
                            terreno : t_terreno);
    begin
        // Si el terreno no existe (indice 0), lo crea.
        if terreno.indice = 0 then
        begin

            // Pedir datos al usuario. Nota: el domicilio parcelario se establece en la búsqueda.
            
            terreno.nro_contribuyente := leer_numero_contribuyente(archivo_contribuyentes, archivo_contador, arbol_contribuyentes_dni, arbol_contribuyentes_nombre);
            terreno.nro_plano := leer_numero_plano(lista);
            terreno.avaluo := StrToFloat(leer_entrada('Ingrese el avalúo', 255, 'real'));
            terreno.fecha_inscripcion := leer_fecha('Ingrese la fecha de inscripción');
            terreno.superficie := strToFloat(leer_entrada('Ingrese la superficie en km cuadrados', 255, 'real'));
            terreno.zona := menu_seleccion_zona();
            terreno.tipo_edificacion := menu_seleccion_tipo_edificacion();

            terreno.indice := cantidad_terrenos(archivo_contador) + 1;

            crear_terreno(archivo_terrenos, archivo_contador, lista, terreno);

            clrscr;
            writeln('Terreno creado satisfactoriamente :)');
            readkey;
        end
        // Terreno ya existente
        else
        begin
            writeln('Terreno ya existente: ');
            writeln('');
            mostrar_terreno(terreno);
        end;
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

        writeln('Terreno eliminado del archivo'); readkey; // TEST

        // Borrar de la lista.
        desenlistar_terreno(lista, terreno.nro_plano);

        writeln('Terreno desenlistado'); readkey; // TEST

        // Actualizar el índice del último terreno en la lista.
        if not(lista_vacia_terrenos(lista)) then
        begin
            desenlistar_terreno(lista, ultimo_terreno.nro_plano);
            enlistar_terreno(lista, ultimo_terreno);

            writeln('Ultimo terreno actualizado en lista'); readkey; // TEST
        end;

        // Descontar un terreno
        restar_terreno(archivo_contador, terreno.tipo_edificacion);

    end;


    procedure baja_terreno(var archivo : t_archivo_terrenos;
                            var archivo_contador : t_archivo_contador;
                            var lista : t_lista_terrenos);
    var
        terreno : t_terreno;
    begin
        terreno := buscar_terreno(lista);
        clrscr;

        if terreno.indice <> 0 then
        begin
            // Mostrar el terreno a eliminar
            writeln('Terreno a eliminar: ');
            writeln('');
            mostrar_terreno(terreno);

            if (leer_si_no('¿Quiere eliminar el terreno?') = 's') then
                borrar_terreno(archivo, archivo_contador, lista, terreno);
        end
        else
        begin
            writeln('No se ha encontrado el terreno que quiere eliminar :(');
            writeln('Presione una tecla para continuar...');
            readkey;
        end;
    end;


    procedure modificar_terreno(var archivo_terrenos : t_archivo_terrenos;
                                var archivo_contribuyentes : t_archivo_contribuyentes;
                                var archivo_contador : t_archivo_contador;
                                var lista : t_lista_terrenos;
                                var arbol_contribuyentes_dni : t_puntero_arbol;
                                var arbol_contribuyentes_nombre : t_puntero_arbol);
    var
        terreno : t_terreno;
        nuevo_terreno : t_terreno;
        opt : byte;
    begin
        terreno := buscar_terreno(lista);
        nuevo_terreno := terreno;
        clrscr;

        if terreno.indice <> 0 then
        begin
            // Menú de modificación
            // TODO: cambiar número de contribuyente buscando contribuyente por nombre o dni.
            repeat
                opt := menu_modificar_terreno();

                case opt of
                1:  nuevo_terreno.nro_contribuyente := leer_entrada('Número de contribuyente', 15, 'natural');
                2:  nuevo_terreno.nro_plano := leer_numero_plano(lista);
                3:  nuevo_terreno.superficie := strToFloat(leer_entrada('Superficie', 255, 'real'));
                4:  nuevo_terreno.zona := menu_seleccion_zona();
                5:  nuevo_terreno.tipo_edificacion := menu_seleccion_tipo_edificacion();
                end;
            until ((opt = 0) or (opt = 6));

            writeln('Datos actualizados:');
            writeln('');
            mostrar_terreno(nuevo_terreno);


            
            if (leer_si_no('¿Desea guardar los cambios?') = 's') then
            begin
                // Borrar datos viejos.
                borrar_terreno(archivo_terrenos, archivo_contador, lista, terreno);

                // Agregar datos nuevos.
                crear_terreno(archivo_terrenos, archivo_contador, lista, terreno);

                clrscr;
                writeln('Terreno actualizado satisfactoriamente :)');
                writeln('Presione una tecla para continuar...');
                readkey;
            end;

            
        end
        else
        begin
            if (leer_si_no('Terreno inexistente. ¿Desea crearlo?') = 's') then
                alta_terreno(archivo_terrenos, archivo_contribuyentes, archivo_contador, lista, arbol_contribuyentes_dni, arbol_contribuyentes_nombre, terreno);
        end;
    end;


    procedure consultar_terreno(var archivo_terrenos : t_archivo_terrenos;
                                var archivo_contribuyentes : t_archivo_contribuyentes;
                                var archivo_contador : t_archivo_contador;
                                var lista : t_lista_terrenos;
                                var arbol_contribuyentes_dni : t_puntero_arbol;
                                var arbol_contribuyentes_nombre : t_puntero_arbol);
    var
        terreno : t_terreno;
    begin
        terreno := buscar_terreno(lista);
        clrscr;

        if terreno.indice <> 0 then
            mostrar_terreno(terreno)
        else
        begin
            if (leer_si_no('Terreno inexistente. ¿Desea crearlo?') = 's') then
                alta_terreno(archivo_terrenos, archivo_contribuyentes, archivo_contador, lista, arbol_contribuyentes_dni, arbol_contribuyentes_nombre, terreno);
        end;
    end;

end.