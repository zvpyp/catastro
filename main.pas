program main;

// Units utilizadas:
uses contribuyente in 'units/contribuyente/contribuyente.pas',
     terreno in 'units/terreno/terreno.pas',
     arbol_contribuyentes in 'units/arbol/arbol_contribuyentes.pas',
     arbol_terrenos in 'units/arbol/arbol_terrenos.pas',
     lista_terrenos in 'units/terreno/lista_terrenos.pas';

var
    archivo_contribuyentes : t_archivo_contribuyentes;
    archivo_terrenos : t_archivo_terrenos;
    archivo_contador : t_archivo_contador;

    arbol_contribuyentes_dni : t_arbol;
    arbol_contribuyentes_nombre : t_arbol;
    
    arbol_terrenos_nro_plano : t_arbol;
    lista_terrenos_fecha : t_lista_terrenos;

{ VARIABLES DE TESTEO }


{ <<<<<<<<<->>>>>>>>> }

begin
    // Abrir archivos necesarios
    abrir_archivo_contribuyentes(archivo_contribuyentes);
    abrir_archivo_terrenos(archivo_terrenos);
    abrir_archivo_contador(archivo_contador);

    // Generar árboles de contribuyentes
    arbol_contribuyentes_dni := arbol_ordenado_por_dni(archivo_contribuyentes, cantidad_contribuyentes(archivo_contador));
    arbol_contribuyentes_nombre := arbol_ordenado_por_nombres(archivo_contribuyentes, cantidad_contribuyentes(archivo_contador));

    // Generar el árbol de terrenos y la lista de terrenos
    arbol_terrenos_nro_plano := (archivo_terrenos, cantidad_terrenos(archivo_contador));
    lista_terrenos_fecha := lista_terrenos_desde_archivo(archivo_terrenos, cantidad_terrenos(archivo_contador));

    // Añadir los correspondientes terrenos a cada contribuyente del árbol.
    agregar_listas_por_contribuyente(arbol_contribuyentes_nombre, lista_terrenos_fecha);

    { LINEAS DE TESTEO }

    { <<<<<<<<>>>>>>>> }

    // Cerrar los archivos utilizados.
    cerrar_archivo_contribuyentes(archivo_contribuyentes);
    cerrar_archivo_terrenos(archivo_terrenos);
    cerrar_archivo_contador(archivo_contador);
end.