unit usuario_contribuyentes;

//TODO:
// Falta que se modifique el super árbol cuando se crea, borra o modifica.
// Mejorar el diseño de todos los Writeln de estos procedimientos.

{ Unidad de tipo de interacción con usuario del submenú de contribuyentes. }

{--------------------------------}

interface

    uses contribuyente in 'units/contribuyente/contribuyente.pas',
         validacion_entradas in 'units/varios/validacion_entradas.pas',
         arbol in 'units/arbol/arbol.pas',
         crt;

// Crea un contribuyente, si el nro de contribuyente proporcionado ya se encuentra en el archivo te da la opción de
// 'regresar a la pantalla anterior', en ese caso el t_contribuyente se encontraría vacío, verificarlo al momento
// de utilizar la función para el ALTA.
Procedure crear_contribuyente(var archivo : t_archivo_contribuyentes; arbol : t_arbol; nuevo_contribuyente : t_contribuyente);

Procedure borrar_contribuyente(var contribuyente : t_contribuyente);

Procedure modificar_contribuyente(var contribuyente : t_contribuyente; var archivo : t_archivo_contribuyentes; arbol : t_arbol);

Procedure consultar_contribuyente(var contribuyente : t_contribuyente);

{--------------------------------}

implementation
// Pasar árbol ordenado por nro de contribuyente y archivo de contribuyentes.
Procedure crear_contribuyente(var archivo : t_archivo_contribuyentes; arbol : t_arbol; nuevo_contribuyente : t_contribuyente); 
var
tcl, pos: int16;
arbol_pos : t_arbol;
nro, apellido, nombre, direccion, ciudad, dni, fecha_nac, tel, email : string;
begin
  tcl := 1;
  While ((tcl <> 0) and (tcl < 11)) do
  begin
    Case tcl of
      1:
      begin
        Writeln('Nro de contribuyente:');
        Readln(nro);
        While ((not limite_caracteres(nro,15)) or (not string_numerica(nro))) do
        begin
        Writeln('El valor ingresado no es un número o supera los 15 caracteres, ingréselo nuevamente por favor');
        Readln(nro);
        end;
        arbol_pos := buscar_por_clave(arbol, nro);
        pos := arbol_pos.indice;
        // Buscamos si el numero existe ya en el archivo.
        While pos = 0 do
          begin
            Writeln('Ya existe un usuario con este numero de contribuyente, que desea hacer?');
            Writeln('1. Ingresar otro numero de contribuyente');
            Writeln('2. Regresar a la pantalla anterior');
            Readln(tcl);
            Case tcl of
            1: Readln(nro);
            2: tcl := -1;
            end;
            arbol_pos := buscar_por_clave(arbol, nro);
            pos := arbol_pos.indice;
          end;
      end;
      2:
      begin

        Writeln('Apellido:');
        Readln(apellido);
        While (not limite_caracteres(apellido,30)) do
          begin
          Writeln('El valor ingresado supera los 30 caracteres, ingréselo nuevamente por favor');
          Readln(apellido);
          end;
            
        end;
      3:
      begin
        Writeln('Nombre:');
        Readln(nombre);
        While (not limite_caracteres(nombre,30)) do
          begin
          Writeln('El valor ingresado supera los 30 caracteres, ingréselo nuevamente por favor');
          Readln(nombre);
          end;
      end;
      4:
      begin
        Writeln('Dirección:');
        Readln(direccion);
        While (not limite_caracteres(direccion,30)) do
          begin
            Writeln('El valor ingresado supera los 30 caracteres, ingréselo nuevamente por favor');
            Readln(direccion);
          end;
      end;
      5:
      begin
        Writeln('Ciudad:');
        Readln(ciudad);
        While (not limite_caracteres(ciudad,40)) do
          begin
            Writeln('El valor ingresado supera los 40 caracteres, ingréselo nuevamente por favor');
            Readln(ciudad);
          end;
      end;
      6:
      begin
        Writeln('DNI:');
        Readln(dni);
        While ((not limite_caracteres(dni,10)) or (not string_numerica(dni))) do
          begin
            Writeln('El valor ingresado no es un numero o supera los 10 caracteres, ingréselo nuevamente por favor');
            Readln(dni);
          end;
      end;
      7:
      begin
        Writeln('Fecha de nacimiento (dd/mm/aaaa):'); // Cambiar es_fecha_valida pq acepta aaaa/mm/dd
        Readln(fecha_nac);
        While (not es_fecha_valida(fecha_nac)) do
          begin
            Writeln('El valor ingresado no cumple con el formato, recuerde que debe ser dd/mm/aaaa, por ejemplo: 23/07/2020');
            Readln(fecha_nac);
          end;
      end;
      8:
      begin
        Writeln('Teléfono:');
        Readln(tel);
        While ((not limite_caracteres(tel,15)) or (not string_numerica(tel))) do
          begin
            Writeln('El valor ingresado no es un numero o supera los 15 caracteres, ingréselo nuevamente por favor');
            Readln(tel);
          end;
      end;
      9:
      begin
        Writeln('Email:');
        Readln(email);
        While (not limite_caracteres(email,40)) do
          begin
          Writeln('El valor ingresado supera los 40 caracteres, ingréselo nuevamente por favor');
          Readln(email);
          end;
      end;
      10:
      begin
        nuevo_contribuyente.numero := nro;
        nuevo_contribuyente.apellido := apellido;
        nuevo_contribuyente.nombre := nombre;
        nuevo_contribuyente.direccion := direccion;
        nuevo_contribuyente.ciudad := ciudad;
        nuevo_contribuyente.dni := dni;
        nuevo_contribuyente.fecha_nacimiento := fecha_nac;
        nuevo_contribuyente.tel := tel;
        nuevo_contribuyente.email := email;
        nuevo_contribuyente.activo := true;
      end;
    end;
    tcl := tcl + 1;
  end;
  if tcl = 0 then
    begin
      nuevo_contribuyente.numero := '-1';
    end;
end;

Procedure borrar_contribuyente(var contribuyente : t_contribuyente);
begin
  contribuyente.activo := false
end;

Procedure modificar_contribuyente(var contribuyente : t_contribuyente; var archivo : t_archivo_contribuyentes; arbol : t_arbol);
var
tcl, pos : int16;
modif : string;
arbol_pos : t_arbol;
begin
  tcl := -1;
  While tcl <> 0 do
    begin
      Writeln('¿Qué desea modificar?');
      Writeln('0. Cancelar');
      Writeln('1. Número de contribuyente');
      Writeln('2. Apellido');
      Writeln('3. Nombre');
      Writeln('4. Dirección');
      Writeln('5. Ciudad');
      Writeln('6. DNI');
      Writeln('7. Fecha de nacimiento');
      Writeln('8. Teléfono');
      Writeln('9. Email');
      Readln(tcl);
      Case tcl of
        1:
        begin
          Writeln('Nro de contribuyente:');
          Readln(modif);
          While ((not limite_caracteres(modif,15)) or (not string_numerica(modif))) do
          begin
          Writeln('El valor ingresado no es un número o supera los 15 caracteres, ingréselo nuevamente por favor');
          Readln(modif);
          end;
        // Buscamos si el numero existe ya en el archivo.
          arbol_pos := buscar_por_clave(arbol, modif);
          pos := arbol_pos.indice;
        While pos = 0 do
          begin
            Writeln('Ya existe un usuario con este numero de contribuyente, que desea hacer?');
            Writeln('1. Ingresar otro numero de contribuyente');
            Writeln('2. Regresar a la pantalla anterior');
            Readln(tcl);
            Case tcl of
            1: Readln(modif);
            2: tcl := -1;
            end;
            arbol_pos := buscar_por_clave(arbol, modif);
            pos := arbol_pos.indice;
          end;
          contribuyente.numero := modif;
        end;
        2:
        begin

          Writeln('Apellido:');
          Readln(modif);
          While (not limite_caracteres(modif,30)) do
            begin
            Writeln('El valor ingresado supera los 30 caracteres, ingréselo nuevamente por favor');
            Readln(modif);
            end;
          contribuyente.apellido := modif;
        end;
        3:
        begin
          Writeln('Nombre:');
          Readln(modif);
          While (not limite_caracteres(modif,30)) do
            begin
            Writeln('El valor ingresado supera los 30 caracteres, ingréselo nuevamente por favor');
            Readln(modif);
            end;
          contribuyente.nombre := modif;
        end;
        4:
        begin
          Writeln('Dirección:');
          Readln(modif);
          While (not limite_caracteres(modif,30)) do
            begin
              Writeln('El valor ingresado supera los 30 caracteres, ingréselo nuevamente por favor');
              Readln(modif);
            end;
          contribuyente.direccion := modif;
        end;
        5:
        begin
          Writeln('Ciudad:');
          Readln(modif);
          While (not limite_caracteres(modif,40)) do
            begin
              Writeln('El valor ingresado supera los 40 caracteres, ingréselo nuevamente por favor');
              Readln(modif);
            end;
          contribuyente.ciudad := modif;
        end;
        6:
        begin
          Writeln('DNI:');
          Readln(modif);
          While ((not limite_caracteres(modif,10)) or (not string_numerica(modif))) do
            begin
              Writeln('El valor ingresado no es un numero o supera los 10 caracteres, ingréselo nuevamente por favor');
              Readln(modif);
            end;
          contribuyente.dni := modif;
        end;
        7:
        begin
          Writeln('Fecha de nacimiento (dd/mm/aaaa):'); // Cambiar es_fecha_valida pq acepta aaaa/mm/dd
          Readln(modif);
          While (not es_fecha_valida(modif)) do
            begin
              Writeln('El valor ingresado no cumple con el formato, recuerde que debe ser dd/mm/aaaa, por ejemplo: 23/07/2020');
              Readln(modif);
            end;
          contribuyente.fecha_nacimiento := modif;
        end;
        8:
        begin
          Writeln('Teléfono:');
          Readln(modif);
          While ((not limite_caracteres(modif,15)) or (not string_numerica(modif))) do
            begin
              Writeln('El valor ingresado no es un numero o supera los 15 caracteres, ingréselo nuevamente por favor');
              Readln(modif);
            end;
          contribuyente.tel := modif;
        end;
        9:
        begin
          WriteLn('Email:');
          Readln(modif);
          While (not limite_caracteres(modif,40)) do
            begin
            Writeln('El valor ingresado supera los 40 caracteres, ingréselo nuevamente por favor');
            Readln(modif);
            end;
          contribuyente.email := modif;
        end;
      end;
    end;
end;

Procedure consultar_contribuyente(var contribuyente : t_contribuyente);
begin
  if contribuyente.activo then
    begin
      Writeln('Número de contribuyente: ',contribuyente.numero);
      Writeln('Nombre completo: ',contribuyente.apellido,' ',contribuyente.nombre);
      Writeln('Dirección: ',contribuyente.direccion);
      Writeln('Ciudad: ',contribuyente.ciudad);
      Writeln('DNI: ',contribuyente.dni);
      Writeln('Fecha de nacimiento: ',contribuyente.fecha_nacimiento);
      Writeln('Teléfono: ',contribuyente.tel);
      Writeln('Email: ',contribuyente.email);
      ReadKey;
    end
    else
      begin 
        Writeln('El usuario ha sido dado de baja');
        ReadKey;
      end;
end;
end.