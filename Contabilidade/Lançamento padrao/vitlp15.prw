/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITLP15  ³ Autor ³Gardenia Ilany         ³ Data ³ 17/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna a Conta Contabil  - Gestao Pessoal                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Alterações³ 01/03/06 - Atualização do lancto. "P01", para tratamento   ³±±
±±³          ³            específico das verbas 228, 229.                 ³±±
±±³          ³          - Inclusão dos lanctos. "B12" e "B13", para tra-  ³±±
±±³          ³            tamento das verbas 781 e 782.                   ³±±
±±³          ³ 13/03/06 - Atualização do lancto. "P01", para tratamento   ³±±
±±³          ³            específico das verbas 293, 295.                 ³±±
±±³          ³          - Atualização do lancto. "P10", para tratamento   ³±±
±±³          ³            específico das verbas 199, 200 e 294.           ³±±  
±±³          ³ 10/04/06 - Inclusão do lancto. "D34", para tratamento da   ³±±
±±³          ³            verba 572.                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function vitlp15(_tipo)

_cconta:=space(13)
if _tipo =="P01"
   if (srz->rz_pd== "069") .or. (srz->rz_pd== "070") .or.;
   	(srz->rz_pd== "293") .or. (srz->rz_pd== "295")
		if substr(srz->rz_cc,1,2)== "23"
			_cconta:="4102010214212"
			//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010210212"
	Else 
	//Fim 	
			_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010210212","3501010316312") //OK
		endif
	else
// Alterado em 19/05/2008 por solicitação da Contabilidade. Alex Júnio.
//		_cconta:="2101050321532"
		_cconta:="1102060120003"
	endif
elseif _tipo =="P05"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010214202"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010210202"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010210202","3501010316302") //OK
	endif
elseif _tipo =="P07"                                               
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010214205"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010210205"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010210205","3501010316305")//OK
	endif
	//elseif _tipo =="P08"
	//	_cconta:=if(substr(srz->rz_cc,1,2)<> "29" ,"3201020121214","3102020112213")
elseif _tipo =="P10"
	if (srz->rz_pd== "137") .or. (srz->rz_pd== "140") .or. (srz->rz_pd== "294")
		if substr(srz->rz_cc,1,2)== "23"
			_cconta:="4102010214211"
			//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010210211"
	Else 
	//Fim 	
			_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010210211","3501010316311") //OK
		endif
	else
		if substr(srz->rz_cc,1,2)== "23"
			_cconta:="4102010214211"
			//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010210211"
	Else 
	//Fim 	
			_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010210211","3501010316311")//OK
		endif
	endif
elseif _tipo =="P11"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010214202"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101020313308"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101020313308","3501020318308")//ok
	endif
elseif _tipo =="P14"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010214203"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010210203"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010210203","3501010316303") //OK
	endif
elseif _tipo =="P15"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010214206"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010210206"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010210206","3501010316306") //OK
	endif
elseif _tipo =="P16"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010214207"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010210207"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010210207","3501010316307") //OK
	endif
elseif _tipo =="P17"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010214208"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010210208"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010210208","3501010316308") //OK
	endif
elseif _tipo =="P18"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010214209"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010210209"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010210209","3501010316309") //OK
	endif
elseif _tipo =="P19"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010214213"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010210213"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010210213","3501010316313") //OK
	endif
elseif _tipo =="P20"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010214214"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010210214"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010210214","3501010316314") //OK
	endif
elseif _tipo =="P21"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010215104"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010211104"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010211104","3501010317104") //OK
	endif
elseif _tipo =="P26"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010214215"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010210215"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010210215","3501010316315") //OK
	endif
elseif _tipo =="P27"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102020316302"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101020313302"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101020313302","3501020318302") //OK
	endif
elseif _tipo =="D05"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="1102060120008"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="1102060120008"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"1102060120008","1102060120008")//ok
	endif
elseif _tipo =="D12"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010214202"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010210202"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010210202","3501010316302")//ok
	endif
elseif _tipo =="D15"
	_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"2101050321532","2101050321532")//ok
elseif _tipo =="D16"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010215103"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010211103"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010211103","3501010317103")//ok
	endif
elseif _tipo =="D17"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102020516506"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101020513506"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101020513506","3501020518506") //ok
	endif

// Alterado em 12/05/2006, conforme Ocorrência 1404, emitido pelo Depto. Contabilidade.
/*
elseif _tipo =="D18"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010215105"
	else
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010211105","3501010317105") //ok
	endif 
*/

elseif _tipo =="D19"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010215101"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010211101"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010211101","3501010317101")//ok
	endif
elseif _tipo =="D20"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010215107"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010211107"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010211107","3501010317107")//ok
	endif
elseif _tipo =="D21"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102020116103"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101020113103"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101020113103","3501020118104")//ok
	endif

// INATIVADO EM 09/08/06 CONFORME SOLICITAÇÃO DO DEPTO. DE CONTABILIDADE - CHAMADO OCOMON Nº 2168.
//elseif _tipo =="D25"
//	if substr(srz->rz_cc,1,2)== "23"
//		_cconta:="4102010214211"
//	else
//		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010210211","3501010316311")//ok
//	endif
	
	//elseif _tipo =="D25"
	//	_cconta:=if(substr(srz->rz_cc,1,2)<> "29" ,"3201020221227","3102020212227")
	//elseif _tipo =="D26"
	//	_cconta:=if(substr(srz->rz_cc,1,2)<> "29" ,"4101010210213","3501010316313")//ok
elseif _tipo =="D27"       //REFEIÇÃO
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:= "4102010215203" //"4102020516501" //4102
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010212203"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010212203","3501010317203")//OK  
//		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101020513501","3501020518501")//OK
	endif
elseif _tipo =="D29"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010215101"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010211101"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010211101","3501010317101")//OK
	endif
elseif _tipo =="D33"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102020516505"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101020513505"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101020513505","3501020518505")//OK
	endif
elseif _tipo =="D34"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:= "4102010215203" //"4102020516501" //4102
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010212203"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010212203","3501010317203")//OK  
//		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101020513501","3501020518501")//OK
	endif
elseif _tipo =="D42"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:= "4102030110102" 
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101030110102"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101030110102","3501980110102")//OK
	endif 
elseif _tipo =="D43"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:= "4102010215103" 
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010211103"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010211103","3501010317103")//OK
	endif
elseif _tipo =="B02"
	if substr(srz->rz_cc,1,2)== "23"    //alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
		_cconta:="4102010215201"
   
	//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010212201"
	Else 
	//Fim 	
	_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010212201","3501010317201") //OK    			
	endif                                                                                        
	
elseif _tipo =="B03"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010215202"
	//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010212202"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010212202","3501010317202") //OK
	endif
elseif _tipo =="B04"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010214211"
	//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010210211"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010210211","3501010316311") //OK
	endif
elseif _tipo =="B05"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010214212"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010210212"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010210212","3501010316312") //OK
	endif
elseif _tipo =="B06"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010215202"
	//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010212202"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010212202","3501010317202") //OK
	endif
elseif _tipo =="B07"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010215202"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010212202"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010212202","3501010317202") //OK
	endif
elseif _tipo =="B08"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010215201"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010212201"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010212201","3501010317201") //OK
	endif
elseif _tipo =="B09"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010215201"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010212201"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010212201","3501010317201") //OK
	endif
elseif _tipo =="B12"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010215201"
	//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010212201"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010212201","3501010317201") //OK
	endif
elseif _tipo =="B13"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010215202"
		//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010212202"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010212202","3501010317202") //OK
	endif
elseif _tipo =="B21"
	if substr(srz->rz_cc,1,2)== "23"
		_cconta:="4102010215201"
	//Inicio   Alteração 30/08/2016 Ricardo Moreira
	elseIf alltrim(srz->rz_cc)$"28000000/28000001/28010004/28020000/28030002/29050100/29050102"
	_cconta :="4101010212201"
	Else 
	//Fim 	
		_cconta:=if(!substr(srz->rz_cc,1,2)$ "28/29" ,"4101010212201","3501010317201") //OK
	endif	
endif

return(_cconta)
