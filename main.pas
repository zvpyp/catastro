// Falta cambiar toda la estructura con el nuevo menú.

program main;

{$codepage utf8}

// Units utilizadas:
    uses arbol in 'units/arbol.pas',
        contribuyente in 'units/contribuyente/contribuyente.pas',
        terreno in 'units/terreno/terreno.pas',
        u_menu in 'units/u_menu.pas',
        contador_datos in 'units/varios/contador_datos.pas',
        validacion_entradas in 'units/varios/validacion_entradas.pas',
        usuario_contribuyentes in 'units/contribuyente/usuario_contribuyentes.pas',
        usuario_terrenos in 'units/terreno/usuario_terrenos.pas',
        compara_fechas in 'units/varios/compara_fechas.pas',
        lista_terrenos in 'units/terreno/lista_terrenos.pas',
        listados in 'units/usuario/listados.pas',
        estadisticas in 'units/usuario/estadisticas.pas',
        comprobante in 'units/usuario/comprobante.pas',
        crt;
    

    // genera un árbol a partir de un archivo.
    // tipo : 'dni', 'nombre' o 'numero'. 
    procedure generar_arbol(var raiz : t_puntero_arbol; var archivo : t_archivo_contribuyentes; cantidad : cardinal; tipo : string);
    var
        i : cardinal;
        contribuyente : t_contribuyente;
        dato : t_dato_arbol;
    begin
        for i := 1 to cantidad do
        begin
            contribuyente := leer_contribuyente(archivo, i);

            if tipo = 'dni' then
                dato.clave := contribuyente.dni
            else if tipo = 'nombre' then
                dato.clave := contribuyente.apellido + ' ' + contribuyente.nombre
            else if tipo = 'numero' then
                dato.clave := contribuyente.numero;
            
            dato.indice := i;

            agregar_hijo(raiz, dato);
        end;
    end;


    // Genera la lista de terrenos a partir de un archivo.
    procedure generar_lista(var lista : t_lista_terrenos; var archivo : t_archivo_terrenos; cantidad : cardinal);
    var
        i : cardinal;
        terreno : t_terreno;
    begin
        for i := 1 to cantidad do
        begin
            terreno := leer_terreno(archivo, i);

            enlistar_terreno(lista, terreno);
        end;
    end;


var
    archivo_contribuyentes : t_archivo_contribuyentes;
    archivo_terrenos : t_archivo_terrenos;
    archivo_contador : t_archivo_contador;

    // Árboles necesarios.
    arbol_contribuyentes_dni : t_puntero_arbol;
    arbol_contribuyentes_nombre : t_puntero_arbol;
    arbol_contribuyentes_nro : t_puntero_arbol;
    
    lista_terrenos_fecha : t_lista_terrenos; // Listas de terrenos.

    vector_terrenos_por_zona : t_vector_listas; // Se genera cada vez que sea necesario.

    opcion_principal : byte; // utilizado para la interacción con el menú principal.
    opcion_submenu : byte; // utilizado para los submenús del menú principal.
    opcion_consulta : byte; // utilizado para el tipo de búsqueda.
    tipo_busqueda : string; // 'dni' o 'nombre'.

    puntero_aux : t_puntero_arbol; // para algo se usa.
    terreno_aux : t_terreno; // utilizado para la selección.
    contribuyente_aux : t_contribuyente; // utilizado para la consulta por dni y nombre.
    dato_aux : t_dato_arbol; // utilizado para la busqueda de contribuyente.
    indice_aux : cardinal;

    nro_contribuyente : string;

begin
    clrscr;
    // Abrir archivos necesarios
    abrir_archivo_contribuyentes(archivo_contribuyentes);
    abrir_archivo_terrenos(archivo_terrenos);
    abrir_archivo_contador(archivo_contador);

    // Generar árboles vacíos
    crear_arbol(arbol_contribuyentes_dni);
    crear_arbol(arbol_contribuyentes_nombre);

    // Agregar contribuyentes a partir del archivo
    if cantidad_contribuyentes(archivo_contador) > 0 then
    begin
        generar_arbol(arbol_contribuyentes_dni, archivo_contribuyentes, cantidad_contribuyentes(archivo_contador), 'dni');
        generar_arbol(arbol_contribuyentes_nombre, archivo_contribuyentes, cantidad_contribuyentes(archivo_contador), 'nombre');
        generar_arbol(arbol_contribuyentes_nro, archivo_contribuyentes, cantidad_contribuyentes(archivo_contador), 'numero');
    end;

    // Generar lista vacía
    crear_lista_terrenos(lista_terrenos_fecha);

    // Agregar terrenos a partir del archivo
    if cantidad_terrenos(archivo_contador) > 0 then
        generar_lista(lista_terrenos_fecha, archivo_terrenos, cantidad_terrenos(archivo_contador));

    // TEST:
    {writeln('al abrir:');
    writeln('cantidad_contribuyentes: ', cantidad_contribuyentes(archivo_contador));
    writeln('cantidad_terrenos: ', cantidad_terrenos(archivo_contador));
    readkey;}

    // Generar lista de terrenos.
    // ¿TODO?: lista ordenada por dueño
    //lista_terrenos_fecha := lista_terrenos_desde_archivo(archivo_terrenos, cantidad_terrenos(archivo_contador));

    // Menú principal
    repeat
        opcion_principal := menu_principal();

        case opcion_principal of

        // Opción de ingresar número de contribuyente.
        1:
        begin
            nro_contribuyente := leer_entrada('Número de contribuyente: ', 15, 'natural');
            dato_aux := info_raiz(preorden(arbol_contribuyentes_nro, nro_contribuyente));
            indice_aux := dato_aux.indice; 
            if indice_aux <> 0 then
              begin
              contribuyente_aux := leer_contribuyente(archivo_contribuyentes, dato_aux.indice);
              if  not (contribuyente_aux.activo) then 
              begin
                if leer_si_no('Contribuyente inactivo. ¿Desea activarlo?') = 's' then activar_contribuyente(archivo_contribuyentes, contribuyente_aux, indice_aux);
              end;
              if contribuyente_aux.activo then
                begin
                    Writeln('Este número de contribuyente pertenece a ' + contribuyente_aux.nombre + ' ' + contribuyente_aux.apellido + '.');
                    pedir_tecla();
                    mostrar_contribuyente(contribuyente_aux);
                        repeat

                            opcion_submenu := menu_encontrado();

                            case opcion_submenu of
                            
                            // Opción de modificación.
                            1: modificar_contribuyente(archivo_contribuyentes, arbol_contribuyentes_nro, nro_contribuyente);

                            // Opción de baja.
                            2: 
                            begin
                            
                            Writeln('Al dar de baja a un contribuyente, también se eliminaran todas sus propiedades.');
                            readkey;
                            if leer_si_no('¿Quiere continuar?') = 's' then
                            baja_contribuyente(archivo_contribuyentes, archivo_terrenos, archivo_contador, lista_terrenos_fecha, arbol_contribuyentes_nro, nro_contribuyente);

                            end;

                            // Opción de ver terrenos.
                            3:
                            begin
                                terreno_aux := seleccionar_terreno(lista_terrenos_fecha, nro_contribuyente);
                                if terreno_aux.indice <> 0 then
                                    mostrar_terreno(terreno_aux);
                            end;

                            // Opción de agregar terreno.
                            4: alta_terreno(archivo_terrenos, archivo_contador, lista_terrenos_fecha, nro_contribuyente);

                            // Opción de modificar terreno.
                            5:
                            begin
                                terreno_aux := seleccionar_terreno(lista_terrenos_fecha, nro_contribuyente);
                                if terreno_aux.indice <> 0 then
                                    modificar_terreno(archivo_terrenos, archivo_contador, lista_terrenos_fecha, terreno_aux);
                            end;

                            // Opción de eliminar terreno.
                            6:
                            begin
                                terreno_aux := seleccionar_terreno(lista_terrenos_fecha, nro_contribuyente);
                                if terreno_aux.indice <> 0 then
                                baja_terreno(archivo_terrenos, archivo_contador, lista_terrenos_fecha, terreno_aux);
                            end;

                            end;
                        until ((opcion_submenu = 0) or (opcion_submenu = 7)); // 0 es salir por escape, 7 es por selección
                end;
              end
              else 
                begin
                    Writeln('El número de contribuyente no se encuentra en la base de datos');
                    readkey;
                    if leer_si_no('¿Desea crear el contribuyente?') = 's' then
                      alta_contribuyente(archivo_contribuyentes, archivo_contador, arbol_contribuyentes_dni, arbol_contribuyentes_nombre, arbol_contribuyentes_nro, nro_contribuyente);
                end;
        end;

        // Opción de consulta.
        2:  repeat

                opcion_submenu := menu_consulta();

                case opcion_submenu of
                1:  //Consulta de contribuyentes.
                    begin
                        opcion_consulta := menu_consulta_contribuyente();

                        case opcion_consulta of
                            1:  tipo_busqueda := 'dni';
                            2:  tipo_busqueda := 'nombre';
                        end;

                        // ignorar casos en que se seleccione volver o se presione escape.
                        if (opcion_consulta <> 3) and (opcion_consulta <> 0) then
                        begin
                            puntero_aux := buscar_contribuyente(archivo_contribuyentes, arbol_contribuyentes_dni, arbol_contribuyentes_nombre, tipo_busqueda);
                            if info_raiz(puntero_aux).indice <> 0 then
                                begin
                                contribuyente_aux := leer_contribuyente(archivo_contribuyentes, info_raiz(puntero_aux).indice);
                                mostrar_contribuyente(contribuyente_aux);
                                end
                            else 
                                begin
                                    Writeln('El usuario no existe, presione una tecla para continuar');
                                    readkey;
                                end;
                        end;
                    end;

                2:  //Consulta de terrenos.
                    begin
                        terreno_aux := buscar_terreno(lista_terrenos_fecha);
                        mostrar_terreno(terreno_aux);
                    end;
                end;
            
            until ((opcion_submenu = 0) or (opcion_submenu = 3));

        // Opción de listados.
        3:  repeat
            
                opcion_submenu := menu_listados();

                case opcion_submenu of
                1:  // Lista de contribuyentes con sus propiedades valorizadas.
                    // TODO: Idem.
                    begin
                        writeln('| Propietario | Domicilio parcelario | Valor de la propiedad |');
                        listado_contribuyentes_propiedades(arbol_contribuyentes_nombre, lista_terrenos_fecha, archivo_contribuyentes);
                        pedir_tecla();
                    end;
                2:  // Lista de inscripciones en un año.
                    // TODO: verificar si funciona.
                    inscripciones_anio(lista_terrenos_fecha, leer_entrada('Año: ', 4, 'normal'));
                3:  begin
                        // Lista de terrenos por zona.
                        // TODO: verificar si funciona.
                        terrenos_por_zona(lista_terrenos_fecha);
                    end;

                4:  // Imprimir comprobante.
                    // TODO: verificar si funciona.
                    consultar_comprobante(lista_terrenos_fecha);
                end;

            until ((opcion_submenu = 0) or (opcion_submenu = 5));

        // Opción de estadísticas.
        4:  repeat

                opcion_submenu := menu_estadisticas();

                case opcion_submenu of
                1:  // Mostrar cantidad de inscripciones entre dos fechas.
                    inscripciones_entre_fechas(lista_terrenos_fecha);

                2:  // Mostrar porcentaje de propietarios con más de una propiedad.
                    porcentaje_propietarios_multiples(arbol_contribuyentes_nro,lista_terrenos_fecha, archivo_contador);

                3:  // Mostrar porcentaje de propietarios por tipo de edificación.
                    porcentaje_terrenos_tipo(archivo_contador);

                4:
                    // Mostrar cantidad de propietarios dados de baja.
                    propietarios_inactivos(archivo_contador);
                   
                end;
            
            until ((opcion_submenu = 0) or (opcion_submenu = 5));
        end;
        
    until ((opcion_principal = 0) or (opcion_principal = 5)); // 0 es salir por escape, 5 es por selección

    clrscr;

    {// TEST:
    writeln('al cerrar:');
    writeln('cantidad_contribuyentes: ', cantidad_contribuyentes(archivo_contador));
    writeln('cantidad_terrenos: ', cantidad_terrenos(archivo_contador));
    readkey;}

    // Cerrar los archivos utilizados.
    cerrar_archivo_contribuyentes(archivo_contribuyentes);
    cerrar_archivo_terrenos(archivo_terrenos);
    cerrar_archivo_contador(archivo_contador);
end.
