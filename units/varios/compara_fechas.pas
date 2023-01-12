unit compara_fechas;

{$codepage utf8}

interface

// Las fechas deben tener el formato aaaa-mm-dd

// Retorna verdadero si fecha 1 es mayor que fecha 2
// Equivalente en el resto de procedimientos.
function fecha_es_mayor(fecha1 : string; fecha2 : string) : boolean;

function fecha_es_igual(fecha1 : string; fecha2 : string) : boolean;

function fecha_es_menor(fecha1 : string; fecha2 : string) : boolean;

function fecha_es_mayor_igual(fecha1 : string; fecha2 : string) : boolean;

function fecha_es_menor_igual(fecha1 : string; fecha2 : string) : boolean;

{--------------------------------}

implementation
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

function fecha_es_menor(fecha1 : string; fecha2 : string) : boolean;
begin
  fecha_es_menor := fecha_es_mayor(fecha2, fecha1);
end;

function fecha_es_igual(fecha1 : string; fecha2 : string) : boolean;
begin
  fecha_es_igual := not(fecha_es_menor(fecha1, fecha2) or fecha_es_mayor(fecha1, fecha2));
end;

function fecha_es_mayor_igual(fecha1 : string; fecha2 : string) : boolean;
begin
  fecha_es_mayor_igual := fecha_es_mayor(fecha1, fecha2) or fecha_es_igual(fecha1, fecha2);
end;

function fecha_es_menor_igual(fecha1 : string; fecha2 : string) : boolean;
begin
  fecha_es_menor_igual := fecha_es_mayor_igual(fecha2, fecha1);
end;

end.