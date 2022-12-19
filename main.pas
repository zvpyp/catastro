program main;

// Units utilizadas:
uses contribuyente in 'units/contribuyente/contribuyente.pas',
     terreno in 'units/terreno/terreno.pas',
     lista_terrenos in 'units/terreno/lista_terrenos.pas';

var
    archivo_contribuyentes : t_archivo_contribuyentes;
    archivo_terrenos : t_archivo_terrenos;
    archivo_contador : t_archivo_contador;

    arbol_contribuyentes_dni : t_arbol;
    arbol_contribuyentes_nombre : t_arbol;
    
    arbol_terrenos_nro_plano : t_arbol;

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
    lista_terrenos_nro_plano := lista_terrenos_desde_archivo(archivo_terrenos, cantidad_terrenos(archivo_contador));

    // TODO:
    // Añadir los correspondientes terrenos a cada contribuyente del árbol.

    { LINEAS DE TESTEO }

    

    { <<<<<<<<>>>>>>>> }

    // Cerrar los archivos utilizados.
    cerrar_archivo_contribuyentes(archivo_contribuyentes);
    cerrar_archivo_terrenos(archivo_terrenos);
    cerrar_archivo_contador(archivo_contador);
end.