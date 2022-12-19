unit arbol_contribuyentes;
{ Unidad de árboles binarios que ordenan contribuyentes. }

{--------------------------------}

interface

    uses contribuyente in './units/contribuyente/contribuyente.pas',
         arbol in 'units/arbol/arbol',
         terreno in 'units/terreno/terreno.pas',
         lista_terrenos in 'units/terreno/lista_terrenos.pas';

    // Retorna un árbol binario ordenado por nombre y apellido de cada contribuyente.
    function arbol_ordenado_por_nombres(var archivo : t_archivo_contribuyentes;
                                            cantidad_contribuyentes : cardinal): t_arbol;

    // Retorna un árbol binario ordenado por dni de cada contribuyente.
    function arbol_ordenado_por_dni(var archivo : t_archivo_contribuyentes;
                                        cantidad_contribuyentes : cardinal): t_arbol;

    // Realiza un recorrido preorden de los árboles, luego añade los elementos de la lista que le corresponden.
    procedure agregar_listas_por_contribuyente(var arbol_por_nombres : t_arbol;
                                               lista_terrenos : t_lista_terrenos);
    
    // Agrega un solo terreno al contribuyente que le corresponde, dado un árbol.
    // Para encontrarlo, hace un recorrido inorden.
    // el argumento "encontrado" debe pasarse como false.
    procedure agregar_terreno_a_contribuyente(var arbol_por_nombres : t_arbol;
                                              terreno : t_terreno;
                                              var encontrado : boolean);
    
    

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
                anidar_hijo_der(arbol, nuevo_contribuyente_indice, nombre_completo_nuevo, nuevo_contribuyente.activo, nuevo_contribuyente.numero);
        end
        // Caso en que sea menor
        else
        begin
            // Verifica si el árbol tiene hijo izquierdo y repite el proceso recursivamente.
            // Sino, lo agrega como hijo izquierdo.
            if tiene_hijo_izq(arbol) then
                sumar_por_nombre(arbol.si^, archivo, nuevo_contribuyente_indice)
            else
                anidar_hijo_izq(arbol, nuevo_contribuyente_indice, nombre_completo_nuevo, nuevo_contribuyente.activo, nuevo_contribuyente.numero);
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
                anidar_hijo_der(arbol, nuevo_contribuyente_indice, nuevo_contribuyente.dni, nuevo_contribuyente.activo, nuevo_contribuyente.numero);
        end
        // Caso en que sea menor
        else
        begin
            // Verifica si el árbol tiene hijo izquierdo y repite el proceso recursivamente.
            // Sino, lo agrega como hijo izquierdo.
            if tiene_hijo_izq(arbol) then
                sumar_por_dni(arbol.si^, archivo, nuevo_contribuyente_indice)
            else
                anidar_hijo_izq(arbol, nuevo_contribuyente_indice, nuevo_contribuyente.dni, nuevo_contribuyente.activo, nuevo_contribuyente.numero);
        end;
    end;

    function busqueda_contribuyente(var arbol : t_arbol): t_contribuyente;
    begin
        
    end;

    
    function arbol_ordenado_por_nombres(var archivo : t_archivo_contribuyentes;
                                            cantidad_contribuyentes : cardinal): t_arbol;
    var
        indice_actual : cardinal;
        primer_contribuyente : t_contribuyente;
        nombre_apellido_primero : string;
    begin
        // Creamos el árbol con el primer índice.
        if  cantidad_contribuyentes > 0 then
        begin
            indice_actual := 1;
            seek(archivo, indice_actual);
            read(archivo, primer_contribuyente);
            nombre_apellido_primero := primer_contribuyente.apellido + ' ' + primer_contribuyente.nombre;

            arbol_ordenado_por_nombres := crear_arbol(indice_actual, nombre_apellido_primero, primer_contribuyente.activo, primer_contribuyente.numero);
        end;

        if cantidad_contribuyentes > 1 then
            begin
            for indice_actual := 2 to cantidad_contribuyentes do
            begin
                sumar_por_nombre(arbol_ordenado_por_nombres, archivo, indice_actual);
            end;
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
        arbol_ordenado_por_dni := crear_arbol(indice_actual, primer_contribuyente.dni, primer_contribuyente.activo, primer_contribuyente.numero);

        if cantidad_contribuyentes > 1 then
        begin
            for indice_actual := 2 to cantidad_contribuyentes do
            begin
                sumar_por_dni(arbol_ordenado_por_dni, archivo, indice_actual);
            end;
        end;
    end;

    procedure agregar_terreno_a_contribuyente(var arbol_por_nombres : t_arbol;
                                              terreno : t_terreno;
                                              var encontrado : boolean);
    begin
        if (terreno.nro_contribuyente = arbol_por_nombres.nro_contribuyente) then
        begin
            enlistar_terreno(arbol_por_nombres.lista, terreno);
            encontrado := true;
        end
        else
        begin
            if not(encontrado) then
            begin
                if tiene_hijo_izq(arbol_por_nombres) then
                    agregar_terreno_a_contribuyente(arbol_ordenado_por_nombres.si^, terreno, encontrado);

                if tiene_hijo_der(arbol_por_nombres) then
                    agregar_terreno_a_contribuyente(arbol_ordenado_por_nombres.sd^, terreno, encontrado);
            end;
        end;
        

    end;


    // a partir de una lista de terrenos, añade a la raíz de un árbol
    // los contribuyentes que le corresponden.
    procedure agregar_terrenos_a_contribuyente(var arbol_por_nombres: t_arbol;
                                              lista : t_lista_terrenos);
    var
        terreno_actual : t_terreno;
    begin
        primero_lista_terrenos(lista);

        while not(fin_lista_terrenos(lista)) do
        begin
            recuperar_lista_terrenos(lista, terreno_actual);

            if (terreno_actual.nro_contribuyente = arbol_por_nombres.nro_contribuyente) then
            begin
                enlistar_terreno(arbol_por_nombres.lista, terreno_actual);
            end;

            siguiente_lista_terrenos(lista);
        end;
    end;

    procedure agregar_listas_por_contribuyente(var arbol_por_nombres : t_arbol;
                                               lista_terrenos : t_lista_terrenos);
    var
        terreno_actual : t_terreno;
    begin
        if tiene_hijo_izq(arbol_por_nombres) then
            agregar_listas_por_contribuyente(arbol_por_nombres.si^);
        
        // con el nodo actual

        agregar_terrenos_a_contribuyente(arbol_por_nombres, lista_terrenos);

        if tiene_hijo_der(arbol_por_nombres) then
            agregar_listas_por_contribuyente(arbol_por_nombres.sd^);
    end;

end.