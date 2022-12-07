unit usuario;1

{ Unidad de tipo de interacción con usuario del submenú de contribuyentes. }

{--------------------------------}

interface

    uses contribuyente in 'units/contribuyente.pas',
         manejo_cadena_fechas in 'units/manejo_cadena_fechas.pas';

{--------------------------------}

implementation

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

// TODO:
// function crear_contribuyente(): t_contribuyente;
// procedure borrar_contribuyente();
// procedure modificar_contribuyente();
// procedure consultar_contribuyente();

end.