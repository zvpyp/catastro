unit usuario_terrenos;

{$codepage utf8}

//TODO:
// Hacer procedimiento borrar_terreno
// Verificar que 'superficie' sea un número real.
// Verificar que 'zona' y 'tipo_edificacion' sean enteros del 1 al 5.
// Hacer árbol de terrenos por nro de plano, para evitar duplicados.
// Mejorar el diseño de todos los Writeln de estos procedimientos.

{ Unidad de tipo de interacción con usuario del submenú de terrenos. }

{--------------------------------}

interface

    uses terreno in 'units/terreno/terreno.pas',
         validacion_entradas in 'units/varios/validacion_entradas.pas',
         arbol in 'units/arbol/arbol.pas',
         u_menu in 'units/u_menu.pas',
         crt;

// Crea un terreno.
Procedure crear_terreno(var archivo : t_archivo_terrenos; var arbol : t_arbol; var nuevo_terreno : t_terreno);

Procedure modificar_terreno(var terreno : t_terreno; var archivo : t_archivo_terrenos; var arbol : t_arbol);

Procedure consultar_terreno(var terreno : t_terreno);

{--------------------------------}

implementation

// Pasar árbol ordenado por nro de plano y archivo de terrenos.
Procedure crear_terreno(var archivo : t_archivo_terrenos; var arbol : t_arbol; var nuevo_terreno : t_terreno);
var
  tcl, pos : int16;
  arbol_pos : t_arbol;
  nro_contribuyente, nro_plano, fecha_inscripcion, domicilio_parcelario: string;
  avaluo, superficie, valor_m2, porc_zona, porc_edif : real;
  zona, tipo_edificacion : 1..5;
begin
  valor_m2 := 12308.6;
  tcl := 1;
  While ((tcl <> 0) and (tcl < 9)) do
  begin
    Case tcl of
      1:
      begin
        Writeln('Número de contribuyente:');
        Readln(nro_contribuyente);
        While ((not limite_caracteres(nro_contribuyente,15)) or (not string_numerica(nro_contribuyente))) do
        begin
        Writeln('El valor ingresado no es un número o supera los 15 caracteres, ingréselo nuevamente por favor');
        Readln(nro_contribuyente);
        end;
      end;
      2:
      begin
        Writeln('Número de plano:');
        Readln(nro_plano);
        While ((not limite_caracteres(nro_plano,15)) or (not string_numerica(nro_plano))) do
          begin
          Writeln('El valor ingresado supera los 15 caracteres, ingréselo nuevamente por favor');
          Readln(nro_plano);
          end;
        // Buscamos si el numero existe ya en el archivo.
          arbol_pos := buscar_por_clave(arbol, nro_plano);
          pos := arbol_pos.indice;
        While (pos <> 0) and (tcl <> -1) do
          begin
            Writeln('Ya existe un terreno con este numero de plano, que desea hacer?');
            Writeln('1. Ingresar otro numero de plano');
            Writeln('2. Regresar a la pantalla anterior');
            Readln(tcl);
            Case tcl of
            1: Readln(nro_plano);
            2: tcl := -1;
            end;
            arbol_pos := buscar_por_clave(arbol, nro_plano);
            pos := arbol_pos.indice;
          end;
        end;
      3:
      begin
        Writeln('Fecha de inscripción (aaaa-mm-dd):');
        Readln(fecha_inscripcion);
        While (not es_fecha_valida(fecha_inscripcion)) do
          begin
            Writeln('El valor ingresado no cumple con el formato, recuerde que debe ser dd/mm/aaaa, por ejemplo: 23/07/2020');
            Readln(fecha_inscripcion);
          end;
      end;
      4:
      begin
        Writeln('Domicilio parcelario:');
        Readln(domicilio_parcelario);
        While (not limite_caracteres(domicilio_parcelario,30)) do
          begin
            Writeln('El valor ingresado supera los 30 caracteres, ingréselo nuevamente por favor');
            Readln(domicilio_parcelario);
          end;
      end;
      5:
      begin
        Writeln('Superficie (en m2): ');
        Readln(superficie);
        // Verificar que sea un número
      end;
      6:
      begin
        Writeln('Zona (1 a 5): ');
        Readln(zona);
        // Verificar que sea un nro entero del 1 al 5
      end;
      7:
      begin
        Writeln('Tipo de edificación (1 a 5): ');
        Readln(tipo_edificacion);
        // Verificar que sea un nro entero del 1 al 5
      end;
      8:
      begin
        case zona of
            1: porc_zona := 1.5;
            2: porc_zona := 1.1;
            3: porc_zona := 0.7;
            4: porc_zona := 0.4;
            5: porc_zona := 0.1;
        end;
        case tipo_edificacion of
            1: porc_edif := 1.7;
            2: porc_edif := 1.3;
            3: porc_edif := 1.1;
            4: porc_edif := 0.8;
            5: porc_edif := 0.5;
        end;
        avaluo := (valor_m2 * superficie * porc_zona * porc_edif);

        nuevo_terreno.nro_contribuyente := nro_contribuyente;
        nuevo_terreno.nro_plano := nro_plano;
        nuevo_terreno.avaluo := avaluo;
        nuevo_terreno.fecha_inscripcion := fecha_inscripcion;
        nuevo_terreno.domicilio_parcelario := domicilio_parcelario;
        nuevo_terreno.superficie := superficie;
        nuevo_terreno.zona := zona;
        nuevo_terreno.tipo_edificacion := tipo_edificacion;
      end;
    end;
    tcl := tcl + 1;
  end;
  if tcl = 0 then
    begin
      nuevo_terreno.nro_contribuyente := '-1';
    end;
end;

Procedure modificar_terreno(var terreno : t_terreno; var archivo : t_archivo_terrenos; var arbol : t_arbol);
var
  tcl, pos : byte;
  arbol_pos : t_arbol;
  nro_contribuyente, nro_plano, fecha_inscripcion, domicilio_parcelario: string;
  avaluo, superficie, porc_zona, porc_edif, valor_m2 : real;
  zona, tipo_edificacion : 1..5;
begin
  valor_m2 := 12308.6;
  repeat
    tcl := menu_modificar_terreno();

    Case tcl of
        1:
        begin
            Writeln('Número de contribuyente:');
            Readln(nro_contribuyente);
            While ((not limite_caracteres(nro_contribuyente,15)) or (not string_numerica(nro_contribuyente))) do
            begin
                Writeln('El valor ingresado no es un número o supera los 15 caracteres, ingréselo nuevamente por favor');
                Readln(nro_contribuyente);
            end;
            terreno.nro_contribuyente := nro_contribuyente;
        end;
          2:
          begin
              Writeln('Número de plano:');
              Readln(nro_plano);
              While ((not limite_caracteres(nro_plano,15)) or (not string_numerica(nro_plano))) do
                begin
                  Writeln('El valor ingresado supera los 15 caracteres, ingréselo nuevamente por favor');
                  Readln(nro_plano);
                end; // Verificar que el numero de plano sea único.
              arbol_pos := buscar_por_clave(arbol, nro_plano);
              pos := arbol_pos.indice;
              While pos = 0 do
                  begin
                    Writeln('Ya existe un terreno con este número de plano, que desea hacer?');
                    Writeln('1. Ingresar otro numero de plano');
                    Writeln('2. Regresar a la pantalla anterior');
                    Readln(tcl);
                    Case tcl of
                    1: Readln(nro_plano);
                    2: tcl := 0;
                    end;
                    arbol_pos := buscar_por_clave(arbol, nro_plano);
                    pos := arbol_pos.indice;
                  end;
              terreno.nro_plano := nro_plano;
          end;
          3:
          begin
              Writeln('Fecha de inscripción (aaaa-mm-dd):');
              Readln(fecha_inscripcion);
              While (not es_fecha_valida(fecha_inscripcion)) do
              begin
                  Writeln('El valor ingresado no cumple con el formato, recuerde que debe ser aaaa-mm-dd, por ejemplo: 2002-07-23');
                  Readln(fecha_inscripcion);
              end;
              terreno.fecha_inscripcion := fecha_inscripcion;
          end;
          4:
          begin
              Writeln('Domicilio parcelario:');
              Readln(domicilio_parcelario);
              While (not limite_caracteres(domicilio_parcelario,30)) do
              begin
                  Writeln('El valor ingresado supera los 30 caracteres, ingréselo nuevamente por favor');
                  Readln(domicilio_parcelario);
              end;
              terreno.domicilio_parcelario := domicilio_parcelario;
          end;
          5:
          begin
              Writeln('Superficie (en m2): ');
              Readln(superficie);
              // Verificar que sea un número

              terreno.superficie := superficie;
          end;
          6:
          begin
              Writeln('Zona (1 a 5): ');
              Readln(zona);
              // Verificar que sea un nro entero del 1 al 5
          end;
          7:
          begin
              Writeln('Tipo de edificación (1 a 5): ');
              Readln(tipo_edificacion);
              // Verificar que sea un nro entero del 1 al 5
          end;
    end;
    begin
        case terreno.zona of
            1: porc_zona := 1.5;
            2: porc_zona := 1.1;
            3: porc_zona := 0.7;
            4: porc_zona := 0.4;
            5: porc_zona := 0.1;
        end;
        case terreno.tipo_edificacion of
            1: porc_edif := 1.7;
            2: porc_edif := 1.3;
            3: porc_edif := 1.1;
            4: porc_edif := 0.8;
            5: porc_edif := 0.5;
        end;
        terreno.avaluo := (valor_m2 * superficie * porc_zona * porc_edif);
    end;
  until ((tcl = 0) or (tcl = 8)); // Opciones de salir según menu_modificar_terreno
end;

Procedure consultar_terreno(var terreno : t_terreno);
begin
      Writeln('Número de contribuyente: ',terreno.nro_contribuyente);
      Writeln('Número de plano: ',terreno.nro_plano);
      Writeln('Avalúo: ',terreno.avaluo);
      Writeln('Fecha de inscripción: ',terreno.fecha_inscripcion);
      Writeln('Domicilio parcelario: ',terreno.domicilio_parcelario);
      Writeln('Superficie: ',terreno.superficie);
      Writeln('Zona: ',terreno.zona);
      Writeln('Tipo de edificación: ',terreno.tipo_edificacion);
      ReadKey;
end;
end.