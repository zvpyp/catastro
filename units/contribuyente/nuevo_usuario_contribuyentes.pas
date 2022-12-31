unit nuevo_usuario_contribuyentes;

{$codepage utf8}

{ Unidad de alta, baja, modificación y consulta de contribuyentes. }

{--------------------------------}

interface

    uses
        contribuyente in 'units/contribuyente/contribuyente.pas',
        arbol in 'units/arbol.pas',
        contador_datos in 'units/varios/contador_datos.pas',
        u_menu in 'units/u_menu.pas',
        validacion_entradas in 'units/varios/validacion_entradas.pas',
        crt, sysutils;

    // Le pide una clave al usuario. Retorna un dato con clave e índice.
    function buscar_contribuyente(raiz : t_puntero_arbol): t_puntero_arbol;

    // Muestra todos los datos de un contribuyente.
    procedure mostrar_contribuyente(contribuyente : t_contribuyente);

    // Pide datos al usuario. Crea un nuevo contribuyente y lo añade al archivo.
    // El árbol ingresado debe estar ordenado por DNI.
    // puntero_datos contiene un puntero árbol con la clave y el índice.
    procedure crear_contribuyente(var archivo : t_archivo_contribuyentes;
                                    var archivo_contador : t_archivo_contador;
                                    var raiz : t_puntero_arbol;
                                    puntero_datos : t_puntero_arbol);

    // Busca un contribuyente por DNI y lo borra si existe.
    // TODO: hacer que funcione también por nombre (caso múltiple)
    procedure borrar_contribuyente(var archivo : t_archivo_contribuyentes;
                                    var archivo_contador : t_archivo_contador;
                                    puntero_datos : t_puntero_arbol);

    // Busca un contribuyente por DNI y lo modifica según lo pedido si existe.
    // TODO: hacer que funcione también por nombre (caso múltiple)
    procedure modificar_contribuyente(var archivo : t_archivo_contribuyentes;
                                        var archivo_contador : t_archivo_contador;
                                        var raiz : t_puntero_arbol;
                                        puntero_datos : t_puntero_arbol);

    // Busca un contribuyente por DNI y muestra sus datos si existe.
    // TODO: hacer que funcione también por nombre (caso múltiple)
    procedure consultar_contribuyente(var archivo : t_archivo_contribuyentes;
                                        var archivo_contador : t_archivo_contador;
                                        var raiz : t_puntero_arbol;
                                        puntero_datos : t_puntero_arbol);

{--------------------------------}

implementation

    // TODO: estilizar.
    procedure mostrar_contribuyente(contribuyente : t_contribuyente);
    begin
        if contribuyente.activo then
        begin
            writeln('Nombre completo: ', contribuyente.nombre, ' ', contribuyente.apellido);
            writeln('DNI: ', contribuyente.dni);
            writeln('Número de contribuyente: ', contribuyente.numero);
            writeln('Dirección: ', contribuyente.direccion);
            writeln('Ciudad: ', contribuyente.ciudad);
            writeln('Fecha de Nacimiento: ', contribuyente.fecha_nacimiento);
            writeln('Teléfono: ', contribuyente.tel);
            writeln('Email: ', contribuyente.email);

            writeln('');
            writeln('Presione una tecla para continuar...');
            readkey;
        end
        else
            writeln('Contribuyente inactivo');
    end;

    
    function buscar_contribuyente(raiz : t_puntero_arbol): t_puntero_arbol;
    var
        clave : string;
    begin
        clave := leer_entrada('Ingrese el DNI del contribuyente: ', 10, true);

        buscar_contribuyente := preorden(raiz, clave);
    end;


    procedure crear_contribuyente(var archivo : t_archivo_contribuyentes;
                                    var archivo_contador : t_archivo_contador;
                                    var raiz : t_puntero_arbol;
                                    puntero_datos : t_puntero_arbol);
    var
        contribuyente : t_contribuyente;
        dato : t_dato_arbol;
        indice : cardinal;
    begin
        clrscr;

        dato := info_raiz(puntero_datos);
        indice := dato.indice;

        if indice = 0 then
        begin
            // Si no existe, pide datos para crearlo.
            contribuyente.dni := dato.clave;
            contribuyente.nombre := leer_entrada('Nombre', 30, false);
            contribuyente.apellido := leer_entrada('Apellido', 30, false);
            contribuyente.direccion := leer_entrada('Dirección', 30, false);
            contribuyente.ciudad := leer_entrada('Ciudad', 40, false);
            contribuyente.fecha_nacimiento := leer_fecha();
            contribuyente.tel := leer_entrada('Teléfono', 15, true);
            contribuyente.email := leer_entrada('Email', 40, false);
            contribuyente.activo := true;

            // Asignar automáticamente número de contribuyente (corresponde con el índice)
            indice := cantidad_contribuyentes(archivo_contador) + 1;
            contribuyente.numero := IntToStr(indice);

            // Añadirlo al archivo y al árbol
            escribir_contribuyente(archivo, contribuyente, indice);
            agregar_hijo(raiz, dato);

            // Cuenta un nuevo contribuyente.
            sumar_contribuyente(archivo_contador);

            clrscr;
            writeln('Contribuyente creado satisfactoriamente :)');
            readkey;
        end
        else
        begin
            // Caso en el que ya exista
            contribuyente := leer_contribuyente(archivo, indice);

            // Si no está activo, pide para activarlo.
            if not(contribuyente.activo) then
            begin
                clrscr;
                if (leer_si_no('Ya existe el contribuyente. ¿Desea activarlo?') = 's') then
                begin
                    contribuyente.activo := true;
                    escribir_contribuyente(archivo, contribuyente, indice);
                    writeln('Contribuyente activado con éxito:');
                    writeln('');
                    mostrar_contribuyente(contribuyente);
                end;
            end
            // Caso de que esté activo
            else
            begin
                writeln('Ya existe ese contribuyente:');
                writeln('');
                mostrar_contribuyente(contribuyente);
            end;            
        end;
    end;


    procedure borrar_contribuyente(var archivo : t_archivo_contribuyentes;
                                    var archivo_contador : t_archivo_contador;
                                    puntero_datos : t_puntero_arbol);
    var
        contribuyente : t_contribuyente;
        indice : cardinal;
    begin
        clrscr;

        indice := info_raiz(puntero_datos).indice;

        if (indice <> 0) then
        begin
            contribuyente := leer_contribuyente(archivo, indice);
            contribuyente.activo := false;

            writeln('Datos del contribuyente a dar de baja:');
            mostrar_contribuyente(contribuyente);
            readkey;

            if leer_si_no('¿Quiere dar de baja al contribuyente Nro. ' + contribuyente.numero + '?') = 's' then
            begin
                escribir_contribuyente(archivo, contribuyente, indice);
                restar_contribuyente(archivo_contador); // resta 1 al contador de activos.
                writeln('Contribuyente dado de baja satisfactoriamente :)');
            end 
        end
        else
            writeln('No se puede dar de baja este contribuyente porque no se encuentra en la base de datos :(');

        writeln('Presione una tecla para continuar...');
        readkey;
        // TODO: BORRAR LAS PROPIEDADES QUE LE PERTENECEN A ESE CONTRIBUYENTE >:(
    end;


    procedure modificar_contribuyente(var archivo : t_archivo_contribuyentes;
                                        var archivo_contador : t_archivo_contador;
                                        var raiz : t_puntero_arbol;
                                        puntero_datos : t_puntero_arbol);
    var
        contribuyente : t_contribuyente;
        opt : byte;
        indice : cardinal;
    begin
        clrscr;
        
        indice := info_raiz(puntero_datos).indice; 

        if (indice <> 0) then
        begin
            // Menú de modificación
            repeat
                opt := menu_modificar_contribuyente();

                case opt of
                1:  contribuyente.nombre := leer_entrada('Nombre', 30, false);
                2:  contribuyente.apellido := leer_entrada('Apellido', 30, false);
                3:  contribuyente.direccion := leer_entrada('Dirección', 30, false);
                4:  contribuyente.ciudad := leer_entrada('Ciudad', 40, false);
                5:  contribuyente.tel := leer_entrada('Teléfono', 15, true);
                6:  contribuyente.email := leer_entrada('Email', 40, false);
                end;

            until ((opt = 0) or (opt = 7)); // Opciones de salir.

            clrscr;
            writeln('Datos actualizados del contribuyente:');
            mostrar_contribuyente(contribuyente);
            writeln('');
            writeln('Presione una tecla para continuar...');
            readkey;

            // guardar los cambios en el archivo y en el árbol.
            if (leer_si_no('¿Desea guardar los cambios?') = 's') then
            begin
                // TODO: modificar arbol en caso de que la clave sea por nombre completo.
                //modificar_clave(puntero_datos, nombre_completo);
                escribir_contribuyente(archivo, contribuyente, indice);
                writeln('Contribuyente modificado satisfactoriamente :)');
            end;
        end
        else
        begin
            if leer_si_no('El contribuyente no existe. ¿Desea crearlo?') = 's' then
                crear_contribuyente(archivo, archivo_contador, raiz, puntero_datos);
        end;

        writeln('Presione una tecla para continuar...');
        readkey;
    end;

    procedure consultar_contribuyente(var archivo : t_archivo_contribuyentes;
                                        var archivo_contador : t_archivo_contador;
                                        var raiz : t_puntero_arbol;
                                        puntero_datos : t_puntero_arbol);
    var
        contribuyente : t_contribuyente;
        indice : cardinal;
    begin
        indice := info_raiz(puntero_datos).indice; 

        if indice <> 0 then
            begin
                contribuyente := leer_contribuyente(archivo, indice);
                mostrar_contribuyente(contribuyente);
            end
        else
        begin
            if leer_si_no('El contribuyente no existe. ¿Desea crearlo?') = 's' then
                crear_contribuyente(archivo, archivo_contador, raiz, puntero_datos);
        end;
    end;

end.