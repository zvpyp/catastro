unit arbol;

{ Unidad de árboles binarios utilizados como índice de datos para archivos. }

{--------------------------------}

interface

    type
    t_puntero_arbol = ^t_arbol; // No utilizar fuera de la unit.

    t_arbol = record
        indice : cardinal;
        si : t_puntero_arbol;
        sd : t_puntero_arbol;
    end;

    // Retorna un arbol binario cuya raiz es el índice dado.
    function crear_arbol(indice : cardinal): t_arbol;

    // Añade un hijo izquierdo a un nodo.
    procedure anidar_hijo_izq(arbol : t_arbol; indice : cardinal);

    // Añade un hijo derecho a un nodo.
    procedure anidar_hijo_der(arbol : t_arbol; indice : cardinal);

    // Retorna verdadero si el nodo raíz posee hijo izquierdo.
    function tiene_hijo_izq(arbol : t_arbol): boolean;

    // Retorna verdadero si el nodo raíz posee hijo derecho.
    function tiene_hijo_der(arbol : t_arbol): boolean;

{--------------------------------}

implementation

    function crear_arbol(indice : cardinal): t_arbol;
    begin
        crear_arbol.indice := indice;
    end;

    procedure anidar_hijo_izq(arbol : t_arbol; indice : cardinal);
    var
    hijo_izq : t_arbol;
    begin
        new(arbol.si);
        hijo_izq := crear_arbol(indice);
        arbol.si^ := hijo_izq;
    end;

    procedure anidar_hijo_der(arbol : t_arbol; indice : cardinal);
    var
    hijo_der : t_arbol;
    begin
        new(arbol.sd);
        hijo_der := crear_arbol(indice);
        arbol.sd^ := hijo_der;
    end;

    function tiene_hijo_izq(arbol : t_arbol): boolean;
    begin
        tiene_hijo_izq := not(arbol.si = nil);
    end;

    function tiene_hijo_der(arbol : t_arbol): boolean;
    begin
        tiene_hijo_der := not(arbol.sd = nil);
    end;

end.