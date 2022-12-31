unit arbol;

{--------------------------------}

interface

    type
    t_dato_arbol = record
        clave : string; // clave utilizada para ordenamiento y búsqueda.
        indice : cardinal; // posición en el archivo.
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

    // retorna el t_dato de la raíz de un árbol.
    function info_raiz(raiz : t_puntero_arbol): t_dato_arbol;

    // Retorna el índice del elemento buscado. Si no existe, retorna un t_dato_arbol vacío.
    function preorden(raiz : t_puntero_arbol; clave : string): t_puntero_arbol;

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

    function info_raiz(raiz : t_puntero_arbol): t_dato_arbol;
    begin
        info_raiz := raiz^.info;        
    end;

    procedure modificar_clave(raiz : t_puntero_arbol; nueva_clave : string);
    begin
        raiz^.info.clave := nueva_clave;
    end;

    // TODO: cambiar al puntero
    function preorden(raiz : t_puntero_arbol; clave : string): t_puntero_arbol;
    begin
        if (raiz = nil) then
            preorden := nil
        else
        begin
            if (raiz^.info.clave = clave) then
                preorden := raiz
            else
            begin
                if (raiz^.info.clave > clave) then
                    preorden := preorden(raiz^.si, clave)
                else
                    preorden := preorden(raiz^.sd, clave);
            end;
        end;
    end;

end.