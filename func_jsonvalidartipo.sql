
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
