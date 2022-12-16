unit usuario;

{ Unidad de tipo de interacción con usuario del submenú de contribuyentes. }

{--------------------------------}

interface

    uses contribuyente in 'units/contribuyente.pas',
         validacion_entradas in 'units/validacion_entradas.pas',
         arbol in 'units/arbol/arbol.pas',
         contribuyentes_ABMC in 'units/contribuyentes_ABMC.pas';

// Crea un contribuyente
Function crear_contribuyente(): t_contribuyente;

{--------------------------------}

implementation

Function crear_contribuyente(): t_contribuyente;
var
tcl : byte;
nro, apellido, nombre, direccion, ciudad, dni, fecha_nac, tel, email : string;
begin
Writeln('Nro de contribuyente:');
Readln(nro);
// Validamos los caracteres
While ((not limite_caracteres(nro,15)) or (not string_numerica(nro))) do
  begin
  Writeln('El valor ingresado no es un número o supera los 15 caracteres, ingréselo nuevamente por favor');
  Readln(nro);
  end;
// Buscamos si el numero existe ya en el archivo (falta hacer funcion)
{if clave_esta_en_arbol() then
begin
  Writeln('Ya existe un usuario con este numero de contribuyente, que desea hacer?')
  Writeln('1. Ingresar otro numero de contribuyente');
  Writeln('2. Regresar a la pantalla anterior');
  Case tcl of
  1: Readln(nro);
  2: -;
  end;}

Writeln('Apellido:');
Readln(apellido);
While (not limite_caracteres(apellido,30)) do
  begin
  Writeln('El valor ingresado supera los 30 caracteres, ingréselo nuevamente por favor');
  Readln(apellido);
  end;

Writeln('Nombre:');
Readln(nombre);
While (not limite_caracteres(nombre,30)) do
  begin
  Writeln('El valor ingresado supera los 30 caracteres, ingréselo nuevamente por favor');
  Readln(nombre);
  end;

Writeln('Dirección:');
Readln(direccion);
While (not limite_caracteres(direccion,30)) do
  begin
  Writeln('El valor ingresado supera los 30 caracteres, ingréselo nuevamente por favor');
  Readln(direccion);
  end;

Writeln('Ciudad:');
Readln(ciudad);
While (not limite_caracteres(ciudad,40)) do
  begin
  Writeln('El valor ingresado supera los 40 caracteres, ingréselo nuevamente por favor');
  Readln(ciudad);
  end;

Writeln('DNI:');
Readln(dni);
While ((not limite_caracteres(dni,10)) or (not string_numerica(dni))) do
  begin
  Writeln('El valor ingresado no es un numero o supera los 10 caracteres, ingréselo nuevamente por favor');
  Readln(dni);
  end;

Writeln('Fecha de nacimiento (dd/mm/aaaa):'); // Cambiar es_fecha_valida pq acepta aaaa/mm/dd
Readln(fecha_nac);
While (not es_fecha_valida(fecha_nac)) do
  begin
  Writeln('El valor ingresado no cumple con el formato, recuerde que debe ser dd/mm/aaaa, por ejemplo: 23/07/2020');
  Readln(fecha_nac);
  end;

Writeln('Teléfono:');
Readln(tel);
While ((not limite_caracteres(tel,15)) or (not string_numerica(tel))) do
  begin
  Writeln('El valor ingresado no es un numero o supera los 15 caracteres, ingréselo nuevamente por favor');
  Readln(tel);
  end;

Writeln('Email:');
Readln(email);
While (not limite_caracteres(email,40)) do
  begin
  Writeln('El valor ingresado supera los 40 caracteres, ingréselo nuevamente por favor');
  Readln(email);
  end;

// Falta pasar todos los valores a crear_contribuyente, ahora a mimir q ya hice bastante.

end;

// TODO:
// function crear_contribuyente(): t_contribuyente;
// procedure borrar_contribuyente();
// procedure modificar_contribuyente();
// procedure consultar_contribuyente();

end.