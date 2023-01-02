unit nuevo_usuario_terrenos;

{$codepage utf8}

{ Unidad de alta, baja, modificación y consulta de terrenos. }

{--------------------------------}

interface

    uses
        terreno in 'units/terreno/terreno.pas',
        arbol in 'units/arbol.pas',
        contador_datos in 'units/varios/contador_datos.pas',
        u_menu in 'units/u_menu.pas',
        validacion_entradas in 'units/varios/validacion_entradas.pas',
        crt, sysutils;

    // CAMBIAR A TERRENO
    // Le pide una clave al usuario. Retorna un dato con clave e índice.
    function buscar_contribuyente(raiz : t_puntero_arbol): t_puntero_arbol;

    // Muestra todos los datos de un terreno.
    procedure mostrar_terreno(terreno : t_terreno);

    // CAMBIAR A TERRENO
    // Pide datos al usuario. Crea un nuevo contribuyente y lo añade al archivo.
    // El árbol ingresado debe estar ordenado por DNI.
    // puntero_datos contiene un puntero árbol con la clave y el índice.
    procedure crear_contribuyente(var archivo : t_archivo_contribuyentes;
                                    var archivo_contador : t_archivo_contador;
                                    var raiz : t_puntero_arbol;
                                    puntero_datos : t_puntero_arbol);

    // CAMBIAR A TERRENO
    // Busca un contribuyente por DNI y lo borra si existe.
    // TODO: hacer que funcione también por nombre (caso múltiple)
    procedure borrar_contribuyente(var archivo : t_archivo_contribuyentes;
                                    var archivo_contador : t_archivo_contador;
                                    puntero_datos : t_puntero_arbol);

    // CAMBIAR A TERRENO
    // Busca un contribuyente por DNI y lo modifica según lo pedido si existe.
    // TODO: hacer que funcione también por nombre (caso múltiple)
    procedure modificar_contribuyente(var archivo : t_archivo_contribuyentes;
                                        var archivo_contador : t_archivo_contador;
                                        var raiz : t_puntero_arbol;
                                        puntero_datos : t_puntero_arbol);

    // CAMBIAR A TERRENO
    // Busca un contribuyente por DNI y muestra sus datos si existe.
    // TODO: hacer que funcione también por nombre (caso múltiple)
    procedure consultar_contribuyente(var archivo : t_archivo_contribuyentes;
                                        var archivo_contador : t_archivo_contador;
                                        var raiz : t_puntero_arbol;
                                        puntero_datos : t_puntero_arbol);

{--------------------------------}

implementation

    // TODO: estilizar.
    procedure mostrar_terreno(terreno : t_contribuyente);
    begin
            writeln('Domicilio parcelario: ', terreno.domicilio_parcelario);
            writeln('Número de plano: ', terreno.nro_plano);
            writeln('Número de contribuyente: ', terreno.nro_contribuyente);
            writeln('Avalúo: ', terreno.avaluo);
            writeln('Fecha de inscripción: ', terreno.fecha_incripcion);
            writeln('Superficie: ', terreno.superficie);
            writeln('Zona: ', terreno.zona);
            writeln('Tipo de edificación: ', terreno.tipo_edificacion);

            writeln('');
            writeln('Presione una tecla para continuar...');
            readkey;
    end;