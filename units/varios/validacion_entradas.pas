unit validacion_entradas;

{ Unidad de funciones de manejo de cadenas de caracteres y manejo de fechas. }

{--------------------------------}

interface

    // Retorna verdadero si una string solo contiene caracteres numéricos.
    function string_numerica(entrada : string): boolean;

    // Retorna verdadero si la string no supera un límite de caracteres.
    function limite_caracteres(entrada : string, limite : byte): boolean;

    // Retorna verdadero si la string es una fecha valida
    function es_fecha_valida(entrada : string): boolean;

{--------------------------------}

implementation

    // Retorna verdadero si un caracter es numérico.
    function caracter_numerico(caracter : char): boolean;
    begin
        caracter_numerico := (('0' <= caracter) and (caracter <= '9'));
    end;

    function string_numerica(entrada : string): boolean;
    var
        i : byte;
    begin
        string_numerica := true;

        for i := 1 to length(entrada) do
        begin
            if not(caracter_numerico(entrada[i])) then
                string_numerica := false;
        end;
    end;

    function limite_caracteres(entrada : string, limite : byte): boolean;
    begin
        limite_caracteres := length(entrada) <= limite;
    end;

    // Retorna verdadero si la string es del formato aaaa-mm-dd o aaaa/mm/dd
    function es_formato_fecha(entrada : string): boolean;
    var
        ano : string[4];
        mes, dia : string[2];
    begin
        es_formato_fecha := true;

        // Chequea el largo y crea variables de año, mes y día.
        if length(entrada) = 10 then
        begin
            ano := copy(entrada, 1, 4);
            mes := copy(entrada, 6, 2);
            dia := copy(entrada, 10);
        end
        else
            es_formato_fecha := false;

        // Chequea que el año, mes y día sean numéricos
        if not(string_numerica(ano) and string_numerica(mes) and string_numerica(dia)) then
            es_formato_fecha := false;
        
        // Chequea que los separadores sean '-' o '/'
        if not((entrada[5] = entrada[8]) and ((string[5] = '-') or (string[5] = '/'))) then
            es_formato_fecha := false;
    end;

    // Retorna verdadero si un año del formato aaaa es bisiesto.
    // Se asume que la variable ingresada siempre será numérica, no negativa y de caracteres exactos.
    function es_bisiesto(ano : string): boolean;
    var
        ano_int := cardinal;
    begin
        es_bisiesto := false;

        ano_int := StrToInt(ano);

        // Caso de año secular (divisible por 100)
        if (ano_int mod 100) = 0 then
        begin
            if (ano_int mod 400) = 0 then
                es_bisiesto := true;
        end;
        // Caso de año no secular
        else
        begin
            if (ano_int mod 4) = 0 then
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
    function es_dia_valido(dia : string; mes : string; ano : string): boolean;
    var
        dia_int : cardinal;
    begin
        es_dia_valido := false;

        dia_int := StrToInt(dia);

        // Febrero
        if StrToInt(mes) = 2 then
        begin
            if es_bisiesto(ano) and (dia_int <= 29) then
                es_dia_valido := true;
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
        dia, mes, ano : string;
    begin
        es_fecha_valida := true;

        // Verifica que el formato sea correcto
        if es_formato_fecha(entrada) then
        begin
            ano := copy(entrada, 1, 4);
            mes := copy(entrada, 6, 2);
            dia := copy(entrada, 10);

            // Verifica mes válido
            if not(es_mes_valido(mes)) then
                es_fecha_valida := false;

            // Verifica día válido
            if not(es_dia_valido(dia, mes ano)) then
                es_fecha_valida := false;
        end
        else
            es_fecha_valida := false;
    end;

    // TODO: hacer bello.
    // Pide una entrada al usuario.
    // Verifica si cumple el límite de caracteres.
    // Verifica si es numerico en caso de ser necesario.
    // Repite hasta obtener una entrada válida.
    function leer_entrada(mensaje : string; limite : byte; numerico : boolean): string;
    var
        valido : boolean;
    begin
        repeat
            clrscr;
            writeln(mensaje);

            valido := true;

            readln(leer_entrada);

            // Verifica si es numérico en caso de ser necesario.
            if (numerico) and not(string_numerica(leer_entrada)) then
                valido := false;
            
            // Verifica el límite de caracteres.
            if not(limite_caracteres(leer_entrada, limite)) then
                valido := false;
        until (valido);
    end;
end.