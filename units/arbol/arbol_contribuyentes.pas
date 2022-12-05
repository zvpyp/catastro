unit arbol_contribuyentes;
{ Unidad de árboles binarios que ordenan contribuyentes. }

{--------------------------------}

interface

    uses arbol in 'units/arbol/arbol';

    // Retorna un árbol binario ordenado por nombre y apellido de cada contribuyente.
    function arbol_ordenado_por_nombres(var archivo : t_archivo_contribuyentes): t_arbol;

    // Retorna un árbol binario ordenado por dni de cada contribuyente.
    function arbol_ordenado_por_dni(var archivo : t_archivo_contribuyentes): t_arbol;

    // Retorna un árbol binario ordenado por dni de cada contribuyente.
    function arbol_ordenado_por_dni(var archivo : t_archivo_contribuyentes): t_arbol;

{--------------------------------}

implementation

    
    function arbol_ordenado_por_nombres(var archivo : t_archivo_contribuyentes): t_arbol;
    begin
        seek(archivo, 1);

        While not(EOF(archivo)) do
        begin
            //TODO:
        end;
    end;

    function arbol_ordenado_por_dni(var archivo : t_archivo_contribuyentes): t_arbol;
    begin
        seek(archivo, 1);

        While not(EOF(archivo)) do
        begin
            //TODO:
        end;
    end;

end.