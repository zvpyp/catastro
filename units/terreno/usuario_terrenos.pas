unit usuario_terrenos;

//TODO:
// Hacer procedimiento borrar_terreno
// Verificar que 'superficie' sea un número real.
// Verificar que 'zona' y 'tipo_edificacion' sean enteros del 1 al 5.
// Hacer árbol de terrenos por nro de plano, para evitar duplicados.
// Mejorar el diseño de todos los Writeln de estos procedimientos.

{ Unidad de tipo de interacción con usuario del submenú de terrenos. }

{--------------------------------}

interface

    uses terreno in 'units/terreno.pas',
         validacion_entradas in 'units/validacion_entradas.pas',
         arbol in 'units/arbol/arbol.pas',
         crt;

// Crea un terreno.
Function crear_terreno(archivo : t_archivo_terrenos; arbol : t_arbol): t_terreno;

Procedure borrar_terreno(var terreno : t_terreno);

Procedure modificar_terreno(var terreno : t_terreno);

Procedure consultar_terreno(var terreno : t_terreno; archivo : t_archivo_terrenos; arbol : t_arbol);

{--------------------------------}

implementation

// Pasar árbol ordenado por nro de plano y archivo de terrenos.
Function crear_terreno(archivo : t_archivo_terrenos; arbol : t_arbol): t_terreno;
var
tcl, pos : byte;
arbol_pos : t_arbol;
nro_contribuyente, nro_plano, fecha_inscripcion, domicilio_parcelario, superficie : string;
avaluo, superficie, valor_m2, porc_zona, porc_edif : real;
zona, tipo_edificacion : 1..5;
begin
  valor_m2 := 12308.6;
  tlc := 1;
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
        While pos = 0 then
          begin
            Writeln('Ya existe un terreno con este numero de plano, que desea hacer?')
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
        Writeln('Fecha de inscripción (dd/mm/aaaa):'); // Cambiar es_fecha_valida pq acepta aaaa/mm/dd
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

        crear_terreno.nro_contribuyente := nro_contribuyente;
        crear_terreno.nro_plano := nro_plano;
        crear_terreno.avaluo := avaluo;
        crear_terreno.fecha_inscripcion := fecha_inscripcion;
        crear_terreno.domicilio_parcelario := domicilio_parcelario;
        crear_terreno.superficie := superficie;
        crear_terreno.zona := zona;
        crear_terreno.tipo_edificacion := tipo_edificacion;
      end;
    end;
    tcl := tcl + 1;
  end;
end;

Procedure borrar_terreno(var terreno : t_terreno); // Acomodar para terrenos
begin
  // Hay que ver como hacer esto
end;

Procedure modificar_terreno(var terreno : t_terreno); // Acomodar para terrenos
var
tcl, pos : byte;
arbol_pos : t_arbol;
nro_contribuyente, nro_plano, fecha_inscripcion, domicilio_parcelario, superficie : string;
avaluo, superficie, porc_zona, porc_edif, valor_m2 : real;
zona, tipo_edificacion : 1..5;
begin
valor_m2 := 12308.6;
  While ((tcl <> 0) and (tcl < 8)) do
  begin
      Writeln('¿Qué desea modificar?')
      Writeln('0. Cancelar');
      Writeln('1. Número de contribuyente');
      Writeln('2. Número de plano');
      Writeln('3. Fecha de inscripción');
      Writeln('4. Domicilio parcelario');
      Writeln('5. Superficie');
      Writeln('6. Zona');
      Writeln('7. Tipo de edificación');
      Readln(tcl);
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
                  While pos = 0 then
                    begin
                      Writeln('Ya existe un terreno con este numero de plano, que desea hacer?')
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
                  end;
                terreno.nro_plano := nro_plano;
            end;
            3:
            begin
                Writeln('Fecha de inscripción (dd/mm/aaaa):'); // Cambiar es_fecha_valida pq acepta aaaa/mm/dd
                Readln(fecha_inscripcion);
                While (not es_fecha_valida(fecha_inscripcion)) do
                begin
                    Writeln('El valor ingresado no cumple con el formato, recuerde que debe ser dd/mm/aaaa, por ejemplo: 23/07/2020');
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
        end;
    end;
end;

Procedure consultar_terreno(terreno : t_terreno); // Acomodar para terrenos
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