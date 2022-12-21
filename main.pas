program main;

{$codepage utf8}

// Units utilizadas:
uses arbol in 'units/arbol/arbol.pas',
     contribuyente in 'units/contribuyente/contribuyente.pas',
     terreno in 'units/terreno/terreno.pas',
     arbol_contribuyentes in 'units/arbol/arbol_contribuyentes.pas',
     arbol_terrenos in 'units/arbol/arbol_terrenos.pas',
     lista_terrenos in 'units/terreno/lista_terrenos.pas',
     u_menu in 'units/u_menu.pas',
     contador_datos in 'units/varios/contador_datos.pas',
     usuario_listados_estadisticas in 'units/usuario/usuario_listados_estadisticas.pas'
     crt;

var
    archivo_contribuyentes : t_archivo_contribuyentes;
    archivo_terrenos : t_archivo_terrenos;
    archivo_contador : t_archivo_contador;

    arbol_contribuyentes_dni : t_arbol;
    arbol_contribuyentes_nombre : t_arbol;
    
    arbol_terrenos_nro_plano : t_arbol;
    lista_terrenos_fecha : t_lista_terrenos;

    vector_terrenos_por_zona : t_vector_listas; // Se genera cada vez que sea necesario.

    opcion_principal : byte; // utilizado para la interacción con el menú principal.
    opcion_submenu : byte; // utilizado para los submenús del menú principal.

{ VARIABLES DE TESTEO }


{ <<<<<<<<<->>>>>>>>> }

begin
    clrscr;
    // Abrir archivos necesarios
    abrir_archivo_contribuyentes(archivo_contribuyentes);
    abrir_archivo_terrenos(archivo_terrenos);
    abrir_archivo_contador(archivo_contador);

    // Generar árboles de contribuyentes
    arbol_contribuyentes_dni := arbol_ordenado_por_dni(archivo_contribuyentes, cantidad_contribuyentes(archivo_contador));
    arbol_contribuyentes_nombre := arbol_ordenado_por_nombres(archivo_contribuyentes, cantidad_contribuyentes(archivo_contador));

    // Generar el árbol de terrenos y la lista de terrenos
    arbol_terrenos_nro_plano := arbol_ordenado_por_nro_plano(archivo_terrenos, cantidad_terrenos(archivo_contador));
    lista_terrenos_fecha := lista_terrenos_desde_archivo(archivo_terrenos, cantidad_terrenos(archivo_contador));

    // Añadir los correspondientes terrenos a cada contribuyente del árbol.
    if cantidad_contribuyentes(archivo_contador) > 0 then
        agregar_listas_por_contribuyente(arbol_contribuyentes_nombre, lista_terrenos_fecha);


    { Loop principal}

    repeat
        opcion_principal := menu_principal();

        case opcion_principal of

        // Opción de alta.
        1:  repeat

                opcion_submenu := menu_ABMC('alta');

                case opcion_submenu of
                1:  begin
                        //TODO: Alta de contribuyentes.
                    end;
                2:  begin
                        //TODO: Alta de terrenos.
                    end;
                end;
            
            until ((opcion_submenu = 0) or (opcion_submenu = 3));
        // Opción de baja.
        2:  repeat

                opcion_submenu := menu_ABMC('baja');

                case opcion_submenu of
                1:  begin
                        //TODO: Baja de contribuyentes.
                    end;
                2:  begin
                        //TODO: Baja de terrenos.
                    end;
                end;
            
            until ((opcion_submenu = 0) or (opcion_submenu = 3));
        // Opción de modificación.
        3:  repeat

                opcion_submenu := menu_ABMC('modificación');

                case opcion_submenu of
                1:  begin
                        //TODO: Modificación de contribuyentes.
                    end;
                2:  begin
                        //TODO: Modificación de terrenos.
                    end;
                end;
            
            until ((opcion_submenu = 0) or (opcion_submenu = 3));
        // Opción de consulta.
        4:  repeat

                opcion_submenu := menu_ABMC('consulta');

                case opcion_submenu of
                1:  begin
                        //TODO: Consulta de contribuyentes.
                    end;
                2:  begin
                        //TODO: Consulta de terrenos.
                    end;
                end;
            
            until ((opcion_submenu = 0) or (opcion_submenu = 3));
        // Opción de listados.
        5:  repeat
            
                opcion_submenu := menu_listados();

                case opcion_submenu of
                1:  // Lista de contribuyentes con sus propiedades valorizadas.
                    listado_contribuyentes_propiedades(arbol_contribuyentes_nombre);

                2:  // Lista de inscripciones en un año.
                    listado_inscripciones_anio(lista_terrenos_fecha);

                3:  begin
                        // Lista de terrenos por zona.
                        vector_terrenos_por_zona := generar_vector_por_zona(lista_terrenos_fecha);
                        listado_zona_terrenos(vector_terrenos_por_zona);
                    end;
                4:  begin
                        //TODO: Imprimir comprobante.
                    end;
                end;

            until ((opcion_submenu = 0) or (opcion_submenu = 5));
        // Opción de estadísticas.
        6:  repeat

                opcion_submenu := menu_estadisticas();

                case opcion_submenu of
                1:  begin
                        //TODO: Mostrar cantidad de inscripciones entre dos fechas.
                    end;
                2:  begin
                        //TODO: Mostrar porcentaje de propietarios con más de una propiedad.
                    end;
                3:  begin
                        //TODO: Mostrar porcentaje de propietarios por tipo de edificación.
                    end;
                4:  begin
                        //TODO: Mostrar cantidad de propietarios dados de baja.
                    end;
                end;
            
            until ((opcion_submenu = 0) or (opcion_submenu = 5));
        end;
        
    until ((opcion_principal = 0) or (opcion_principal = 7)); // 0 es salir por escape, 7 es por selección

    clrscr;

    // Cerrar los archivos utilizados.
    cerrar_archivo_contribuyentes(archivo_contribuyentes);
    cerrar_archivo_terrenos(archivo_terrenos);
    cerrar_archivo_contador(archivo_contador);
end.