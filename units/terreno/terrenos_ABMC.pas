// TODO: cambiar para que funcione solamente con las listas.

Unit terrenos_ABMC;

{$codepage utf8}

Interface

Uses terreno in 'units/terreno/terreno.pas',
     usuario_terrenos in 'units/terreno/usuario_terrenos',
     validacion_entradas in 'units/varios/validacion_entradas.pas',
     contador_datos in 'units/varios/contador_datos.pas',
     arbol in 'units/arbol.pas',
     lista_terrenos in 'units/terreno/lista_terrenos.pas',
     crt, sysutils;

// Pasar archivo de terrenos, archivo contador, arbol por nro de contribuyente, fecha, nro de plano y lista de terrenos.
Procedure alta_terreno(var archivo : t_archivo_terrenos;
                       var archivo_contador : t_archivo_contador;
                       var arbol_nro_contribuyente : t_arbol;
                       var arbol_fecha : t_arbol;
                       var arbol_nro_plano : t_arbol;
                       var lista_terrenos : t_lista_terrenos);

// Pasar archivo de terrenos, archivo contador, arbol por nro de contribuyente, fecha, nro de plano y lista de terrenos.
Procedure baja_terreno(var archivo : t_archivo_terrenos;
                       var archivo_contador : t_archivo_contador;
                       var arbol_nro_contribuyente : t_arbol;
                       var arbol_fecha : t_arbol;
                       var arbol_nro_plano : t_arbol;
                       var lista_terrenos : t_lista_terrenos);

// Pasar archivo de terrenos, archivo contador, arbol por nro de contribuyente, fecha, nro de plano y lista de terrenos.
Procedure mod_terreno(var archivo : t_archivo_terrenos;
                      var archivo_contador : t_archivo_contador;
                      var arbol_nro_contribuyente : t_arbol;
                      var arbol_fecha : t_arbol;
                      var arbol_nro_plano : t_arbol;
                      var lista_terrenos : t_lista_terrenos);

// Pasar archivo de terrenos y árbol ordenado por número de plano.
Procedure consulta_terreno(var archivo : t_archivo_terrenos;
                               arbol : t_arbol);

Implementation

// TODO: cambiar para que funcione solamente con las listas.
Procedure alta_terreno(var archivo : t_archivo_terrenos;
                       var archivo_contador : t_archivo_contador;
                       var arbol_nro_contribuyente : t_arbol;
                       var arbol_fecha : t_arbol;
                       var arbol_nro_plano : t_arbol;
                       var lista_terrenos : t_lista_terrenos);
 var
  terreno_nuevo : t_terreno;
  indice : cardinal;
begin
    indice := cantidad_terrenos(archivo_contador) + 1;
    crear_terreno(archivo, arbol_nro_plano, terreno_nuevo);

    if (terreno_nuevo.nro_contribuyente <> '') then
    begin
    escribir_terreno(archivo, terreno_nuevo, indice);
    contar_terreno(archivo_contador);
    arbol_nro_contribuyente := arbol_ordenado_por_nro_contribuyente(archivo, cantidad_terrenos(archivo_contador));
    arbol_fecha := arbol_ordenado_por_fecha_inscripcion(archivo, cantidad_terrenos(archivo_contador));
    arbol_nro_plano := arbol_ordenado_por_nro_plano(archivo, cantidad_terrenos(archivo_contador));
    // Creamos la lista
    lista_terrenos := lista_terrenos_desde_archivo(archivo,cantidad_terrenos(archivo_contador));
    Writeln('Terreno dado de alta con éxito');
    Readkey;
    end;
end;

Procedure baja_terreno(var archivo : t_archivo_terrenos;
                       var archivo_contador : t_archivo_contador;
                       var arbol_nro_contribuyente : t_arbol;
                       var arbol_fecha : t_arbol;
                       var arbol_nro_plano : t_arbol;
                       var lista_terrenos : t_lista_terrenos);
var
  tcl : int16;
  nro_plano_baja : string;
  arbol_nro_contribuyente_baja, arbol_fecha_baja, arbol_nro_plano_baja : t_arbol;
  pos : byte;
  terreno_baja, ultimo_terreno : t_terreno;
begin
  Writeln('Número de plano: ');
  Readln(nro_plano_baja);
  While ((not limite_caracteres(nro_plano_baja,15)) or (not string_numerica(nro_plano_baja))) do
    begin
      Writeln('El valor ingresado supera los 15 caracteres, ingréselo nuevamente por favor');
      Readln(nro_plano_baja);
    end;
  arbol_nro_plano_baja := buscar_por_clave(arbol_nro_plano, nro_plano_baja);
  pos := arbol_nro_plano_baja.indice;
  While (pos <> 0) and (tcl <> -1) do
    begin
        Writeln('Ya existe un terreno con este numero de plano, que desea hacer?');
        Writeln('1. Ingresar otro numero de plano');
        Writeln('2. Regresar a la pantalla anterior');
        Readln(tcl);
        Case tcl of
            1: Readln(nro_plano_baja);
            2: tcl := -1;
        end;
            arbol_nro_plano_baja := buscar_por_clave(arbol_nro_plano, nro_plano_baja);
            pos := arbol_nro_plano_baja.indice;
    end;
  if tcl <> -1 then
    begin
        // Obtenemos el terreno a dar de baja.
        terreno_baja := leer_terreno(archivo, pos);
        {// Buscamos los árboles.
        arbol_nro_contribuyente_baja := buscar_por_clave(arbol_nro_contribuyente, terreno_baja.nro_contribuyente);
        arbol_fecha_baja := buscar_por_clave(arbol_fecha, terreno_baja.fecha_inscripcion);
        arbol_nro_plano_baja := buscar_por_clave(arbol_nro_plano, terreno_baja.nro_plano);
        // Borramos los árboles.
        borrar_raiz(arbol_nro_contribuyente_baja);
        borrar_raiz(arbol_fecha_baja);
        borrar_raiz(arbol_nro_plano_baja);}
        // Obtenemos el último terreno del archivo.
        ultimo_terreno := leer_terreno(archivo, cantidad_terrenos(archivo_contador));
        // Sobrescribimos el terreno a borrar por el último terreno.
        escribir_terreno(archivo, ultimo_terreno, pos);
        // Disminuímos el tamaño del archivo contador de terrenos.
        restar_terreno(archivo_contador);
        // Creamos los nuevos árboles.
        arbol_nro_contribuyente := arbol_ordenado_por_nro_contribuyente(archivo, cantidad_terrenos(archivo_contador));
        arbol_fecha := arbol_ordenado_por_fecha_inscripcion(archivo, cantidad_terrenos(archivo_contador));
        arbol_nro_plano := arbol_ordenado_por_nro_plano(archivo, cantidad_terrenos(archivo_contador));
        // Creamos una nueva lista.
        lista_terrenos := lista_terrenos_desde_archivo(archivo,cantidad_terrenos(archivo_contador));
        Writeln('Terreno dado de baja con éxito');
        readkey;
    end;         
end;

Procedure mod_terreno(var archivo : t_archivo_terrenos;
                      var archivo_contador : t_archivo_contador;
                      var arbol_nro_contribuyente : t_arbol;
                      var arbol_fecha : t_arbol;
                      var arbol_nro_plano : t_arbol;
                      var lista_terrenos : t_lista_terrenos);
var
  terreno_modificado : t_terreno;
  nro_terreno_modificado : string;
  arbol_nro_contribuyente_mod, arbol_fecha_mod, arbol_nro_plano_mod : t_arbol;
  pos, tcl : int16;
begin
  Writeln('Introduzca el número de plano del terreno que desea modificar: ');
  Readln(nro_terreno_modificado);
  While ((not limite_caracteres(nro_terreno_modificado,15)) or (not string_numerica(nro_terreno_modificado))) do
    begin
        Writeln('El valor ingresado no es un número o supera los 15 caracteres, ingréselo nuevamente por favor');
        Readln(nro_terreno_modificado);
    end;
    arbol_nro_plano_mod := buscar_por_clave(arbol_nro_plano, nro_terreno_modificado);
    pos := arbol_nro_plano_mod.indice;
    // Buscamos si el numero existe ya en el archivo.
  While (pos = 0) and (tcl <> -1) do
        begin
            Writeln('No existe ningún terreno con este número de plano, que desea hacer?');
            Writeln('1. Ingresar otro número de contribuyente');
            Writeln('2. Regresar a la pantalla anterior');
            Readln(tcl);
            Case tcl of
            1: Readln(nro_terreno_modificado);
            2: tcl := -1;
            end;
            arbol_nro_plano_mod := buscar_por_clave(arbol_nro_plano, nro_terreno_modificado);
            pos := arbol_nro_plano_mod.indice;
        end;
  if tcl <> -1 then
        begin
          // Obtenemos el terreno a modificar.
          terreno_modificado := leer_terreno(archivo, pos);
          // Buscamos los árboles.
          {arbol_nro_contribuyente_mod := buscar_por_clave(arbol_nro_contribuyente, terreno_modificado.nro_contribuyente);
          arbol_fecha_mod := buscar_por_clave(arbol_fecha, terreno_modificado.fecha_inscripcion);
          arbol_nro_plano_mod := buscar_por_clave(arbol_nro_plano, terreno_modificado.nro_plano);
          // Borramos los árboles.
          borrar_raiz(arbol_nro_contribuyente_mod);
          borrar_raiz(arbol_fecha_mod);
          borrar_raiz(arbol_nro_plano_mod);}
          // Modificamos el terreno.
          modificar_terreno(terreno_modificado, archivo, arbol_nro_plano);
          // Guardamos el terreno modificado en el archivo.
          escribir_terreno(archivo, terreno_modificado, pos);
          {// Agregamos el terreno a los árboles.
          sumar_por_nro_contribuyente(arbol_nro_contribuyente, archivo, pos);
          sumar_por_fecha_inscripcion(arbol_fecha, archivo, pos);
          sumar_por_nro_plano(arbol_nro_plano, archivo, pos); }
          // Creamos los nuevos árboles.
          arbol_nro_contribuyente := arbol_ordenado_por_nro_contribuyente(archivo, cantidad_terrenos(archivo_contador));
          arbol_fecha := arbol_ordenado_por_fecha_inscripcion(archivo, cantidad_terrenos(archivo_contador));
          arbol_nro_plano := arbol_ordenado_por_nro_plano(archivo, cantidad_terrenos(archivo_contador));
          // Creamos una nueva lista.
          lista_terrenos := lista_terrenos_desde_archivo(archivo,cantidad_terrenos(archivo_contador));
          Writeln('Terreno modificado con éxito');
          readkey;    
        end;

end;

Procedure consulta_terreno(var archivo : t_archivo_terrenos; arbol : t_arbol);
var
  terreno_consultado : t_terreno;
  nro_plano_consultado : string;
  arbol_pos : t_arbol;
  pos, tcl : int16;
begin
  Writeln('Número de plano: ');
  Readln(nro_plano_consultado);
  arbol_pos := buscar_por_clave(arbol, nro_plano_consultado);
  pos := arbol_pos.indice;
  
  terreno_consultado := leer_terreno(archivo, pos);
  consultar_terreno(terreno_consultado);
end;

end.