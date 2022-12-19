// Falta agregar que en alta y modificación también se modifique el árbol, para no generarlo de 0 todas las veces.


Unit terrenos_ABMC;

Interface

Uses terreno in 'units/terreno/terreno.pas',
     usuario_terrenos in 'units/terreno/usuario_terrenos',
     validacion_entradas in 'units/varios/validacion_entradas.pas',
     contador_datos in 'units/varios/contador_datos.pas',
     arbol in 'units/arbol/arbol.pas',
     crt, sysutils;

// Pasar archivo de terrenos y arbol ordenado por nro de contribuyente.
Procedure alta_terreno(var archivo : t_archivo_terrenos; var arbol : t_arbol; var archivo_contador : t_archivo_contador);

// Pasar archivo de terrenos y arbol ordenado por nro de contribuyente.
Procedure baja_terreno(var archivo : t_archivo_terrenos; var arbol : t_arbol);

// Pasar arbol ordenado por nro de plano y archivo de terrenos.
Procedure mod_terreno(var archivo : t_archivo_terrenos);

Procedure consulta_terreno(var archivo : t_archivo_terrenos; arbol : t_arbol);

Implementation

// Agregar que se modifique el arbol.
Procedure alta_terreno(var archivo : t_archivo_terrenos; var arbol : t_arbol; var archivo_contador : t_archivo_contador);
var
terreno_nuevo : t_terreno;
begin
    abrir_archivo_terrenos(archivo);

    crear_terreno(archivo, arbol, terreno_nuevo);

    abrir_archivo_contador(archivo_contador);

    if (terreno_nuevo.numero <> '') then
    escribir_terreno(archivo, terreno_nuevo, cantidad_terrenos(archivo_contador));
end;

Procedure baja_terreno(var archivo : t_archivo_terrenos; var arbol : t_arbol);
var
begin
  
end;

// Pasar arbol ordenado por nro de plano y archivo de terrenos.
Procedure mod_terreno(var archivo : t_archivo_terrenos, var arbol : t_arbol);
var
terreno_modificado : t_contribuyente;
nro_terreno_modificado : string;
arbol_pos : t_arbol;
pos, tcl : int16;
begin
  abrir_archivo_contribuyentes(archivo);

  Writeln('Introduzca el número de plano del terreno que desea modificar: ');
  Readln(nro_terreno_modificado);
  While ((not limite_caracteres(nro_terreno_modificado,15)) or (not string_numerica(nro_terreno_modificado))) do
    begin
        Writeln('El valor ingresado no es un número o supera los 15 caracteres, ingréselo nuevamente por favor');
        Readln(nro_terreno_modificado);
    end;
    arbol_pos := buscar_por_clave(arbol, nro_terreno_modificado);
    pos := arbol_pos.indice;
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
            arbol_pos := buscar_por_clave(arbol, nro_terreno_modificado);
            pos := arbol_pos.indice;
        end;
          if tcl <> -1 then
            begin
                terreno_modificado := leer_terreno(archivo, pos);
                modificar_terreno(terreno_modificado, archivo, arbol);
                escribir_terreno(archivo, terreno_modificado, pos);
            end;
        cerrar_archivo_terrenos(archivo);

end;

Procedure consulta_terreno(var archivo : t_archivo_terrenos; arbol : t_arbol);
var
terreno_consultado : t_terreno;
nro_plano_consultado : string;
arbol_pos : t_arbol;
pos, tcl : int16;
begin
  abrir_archivo_terrenos(archivo);
  Writeln('Número de plano: ')
  Readln(nro_plano_consultado);
  arbol_pos := buscar_por_clave(arbol, nro_plano_consultado);
  pos := arbol_pos.indice;
  
  terreno_consultado := leer_terreno(archivo, pos);
  consultar_terreno(terreno_consultado);
  cerrar_archivo_terrenos(archivo);
end;

end.