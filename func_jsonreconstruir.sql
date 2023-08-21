create or replace func_jsonreconstruir( pCursor refcursor )
returns json as  
$funcao$
declare 
rRecord record ; 
rTabelas record;
begin
--Tabela que reconstroi o json deve conter os 4 campos nomeados : pai , valor , chave , sequencia
    
    create temporary table tmp_json(pai text, valor text, chave text, sequencia bigint) on commit drop ;


    loop
        fetch next from pCursor into rRecord ; 
        exit when not found ;
        insert into tmp_json( pai , valor , chave , sequencia ) values (rRecord.pai , rRecord.valor ,rRecord.chave , rRecord.sequencia );
    end loop ;     

    for rTabelas in select 'create table tmp'||format('%s_%s', now()::text , coalesce(pai,'') )||format('( "%s" )on commit drop;', array_agg(pai||' text' ) ) query
    from tmp_json 
    group by pai
    loop 
        begin 
        execute rTabelas.query; 
        exception when others then 
            raise notice 'erro query dinamica %' , rTabelas.query ;
        end ;
    end loop ;

    with recursive reconstruir(pai text )( 
        select pai  from tmp_json where pai is null group by pai ;
        union all
        select pai from reconstruir r
        join tmp_json t on t.pai <> r.pai and 
    )



    
    exception when sqlstate '24000' then 
    raise exception 'invalid_cursor_state';
    when others then 
    raise exception 'cursor inválido' ;
end;
$funcao$

cost 20
immutable
language plpgsql ; 
