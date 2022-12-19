unit arbol;

{ Unidad de árboles binarios utilizados como índice de datos para archivos. }

{--------------------------------}

interface

    type
    t_puntero_arbol = ^t_arbol; // No utilizar fuera de la unit.

    t_arbol = record
        indice : cardinal;
        clave : string;
        estado : boolean;
        lista : t_lista_terrenos;
        si : t_puntero_arbol;
        sd : t_puntero_arbol;
    end;

    // Retorna un arbol binario cuya raiz es el índice dado.
    function crear_arbol(indice : cardinal; clave : string; estado : boolean): t_arbol;

    // Añade un hijo izquierdo a un nodo.
    procedure anidar_hijo_izq(var arbol : t_arbol; indice : cardinal; clave : string; estado : boolean);

    // Añade un hijo derecho a un nodo.
    procedure anidar_hijo_der(var arbol : t_arbol; indice : cardinal; clave : string; estado : boolean);

    // Retorna verdadero si el nodo raíz posee hijo izquierdo.
    function tiene_hijo_izq(arbol : t_arbol): boolean;

    // Retorna verdadero si el nodo raíz posee hijo derecho.
    function tiene_hijo_der(arbol : t_arbol): boolean;

    // Retorna el índice del elemento buscado, según su clave.
    function buscar_por_clave(arbol : t_arbol; clave : string): t_arbol;

{--------------------------------}

implementation

    function crear_arbol(indice : cardinal; clave : string; estado : boolean): t_arbol;
    begin
        crear_arbol.indice := indice;
        crear_arbol.clave := clave;
        crear_arbol.estado := estado;
        crear_arbol.si := nil;
        crear_arbol.sd := nil;
    end;

    procedure anidar_hijo_izq(var arbol : t_arbol; indice : cardinal; clave : string; estado : boolean);
    var
    hijo_izq : t_arbol;
    begin
        new(arbol.si);
        hijo_izq := crear_arbol(indice, clave, estado);
        arbol.si^ := hijo_izq;
    end;

    procedure anidar_hijo_der(var arbol : t_arbol; indice : cardinal; clave : string; estado : boolean);
    var
    hijo_der : t_arbol;
    begin
        new(arbol.sd);
        hijo_der := crear_arbol(indice, clave, estado);
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

    function buscar_por_clave(arbol : t_arbol; clave : string): t_arbol;
    begin
        buscar_por_clave.indice := 0;

        if arbol.clave = clave then
            buscar_por_clave := arbol
        else
        begin
            if clave < arbol.clave then
                buscar_por_clave(arbol.si^, clave)
            else
                buscar_por_clave(arbol.sd^, clave);
        end;
    end;

    procedure borrar_raiz(arbol : t_arbol);
    var
        izq_auxiliar : t_puntero_arbol;
        der_auxiliar : t_puntero_arbol;
        arbol_actual : t_puntero_arbol;
    begin
        izq_auxiliar := arbol.si;
        der_auxiliar := arbol.sd;

        arbol.indice := izq_auxiliar^.indice;
        arbol.clave := izq_auxiliar^.clave;
        arbol.estado := izq_auxiliar^.estado;
        arbol.si := izq_auxiliar^.si;
        arbol.sd := izq_auxiliar^.sd;

        arbol_actual := arbol.sd;

        while (arbol_actual^.sd <> nil) do
        begin
            arbol_actual := arbol_actual^.sd;
        end;

        arbol_actual := der_auxiliar;

        dispose(der_auxiliar);
        dispose(izq_auxiliar);
    end;

end.