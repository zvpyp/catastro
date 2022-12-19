// Falta agregar que en alta, baja y modificación también se modifique el árbol, para no generarlo de 0 todas las veces.


Unit contribuyentes_ABMC;

Interface

Uses contribuyente in 'units/contribuyente/contribuyente.pas',
     usuario_contribuyentes in 'units/contribuyente/usuario_contribuyentes',
     validacion_entradas in 'units/varios/validacion_entradas.pas',
     contador_datos in 'units/varios/contador_datos.pas',
     arbol in 'units/arbol/arbol.pas',
     crt, sysutils;

// Pasar archivo de contribuyentes y arbol ordenado por nro de contribuyente.
Procedure alta_contribuyente(var archivo : t_archivo_contribuyentes; var arbol : t_arbol; var archivo_contador : t_archivo_contador);

// Pasar archivo de contribuyentes y arbol ordenado por nro de contribuyente.
Procedure baja_contribuyente(var archivo : t_archivo_contribuyentes; var arbol : t_arbol);

Procedure mod_contribuyente(var archivo : t_archivo_contribuyentes; var arbol : t_arbol);

Procedure consulta_contribuyente(var archivo : t_archivo_contribuyentes; var arbol_nombre : t_arbol; var arbol_numero : t_arbol);

Implementation

// Agregar que se modifique el arbol.
Procedure alta_contribuyente(var archivo : t_archivo_contribuyentes; var arbol : t_arbol; var archivo_contador : t_archivo_contador);
var
contribuyente_nuevo : t_contribuyente;
begin
    abrir_archivo_contribuyentes(archivo);

    crear_contribuyente(archivo, arbol, contribuyente_nuevo);

    if (contribuyente_nuevo.numero <> '') then
    begin
      escribir_contribuyente(archivo, contribuyente_nuevo, cantidad_contribuyentes(archivo_contador));
      contar_contribuyente(archivo);
    end;
end;

Procedure baja_contribuyente(var archivo : t_archivo_contribuyentes; var arbol : t_arbol);
var
contribuyente_baja : t_contribuyente;
nro_contribuyente_baja : string;
arbol_pos : t_arbol;
pos, tcl : int16;
begin

  Writeln('Introduzca el número de contribuyente del usuario que desea dar de baja: ');
  Readln(nro_contribuyente_baja);
  While ((not limite_caracteres(nro_contribuyente_baja,15)) or (not string_numerica(nro_contribuyente_baja))) do
    begin
        Writeln('El valor ingresado no es un número o supera los 15 caracteres, ingréselo nuevamente por favor');
        Readln(nro_contribuyente_baja);
    end;
    arbol_pos := buscar_por_clave(arbol, nro_contribuyente_baja);
    pos := arbol_pos.indice;
    // Buscamos si el numero existe ya en el archivo.
    While (pos = 0) and (tcl <> -1) do
        begin
            Writeln('No existe ningún usuario con este número de contribuyente, que desea hacer?');
            Writeln('1. Ingresar otro numero de contribuyente');
            Writeln('2. Regresar a la pantalla anterior');
            Readln(tcl);
            Case tcl of
            1: Readln(nro_contribuyente_baja);
            2: tcl := -1;
            end;
            arbol_pos := buscar_por_clave(arbol, nro_contribuyente_baja);
            pos := arbol_pos.indice;
        end;
          if tcl <> -1 then
            begin
                contribuyente_baja := leer_contribuyente(archivo, pos);
                borrar_contribuyente(contribuyente_baja);
                escribir_contribuyente(archivo, contribuyente_baja, pos);
            end;
end;

Procedure mod_contribuyente(var archivo : t_archivo_contribuyentes; var arbol : t_arbol);
var
contribuyente_modificado : t_contribuyente;
nro_contribuyente_modificado : string;
arbol_pos : t_arbol;
pos, tcl : int16;
begin
  abrir_archivo_contribuyentes(archivo);

  Writeln('Introduzca el número de contribuyente del usuario que desea modificar: ');
  Readln(nro_contribuyente_modificado);
  While ((not limite_caracteres(nro_contribuyente_modificado,15)) or (not string_numerica(nro_contribuyente_modificado))) do
    begin
        Writeln('El valor ingresado no es un número o supera los 15 caracteres, ingréselo nuevamente por favor');
        Readln(nro_contribuyente_modificado);
    end;
    arbol_pos := buscar_por_clave(arbol, nro_contribuyente_modificado);
    pos := arbol_pos.indice;
    // Buscamos si el numero existe ya en el archivo.
    While (pos = 0) and (tcl <> -1) do
        begin
            Writeln('No existe ningún usuario con este número de contribuyente, que desea hacer?');
            Writeln('1. Ingresar otro número de contribuyente');
            Writeln('2. Regresar a la pantalla anterior');
            Readln(tcl);
            Case tcl of
            1: Readln(nro_contribuyente_modificado);
            2: tcl := -1;
            end;
            arbol_pos := buscar_por_clave(arbol, nro_contribuyente_modificado);
            pos := arbol_pos.indice;
        end;
          if tcl <> -1 then
            begin
                contribuyente_modificado := leer_contribuyente(archivo, pos);
                modificar_contribuyente(contribuyente_modificado, archivo, arbol);
                escribir_contribuyente(archivo, contribuyente_modificado, pos);
            end;
        cerrar_archivo_contribuyentes(archivo);

end;

// Pasar arbol ordenado
Procedure consulta_contribuyente(var archivo : t_archivo_contribuyentes; var arbol_nombre : t_arbol; var arbol_numero : t_arbol);
var
contribuyente_consultado : t_contribuyente;
nro_contribuyente_consultado, nombre_contribuyente_consultado : string;
nombre_consultado, apellido_consultado : string;
arbol_pos : t_arbol;
pos, tcl : int16;
begin
  Writeln('Cómo desea realizar la consulta?');
  Writeln('1. Por nombre completo');
  Writeln('2. Por número de contribuyente');
  Readln(tcl);
  Case tcl of
    1:
    begin
        Writeln('Apellido: ');
        Readln(apellido_consultado);
        Writeln('Nombre: ');
        Readln(nombre_consultado);
        nombre_contribuyente_consultado := apellido_consultado + ' ' + nombre_consultado;
        arbol_pos := buscar_por_clave(arbol_nombre, nombre_contribuyente_consultado);
        pos := arbol_pos.indice;
    end;
    2:
    begin
        Writeln('Nro de contribuyente: ');
        Readln(nro_contribuyente_consultado);
        arbol_pos := buscar_por_clave(arbol_numero, nro_contribuyente_consultado);
        pos := arbol_pos.indice;
    end;
  end;
  contribuyente_consultado := leer_contribuyente(archivo, pos);
  consultar_contribuyente(contribuyente_consultado);
end;

end.