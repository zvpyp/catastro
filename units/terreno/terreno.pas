unit terreno;

{$codepage utf8}

{ Unidad de tipo de dato terreno. }

{--------------------------------}

interface

const 
  	ruta_terrenos = './terrenos.dat';

type 
  	t_terreno = record
		nro_contribuyente : string[15];
		nro_plano : string[15];
		avaluo : real;
		fecha_inscripcion : string[10];
		domicilio_parcelario : string[30];
		superficie : real;
		zona : 1..5;
		tipo_edificacion : 1..5;
		indice : cardinal; // posición en el archivo
  	End;

  	t_archivo_terrenos = file Of t_terreno;

	// Setea valores por default a una variable de terreno.
	procedure terreno_default(var terreno : t_terreno);

	// Genera el archivo de terrenos si no existe. Sino, lo abre.
	Procedure abrir_archivo_terrenos(var archivo : t_archivo_terrenos);

	// Añade un terreno a un archivo en un índice dado.
	Procedure escribir_terreno(var archivo : t_archivo_terrenos;
							terreno : t_terreno;
							indice : cardinal);

	// Retorna el terreno en el indice indicado de un archivo.
	Function leer_terreno(var archivo : t_archivo_terrenos;
						indice : cardinal): t_terreno;

	// Syntactic sugar. Cierra el archivo.
	Procedure cerrar_archivo_terrenos(var archivo: t_archivo_terrenos);

{--------------------------------}

Implementation

	procedure terreno_default(var terreno : t_terreno);
	begin
		terreno.nro_contribuyente := '';
		terreno.nro_plano := '';
		terreno.avaluo := 0;
		terreno.fecha_inscripcion := '';
		terreno.domicilio_parcelario := '';
		terreno.superficie := 0;
		terreno.zona := 1;
		terreno.tipo_edificacion := 1;
		terreno.indice := 0; // posición en el archivo
	end;


	Procedure abrir_archivo_terrenos(var archivo : t_archivo_terrenos);
	Begin
		assign(archivo, ruta_terrenos);

		{$I-} reset(archivo) {$I+};

		// Si el archivo no existe, lo crea.
		If ioresult <> 0 Then rewrite(archivo);
	End;


	Procedure escribir_terreno(var archivo : t_archivo_terrenos;
							terreno : t_terreno;
							indice : cardinal);
	Begin
		seek(archivo, indice);
		write(archivo, terreno);
	End;


	Function leer_terreno(var archivo : t_archivo_terrenos;
						indice : cardinal): t_terreno;
	Begin
		seek(archivo, indice);
		read(archivo, leer_terreno);
	End;


	Procedure cerrar_archivo_terrenos(var archivo: t_archivo_terrenos);
	Begin
		close(archivo);
	End;

End.
