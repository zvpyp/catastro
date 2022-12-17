// Agregar opción de cancelar cuando se quiere borrar un contribuyente y se escribe
// un número de contribuyente que no se encuentra en el archivo.


Unit contribuyentes_ABMC;

Interface

Uses contribuyente in 'units/contribuyente.pas',
     usuario_contribuyentes in 'units/usuario/usuario_contribuyentes',
     validacion_entradas in 'units/validacion_entradas.pas',
     contador_datos in 'units/contador_datos.pas',
     crt;

Procedure alta_contribuyente(var archivo : t_archivo_contribuyentes);

Procedure baja_contribuyente(var archivo : t_archivo_contribuyentes);

Procedure mod_contribuyente(var archivo : t_archivo_contribuyentes);

Procedure consulta_contribuyente(var archivo : t_archivo_contribuyentes);

Implementation

Procedure alta_contribuyente(var archivo : t_archivo_contribuyentes);
var
contribuyente_nuevo : t_contribuyente;
begin
    abrir_archivo_contribuyentes(archivo);

    contribuyente_nuevo := crear_contribuyente();

    escribir_contribuyente(archivo, contribuyente_nuevo, cantidad_contribuyentes(archivo));
end;

Procedure baja_contribuyente(var archivo : t_archivo_contribuyentes);
var
contribuyente_baja : t_contribuyente;
nro_contribuyente_baja : string;
pos : byte;
begin
  abrir_archivo_contribuyentes(archivo);

  Writeln('Introduzca el número de contribuyente del usuario que desea dar de baja: ');
  Readln(nro_contribuyente_baja);
  While ((not limite_caracteres(nro_contribuyente_baja,15)) or (not string_numerica(nro_contribuyente_baja))) do
        begin
        Writeln('El valor ingresado no es un número o supera los 15 caracteres, ingréselo nuevamente por favor');
        Readln(nro_contribuyente_baja);
        end;
    end;
    // Buscamos el contribuyente (falta hacer función)  FALTA METER EN UN WHILE.
    // pos := pos_en_arbol(arbol, nro_contribuyente_baja);
    // if pos = 0 then
    // begin
    //  Writeln('No existe contribuyente con ese número, por favor ingrese un nro existente');
    //  Readln(nro_contribuyente_baja); 
    // end
    // else
        begin
         leer_contribuyente(archivo,contribuyente_baja,pos);
         if contribuyente_baja.activo then
         contribuyente_baja.activo := false
         else Writeln('El usuario ya ha sido dado de baja');
         Readkey;
        end;
end;

Procedure mod_contribuyente(var archivo : t_archivo_contribuyentes);

Procedure consulta_contribuyente(var archivo : t_archivo_contribuyentes);


end.