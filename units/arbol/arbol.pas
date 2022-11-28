unit arbol;

{ Librería de árboles binarios utilizados como índice de datos para archivos. }

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

    // Procedimientos que añaden subárboles hijos a árboles.
    procedure anidar_hijo_izq(arbol : t_arbol; indice : cardinal);
    procedure anidar_hijo_der(arbol : t_arbol; indice : cardinal);


{--------------------------------}
implementation

    function crear_arbol(indice : cardinal): t_arbol;
    begin
        new(crear_arbol.si);
        new(crear_arbol.sd);
        crear_arbol.indice := indice;
    end;

    procedure anidar_hijo_izq(arbol : t_arbol; indice : cardinal);
    var
    hijo_izq : t_arbol;
    begin
        hijo_izq := crear_arbol(indice);
        arbol.si^ := hijo_izq;
    end;

    procedure anidar_hijo_der(arbol : t_arbol; indice : cardinal);
    var
    hijo_der : t_arbol;
    begin
        hijo_der := crear_arbol(indice);
        arbol.sd^ := hijo_der;
    end;

end.