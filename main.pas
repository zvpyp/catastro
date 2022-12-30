program main;

{$codepage utf8}

// Units utilizadas:
uses arbol in 'units/arbol.pas',
     contribuyente in 'units/contribuyente/contribuyente.pas',
     terreno in 'units/terreno/terreno.pas',
     lista_terrenos in 'units/terreno/lista_terrenos.pas',
     u_menu in 'units/u_menu.pas',
     contador_datos in 'units/varios/contador_datos.pas',
     usuario_listados_estadisticas in 'units/usuario/usuario_listados_estadisticas.pas',
     contribuyentes_ABMC in 'units/contribuyente/contribuyentes_ABMC.pas',
     terrenos_ABMC in 'units/terreno/terrenos_ABMC.pas',
     comprobante in 'units/usuario/comprobante.pas',
     crt;

var
    archivo_contribuyentes : t_archivo_contribuyentes;
    archivo_terrenos : t_archivo_terrenos;
    archivo_contador : t_archivo_contador;

    // Crea los árboles necesarios.

    arbol_contribuyentes_dni : t_puntero_arbol;
    arbol_contribuyentes_nombre : t_puntero_arbol;
    

    // Crea las listas necesarias.

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

    // TODO: Generar árboles de contribuyentes
    {arbol_contribuyentes_dni := 
    arbol_contribuyentes_nombre :=}

    // Generar lista de terrenos.
    // TODO: lista ordenada por dueño???
    lista_terrenos_fecha := lista_terrenos_desde_archivo(archivo_terrenos, cantidad_terrenos(archivo_contador));

    { Loop principal}

    repeat
        opcion_principal := menu_principal();

        case opcion_principal of

        // Opción de alta.
        1:  repeat

                opcion_submenu := menu_ABMC('alta');

                case opcion_submenu of
                1:  //Alta de contribuyentes.
                    // TODO: cambiar para que funcione con nueva implementación de árbol. 
                    //alta_contribuyente(archivo_contribuyentes, arbol_contribuyentes_nro, arbol_contribuyentes_nombre, arbol_contribuyentes_dni, archivo_contador);

                2:  //Alta de terrenos.
                    // TODO: cambiar para que funcione solamente con las listas.
                    //alta_terreno(archivo_terrenos, archivo_contador, arbol_terrenos_nro_contribuyente, arbol_terrenos_fecha_inscripcion, arbol_terrenos_nro_plano, lista_terrenos_fecha);
                end;
            
            until ((opcion_submenu = 0) or (opcion_submenu = 3));

        // Opción de baja.
        2:  repeat

                opcion_submenu := menu_ABMC('baja');

                case opcion_submenu of
                1:  //Baja de contribuyentes.
                    // TODO: Idem.
                    //baja_contribuyente(archivo_contribuyentes, arbol_contribuyentes_nro, arbol_contribuyentes_nombre, arbol_contribuyentes_dni);

                2:  //Baja de terrenos.
                    // TODO: Idem.
                    //baja_terreno(archivo_terrenos, archivo_contador, arbol_terrenos_nro_contribuyente, arbol_terrenos_fecha_inscripcion, arbol_terrenos_nro_plano, lista_terrenos_fecha);
                end;
            
            until ((opcion_submenu = 0) or (opcion_submenu = 3));

        // Opción de modificación.
        3:  repeat

                opcion_submenu := menu_ABMC('modificación');

                case opcion_submenu of
                1:  //Modificación de contribuyentes.
                    // TODO: Idem.
                    //mod_contribuyente(archivo_contribuyentes, archivo_contador, arbol_contribuyentes_nro, arbol_contribuyentes_nombre, arbol_contribuyentes_dni);

                2:  //Modificación de terrenos.
                    // TODO: Idem.
                    //mod_terreno(archivo_terrenos, archivo_contador, arbol_terrenos_nro_contribuyente, arbol_terrenos_fecha_inscripcion, arbol_terrenos_nro_plano, lista_terrenos_fecha);
                end;
            
            until ((opcion_submenu = 0) or (opcion_submenu = 3));
        // Opción de consulta.
        4:  repeat

                opcion_submenu := menu_ABMC('consulta');

                case opcion_submenu of
                1:  //Consulta de contribuyentes.
                    // TODO: Idem.
                    //consulta_contribuyente(archivo_contribuyentes, arbol_contribuyentes_nombre, arbol_contribuyentes_dni);

                2:  //Consulta de terrenos.
                    // TODO: Idem.
                    //consulta_terreno(archivo_terrenos, arbol_terrenos_nro_plano);
                end;
            
            until ((opcion_submenu = 0) or (opcion_submenu = 3));
        // Opción de listados.
        5:  repeat
            
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
                    // TODO: verificar si funciona.
                    //cantidad_inscripciones_entre_fechas(lista_terrenos_fecha);

                2:  // Mostrar porcentaje de propietarios con más de una propiedad.
                    // TODO: idem.
                    //porc_propietarios_mult_propiedades(arbol_contribuyentes_nombre, archivo_contador);

                3:  // Mostrar porcentaje de propietarios por tipo de edificación.
                    // TODO: verificar si funciona.
                    //porc_por_tipo_edif(lista_terrenos_fecha, archivo_contador);

                4:  begin
                        // Mostrar cantidad de propietarios dados de baja.
                        // TODO: verificar si funciona.
                        //propietarios_dados_de_baja(archivo_contribuyentes, archivo_contador);
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