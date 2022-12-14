unit arbol;

{$codepage utf8}

{ Unidad de árboles binarios utilizados como índice de datos para archivos. }

{--------------------------------}

interface

    uses lista_terrenos in 'units/terreno/lista_terrenos.pas';

    type
    t_puntero_arbol = ^t_arbol; // No utilizar fuera de la unit.

    t_arbol = record
        indice : cardinal;
        clave : string;
        estado : boolean;
        nro_contribuyente : string;
        lista : t_lista_terrenos;
        si : t_puntero_arbol;
        sd : t_puntero_arbol;
    end;

    // Retorna un arbol binario cuya raiz es el índice dado.
    function crear_arbol(indice : cardinal; clave : string; estado : boolean; nro_contribuyente : string): t_arbol;

    // Añade un hijo izquierdo a un nodo.
    procedure anidar_hijo_izq(var arbol : t_arbol; indice : cardinal; clave : string; estado : boolean; nro_contribuyente : string);

    // Añade un hijo derecho a un nodo.
    procedure anidar_hijo_der(var arbol : t_arbol; indice : cardinal; clave : string; estado : boolean; nro_contribuyente : string);

    // Retorna verdadero si el nodo raíz posee hijo izquierdo.
    function tiene_hijo_izq(arbol : t_arbol): boolean;

    // Retorna verdadero si el nodo raíz posee hijo derecho.
    function tiene_hijo_der(arbol : t_arbol): boolean;

    // Retorna el índice del elemento buscado, según su clave.
    function buscar_por_clave(arbol : t_arbol; clave : string): t_arbol;

    // TODO: Obsoleto. Borrar cuando se modifique contribuyentes ABMC.
    procedure borrar_raiz(var arbol : t_arbol);

{--------------------------------}

implementation

    function crear_arbol(indice : cardinal; clave : string; estado : boolean; nro_contribuyente : string): t_arbol;
    begin
        crear_arbol.indice := indice;
        crear_arbol.clave := clave;
        crear_arbol.estado := estado;
        crear_arbol.nro_contribuyente := nro_contribuyente;
        crear_arbol.si := nil;
        crear_arbol.sd := nil;
    end;

    procedure anidar_hijo_izq(var arbol : t_arbol; indice : cardinal; clave : string; estado : boolean; nro_contribuyente : string);
    var
    hijo_izq : t_arbol;
    begin
        new(arbol.si);
        hijo_izq := crear_arbol(indice, clave, estado, nro_contribuyente);
        arbol.si^ := hijo_izq;
    end;

    procedure anidar_hijo_der(var arbol : t_arbol; indice : cardinal; clave : string; estado : boolean; nro_contribuyente : string);
    var
    hijo_der : t_arbol;
    begin
        new(arbol.sd);
        hijo_der := crear_arbol(indice, clave, estado, nro_contribuyente);
        arbol.sd^ := hijo_der;
    end;

    function tiene_hijo_izq(arbol : t_arbol): boolean;
    begin
        tiene_hijo_izq := (arbol.si <> nil);
    end;

    function tiene_hijo_der(arbol : t_arbol): boolean;
    begin
        tiene_hijo_der := (arbol.sd <> nil);
    end;

    function buscar_por_clave(arbol : t_arbol; clave : string): t_arbol;
    begin
        buscar_por_clave := crear_arbol(0,'',false, '');
        if arbol.clave = clave then
            buscar_por_clave := arbol
        else
        begin
            if (clave < arbol.clave) and (tiene_hijo_izq(arbol)) then
                buscar_por_clave := buscar_por_clave(arbol.si^, clave)
            else
            if tiene_hijo_der(arbol) then
                buscar_por_clave := buscar_por_clave(arbol.sd^, clave);
        end;
    end;

    // Obsoleto. No funciona.
    procedure borrar_raiz(var arbol : t_arbol);
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