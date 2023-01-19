unit listados;

{$codepage utf8}

{--------------------------------}

interface

    uses
    terreno in 'units/terreno/terreno.pas',
    contribuyente in 'units/contribuyente/contribuyente.pas',
    lista_terrenos in 'units/terreno/lista_terrenos.pas',
    crt, sysutils,
    comprobante in 'units/usuario/comprobante.pas',
    validacion_entradas in 'units/varios/validacion_entradas.pas',
    arbol in 'units/arbol.pas',
    compara_fechas in 'units/varios/compara_fechas.pas';

    // Muestra los terrenos según la zona que le corresponda.
    procedure terrenos_por_zona(lista : t_lista_terrenos);

    // Muestra todas las inscripciones de terrenos dadas en un año.
    procedure inscripciones_anio(var lista : t_lista_terrenos; anio : string);

    procedure listado_contribuyentes_propiedades(raiz : t_puntero_arbol;
                                                    lista : t_lista_terrenos;
                                                    var archivo_contribuyentes : t_archivo_contribuyentes);

{--------------------------------}

implementation

    // TODO: hacer ver como grilla
    procedure listado_contribuyentes_propiedades(raiz : t_puntero_arbol;
                                                lista : t_lista_terrenos;
                                            var archivo_contribuyentes : t_archivo_contribuyentes);
    var
        dato : t_dato_arbol;
        nombre, nro_contribuyente, mensaje : string;
        terreno : t_terreno;
        y : byte;
    begin
        // Ignorar nodos nulos.
        if raiz <> nil then
        begin
            listado_contribuyentes_propiedades(hijo_izquierdo(raiz), lista, archivo_contribuyentes);
            y := 3;

            // Carga los datos.
            dato := info_raiz(raiz);
            nombre := dato.clave;
            nro_contribuyente := leer_contribuyente(archivo_contribuyentes, dato.indice).numero;

            //writeln('| Propietario | Domicilio parcelario | Valor de la propiedad |');

            // Escribe los terrenos que le corresponden a ese número de contribuyente.
            primero_lista_terrenos(lista);
            while not(fin_lista_terrenos(lista)) do
            begin
                recuperar_lista_terrenos(lista, terreno);
                y := y + 1;

                if terreno.nro_contribuyente = nro_contribuyente then
                begin
                    mensaje := '| '+ nombre;
                    escribir_xy(mensaje,10,y);
                    mensaje := '| ' + terreno.domicilio_parcelario;
                    escribir_xy(mensaje,40,y);
                    mensaje := '| ' + '$' + FloatToStr(terreno.avaluo);
                    escribir_xy(mensaje,70,y);
                    escribir_xy('|',100,y);
                end;
                siguiente_lista_terrenos(lista);
            end;
            escribir_xy('-----------------------------------------------------------------------------------------',11,y+1);

            listado_contribuyentes_propiedades(hijo_derecho(raiz), lista, archivo_contribuyentes);
        end;
    end;

    // TODO: hacer ver como grilla
    procedure terrenos_por_zona(lista : t_lista_terrenos);
    var
        vector_por_zona : t_vector_listas;
        lista_actual : t_lista_terrenos;
        terreno_actual : t_terreno;
        i : 1..5;
        mensaje : string;
        y, max : byte;
    begin
        max := 3;
        vector_por_zona := generar_vector_por_zona(lista);
        escribir_xy('-----------------------------------------------------------------------------------------------------',10,1);
        for i := 1 to 5 do
        begin
            y := 3;
            mensaje := '| Zona '+ FloatToStr(i);
            case i of
            1: escribir_xy(mensaje,10,2);
            2: escribir_xy(mensaje,30,2);
            3: escribir_xy(mensaje,50,2);
            4: escribir_xy(mensaje,70,2);
            5: 
            begin
                escribir_xy(mensaje,90,2);
                escribir_xy('|',110,2);
                escribir_xy('-----------------------------------------------------------------------------------------------------',10,3);
            end;
            end;

            lista_actual := vector_por_zona[i];
            primero_lista_terrenos(lista_actual);

            if lista_actual.tam <> 0 then
            begin
                while not(fin_lista_terrenos(lista_actual)) do
                begin
                    y := y + 1;
                    if y > max then max := y;
                    recuperar_lista_terrenos(lista_actual, terreno_actual);
                    mensaje := '| ' + terreno_actual.domicilio_parcelario;
                    escribir_xy('|',10,y);
                    escribir_xy('|',30,y);
                    escribir_xy('|',50,y);
                    escribir_xy('|',70,y);
                    escribir_xy('|',90,y);
                    escribir_xy('|',110,y);
                    case i of
                        1: escribir_xy(mensaje,10,y);
                        2: escribir_xy(mensaje,30,y);
                        3: escribir_xy(mensaje,50,y);
                        4: escribir_xy(mensaje,70,y);
                        5: escribir_xy(mensaje,90,y);
                    end;
                    siguiente_lista_terrenos(lista_actual);
                end;
            end;
        end;
        escribir_xy('-----------------------------------------------------------------------------------------------------',10,max + 1);
        pedir_tecla();
    end;


    procedure inscripciones_anio(var lista : t_lista_terrenos; anio : string);
    var
        anio_con_ceros : string;
        ceros : byte;
        i : byte;
        terreno_actual : t_terreno;
        fecha1, fecha2, fecha_actual, mensaje : string;
        cantidad : cardinal;
        existe : boolean;
    begin
        clrscr;
        cantidad := 0;
        existe := false;

        // Convertir a string de 4 dígitos en caso de ser necesario.
        ceros := 4 - length(anio);
        anio_con_ceros := anio;
        if ceros > 0 then
        begin
            for i := 1 to ceros do
                anio_con_ceros := '0' + anio_con_ceros;
        end;

        // Las fechas corresponden al primer día del año y al último.
        fecha1 := anio_con_ceros + '-01-01';
        fecha2 := anio_con_ceros + '-12-31';
        fecha_actual := '0001-01-01'; // por predeterminado, la fecha mínima posible
        
        primero_lista_terrenos(lista);
        i := 3;
        // Escribe todos los terrenos entre ambas fechas.
        while not(fin_lista_terrenos(lista)) do
        begin
            recuperar_lista_terrenos(lista, terreno_actual);
            fecha_actual := terreno_actual.fecha_inscripcion;
            if fecha_es_mayor_igual(fecha_actual, fecha1) and fecha_es_menor_igual(fecha_actual, fecha2) then
            begin
            if not existe then
              begin 
              escribir_xy('------------------------------------------------------------',11,1);
              escribir_xy('| Domicilio parcelario',10,2);
              escribir_xy('| Fecha de inscripción',40,2);
              escribir_xy('|',70,2);
              escribir_xy('------------------------------------------------------------',11,3);
              existe := true;
              end;
              i := i + 1;
              mensaje := '| '+ terreno_actual.domicilio_parcelario;
              escribir_xy(mensaje,10,i);
              mensaje := '| '+ fecha_actual;
              escribir_xy(mensaje,40,i);
              escribir_xy('|',70,i);
              
            end;
            siguiente_lista_terrenos(lista);
        end;
        if existe then
        escribir_xy('------------------------------------------------------------',11,i + 1)
        else writeln('Ningún terreno se inscribió en el año ', anio_con_ceros);
        
        pedir_tecla();
    end;


end.
