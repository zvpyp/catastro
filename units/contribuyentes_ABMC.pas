Unit contribuyentes_ABMC;

Interface

Uses contribuyente in 'units/contribuyente.pas',
     validacion_entradas in 'units/validacion_entradas.pas',
     contador_datos in 'units/contador_datos.pas';

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

Procedure mod_contribuyente(var archivo : t_archivo_contribuyentes);

Procedure consulta_contribuyente(var archivo : t_archivo_contribuyentes);


end.