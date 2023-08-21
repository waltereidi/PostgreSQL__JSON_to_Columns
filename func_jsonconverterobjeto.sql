CREATE OR REPLACE FUNCTION public.func_jsonconverterobjeto (  doc text )
RETURNS TABLE (  chave text,  valor text,  sequencia bigint ) AS
$funcao$
declare 
  jDoc json ;
  rJson record ;
  iCount bigint := 0 ; 
  begin

  jDoc:=doc::json;
    if doc == 'array' then

        for rJson in select json_array_elements_text( jDoc )::json arrayelement
        loop 
          iCount := iCount+1 ; 
          return query select key::text , value::text , iCount from json_each( rJson.arrayelement ); 
        end loop;

    else 
        return query select key::text , value::text , iCount from json_each( jDoc );
    end if ;
  end ;
$funcao$
LANGUAGE 'plpgsql'
IMMUTABLE
RETURNS NULL ON NULL INPUT
SECURITY INVOKER
PARALLEL SAFE
COST 10 ROWS 5;
