
// Falta crear función para comparar fechas y hacer
// el procedimiento arbol_ordenado_por_fecha_inscripcion

// Revisar arbol_ordenado_por_zona q no se si lo termine o no


Unit arbol_terrenos;
{ Unidad de árboles binarios que ordenan terrenos. }

{--------------------------------------------------------------------------------------}

Interface

Uses terreno in './units/terreno/terreno.pas',
arbol in 'units/arbol/arbol.pas',
compara_fechas in 'units/varios/compara_fechas.pas';

// Retorna un árbol binario ordenado por numero de contribuyente asociado
// a cada terreno.
Function arbol_ordenado_por_nro_contribuyente(Var archivo : t_archivo_terrenos;
                                              cantidad_terrenos : cardinal): t_arbol;

// Retorna un árbol binario ordenado por fecha de inscripcion de cada terreno.
Function arbol_ordenado_por_fecha_inscripcion(Var archivo : t_archivo_terrenos;
                                                  cantidad_terrenos : cardinal): t_arbol;

// Retorna un árbol binario ordenado por número de plano de cada terreno.
Function arbol_ordenado_por_nro_plano(Var archivo : t_archivo_terrenos;
                                          cantidad_terrenos : cardinal): t_arbol;

// Agrega un nodo a un arbol ordenado por nro de contribuyente.
// Su raíz será la posición en el archivo dado.
// El valor se determina según el nro de contributente del terreno dado.
Procedure sumar_por_nro_contribuyente(Var arbol: t_arbol;
                                      Var archivo : t_archivo_terrenos;
                                          nuevo_terreno_indice : cardinal);

// Agrega un nodo a un arbol ordenado por fecha de inscripción.
// Su raíz será la posición en el archivo dado.
// El valor se determina según la fecha de inscripción del terreno dado.
Procedure sumar_por_fecha_inscripcion(Var arbol: t_arbol;
                                      Var archivo : t_archivo_terrenos;
                                          nuevo_terreno_indice : cardinal);

// Agrega un nodo a un arbol ordenado por nro de plano.
// Su raíz será la posición en el archivo dado.
// El valor se determina según el nro de plano del terreno dado.
Procedure sumar_por_nro_plano(Var arbol: t_arbol;
                              Var archivo : t_archivo_terrenos;
                                  nuevo_terreno_indice : cardinal);

{--------------------------------------------------------------------------------------}

Implementation

// Agrega un nodo a un arbol ordenado por nro de contribuyente.
// Su raíz será la posición en el archivo dado.
// El valor se determina según el nro de contributente del terreno dado.
Procedure sumar_por_nro_contribuyente(Var arbol: t_arbol;
                           Var archivo : t_archivo_terrenos;
                           nuevo_terreno_indice : cardinal);

Var 
  nuevo_terreno : t_terreno;
  nro_contribuyente_nuevo : string;
  nro_contribuyente_actual : string;
Begin

  // lee el terreno a agregar
  seek(archivo, nuevo_terreno_indice);
  read(archivo, nuevo_terreno);

  nro_contribuyente_actual := arbol.clave;
  nro_contribuyente_nuevo := nuevo_terreno.nro_contribuyente;

  // Caso en que el nro de contribuyente sea mayor:
  If (nro_contribuyente_actual < nro_contribuyente_nuevo) Then
    Begin

      // Verifica si el árbol tiene hijo derecho y repite el proceso recursivamente.
      // Sino, lo agrega como hijo derecho.
      If tiene_hijo_der(arbol) Then
        sumar_por_nro_contribuyente(arbol.sd^, archivo, nuevo_terreno_indice)
      Else
        anidar_hijo_der(arbol, nuevo_terreno_indice, nro_contribuyente_nuevo);
    End
    // Caso en que sea menor
  Else
    Begin

      // Verifica si el árbol tiene hijo izquierdo y repite el proceso recursivamente.
      // Sino, lo agrega como hijo izquierdo.
      If tiene_hijo_izq(arbol) Then
        sumar_por_nro_contribuyente(arbol.si^, archivo, nuevo_terreno_indice)
      Else
        anidar_hijo_izq(arbol, nuevo_terreno_indice, nro_contribuyente_nuevo);
    End;
End;

Function arbol_ordenado_por_nro_contribuyente(Var archivo : t_archivo_terrenos;
                                    cantidad_terrenos : cardinal): t_arbol;

Var 
  indice_actual : cardinal;
  primer_terreno : t_terreno;
  nro_contribuyente_primero : string;
Begin
  // Creamos el árbol con el primer índice.
  indice_actual := 1;
  seek(archivo, indice_actual);
  read(archivo, primer_terreno);
  nro_contribuyente_primero := primer_terreno.nro_contribuyente;

  arbol_ordenado_por_nro_contribuyente := crear_arbol(indice_actual,
                                nro_contribuyente_primero);

  For indice_actual := 2 To cantidad_terrenos Do
    Begin
      sumar_por_nro_contribuyente(arbol_ordenado_por_nro_contribuyente, archivo, indice_actual);
    End;
End;

// Agrega un nodo a un arbol ordenado por fecha de inscripción.
// Su raíz será la posición en el archivo dado.
// El valor se determina según la fecha de inscripción del terreno dado.
// Aclaración: se utiliza la función fecha_es_mayor para realizar la comparativa.
Procedure sumar_por_fecha_inscripcion(Var arbol: t_arbol;
                           Var archivo : t_archivo_terrenos;
                           nuevo_terreno_indice : cardinal);

Var 
  nuevo_terreno : t_terreno;
  fecha_inscripcion_nuevo : string;
  fecha_inscripcion_actual : string;
Begin

  // lee el terreno a agregar
  seek(archivo, nuevo_terreno_indice);
  read(archivo, nuevo_terreno);

  fecha_inscripcion_actual := arbol.clave;
  fecha_inscripcion_nuevo := nuevo_terreno.fecha_inscripcion;

  // Caso en que la fecha de inscripcion sea mayor:
  If fecha_es_mayor(fecha_inscripcion_nuevo, fecha_inscripcion_actual) Then
    Begin

      // Verifica si el árbol tiene hijo derecho y repite el proceso recursivamente.
      // Sino, lo agrega como hijo derecho.
      If tiene_hijo_der(arbol) Then
        sumar_por_fecha_inscripcion(arbol.sd^, archivo, nuevo_terreno_indice)
      Else
        anidar_hijo_der(arbol, nuevo_terreno_indice, fecha_inscripcion_nuevo);
    End
    // Caso en que sea menor
  Else
    Begin

      // Verifica si el árbol tiene hijo izquierdo y repite el proceso recursivamente.
      // Sino, lo agrega como hijo izquierdo.
      If tiene_hijo_izq(arbol) Then
        sumar_por_fecha_inscripcion(arbol.si^, archivo, nuevo_terreno_indice)
      Else
        anidar_hijo_izq(arbol, nuevo_terreno_indice, fecha_inscripcion_nuevo);
    End;
End;

Function arbol_ordenado_por_fecha_inscripcion(Var archivo : t_archivo_terrenos;
                                              cantidad_terrenos : cardinal): t_arbol
Var 
  indice_actual : cardinal;
  primer_terreno : t_terreno;
  fecha_inscripcion_primero : string;
Begin
  if cantidad_terrenos > 0 then
  begin
    // Creamos el árbol con el primer índice.
    indice_actual := 1;
    seek(archivo, indice_actual);
    read(archivo, primer_terreno);
    fecha_inscripcion_primero := primer_terreno.fecha_inscripcion;

    arbol_ordenado_por_fecha_inscripcion := crear_arbol(indice_actual,
                                  fecha_inscripcion_primero);
  end;

  if cantidad_terrenos > 1 then
  begin
  For indice_actual := 2 To cantidad_terrenos Do
    Begin
      sumar_por_fecha_inscripcion(arbol_ordenado_por_fecha_inscripcion, archivo, indice_actual);
    End;
  end;
End;

// Agrega un nodo a un arbol ordenado por nro de plano.
// Su raíz será la posición en el archivo dado.
// El valor se determina según el nro de plano del terreno dado.
Procedure sumar_por_nro_plano(Var arbol: t_arbol;
                           Var archivo : t_archivo_terrenos;
                           nuevo_terreno_indice : cardinal);

Var 
  nuevo_terreno : t_terreno;
  nro_plano_nuevo : string;
  nro_plano_actual : string;
Begin

  // lee el terreno a agregar
  seek(archivo, nuevo_terreno_indice);
  read(archivo, nuevo_terreno);

  nro_plano_actual := arbol.clave;
  nro_plano_nuevo := nuevo_terreno.nro_plano;

  // Caso en que el nro de contribuyente sea mayor:
  If (nro_plano_actual < nro_plano_nuevo) Then
    Begin

      // Verifica si el árbol tiene hijo derecho y repite el proceso recursivamente.
      // Sino, lo agrega como hijo derecho.
      If tiene_hijo_der(arbol) Then
        sumar_por_nro_plano(arbol.sd^, archivo, nuevo_terreno_indice)
      Else
        anidar_hijo_der(arbol, nuevo_terreno_indice, nro_plano_nuevo);
    End
    // Caso en que sea menor
  Else
    Begin

      // Verifica si el árbol tiene hijo izquierdo y repite el proceso recursivamente.
      // Sino, lo agrega como hijo izquierdo.
      If tiene_hijo_izq(arbol) Then
        sumar_por_nro_plano(arbol.si^, archivo, nuevo_terreno_indice)
      Else
        anidar_hijo_izq(arbol, nuevo_terreno_indice, nro_plano_nuevo);
    End;
End;

Function arbol_ordenado_por_nro_plano(Var archivo : t_archivo_terrenos;
                                    cantidad_terrenos : cardinal): t_arbol;

Var 
  indice_actual : cardinal;
  primer_terreno : t_terreno;
  nro_plano_primero : string;
Begin

  if cantidad_terrenos > 0 then
  begin
    // Creamos el árbol con el primer índice.
    indice_actual := 1;
    seek(archivo, indice_actual);
    read(archivo, primer_terreno);
    nro_plano_primero := primer_terreno.nro_plano;

    arbol_ordenado_por_nro_plano := crear_arbol(indice_actual,
                                  nro_plano_primero);
  end;

  if cantidad_terrenos > 1 then
  begin
    For indice_actual := 2 To cantidad_terrenos Do
    Begin
      sumar_por_nro_plano(arbol_ordenado_por_nro_plano, archivo, indice_actual);
    End;
  end;
End;

End.
