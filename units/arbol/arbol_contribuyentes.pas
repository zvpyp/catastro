unit arbol_contribuyentes;
{ Unidad de árboles binarios que ordenan contribuyentes. }

{--------------------------------}

interface

    uses contribuyente in './units/contribuyente.pas',
         arbol in 'units/arbol/arbol',
         terreno in 'units/terreno/terreno.pas';

    // Retorna un árbol binario ordenado por nombre y apellido de cada contribuyente.
    function arbol_ordenado_por_nombres(var archivo : t_archivo_contribuyentes;
                                            cantidad_contribuyentes : cardinal): t_arbol;

    // Retorna un árbol binario ordenado por dni de cada contribuyente.
    function arbol_ordenado_por_dni(var archivo : t_archivo_contribuyentes;
                                        cantidad_contribuyentes : cardinal): t_arbol;

{--------------------------------}

implementation

    // Agrega un nodo a un arbol ordenado por nombres.
    // Su raíz será la posición en el archivo dado.
    // El valor se determina según el nombre del contribuyente dado.
    procedure sumar_por_nombre(var arbol: t_arbol;
                               var archivo : t_archivo_contribuyentes;
                                   nuevo_contribuyente_indice : cardinal);
    var
        nuevo_contribuyente : t_contribuyente;
        nombre_completo_nuevo : string;
        nombre_completo_actual : string;
    begin

        // lee el contribuyente a agregar
        seek(archivo, nuevo_contribuyente_indice);
        read(archivo, nuevo_contribuyente);

        nombre_completo_actual := arbol.clave;
        nombre_completo_nuevo := nuevo_contribuyente.apellido + ' ' + nuevo_contribuyente.nombre;

        // Caso en que el nombre sea mayor:
        if (nombre_completo_actual < nombre_completo_nuevo) then
        begin
            // Verifica si el árbol tiene hijo derecho y repite el proceso recursivamente.
            // Sino, lo agrega como hijo derecho.
            if tiene_hijo_der(arbol) then
                sumar_por_nombre(arbol.sd^, archivo, nuevo_contribuyente_indice)
            else
                anidar_hijo_der(arbol, nuevo_contribuyente_indice, nombre_completo_nuevo, nuevo_contribuyente.activo);
        end
        // Caso en que sea menor
        else
        begin
            // Verifica si el árbol tiene hijo izquierdo y repite el proceso recursivamente.
            // Sino, lo agrega como hijo izquierdo.
            if tiene_hijo_izq(arbol) then
                sumar_por_nombre(arbol.si^, archivo, nuevo_contribuyente_indice)
            else
                anidar_hijo_izq(arbol, nuevo_contribuyente_indice, nombre_completo_nuevo, nuevo_contribuyente.activo);
        end;
    end;

    // Agrega un nodo a un arbol ordenado por DNI.
    // Su raíz será la posición en el archivo dado.
    // El valor se determina según el dni del contribuyente dado.
    procedure sumar_por_dni(var arbol: t_arbol;
                            var archivo : t_archivo_contribuyentes;
                                nuevo_contribuyente_indice : cardinal);
    var
        nuevo_contribuyente : t_contribuyente;
        dni_actual : string;
    begin
        dni_actual := arbol.clave;

        // lee el contribuyente a agregar
        seek(archivo, nuevo_contribuyente_indice);
        read(archivo, nuevo_contribuyente);

        // Caso en que el dni sea mayor:
        if (dni_actual < nuevo_contribuyente.dni) then
        begin
            // Verifica si el árbol tiene hijo derecho y repite el proceso recursivamente.
            // Sino, lo agrega como hijo derecho.
            if tiene_hijo_der(arbol) then
                sumar_por_dni(arbol.sd^, archivo, nuevo_contribuyente_indice)
            else
                anidar_hijo_der(arbol, nuevo_contribuyente_indice, nuevo_contribuyente.dni, nuevo_contribuyente.activo);
        end
        // Caso en que sea menor
        else
        begin
            // Verifica si el árbol tiene hijo izquierdo y repite el proceso recursivamente.
            // Sino, lo agrega como hijo izquierdo.
            if tiene_hijo_izq(arbol) then
                sumar_por_dni(arbol.si^, archivo, nuevo_contribuyente_indice)
            else
                anidar_hijo_izq(arbol, nuevo_contribuyente_indice, nuevo_contribuyente.dni, nuevo_contribuyente.activo);
        end;
    end;

    
    function arbol_ordenado_por_nombres(var archivo : t_archivo_contribuyentes;
                                            cantidad_contribuyentes : cardinal): t_arbol;
    var
        indice_actual : cardinal;
        primer_contribuyente : t_contribuyente;
        nombre_apellido_primero : string;
    begin
        // Creamos el árbol con el primer índice.
        indice_actual := 1;
        seek(archivo, indice_actual);
        read(archivo, primer_contribuyente);
        nombre_apellido_primero := primer_contribuyente.apellido + ' ' + primer_contribuyente.nombre;

        arbol_ordenado_por_nombres := crear_arbol(indice_actual, nombre_apellido_primero, primer_contribuyente.activo);

        for indice_actual := 2 to cantidad_contribuyentes do
        begin
            sumar_por_nombre(arbol_ordenado_por_nombres, archivo, indice_actual);
        end;
    end;

    function arbol_ordenado_por_dni(var archivo : t_archivo_contribuyentes;
                                        cantidad_contribuyentes : cardinal): t_arbol;
    var
        indice_actual : cardinal;
        primer_contribuyente : t_contribuyente;
    begin
        // Creamos el árbol con el primer índice.
        indice_actual := 1;
        seek(archivo, indice_actual);
        read(archivo, primer_contribuyente);
        arbol_ordenado_por_dni := crear_arbol(indice_actual, primer_contribuyente.dni, primer_contribuyente.activo);

        for indice_actual := 2 to cantidad_contribuyentes do
        begin
            sumar_por_dni(arbol_ordenado_por_dni, archivo, indice_actual);
        end;
    end;

    //TODO:
    //procedure agregar_listas_por_contribuyente(var arbol : t_arbol;
    //                                           archivo_terrenos : t_archivo_terrenos; 
    //                                           cantidad_terrenos : cardinal);
    // pasa por todos los terrenos y los agrega según el contribuyente.

end.