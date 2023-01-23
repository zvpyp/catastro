unit validacion_entradas;

{$codepage utf8}

{ Unidad de funciones de manejo de cadenas de caracteres y manejo de fechas. }

{--------------------------------}

interface

uses sysutils, crt;

    // Pide una entrada al usuario.
    // Verifica si cumple el límite de caracteres.
    // Verifica si es numerico en caso de ser necesario.
    // Repite hasta obtener una entrada válida.
    // TIPOS:
    //      -normal : alfanumérico, sin restricciones de tipo
    //      -natural : Acepta solamente números naturales.
    //      -real_positivo : acepta solamente números reales positivos. Se utiliza punto como separador decimal.
    function leer_entrada(mensaje : string; limite : byte; tipo : string): string;

    // Pide una fecha al usuario. Continúa una vez ingresada una fecha válida.
    function leer_fecha(mensaje : string): string;

    // Muestra un mensaje al usuario. No retorna hasta que elija s o n.
    function leer_si_no(mensaje : string): string;

    // Pide al usuario que presione cualquier tecla.
    procedure pedir_tecla();

    // Escribe el mensaje dado en las coordenadas indicadas.
    procedure escribir_xy(mensaje : string; x : byte; y : byte);

{--------------------------------}

implementation

    // Retorna verdadero si un caracter es numérico.
    // Incluye puntos.
    function caracter_numerico(caracter : char): boolean;
    begin
        caracter_numerico := (('0' <= caracter) and (caracter <= '9')) or (caracter = '.');
        // TEST:
        {writeln('caracter ingresado: ', caracter);
        writeln('es numérico/punto: ', caracter_numerico);
        readkey;}
    end;

    // retorna verdadero si una string es un número entero.
    function string_numerica(entrada : string; positivo : boolean; numero_real : boolean): boolean;
    var
        i : byte;
        primer_digito : byte;
        limite_puntos : 0..1; // cantidad de puntos que puede tener la string.
        puntos : byte; // contador de la cantidad de puntos.
    begin
        puntos := 0;
        string_numerica := true;

        if numero_real then
            limite_puntos := 1
        else
            limite_puntos := 0;

        // caso del primer carácter.
        if positivo then
            primer_digito := 1 // marca que el primer dígito está en la posición 1.
        else
        begin
            // caso de que permita negativos
            if (entrada[1] = '-') then
                primer_digito := 2; // marca que el primer dígito está en la posición 2.
        end;

        for i := primer_digito to length(entrada) do
        begin
            if not(caracter_numerico(entrada[i])) then
                string_numerica := false
            else if entrada[i] = '.' then
                puntos := puntos + 1;
        end;

        if puntos > limite_puntos then
            string_numerica := false;
    end;

    function limite_caracteres(entrada : string; limite : byte): boolean;
    begin
        limite_caracteres := length(entrada) <= limite;
    end;

    // Retorna verdadero si la string es del formato aaaa-mm-dd o aaaa/mm/dd
    function es_formato_fecha(entrada : string): boolean;
    var
        anio : string[4];
        mes, dia : string[2];
    begin
        es_formato_fecha := true;

        // Chequea el largo y crea variables de año, mes y día.
        if length(entrada) = 10 then
        begin
            anio := copy(entrada, 1, 4);
            mes := copy(entrada, 6, 2);
            dia := copy(entrada, 10);
        end
        else
            es_formato_fecha := false;

        // Chequea que el año, mes y día sean numéricos
        if not(string_numerica(anio, true, false) and string_numerica(mes, true, false) and string_numerica(dia, true, false)) then
            es_formato_fecha := false;
        
        // Chequea que los separadores sean '-' o '/'
        if not((entrada[5] = entrada[8]) and ((entrada[5] = '-') or (entrada[5] = '/'))) then
            es_formato_fecha := false;
    end;

    // Retorna verdadero si un año del formato aaaa es bisiesto.
    // Se asume que la variable ingresada siempre será numérica, no negativa y de caracteres exactos.
    function es_bisiesto(anio : string): boolean;
    var
        anio_int : cardinal;
    begin
        es_bisiesto := false;

        anio_int := StrToInt(anio);

        // Caso de año secular (divisible por 100)
        if (anio_int mod 100) = 0 then
        begin
            if (anio_int mod 400) = 0 then
                es_bisiesto := true;
        end
        // Caso de año no secular
        else
        begin
            if (anio_int mod 4) = 0 then
                es_bisiesto := true;
        end;
    end;

    // Retorna verdadero si un mes del forma mm es válido.
    // Se asume que la variable ingresada siempre será numérica, no negativa y de caracteres exactos.
    function es_mes_valido(mes : string): boolean;
    begin
        es_mes_valido := false;

        if (StrToInt(mes) >= 1) and (StrToInt(mes) <= 12) then
            es_mes_valido := true;
    end;

    // Retorna verdadero si el mes posee 31 días.
    // Se asume que la variable ingresada siempre será numérica, no negativa y de caracteres exactos.
    function mes_de_31(mes : string): boolean;
    var
        mes_int : cardinal;
    begin
        mes_de_31 := false;

        mes_int := StrToInt(mes);

        if (mes_int = 1) or (mes_int = 3) or (mes_int = 5) or
           (mes_int = 7) or (mes_int = 10) or (mes_int = 12) then
                mes_de_31 := true;
    end;

    // Retorna verdadero si un mes del forma dd es válido, basado en mes y año.
    // Se asume que la variable ingresada siempre será numérica, no negativa y de caracteres exactos.
    function es_dia_valido(dia : string; mes : string; anio : string): boolean;
    var
        dia_int : cardinal;
    begin
        es_dia_valido := false;

        dia_int := StrToInt(dia);

        // Febrero
        if StrToInt(mes) = 2 then
        begin
            if es_bisiesto(anio) and (dia_int <= 29) then
                es_dia_valido := true
            else
            begin
                if dia_int <= 28 then
                    es_dia_valido := true;
            end;
        end
        else
        begin
            // Meses con 31 días
            if mes_de_31(mes) then
            begin
                if dia_int <= 31 then
                    es_dia_valido := true;
            end
            // Meses con 30 días
            else
            begin
                if dia_int <= 30 then
                    es_dia_valido := true;
            end;
        end;
    end;

    function es_fecha_valida(entrada : string): boolean;
    var
        dia, mes, anio : string;
    begin
        es_fecha_valida := true;

        // Verifica que el formato sea correcto
        if es_formato_fecha(entrada) then
        begin
            anio := copy(entrada, 1, 4);
            mes := copy(entrada, 6, 2);
            dia := copy(entrada, 10);

            // Verifica mes válido
            if not(es_mes_valido(mes)) then
                es_fecha_valida := false;

            // Verifica día válido
            if not(es_dia_valido(dia, mes, anio)) then
                es_fecha_valida := false;
        end
        else
            es_fecha_valida := false;
    end;

    // TODO: hacer bello.
    function leer_entrada(mensaje : string; limite : byte; tipo : string): string;
    var
        valido : boolean;
        restricciones : string;
    begin
        restricciones := 'hasta ' + IntToStr(limite) + ' caracteres';
        
        if (tipo = 'normal') or (tipo = 'real_positivo') then
            restricciones := 'hasta ' + IntToStr(limite) + ' caracteres';
        if (tipo = 'natural') then
            restricciones := 'hasta ' + IntToStr(limite) + ' dígitos';

        repeat
            write(mensaje, '(', restricciones, '): ');

            valido := true;

            readln(leer_entrada);
            Writeln;
            // tipos numéricos
            case tipo of
                'natural':          begin
                                        if not(string_numerica(leer_entrada, true, false)) then
                                            valido := false;
                                    end;

                'real_positivo':    begin
                                        if not(string_numerica(leer_entrada, true, true)) then
                                            valido := false;
                                    end;
            end;
            
            // Verifica el límite de caracteres.
            if not(limite_caracteres(leer_entrada, limite)) then
                valido := false;
        until (valido and (length(leer_entrada) >= 1));
    end;

    function leer_fecha(mensaje : string): string;
    begin
        repeat
            write(mensaje, ' (AAAA-MM-DD): ');
            readln(leer_fecha);
            Writeln;
        until (es_fecha_valida(leer_fecha));
    end;

    function leer_si_no(mensaje : string): string;
    begin
        repeat
            clrscr;
            writeln(mensaje, ' (s/n)');
            leer_si_no := readkey;
            leer_si_no := lowercase(leer_si_no);
            
        until ((leer_si_no = 's') or (leer_si_no = 'n'));
    end;


    procedure pedir_tecla();
    begin
        writeln('');
        writeln('Presione una tecla para continuar...');
        readkey;
        clrscr;
    end;

    procedure escribir_xy(mensaje : string; x : byte; y : byte);
    begin
      gotoxy(x,y);
      writeln(mensaje);
    end;
end.
