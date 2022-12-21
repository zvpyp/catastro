// Falta agregar que en alta, baja y modificación también se modifique el árbol, para no generarlo de 0 todas las veces.

Unit contribuyentes_ABMC;

{$codepage utf8}

Interface

Uses contribuyente in 'units/contribuyente/contribuyente.pas',
     usuario_contribuyentes in 'units/contribuyente/usuario_contribuyentes',
     validacion_entradas in 'units/varios/validacion_entradas.pas',
     contador_datos in 'units/varios/contador_datos.pas',
     arbol in 'units/arbol/arbol.pas',
     arbol_contribuyentes in 'units/arbol/arbol_contribuyentes.pas',
     u_menu in 'units/u_menu.pas',
     crt, sysutils;

// Pasar archivo de contribuyentes y arbol ordenado por nro de contribuyente, nombre y dni.
Procedure alta_contribuyente(var archivo_contribuyentes : t_archivo_contribuyentes;
                             var arbol_nro : t_arbol;
                             var arbol_nombre : t_arbol;
                             var arbol_dni : t_arbol;
                             var archivo_contador : t_archivo_contador);

// Pasar archivo de contribuyentes y arbol ordenado por nro de contribuyente, nombre y dni.
Procedure baja_contribuyente(var archivo : t_archivo_contribuyentes;
                             var arbol_nro : t_arbol;
                             var arbol_nombre : t_arbol;
                             var arbol_dni : t_arbol);

Procedure mod_contribuyente(var archivo : t_archivo_contribuyentes;
                            var archivo_contador : t_archivo_contador;
                            var arbol_nro : t_arbol;
                            var arbol_nombre : t_arbol;
                            var arbol_dni : t_arbol);

Procedure consulta_contribuyente(var archivo : t_archivo_contribuyentes;
                                 var arbol_nombre : t_arbol;
                                 var arbol_dni : t_arbol);

Implementation

Procedure alta_contribuyente(var archivo_contribuyentes : t_archivo_contribuyentes;
                             var arbol_nro : t_arbol;
                             var arbol_nombre : t_arbol;
                             var arbol_dni : t_arbol;
                             var archivo_contador : t_archivo_contador);
var
contribuyente_nuevo : t_contribuyente;
indice : cardinal;
begin
    indice := cantidad_contribuyentes(archivo_contador) + 1;
    crear_contribuyente(archivo_contribuyentes, arbol_nro, contribuyente_nuevo);

    if (contribuyente_nuevo.numero <> '') then
    begin
      // Guarda el contribuyente en el archivo.
      escribir_contribuyente(archivo_contribuyentes, contribuyente_nuevo, indice);
      // Modifica todos los árboles.
      sumar_por_nro(arbol_nro, archivo_contribuyentes, indice);
      sumar_por_nombre(arbol_nombre, archivo_contribuyentes, indice);
      sumar_por_dni(arbol_dni, archivo_contribuyentes, indice);
      // Aumenta la cantidad de contribuyentes.
      contar_contribuyente(archivo_contador);
    end;
end;

Procedure baja_contribuyente(var archivo : t_archivo_contribuyentes;
                             var arbol_nro : t_arbol;
                             var arbol_nombre : t_arbol;
                             var arbol_dni : t_arbol);
var
  contribuyente_baja : t_contribuyente;
  nro_contribuyente_baja, clave_nombre, clave_dni : string;
  arbol_nro_baja, arbol_nombre_baja, arbol_dni_baja  : t_arbol;
  pos, tcl : int16;
begin

  Writeln('Introduzca el número de contribuyente del usuario que desea dar de baja: ');
  Readln(nro_contribuyente_baja);
  While ((not limite_caracteres(nro_contribuyente_baja,15)) or (not string_numerica(nro_contribuyente_baja))) do
    begin
        Writeln('El valor ingresado no es un número o supera los 15 caracteres, ingréselo nuevamente por favor');
        Readln(nro_contribuyente_baja);
    end;
    arbol_nro_baja := buscar_por_clave(arbol_nro, nro_contribuyente_baja);
    pos := arbol_nro_baja.indice;
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
            arbol_nro_baja := buscar_por_clave(arbol_nro, nro_contribuyente_baja);
            pos := arbol_nro_baja.indice;
        end;
    if tcl <> -1 then
      begin
        // Modificamos el archivo.
        contribuyente_baja := leer_contribuyente(archivo, pos);
        borrar_contribuyente(contribuyente_baja);
        escribir_contribuyente(archivo, contribuyente_baja, pos);
        // Buscamos las claves de los árboles.
       clave_nombre := contribuyente_baja.apellido + ' ' + contribuyente_baja.nombre;
       clave_dni := contribuyente_baja.dni;
       // Buscamos los árboles.
       arbol_nombre_baja := buscar_por_clave(arbol_nombre, clave_nombre);
       arbol_dni_baja := buscar_por_clave(arbol_dni, clave_dni);
       // Modificamos los árboles.
       arbol_nro_baja.estado := false;
       arbol_nombre_baja.estado := false;
       arbol_dni_baja.estado := false;
            end;
end;

Procedure mod_contribuyente(var archivo : t_archivo_contribuyentes;
                            var archivo_contador : t_archivo_contador;
                            var arbol_nro : t_arbol;
                            var arbol_nombre : t_arbol;
                            var arbol_dni : t_arbol);
var
  contribuyente_modificado : t_contribuyente;
  nro_contribuyente_modificado, clave_nombre, clave_dni : string;
  arbol_nro_mod, arbol_nombre_mod, arbol_dni_mod : t_arbol;
  pos, tcl : int16;
begin

  Writeln('Introduzca el número de contribuyente del usuario que desea modificar: ');
  Readln(nro_contribuyente_modificado);
  While ((not limite_caracteres(nro_contribuyente_modificado,15)) or (not string_numerica(nro_contribuyente_modificado))) do
    begin
        Writeln('El valor ingresado no es un número o supera los 15 caracteres, ingréselo nuevamente por favor');
        Readln(nro_contribuyente_modificado);
    end;

  arbol_nro_mod := buscar_por_clave(arbol_nro, nro_contribuyente_modificado);
  pos := arbol_nro_mod.indice;
  // Buscamos si el numero existe ya en el archivo.
  While (pos = 0) and (tcl <> 2) and (tcl <> 0) do
    begin

      tcl := menu_contribuyente_inexistente();

      if tcl = 1 then
        Readln(nro_contribuyente_modificado);
      arbol_nro_mod := buscar_por_clave(arbol_nro, nro_contribuyente_modificado);
      pos := arbol_nro_mod.indice;
    end;
  if (tcl <> 0) and (tcl <> 2) then // 0 es salir por escape, 2 es salir por opción "volver"
    begin
      // Obtenemos el contribuyente viejo, sin modificar.
      contribuyente_modificado := leer_contribuyente(archivo, pos);
      {// Buscamos las claves.
      clave_nombre := contribuyente_modificado.apellido + ' ' + contribuyente_modificado.nombre;
      clave_dni := contribuyente_modificado.dni;
      // Buscamos los árboles.
      arbol_nombre_mod := buscar_por_clave(arbol_nombre, clave_nombre);
      arbol_dni_mod := buscar_por_clave(arbol_dni, clave_dni);
      // Borramos los árboles.
      borrar_raiz(arbol_nro_mod);
      borrar_raiz(arbol_nombre_mod);
      borrar_raiz(arbol_dni_mod);}
      // Modificamos el contribuyente.
      modificar_contribuyente(contribuyente_modificado, archivo, arbol_nro);
      // Guardamos el contribuente.
      escribir_contribuyente(archivo, contribuyente_modificado, pos);
      {// Obtenemos las nuevas claves.
      nro_contribuyente_modificado := contribuyente_modificado.numero;
      clave_nombre := contribuyente_modificado.apellido + ' ' + contribuyente_modificado.nombre;
      clave_dni := contribuyente_modificado.dni;
      // Añadimos las nuevas claves a los árboles.
      sumar_por_nro(arbol_nro, archivo, pos);
      sumar_por_nombre(arbol_nombre, archivo, pos);
      sumar_por_dni(arbol_dni, archivo, pos);}
      // Creamos los nuevos árboles.
      arbol_nro := arbol_ordenado_por_nro(archivo, cantidad_contribuyentes(archivo_contador));
      arbol_nombre := arbol_ordenado_por_nombres(archivo, cantidad_contribuyentes(archivo_contador));
      arbol_dni := arbol_ordenado_por_dni(archivo, cantidad_contribuyentes(archivo_contador));
    end;

end;

Procedure consulta_contribuyente(var archivo : t_archivo_contribuyentes;
                                 var arbol_nombre : t_arbol;
                                 var arbol_dni : t_arbol);
var
  contribuyente_consultado : t_contribuyente;
  dni_consultado, nombre_contribuyente_consultado : string;
  nombre_consultado, apellido_consultado : string;
  arbol_pos : t_arbol;
  pos, tcl : int16;
begin
  tcl := menu_consulta;
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
        Writeln('DNI: ');
        Readln(dni_consultado);
        arbol_pos := buscar_por_clave(arbol_dni, dni_consultado);
        pos := arbol_pos.indice;
    end;
  end;
  if (tcl <> 3) and (tcl <> 0) then
  begin
    contribuyente_consultado := leer_contribuyente(archivo, pos);
    consultar_contribuyente(contribuyente_consultado);
  end;
end;

end.