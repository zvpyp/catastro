
Unit terreno;

{ Unidad de tipo de dato terreno. }

{--------------------------------}

Interface

Const 
  ruta_terrenos = './terrenos.dat';

Type 
  t_terreno = Record
    nro_contribuyente : string[15];
    nro_plano: string[15];
    avaluo: real;
    fecha_inscripcion: string[10];
    domicilio_parcelario: string[30];
    superficie: real;
    zona: 1..5;
    tipo_edificacion: 1..5;
  End;

  t_archivo_terrenos = file Of t_terreno;

  // Genera el archivo de terrenos si no existe. Sino, lo abre.
Procedure abrir_archivo_terrenos(Var archivo : t_archivo_terrenos);

// Añade un terreno a un archivo en un índice dado.
Procedure escribir_terreno(Var archivo : t_archivo_terrenos;
                           terreno : t_terreno;
                           indice : cardinal);

// Retorna el terreno en el indice indicado de un archivo.
Function leer_terreno(Var archivo : t_archivo_terrenos;
                      indice : cardinal): t_terreno;

// Syntactic sugar. Cierra el archivo.
Procedure cerrar_archivo_terrenos(Var archivo: t_archivo_terrenos);

{--------------------------------}

Implementation

Procedure abrir_archivo_terrenos(Var archivo : t_archivo_terrenos);
Begin
  assign(archivo, ruta_terrenos);

  {$I-} reset(archivo) {$I+};

  // Si el archivo no existe, lo crea.
  If ioresult <> 0 Then rewrite(archivo);

End;

Procedure escribir_terreno(Var archivo : t_archivo_terrenos;
                           terreno : t_terreno;
                           indice : cardinal);
Begin
  seek(archivo, indice);
  write(archivo, terreno);
End;

Function leer_terreno(Var archivo : t_archivo_terrenos;
                      indice : cardinal): t_terreno;
Begin
  seek(archivo, indice);
  read(archivo, leer_terreno);
End;

Procedure cerrar_archivo_terrenos(Var archivo: t_archivo_terrenos);
Begin
  close(archivo);
End;

End.
