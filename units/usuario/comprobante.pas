unit comprobante;
{$codepage utf8}

interface

uses
    terreno in 'units/terreno/terreno.pas',
    validacion_entradas in 'units/varios/validacion_entradas.pas',
    lista_terrenos in 'units/terreno/lista_terrenos.pas',
    crt;

    // Obtiene la lista de terrenos. Pide un número de plano y muestra el comprobante si existe.
    procedure consultar_comprobante(lista : t_lista_terrenos);

implementation

    procedure mostrar_comprobante(terreno:t_terreno);
    var
        i:byte;
    begin
        clrscr;
        for i:=1 to 27 do
        begin
            gotoxy(3,i);
            write('|');
            gotoxy(76,i);
            write('|');
        end;
        gotoxy(4,1);
        writeln('-----------------------------------------------------------------------');
        gotoxy(4,27);
        writeln('-----------------------------------------------------------------------');
        gotoxy(16,3);
        write('COMPROBANTE DE REGISTRACION DEL ESTADO PARCELARIO');
        gotoxy(4,6);
        writeln('-----------------------------------------------------------------------');
        gotoxy(5,9);
        write('Fecha de Registración');
        gotoxy(30,9);
        write(terreno.fecha_inscripcion);
        gotoxy(4,11);
        writeln('-----------------------------------------------------------------------');
        gotoxy(5,13);
        write('N° Contribuyente: ');
        gotoxy(24,13);
        write(terreno.nro_contribuyente);
        gotoxy(40,12);
        writeln('|');
        gotoxy(40,13);
        writeln('|');
        gotoxy(40,14);
        writeln('|');
        gotoxy(47,13);
        write('N° Plano: ');
        gotoxy(60,13);
        write(terreno.nro_plano);
        gotoxy(4,15);
        writeln('-----------------------------------------------------------------------');
        gotoxy(5,17);
        write('Avaluo: ');
        gotoxy(15,17);
        write(terreno.avaluo:7:2);
        gotoxy(40,16);
        writeln('|');
        gotoxy(40,17);
        writeln('|');
        gotoxy(40,18);
        writeln('|');
        gotoxy(47,17);
        write('Superficie: ');
        gotoxy(60,17);
        write(terreno.superficie:7:2);
        gotoxy(4,19);
        writeln('-----------------------------------------------------------------------');
        gotoxy(5,21);
        write('Domicilio Parcelario: ');
        gotoxy(29,21);
        write(terreno.domicilio_parcelario);
        gotoxy(4,23);
        writeln('-----------------------------------------------------------------------');
        gotoxy (5,25);
        write('Zona: ');
        gotoxy (13,25);
        write(terreno.zona);
        gotoxy(40,24);
        writeln('|');
        gotoxy(40,25);
        writeln('|');
        gotoxy(40,26);
        writeln('|');
        gotoxy(47,25);
        write('Tipo de edificación: ');
        gotoxy(71,25);
        write(terreno.tipo_edificacion);
        readkey;
        clrscr;
    end;

    procedure consultar_comprobante(lista : t_lista_terrenos);
    var
        terreno_actual : t_terreno;
        nro_plano : string;
    begin
        clrscr;
        repeat
            
            writeln('Escriba el número de plano (15 dígitos como máximo)');
            readln(nro_plano);

            clrscr;
        until (string_numerica(nro_plano) and limite_caracteres(nro_plano, 15));

        primero_lista_terrenos(lista);
        recuperar_lista_terrenos(lista, terreno_actual);

        while not(fin_lista_terrenos(lista)) and (terreno_actual.nro_plano <> nro_plano) do
        begin
            siguiente_lista_terrenos(lista);
            recuperar_lista_terrenos(lista, terreno_actual);
        end;

        if not(fin_lista_terrenos(lista)) then
            mostrar_comprobante(terreno_actual)
        else
            writeln('El número de plano ingresado no se encuentra en la base de datos');

        clrscr;
    end;

end.