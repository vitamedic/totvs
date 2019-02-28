#include "rwmake.ch"  
#INCLUDE "TOPCONN.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VIT180   ³ Autor ³ Gardenia Ilany        ³ Data ³ 25/01/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ordem de Producao                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Alterações³ 28/10/05 - Alex Júnio - Inclusao da Descricao cientifica,  ³±±
±±³          ³ nº de Rev e Data da Revisao. Correcoes no Layout.          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

user function VIT180()
titulo  := "FORMULA MESTRE"
cdesc1  := "Este programa ira emitir a Formula Mestre"
cdesc2  := ""
cdesc3  := ""
tamanho := "M"
limite  := 132
cstring :="SC2"
areturn :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog:="VIT180"
aLinha  :={}
nlastkey:=0
lcontinua:=.t.

mpag := 0
nqtdparc:=0
cumemp:='  '
cum := '  '
cperg:="PERGVIT180"
_pergsx1()
pergunte(cperg,.f.)

wnrel:="VIT180"+Alltrim(cusername)
wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)

if nlastkey==27
   set filter to
   return
endif

setdefault(areturn,cstring)

ntipo:=if(areturn[4]==1,15,18)

if nlastkey==27
   set filter to
   return
endif
rptstatus({|| rptdetail()})
return




//*******************************************
//Funcao RptDetail - Impressao do Relatorio
//*******************************************


Static  Function RptDetail()

cbcont := 0
m_pag  := 1
li     := 132
cbtxt  := space(10)

_cfilsb1:=xfilial("SB1")
_cfilsg1:=xfilial("SG1")
_cfilqdh:=xfilial("QDH")
sb1->(dbsetorder(1))
sg1->(dbsetorder(1))
qdh->(dbsetorder(1))

processa({|| _querys()})
   
tmp1->(dbgotop())
while ! tmp1->(eof())
	_produto:=tmp1->produto
	mfirst:=.t.
	mfirst2:=.t.
	sb1->(dbseek(_cfilsb1+tmp1->produto))	
	_desc:=sb1->b1_desc
   _cdesccien:= sb1->b1_desccie
	_prvalid:=sb1->b1_prvalid
	_um:=sb1->b1_um
	_apres:= sb1->b1_apres
	_le:=sb1->b1_le
	_funpos:=sb1->b1_funpos
	_unpos:=sb1->b1_unpos    
   _ddata:= ctod(space(8))
 
   qdh->(dbseek(_cfilqdh+"OP-"+substr(sb1->b1_cod,1,13)))
   While (qdh->qdh_filial == _cfilqdh .and. qdh->qdh_docto == "OP-"+substr(sb1->b1_cod,1,13) .and. !qdh->(EOF()))
       if  qdh->qdh_obsol <> "S" .and. !Empty(qdh->qdh_dtvig)
		   _ddata := qdh->qdh_dtvig
		   _crev  := qdh->qdh_rv
      endif
      qdh->(DBSkip())

	EndDo

	
	if sb1->b1_tipo < mv_par03 .or. sb1->b1_tipo > mv_par04 
	  	tmp1->(dbskip())
		loop
	endif			
	if sb1->b1_grupo < mv_par05 .or. sb1->b1_grupo > mv_par06 
	  	tmp1->(dbskip())
		loop
	endif			

	cab052()
	while ! tmp1->(eof()) .and. _produto == tmp1->produto
//	while ! tmp1->(eof()) .and. _produto >= mv_par01 .and. _produto <= mv_par02
		_tipo:=tmp1->tipo
	   if _tipo =='MP' .or. _tipo=='PI'
			@ prow()+1,000 PSAY "|------------------------------------------------------------------------------------------------------------------------------|"
			@ prow()+1,000 PSAY "|                                        MATERIA  PRIMA                                                                        |"
			@ prow()+1,000 PSAY "|------------------------------------------------------------------------------------------------------------------------------|"
			@ prow()+1,000 PSAY "| Codigo| Materia Prima                              |DCB        |         Qtde Padrao  | UM  |           Qtde.Posologica/"+_unpos+"   |"
			@ prow()+1,000 PSAY "|------------------------------------------------------------------------------------------------------------------------------|"
      elseif _tipo =='EE'
			@ prow()+3,000 PSAY "|------------------------------------------------------------------------------------------------------------------------------|"
			@ prow()+1,000 PSAY "|                                   MATERIAL DE EMBALAGEM ESSENCIAL                                                            |"
			@ prow()+1,000 PSAY "|------------------------------------------------------------------------------------------------------------------------------|"
			@ prow()+1,000 PSAY "| Codigo| Material                                               |         Qtde Padrao  | UM  |           Qtde.Posologica/"+_unpos+"   |"
			@ prow()+1,000 PSAY "|------------------------------------------------------------------------------------------------------------------------------|"
		elseif _tipo =='EN'
			@ prow()+3,000 PSAY "|------------------------------------------------------------------------------------------------------------------------------|"
			@ prow()+1,000 PSAY "|                                 MATERIAL DE EMBALAGEM NAO ESSENCIAL                                                          |"
			@ prow()+1,000 PSAY "|------------------------------------------------------------------------------------------------------------------------------|"
			@ prow()+1,000 PSAY "| Codigo| Material                                               |         Qtde Padrao  | UM  |           Qtde.Posologica/"+_unpos+"   |"
			@ prow()+1,000 PSAY "|------------------------------------------------------------------------------------------------------------------------------|"
      endif

		while ! tmp1->(eof()) .and.;
				_produto >= mv_par01 .and.;
				_produto <= mv_par02 .and.;
				_tipo == tmp1->tipo
				
			_qtde :=0
			_comp:=tmp1->comp              
			_desccomp :=tmp1->descri
			_umcomp := tmp1->um     
			_qtdepos:=0
			_dcb1:=tmp1->dcb1

			while ! tmp1->(eof()) .and.;
					_produto >= mv_par01 .and.;
					_produto <= mv_par02 .and.;
					_tipo == tmp1->tipo  .and.;
					_comp == tmp1->comp 
					
				_qtde += tmp1->quant // * _le 
				_qtdepos+=(tmp1->quant/_funpos)/_le
			  	tmp1->(dbskip())
			end	
			
		   if _tipo =='MP' .or. _tipo=='PI'
				@ prow()+1,000 PSAY "|"
				@ prow(),001 PSAY left(_comp,6)
				@ prow(),008 PSAY "|"
				@ prow(),010 PSAY _desccomp
				@ prow(),053 PSAY "|"         
				if !empty(_dcb1)
					@ prow(),054 PSAY _dcb1 picture "@R 99999.99-9"                                
				endif	
				@ prow(),065 PSAY "|"
				@ prow(),070 PSAY _qtde  picture "@E 999,999,999.999999"
				@ prow(),088 PSAY "|"
				@ prow(),090 PSAY _umcomp   
				@ prow(),094 PSAY "|"

				@ prow(),102 PSAY _qtdepos  picture "@E 999,999,999.999999"
  				@ prow(),122 PSAY "|"
  				@ prow(),123 PSAY _umcomp
  				@ prow(),127 PSAY "|"

			elseif _tipo =='EE'
				@ prow()+1,000 PSAY "|"
				@ prow(),001 PSAY left(_comp,6)
				@ prow(),008 PSAY "|"
				@ prow(),010 PSAY _desccomp
				@ prow(),065 PSAY "|"
				@ prow(),070 PSAY _qtde  picture "@E 999,999,999.999999"
				@ prow(),088 PSAY "|"
				@ prow(),090 PSAY _umcomp   
				@ prow(),094 PSAY "|"

				@ prow(),102 PSAY _qtdepos  picture "@E 999,999,999.999999"
  				@ prow(),122 PSAY "|"
  				@ prow(),123 PSAY _umcomp
  				@ prow(),127 PSAY "|"

			elseif _tipo =='EN'
				@ prow()+1,000 PSAY "|"
				@ prow(),001 PSAY left(_comp,6)
				@ prow(),008 PSAY "|"
				@ prow(),010 PSAY _desccomp
				@ prow(),065 PSAY "|"
				@ prow(),070 PSAY _qtde  picture "@E 999,999,999.999999"
				@ prow(),088 PSAY "|"
				@ prow(),090 PSAY _umcomp   
				@ prow(),094 PSAY "|"

				@ prow(),102 PSAY _qtdepos  picture "@E 999,999,999.999999"
  				@ prow(),122 PSAY "|"
  				@ prow(),123 PSAY _umcomp
  				@ prow(),127 PSAY "|"


			endif    
		end	   
		@ prow()+1,000 PSAY "|------------------------------------------------------------------------------------------------------------------------------|"
	end	

	@ prow()+3,000 PSAY    "|------------------------------------------------------------------------------------------------------------------------------|"
	@ prow()+1,000 PSAY    "|ELABORADOR                     | REVISOR                         | APROVADOR             | GQL                                |"
	@ prow()+1,000 PSAY    "|-------------------------------|---------------------------------|-----------------------|------------------------------------|"
	@ prow()+1,000 PSAY    "|Nome:                          |Nome:                            |Nome:                  |Nome:                               |"
	@ prow()+1,000 PSAY    "|Data:____/____/____            |Data:____/____/____              |Data:____/____/____    |Data____/____/____                  |"
	@ prow()+1,000 PSAY    "|------------------------------------------------------------------------------------------------------------------------------|"
end


tmp1->(dbclosearea())
Set Device To Screen


If ( aReturn[5]==1 )
	Set Print to
	dbCommitall()
	ourspool(wnrel)
EndIf

MS_Flush()
Return



static function _querys()
_cquery:=" SELECT"
_cquery+=" B1_COD COD,B1_DESC DESCRI,B1_TIPO TIPO,B1_UM UM,B1_LOCPAD LOCPAD,B1_GRUPO GRUPO,B1_DCB1 DCB1,"
_cquery+=" G1_COD PRODUTO, G1_COMP COMP,G1_QUANT QUANT,B1_FUNPOS FUNPOS,B1_UNPOS UNPOS"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SG1")+" SG1"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SG1.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND G1_FILIAL='"+_cfilsg1+"'"
//_cquery+=" AND B1_TIPO IN ('MP','EE','EN')"
_cquery+=" AND B1_COD =G1_COMP"
_cquery+=" AND G1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
//_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
//_cquery+=" AND G1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"

_cquery+=" ORDER BY  G1_COD,B1_LOCPAD,B1_TIPO,B1_DESC"


_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","QUANT"  ,"N",15,7)
tcsetfield("TMP1","FUNPOS"  ,"N",9,2)
return




Static function cab052()
	if mfirst
		setprc(0,0)
		mpag:=1
		mfirst:=.f.
	else
	   mpag:=mpag+1 	
	endif
	@ 000,000 PSAY avalimp(133)
	@ 000,000 PSAY chr(18)
   @ prow()+1,000 PSAY "Vitamedic Industria Farmaceutica Ltda." 
   @ prow()  ,103 PSAY "Pag.: "+strzero(mpag,3,0)
   @ prow()+1,000 PSAY "Produto: "+left(tmp1->produto,6)+"-"+_desc
   @ prow()+1,000 PSAY "D.Quimica: "+substr(_cdesccien,1,53) 
   @ prow(),  097 PSAY "Lote Nº. 000000"
   @ prow()+1,000 PSAY "Apresent:"+substr(_apres,1,50)
   @ prow()  ,094 PSAY "Validade: "+strzero((_prvalid/365)*12,2,0)
   @ prow()  ,107 PSAY "meses"
//   @ prow()  ,062 PSAY "Emissao: "+dtoc(database()) 
   if Empty(_ddata)
     @ prow()+1,000 PSAY "Revisao:            Data Revisao:   /   /   "
   else
     @ prow()+1,000 PSAY "Revisao: "+_crev+"        Data Revisao: "+dtoc(_ddata)
   endif  
   @ prow()  ,090 PSAY "Qtde.Teorica:"
   @ prow()  ,103 PSAY _le picture "@E 999,999"
   @ prow()  ,110 PSAY _um
   @ prow()+1,000 PSAY "                                                     FORMULA MESTRE "
   @ prow()+1,000 PSAY replicate("_",127)
   @ prow()+1,000 PSAY chr(15)
 return







/*
|---------------------------------------------------------------------------------------------|
|                                   REQUISICAO DE MATERIA PRIMA                               |
|---------------------------------------------------------------------------------------------|
| Codigo| Materia Prima                            |Endereco |Peso Balanca      |UM|Lote      |
|---------------------------------------------------------------------------------------------|
| 999999|-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |         |999.999.999,999999|xx |999999   |
|---------------------------------------------------------------------------------------------|
|                                                          |                                  |
|Remetido por:__________________________   Data:___/___/___|                                  |
|                                                          |                                  |
|Separado por:__________________________   Data:___/___/___|                                  |
|                                                          |                                  |
|Pesado por  :__________________________   Data:___/___/___|                                  |
|                                                          |__________________________________|
|Material recebido na producao                             |DCQ:                              |
|                                                          |                                  |
|Conferido por:_________________________   Data:___/___/___|__________________________________|
|                                                                                             |
|Observacoes:_________________________________________________________________________________|
|                                                                                             |
|_____________________________________________________________________________________________|
|                                                                                             |
|_____________________________________________________________________________________________|



|-------------------------------------------------------------------------------------------------------------------|
| 						    	      	REQUISICAO DE MATERIAL DE EMBALAGEM                                                |
|-------------------------------------------------------------------------------------------------------------------|        |
| Codigo| Material                                |Endereco |UM |Lote     |Separador          |Conferente  |Data    |
|-------------------------------------------------|---------|---|---------|-------------------|------------|--------|
| 999999|XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |         |XX |999999   |                   |            |99/99/99|
|-------------------------------------------------------------------------------------------------------------------|        |



|---------------------------------------------------------------------------------------------|
|                                   CONFERENCIA DE PESAGEM DE MATERIA PRIMA                   |
|---------------------------------------------------------------------------------------------|
| Codigo| Materia Prima                            |Endereco |Peso Balanca      |UM |Lote     |
|---------------------------------------------------------------------------------------------|
| 999999|-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |         |                  |xx |999999   |
|---------------------------------------------------------------------------------------------|
         

*/

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo            ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})

	
for _i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[_i,1]+_agrpsx1[_i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[_i,01]
		sx1->x1_ordem  :=_agrpsx1[_i,02]
		sx1->x1_pergunt:=_agrpsx1[_i,03]
		sx1->x1_variavl:=_agrpsx1[_i,04]
		sx1->x1_tipo   :=_agrpsx1[_i,05]
		sx1->x1_tamanho:=_agrpsx1[_i,06]
		sx1->x1_decimal:=_agrpsx1[_i,07]
		sx1->x1_presel :=_agrpsx1[_i,08]
		sx1->x1_gsc    :=_agrpsx1[_i,09]
		sx1->x1_valid  :=_agrpsx1[_i,10]
		sx1->x1_var01  :=_agrpsx1[_i,11]
		sx1->x1_def01  :=_agrpsx1[_i,12]
		sx1->x1_cnt01  :=_agrpsx1[_i,13]
		sx1->x1_var02  :=_agrpsx1[_i,14]
		sx1->x1_def02  :=_agrpsx1[_i,15]
		sx1->x1_cnt02  :=_agrpsx1[_i,16]
		sx1->x1_var03  :=_agrpsx1[_i,17]
		sx1->x1_def03  :=_agrpsx1[_i,18]
		sx1->x1_cnt03  :=_agrpsx1[_i,19]
		sx1->x1_var04  :=_agrpsx1[_i,20]
		sx1->x1_def04  :=_agrpsx1[_i,21]
		sx1->x1_cnt04  :=_agrpsx1[_i,22]
		sx1->x1_var05  :=_agrpsx1[_i,23]
		sx1->x1_def05  :=_agrpsx1[_i,24]
		sx1->x1_cnt05  :=_agrpsx1[_i,25]
		sx1->x1_f3     :=_agrpsx1[_i,26]
		sx1->(msunlock())
	endif
next
return





