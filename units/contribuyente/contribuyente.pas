unit contribuyente;

{ Unidad de tipo de dato contribuyente. }

{--------------------------------}

interface

    const
    ruta_contribuyentes = './contribuyentes.dat';

    type
    t_contribuyente = record 
        numero : string[15];
        apellido : string[30];
        nombre : string[30];
        direccion : string[30];
        ciudad : string[40];
        dni : string[10];
        fecha_nacimiento : string[10];
        tel : string[15];
        email : string[40];
        activo : boolean;
        end;
    
    t_archivo_contribuyentes = file of t_contribuyente;

    // Genera el archivo de contribuyentes si no existe. Sino, lo abre.
    procedure abrir_archivo_contribuyentes(var archivo : t_archivo_contribuyentes);

    // Añade un contribuyente a un archivo en un índice dado.
    procedure escribir_contribuyente(var archivo : t_archivo_contribuyentes;
                                    contribuyente : t_contribuyente;
                                    indice : cardinal);

    // Retorna el contribuyente en el indice indicado de un archivo.
    function leer_contribuyente(var archivo : t_archivo_contribuyentes;
                                indice : cardinal): t_contribuyente;
    
    // Syntactic sugar. Cierra el archivo.
    procedure cerrar_archivo_contribuyentes(var archivo: t_archivo_contribuyentes);

{--------------------------------}

implementation
    
    procedure abrir_archivo_contribuyentes(var archivo : t_archivo_contribuyentes);
    begin
        assign(archivo, ruta_contribuyentes);
        
        {$I-} reset(archivo) {$I+};

        // Si el archivo no existe, lo crea.
        if ioresult <> 0 then rewrite(archivo);

    end;
    
    procedure escribir_contribuyente(var archivo : t_archivo_contribuyentes;
                                    contribuyente : t_contribuyente;
                                    indice : cardinal);
    begin
        seek(archivo, indice);
        write(archivo, contribuyente);
    end;

    function leer_contribuyente(var archivo : t_archivo_contribuyentes;
                                indice : cardinal): t_contribuyente;
    begin
        seek(archivo, indice);
        read(archivo, leer_contribuyente);
    end;

    procedure cerrar_archivo_contribuyentes(var archivo: t_archivo_contribuyentes);
    begin
        close(archivo);
    end;

end.