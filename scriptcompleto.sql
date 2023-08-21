--Operador e função;
create or replace function func_jsonvalidartipo(pDoc text , pTipo text) 
returns boolean as 
$function$

begin 
case pTipo when 'object' then 
             return (select true from json_each(pDoc::json) limit 1);
           when 'array' then 
             return (select true from (select json_each(json_array_elements(pDoc::json))  limit 1 ) a );
else 
    return false ;
end case;

    exception when others then
    return false ;
end; 

$function$
IMMUTABLE 
parallel safe 
language plpgsql 
cost 10;

create operator == (
    leftarg = text,
    rightarg = text,
    commutator = ==,
    function = func_jsonvalidartipo
);


----  Conversor de objeto
CREATE OR REPLACE FUNCTION func_jsonconverterobjeto (  doc text )
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

-- Função de utilidade. 
create or replace function func_jsonmapeamento(pchavePrimaria bigint , pJson text)
returns table ( chaveprimaria bigint ,chave text , valor text ,pai text , sequencia bigint ) as
$body$

begin
    return query with recursive json_repartido (valor , chave , pai, sequencia ) as ( 
                    select jsoninicial.valor , jsoninicial.chave , null , jsoninicial.sequencia
                    from func_jsonconverterobjeto( pJson) jsoninicial
                 union all 
                    select jsoncomarray.valor as valor ,jsoncomarray.chave as chave , j.chave as pai ,jsoncomarray.sequencia sequencia
                    from json_repartido j
                    join func_jsonconverterobjeto(j.valor::text) jsoncomarray on true
                    where  j.valor=='object' or j.valor=='array'
                 )  select pchavePrimaria, j.chave , j.valor , j.pai , j.sequencia from json_repartido j where not j.valor=='object' and not j.valor=='array';

    end;
$body$
IMMUTABLE
rows 30
language plpgsql ; 


