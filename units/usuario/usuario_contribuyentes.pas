unit usuario;

interface

    uses contribuyente in 'units/contribuyente.pas';

implementation

    // Retorna verdadero si un caracter es numérico.
    function caracter_numerico(caracter : char): boolean;
    begin
        caracter_numerico := (('0' <= caracter) and (caracter <= '9'));
    end;

    // Retorna verdadero si una string es numérica.
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

    // TODO: hacer bello.
    // Pide una entrada al usuario.
    // Verifica si cumple el límite de caracteres.
    // Verifica si es numerico en caso de ser necesario.
    // Repite hasta obtener una entrada válida.
    function leer_entrada(mensaje : string; limite_caracteres : byte; numerico : boolean): string;
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
            if length(leer_entrada) > limite_caracteres then
                valido := false;
        until (valido);
    end;

// TODO:
// function crear_contribuyente(): t_contribuyente;
// procedure borrar_contribuyente();
// procedure modificar_contribuyente();
// procedure consultar_contribuyente();

end.