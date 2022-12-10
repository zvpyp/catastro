unit arbol_contribuyentes;
{ Unidad de árboles binarios que ordenan contribuyentes. }

{--------------------------------}

interface

    uses arbol in 'units/arbol/arbol',
         contribuyente in 'units/contribuyente.pas';

    // Retorna un árbol binario ordenado por nombre y apellido de cada contribuyente.
    function arbol_ordenado_por_nombres(var archivo : t_archivo_contribuyentes
                                            cantidad_contribuyentes : cardinal): t_arbol;

    // Retorna un árbol binario ordenado por dni de cada contribuyente.
    function arbol_ordenado_por_dni(var archivo : t_archivo_contribuyentes
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
        contribuyente_actual : t_contribuyente;
        nombre_completo_nuevo : string;
        nombre_completo_actual : string;
    begin

        nombre_completo_actual := contribuyente_actual.apellido + ' ' + contribuyente_actual.nombre;
        nombre_completo_nuevo := nuevo_contribuyente.apellido + ' ' + nuevo_contribuyente.nombre;

        // lee el contribuyente en la posición que indica el árbol
        seek(archivo, arbol.indice);
        read(archivo, contribuyente_actual);

        // lee el contribuyente a agregar
        seek(archivo, nuevo_contribuyente_indice);
        read(archivo, nuevo_contribuyente);

        // Caso en que el nombre sea mayor:
        if (nombre_completo_actual < nombre_completo_nuevo) then
        begin
            // Verifica si el árbol tiene hijo derecho y repite el proceso recursivamente.
            // Sino, lo agrega como hijo derecho.
            if tiene_hijo_der(arbol) then
                sumar_por_dni(arbol.sd^, archivo, nuevo_contribuyente_indice)
            else
                anidar_hijo_der(arbol, indice);
        end
        // Caso en que sea menor
        else
        begin
            // Verifica si el árbol tiene hijo izquierdo y repite el proceso recursivamente.
            // Sino, lo agrega como hijo izquierdo.
            if tiene_hijo_izq(arbol) then
                sumar_por_dni(arbol.si^, archivo, nuevo_contribuyente_indice)
            else
                anidar_hijo_izq(arbol, indice);
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
        contribuyente_actual : t_contribuyente;
    begin

        // lee el contribuyente en la posición que indica el árbol
        seek(archivo, arbol.indice);
        read(archivo, contribuyente_actual);

        // lee el contribuyente a agregar
        seek(archivo, nuevo_contribuyente_indice);
        read(archivo, nuevo_contribuyente);

        // Caso en que el dni sea mayor:
        if (contribuyente_actual.dni < nuevo_contribuyente.dni) then
        begin
            // Verifica si el árbol tiene hijo derecho y repite el proceso recursivamente.
            // Sino, lo agrega como hijo derecho.
            if tiene_hijo_der(arbol) then
                sumar_por_dni(arbol.sd^, archivo, nuevo_contribuyente_indice)
            else
                anidar_hijo_der(arbol, indice);
        end
        // Caso en que sea menor
        else
        begin
            // Verifica si el árbol tiene hijo izquierdo y repite el proceso recursivamente.
            // Sino, lo agrega como hijo izquierdo.
            if tiene_hijo_izq(arbol) then
                sumar_por_dni(arbol.si^, archivo, nuevo_contribuyente_indice)
            else
                anidar_hijo_izq(arbol, indice);
        end;
    end;

    
    function arbol_ordenado_por_nombres(var archivo : t_archivo_contribuyentes
                                            cantidad_contribuyentes : cardinal): t_arbol;
    var
        indice_actual : cardinal;
    begin
        // Creamos el árbol con el primer índice.
        seek(archivo, 1);
        read(archivo, indice_actual);
        arbol_ordenado_por_nombres := crear_arbol(indice_actual);

        for indice_actual := 2 to cantidad_contribuyentes do
        begin
            sumar_por_nombre(arbol_ordenado_por_nombres, archivo, indice_actual);
        end;
    end;

    function arbol_ordenado_por_dni(var archivo : t_archivo_contribuyentes
                                        cantidad_contribuyentes : cardinal): t_arbol;
    var
        indice_actual : cardinal;
    begin
        // Creamos el árbol con el primer índice.
        seek(archivo, 1);
        read(archivo, indice_actual);
        arbol_ordenado_por_dni := crear_arbol(indice_actual);

        for indice_actual := 2 to cantidad_contribuyentes do
        begin
            sumar_por_dni(arbol_ordenado_por_dni, archivo, indice_actual);
        end;
    end;

end.