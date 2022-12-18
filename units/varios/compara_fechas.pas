unit compara_fechas;

interface

// Las fechas deben tener el formato dd/mm/aaaa

// Retorna verdadero si fecha 1 es mayor que fecha 2
function fecha_es_mayor(fecha1 : string; fecha2 : string) : boolean;

implementation
// AAAA-MM-DD
function fecha_es_mayor(fecha1 : string; fecha2 : string) : boolean;
var
anio1, mes1, dia1, anio2, mes2, dia2 : string;
begin
anio1 := Copy(fecha1,1,4);
mes1 := Copy(fecha1,6,2);
dia1 := Copy(fecha1,9,2);
anio2 := Copy(fecha2,1,4);
mes2 := Copy(fecha2,6,2);
dia2 := Copy(fecha2,9,2);


if anio1 > anio2 then
  fecha_es_mayor := true
else 
  if anio1 = anio2 then
    begin
      if mes1 > mes2 then
        fecha_es_mayor := true
      else
        if mes1 = mes2 then
          begin
            if dia1 > dia2 then
              fecha_es_mayor := true
            else
            fecha_es_mayor := false;
          end;
    end
  else fecha_es_mayor := false;

end;

end.