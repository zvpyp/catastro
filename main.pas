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
        //usuario_listados_estadisticas in 'units/usuario/usuario_listados_estadisticas.pas',
        //comprobante in 'units/usuario/comprobante.pas',
        crt;
    

    // genera un árbol a partir de un archivo.
    // tipo : 'dni' o 'nombre'.
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
                dato.clave := contribuyente.nombre + ' ' + contribuyente.apellido;
            
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
    
    lista_terrenos_fecha : t_lista_terrenos; // Listas de terrenos.

    //vector_terrenos_por_zona : t_vector_listas; // Se genera cada vez que sea necesario.

    opcion_principal : byte; // utilizado para la interacción con el menú principal.
    opcion_submenu : byte; // utilizado para los submenús del menú principal.
    opcion_consulta : byte; // utilizado para el tipo de búsqueda.
    tipo_busqueda : string; // 'dni' o 'nombre'.

    puntero_aux : t_puntero_arbol; // utilizado para las búsquedas.
    terreno_aux : t_terreno; // utilizado para la búsqueda en alta.

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
    end;

    // Generar lista vacía
    crear_lista_terrenos(lista_terrenos_fecha);

    // Agregar terrenos a partir del archivo
    if cantidad_terrenos(archivo_contador) > 0 then
        generar_lista(lista_terrenos_fecha, archivo_terrenos, cantidad_terrenos(archivo_contador));

    // TEST:
    writeln('al abrir:');
    writeln('cantidad_contribuyentes: ', cantidad_contribuyentes(archivo_contador));
    writeln('cantidad_terrenos: ', cantidad_terrenos(archivo_contador));
    readkey;

    // Generar lista de terrenos.
    // ¿TODO?: lista ordenada por dueño
    //lista_terrenos_fecha := lista_terrenos_desde_archivo(archivo_terrenos, cantidad_terrenos(archivo_contador));

    // Menú principal
    repeat
        opcion_principal := menu_principal();

        case opcion_principal of

        // Opción de alta.
        1:  repeat

                opcion_submenu := menu_ABMC('alta');

                case opcion_submenu of
                1:  // Alta de contribuyentes.
                    begin
                        puntero_aux := buscar_contribuyente(archivo_contribuyentes, arbol_contribuyentes_dni, arbol_contribuyentes_nombre, 'dni'); // verifica si el contribuyente ya existe.
                        alta_contribuyente(archivo_contribuyentes, archivo_contador, arbol_contribuyentes_dni, arbol_contribuyentes_nombre, puntero_aux, 'dni');
                    end;

                2:  // Alta de terrenos.
                    begin
                        terreno_aux := buscar_terreno(lista_terrenos_fecha);
                        alta_terreno(archivo_terrenos, archivo_contribuyentes, archivo_contador, lista_terrenos_fecha, arbol_contribuyentes_dni, arbol_contribuyentes_nombre, terreno_aux);
                    end;
                end;
            
            until ((opcion_submenu = 0) or (opcion_submenu = 3));

        // Opción de baja.
        2:  repeat

                opcion_submenu := menu_ABMC('baja');

                case opcion_submenu of
                1:  //Baja de contribuyentes.
                    begin
                        opcion_consulta := menu_consulta();

                        case opcion_consulta of
                            1:  tipo_busqueda := 'dni';
                            2:  tipo_busqueda := 'nombre';
                        end;

                        puntero_aux := buscar_contribuyente(archivo_contribuyentes, arbol_contribuyentes_dni, arbol_contribuyentes_nombre, tipo_busqueda);
                        baja_contribuyente(archivo_contribuyentes, archivo_terrenos, archivo_contador, lista_terrenos_fecha, puntero_aux);
                    end;

                2:  //Baja de terrenos.
                    baja_terreno(archivo_terrenos, archivo_contador, lista_terrenos_fecha);

                end;
            
            until ((opcion_submenu = 0) or (opcion_submenu = 3));

        // Opción de modificación.
        3:  repeat

                opcion_submenu := menu_ABMC('modificación');

                case opcion_submenu of
                1:  //Modificación de contribuyentes.
                    begin
                        opcion_consulta := menu_consulta();

                        case opcion_consulta of
                            1:  tipo_busqueda := 'dni';
                            2:  tipo_busqueda := 'nombre';
                        end;

                        puntero_aux := buscar_contribuyente(archivo_contribuyentes, arbol_contribuyentes_dni, arbol_contribuyentes_nombre, tipo_busqueda);
                        modificar_contribuyente(archivo_contribuyentes, archivo_contador, arbol_contribuyentes_dni, arbol_contribuyentes_nombre, puntero_aux, tipo_busqueda);
                    end;

                2:  //Modificación de terrenos.
                    modificar_terreno(archivo_terrenos, archivo_contribuyentes, archivo_contador, lista_terrenos_fecha, arbol_contribuyentes_dni, arbol_contribuyentes_nombre);

                end;
            
            until ((opcion_submenu = 0) or (opcion_submenu = 3));
        // Opción de consulta.
        4:  repeat

                opcion_submenu := menu_ABMC('consulta');

                case opcion_submenu of
                1:  //Consulta de contribuyentes.
                    begin
                        opcion_consulta := menu_consulta();

                        case opcion_consulta of
                            1:  tipo_busqueda := 'dni';
                            2:  tipo_busqueda := 'nombre';
                        end;

                        puntero_aux := buscar_contribuyente(archivo_contribuyentes, arbol_contribuyentes_dni, arbol_contribuyentes_nombre, tipo_busqueda);
                        consultar_contribuyente(archivo_contribuyentes, archivo_contador, arbol_contribuyentes_dni, arbol_contribuyentes_nombre, puntero_aux, tipo_busqueda);
                    end;

                2:  //Consulta de terrenos.
                    consultar_terreno(archivo_terrenos, archivo_contribuyentes, archivo_contador, lista_terrenos_fecha, arbol_contribuyentes_dni, arbol_contribuyentes_nombre);

                end;
            
            until ((opcion_submenu = 0) or (opcion_submenu = 3));
        // Opción de listados.
        {5:  repeat
            
                opcion_submenu := menu_listados();

                case opcion_submenu of
                1:  // Lista de contribuyentes con sus propiedades valorizadas.
                    // TODO: Idem.
                    //listado_contribuyentes_propiedades(arbol_contribuyentes_nombre);

                2:  // Lista de inscripciones en un año.
                    // TODO: verificar si funciona.
                    //listado_inscripciones_anio(lista_terrenos_fecha);

                3:  begin
                        // Lista de terrenos por zona.
                        // TODO: verificar si funciona.
                        //vector_terrenos_por_zona := generar_vector_por_zona(lista_terrenos_fecha);
                        //listado_zona_terrenos(vector_terrenos_por_zona);
                    end;

                4:  // Imprimir comprobante.
                    // TODO: verificar si funciona.
                    //consultar_comprobante(lista_terrenos_fecha);
                end;

            until ((opcion_submenu = 0) or (opcion_submenu = 5));
        // Opción de estadísticas.
        6:  repeat

                opcion_submenu := menu_estadisticas();

                case opcion_submenu of
                1:  // Mostrar cantidad de inscripciones entre dos fechas.
                    //cantidad_inscripciones_entre_fechas(lista_terrenos_fecha);

                2:  // Mostrar porcentaje de propietarios con más de una propiedad.
                    //porc_propietarios_mult_propiedades(arbol_contribuyentes_nombre, archivo_contador);

                3:  // Mostrar porcentaje de propietarios por tipo de edificación.
                    //porc_por_tipo_edif(lista_terrenos_fecha, archivo_contador);

                4:  begin
                        // Mostrar cantidad de propietarios dados de baja.
                        //propietarios_dados_de_baja(archivo_contribuyentes, archivo_contador);
                    end;
                end;
            
            until ((opcion_submenu = 0) or (opcion_submenu = 5));}
        end;
        
    until ((opcion_principal = 0) or (opcion_principal = 7)); // 0 es salir por escape, 7 es por selección

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