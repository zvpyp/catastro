unit arbol;

{--------------------------------}

interface

    // para testeo
    uses
    crt, sysutils;

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

    // retorna el hijo derecho de un árbol.
    function hijo_derecho(raiz : t_puntero_arbol): t_puntero_arbol;

    // Retorna un puntero al primer elemento encontrado. Si no existe, retorna un t_dato_arbol con índice 0.
    // NOTA: si retorna índice 0, borrar posteriormente el puntero luego del uso.
    function preorden(raiz : t_puntero_arbol; clave : string): t_puntero_arbol;

    // Retorna un árbol con todos los nodos que tengan la misma clave. Guarda en una variable la cantidad de nodos encontrados.
    procedure preorden_multiple(raiz : t_puntero_arbol; clave : string; var encontrados : t_puntero_arbol; var cantidad : cardinal);

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
            // NOTA: si son iguales, el hijo a agregar se posiciona en el subárbol derecho.
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
        if (raiz <> nil) then
        begin
            info_raiz := raiz^.info;
        end
        else
        begin
            info_raiz.clave := '';
            info_raiz.indice := 0;
        end;
    end;


    function hijo_derecho(raiz : t_puntero_arbol): t_puntero_arbol;
    begin
        hijo_derecho := raiz^.sd;
    end;


    procedure modificar_clave(raiz : t_puntero_arbol; nueva_clave : string);
    begin
        raiz^.info.clave := nueva_clave;
    end;


    function preorden(raiz : t_puntero_arbol; clave : string): t_puntero_arbol;
    begin
        if (raiz = nil) then
        begin
            new(preorden);
            preorden^.info.clave := clave;
            preorden^.info.indice := 0;
        end
        else
        begin


            clrscr;
            writeln('actual: ', raiz^.info.clave);
            writeln('buscado: ', clave);
            writeln('indice: ', raiz^.info.indice);
            writeln('iguales: ', (lowercase(raiz^.info.clave) = lowercase(clave)));
            readkey;

            if (lowercase(raiz^.info.clave) = lowercase(clave)) then
                preorden := raiz
            else
            begin
                if (lowercase(raiz^.info.clave) > lowercase(clave)) then
                    preorden := preorden(raiz^.si, clave)
                else
                    preorden := preorden(raiz^.sd, clave);
            end;
        end;
    end;


    procedure preorden_multiple(raiz : t_puntero_arbol; clave : string; var encontrados : t_puntero_arbol; var cantidad : cardinal);
    begin
        raiz := preorden(raiz, clave); // busca el primer elemento que concuerde con la clave.

        // Encontrado (índice distinto de 0)
        if (raiz^.info.indice <> 0) then
        begin
            encontrados := raiz;
            cantidad := cantidad + 1;
            // busca en el subárbol derecho de la raíz para determinar si hay más elementos iguales y los agrega.
            preorden_multiple(raiz^.sd, clave, encontrados^.sd, cantidad);
        end
        else if cantidad > 0 then
            dispose(raiz); // borrar nodo vacío si existe otra entrada.
    end;

end.