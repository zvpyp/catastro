unit contribuyente;

{ Unidad de tipo de dato contribuyente. }

{--------------------------------}

interface

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

{--------------------------------}

implementation
    

    
end.