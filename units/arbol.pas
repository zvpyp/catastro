unit arbol;

{--------------------------------}

interface

    type
    t_dato_arbol = record
        clave : string; // clave utilizada para ordenamiento y búsqueda.
        pos : cardinal; // posición en el archivo.
    end;
    
    t_puntero_arbol = ^t_nodo_arbol;

    t_nodo_arbol = record
        info : t_dato_arbol;
        si, sd : t_puntero_arbol;
    end;

    // Inicializa un arbol.
    procedure crear_arbol(var raiz: t_puntero_arbol);

    // Agrega un hijo a un árbol binario. Lo ordena según clave.
    procedure agregar_hijo(var raiz : t_puntero_arbol; dato : t_dato_arbol);

    function arbol_vacio(raiz : t_puntero_arbol): boolean;

    function arbol_lleno(raiz : t_puntero_arbol): boolean;

{--------------------------------}

implementation

    procedure crear_arbol(var raiz: t_puntero_arbol);
    begin
        raiz := nil;
    end;
    
    procedure agregar_hijo(var raiz : t_puntero_arbol; dato : t_dato_arbol);
    begin
        if raiz = nil then
        begin
            new(raiz);
            raiz^.info := dato;

            raiz^.si := nil;
            raiz^.sd := nil;
        end
        else
        begin
            if raiz^.info.clave > dato.clave then
                agregar_hijo(raiz^.si, dato)
            else
                agregar_hijo(raiz^.sd, dato);
        end;
    end;

    function arbol_vacio(raiz : t_puntero_arbol): boolean;
    begin
        arbol_vacio := (raiz = nil);
    end;

    function arbol_lleno(raiz : t_puntero_arbol): boolean;
    begin
        arbol_lleno := getHeapStatus.totalFree < sizeOf(t_nodo_arbol);
    end;

end.