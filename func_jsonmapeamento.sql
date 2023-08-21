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


