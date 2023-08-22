--Testes de documento 

select * from func_jsonmapeamento( 1::bigint , 
'{
   "id":1,
   "nome":"Maria",
   "endereco":"R. Qualquer", 
   "escada": [{"1 andar" :"azul"},{"1 andar" :"vermelho"},{"1 andar" :
   [{"2 andar":"verde"},{"2 andar":
      [{"3 andar":"marrom"},{"3 andar":
         [{"4 andar":"amarelo"}]}]}]}
]
}');


select * from func_jsonmapeamento( 1::bigint , 
'{
"resultset": {
    "violations": {
        "hpd": [
            {
                "0": {
                    "ViolationID": "110971",
                    "BuildingID": "775548",
                    "RegistrationID": "500590",
                    "Boro": "STATEN ISLAND",
                    "HouseNumber": "275",
                    "LowHouseNumber": "275",
                    "HighHouseNumber": "275",
                    "StreetName": "RICHMOND AVENUE",
                    "StreetCode": "44750",
                    "Zip": "10302",
                    "Apartment": "",
                    "Story": "All Stories ",
                    "Block": "1036",
                    "Lot": "1",
                    "Class": "A",
                    "InspectionDate": "1997-04-11",
                    "OriginalCertifyByDate": "1997-08-15",
                    "OriginalCorrectByDate": "1997-08-08",
                    "NewCertifyByDate": "",
                    "NewCorrectByDate": "",
                    "CertifiedDate": "",
                    "OrderNumber": "772",
                    "NOVID": "3370",
                    "NOVDescription": "Â§ 27-2098 ADM CODE FILE WITH THIS DEPARTMENT A REGISTRATION STATEMENT FOR BUILDING. ",
                    "NOVIssuedDate": "1997-04-22",
                    "CurrentStatus": "VIOLATION CLOSED",
                    "CurrentStatusDate": "2015-03-10"
                },
                "count": "1"
            }
        ]
    }
},
"count": "1",
"total_page": 1,
"current_page": 1,
"limit": [
    "0",
    "1000"
],
"status": "success",
"error_code": "",
"message": ""
}'
)
--Testes de operadores

select func_jsonmapeamento (2::bigint ,
'[{"array":"teste"},{"array2":"teste2"}]'
);

select '[{"array":"teste"},{"array2":"teste2"}]'== 'array';
select '[0,1]'=='array';



