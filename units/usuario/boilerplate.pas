// TODO: una vez terminado todo, borrar este archivo.
{ NO COMPILAR: código boilerplate para hacer recorridos inorden }

procedure inorden_boilerplate(raiz : t_puntero_arbol);
begin
    // No hacer nada si es nil.
    if raiz <> nil then
    begin
        inorden_boilerplate(hijo_izquierdo(raiz));

        { código realizado en todos los nodos }

        { ----------------------------------- }

        inorden_boilerplate(hijo_derecho(raiz));
    end;
end;