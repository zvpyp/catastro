
// Falta crear función para comparar fechas y hacer
// el procedimiento arbol_ordenado_por_fecha_inscripcion

// Revisar arbol_ordenado_por_zona q no se si lo termine o no


Unit arbol_terrenos;
{ Unidad de árboles binarios que ordenan terrenos. }

{--------------------------------}

Interface

Uses terreno in './units/terreno.pas',
arbol in 'units/arbol/arbol';

// Retorna un árbol binario ordenado por numero de contribuyente asociado
// a cada terreno.
Function arbol_ordenado_por_nro_contribuyente(Var archivo : t_archivo_terrenos;
                                              cantidad_terrenos : cardinal): t_arbol
;

// Retorna un árbol binario ordenado por fecha de inscripcion de cada terreno.
Function arbol_ordenado_por_fecha_inscripcion(Var archivo : t_archivo_terrenos;
                                              cantidad_terrenos : cardinal): t_arbol
;

// Retorna un árbol binario ordenado por zona de cada terreno.
Function arbol_ordenado_por_zona(Var archivo : t_archivo_terrenos;
                                 cantidad_terrenos : cardinal): t_arbol
;

{--------------------------------}

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

// Agrega un nodo a un arbol ordenado por zona.
// Su raíz será la posición en el archivo dado.
// El valor se determina según el zona del terreno dado.
Procedure sumar_por_zona(Var arbol: t_arbol;
                        Var archivo : t_archivo_terrenos;
                        nuevo_terreno_indice : cardinal);

Var 
  nuevo_terreno : t_terreno;
  zona_actual : string;
Begin
  _actual := arbol.clave;

  // lee el terreno a agregar
  seek(archivo, nuevo_terreno_indice);
  read(archivo, nuevo_terreno);

  // Caso en que el zona sea mayor:
  If (zona_actual < nuevo_terreno.zona) Then
    Begin

 // Verifica si el árbol tiene hijo derecho y repite el proceso recursivamente.
      // Sino, lo agrega como hijo derecho.
      If tiene_hijo_der(arbol) Then
        sumar_por_zona(arbol.sd^, archivo, nuevo_terreno_indice)
      Else
        anidar_hijo_der(arbol, nuevo_terreno_indice, nuevo_terreno.zona);
    End
    // Caso en que sea menor
  Else
    Begin

// Verifica si el árbol tiene hijo izquierdo y repite el proceso recursivamente.
      // Sino, lo agrega como hijo izquierdo.
      If tiene_hijo_izq(arbol) Then
        sumar_por_zona(arbol.si^, archivo, nuevo_terreno_indice)
      Else
        anidar_hijo_izq(arbol, nuevo_terreno_indice, nuevo_terreno.zona);
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

Function arbol_ordenado_por_zona(Var archivo : t_archivo_terrenos;
                                cantidad_terrenos : cardinal): t_arbol;

Var 
  indice_actual : cardinal;
  primer_terreno : t_terreno;
Begin
  // Creamos el árbol con el primer índice.
  indice_actual := 1;
  seek(archivo, indice_actual);
  read(archivo, primer_terreno);
  arbol_ordenado_por_zona := crear_arbol(indice_actual, primer_terreno.zona);

  For indice_actual := 2 To cantidad_terrenos Do
    Begin
      sumar_por_zona(arbol_ordenado_por_zona, archivo, indice_actual);
    End;
End;

End.
