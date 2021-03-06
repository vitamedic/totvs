/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT067   � Autor � Aline B.Pereira       � Data � 07/02/02 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Impressao da Fichas de Controle de Recebimento de Material 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitamedic                                  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/


#include "rwmake.ch"

user function vit067(_lauto)
if _lauto==nil
	_lauto:=.f.
endif
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="CONTROLE DE RECEBIMENTO DE MATERIAL     "
cdesc1   :="Este programa ira emitir a ficha de controle de recebimento de material"
cdesc2   :=""
cdesc3   :=""
cstring  :="SD1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT067"
wnrel    :="VIT067"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

if _lauto
	cperg:=""
	mv_par01:=sd1->d1_dtdigit   // DA DATA
	mv_par02:=sd1->d1_dtdigit   // ATE A DATA	
	mv_par03:=sd1->d1_doc       // DA NOTA FISCAL
	mv_par04:=sd1->d1_doc       // ATE A NOTA FISCAL
	mv_par05:=sd1->d1_serie     // DA SERIE
	mv_par06:=sd1->d1_serie     // ATE A SERIE
	mv_par07:="               " // DO PRODUTO
	mv_par08:="ZZZZZZZZZZZZZZZ" // ATE O PRODUTO
	mv_par09:="S"               // REIMPRIME JA IMPRES
else
	cperg:="PERGVIT067"
	_pergsx1()
	pergunte(cperg,.f.) 
endif

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
//Funcao rptdetail - impressao do relatorio
//*******************************************

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

cabec1:=""
cabec2:=""

_cfilsa2:=xfilial("SA2")
_cfilsb1:=xfilial("SB1")
_cfilsd1:=xfilial("SD1")
_cfilsf4:=xfilial("SF4")
sa2->(dbsetorder(1))
sb1->(dbsetorder(1))
sd1->(dbsetorder(6))
sf4->(dbsetorder(1))

setregua(sd1->(lastrec()))

mcont:=0
sd1->(dbseek(_cfilsd1+dtos(mv_par01),.t.))
while ! sd1->(eof()) .and.;
		sd1->d1_filial==_cfilsd1 .and.;
		sd1->d1_dtdigit<=mv_par02 .and.;
		lcontinua
	incregua()
	if ! empty(sd1->d1_lotectl) .and.;
		sd1->d1_tipo=="N" .and.;
		sd1->d1_doc>=mv_par03 .and.;
		sd1->d1_doc<=mv_par04 .and.;
		sd1->d1_serie>=mv_par05 .and.;
		sd1->d1_serie<=mv_par06 .and.;
		sd1->d1_cod>=mv_par07 .and.;
		sd1->d1_cod<=mv_par08 .and.;
	   sd1->d1_numvol>0 .and.;            
	   (empty(sd1->d1_recmat) .or.  mv_par09="S").and.; 
		sf4->(dbseek(_cfilsf4+sd1->d1_tes)) .and.;
		sf4->f4_estoque=="S"

		sa2->(dbseek(_cfilsa2+sd1->d1_fornece+sd1->d1_loja))
		sb1->(dbseek(_cfilsb1+sd1->d1_cod))

		if !empty(sd1->d1_fabric)
	      _mfab :=alltrim(substr(sd1->d1_fabric,1,40))	      
		else
			_mfab :=alltrim(substr(sa2->a2_nome,1,40))
		endif
		
 	   if mcont==2
 	   	eject
			mcont:=0
		endif
		
   	if mcont==0
			setprc(0,0)
			@ 000,000 PSAY avalimp(limite)
   		@ prow()+1,001 PSAY "__________________________________________________________________________________________________"
		else
			@ prow()+3,001 PSAY "__________________________________________________________________________________________________"
		endif

		mcont++
		if sb1->b1_grupo="MP03"	
	      @ prow()+1,001 PSAY "|                          CONTROLE DE RECEBIMENTO DE MATERIAL PARA DESENVOLVIMENTO"+space(12)+" |"                                             
	   else   
	      @ prow()+1,001 PSAY "|                          CONTROLE DE RECEBIMENTO DE MATERIAL "+space(34)+" |"                                             
	   endif   
   	@ prow()+1,001 PSAY "|_________________________________________________________________________________________________|"
      @ prow()+1,001 PSAY "|1� Etapa - Almoxarifado                            | 2� Etapa - CQ                               |"
		@ prow()+1,001	PSAY "| "+alltrim(sd1->d1_cod)+"-"+substr(sb1->b1_desc,1,40)
      @ prow()  ,053 PSAY "|_____________________________________________|"
		@ prow()+1,001 PSAY "|                                                   |1- As embalagens encontram-se integras (sem  |"
		@ prow()+1,001 PSAY "| Lote Vitamedic: "+alltrim(sd1->d1_lotectl)
      @ prow()  ,053 PSAY "| deformacoes, rasgos, manchas e umidade).    |"
		@ prow()+1,001 PSAY "| Data Validade: "+dtoc(sd1->d1_dtvalid)
      @ prow()  ,053 PSAY "|                                             |"
  		@ prow()+1,001 PSAY "| Fabricante: "+_mfab
      @ prow()  ,053 PSAY "| (  ) De acordo      (  ) Em desacordo       |"
  		@ prow()+1,001 PSAY "| Lote : "+if(!empty(sd1->d1_lotfabr),alltrim(sd1->d1_lotfabr),alltrim(sd1->d1_lotefor))
      @ prow()  ,053 PSAY "|                                             |"
		@ prow()+1,001 PSAY "| Qtde Recebida: "+TRANSFORM(sd1->d1_quant,"@E 999,999,999")+" "+sd1->d1_um
      @ prow()  ,053 PSAY "|_____________________________________________|"
		@ prow()+1,001 PSAY "| Volumes : "+TRANSFORM(sd1->d1_numvol,"@E 99999")
      @ prow()  ,053 PSAY "|2- Nome, Dt. Validade e Lote Produto (emba-  |"
		@ prow()+1,001 PSAY "| Fornecedor: "+alltrim(substr(sa2->a2_nome,1,25))
      @ prow()  ,053 PSAY "|lagem x laudo fornecedor)                    |"
		@ prow()+1,001 PSAY "| Lote: "+alltrim(sd1->d1_lotefor)
		@ prow()  ,053 PSAY "|                                             |"
		@ prow()+1,001 PSAY "| Entrada : "+dtoc(sd1->d1_dtdigit)
      @ prow()  ,053 PSAY "| (  ) De acordo      (  ) Em desacordo       |"
		@ prow()+1,001 PSAY "| NF.: "+sd1->d1_doc+" "+sd1->d1_serie
      @ prow()  ,053 PSAY "|                                             |"
      @ prow()+1,001 PSAY "| Impressao: "+dtoc(date())+"  "+time()+" h                 |_____________________________________________|" 
      @ prow()+1,001 PSAY "|                                                                                                 |" 
      @ prow()+1,001 PSAY "| Amostragem: Inicio: ____/____/____  ____:____h    Fim: ____/____/____  ____:____h  ____________ |"
      @ prow()+1,001 PSAY "|                                                                                                 |"
      @ prow()+1,001 PSAY "| No. de Analise: _____________________________                                                   |"
      @ prow()+1,001 PSAY "|                                                                                                 |"
      @ prow()+1,001 PSAY "| An.Mat.Emb: Inicio: ____/____/____  ____:____h    Fim: ____/____/____  ____:____h  ____________ |"
      @ prow()+1,001 PSAY "|                                                                                                 |"
      @ prow()+1,001 PSAY "| Anal.Quim: Entrada: ____/____/____  ____:____h  Laudo: ____/____/____  ____:____h  ____________ |"
      @ prow()+1,001 PSAY "|                                                                                                 |"
      @ prow()+1,001 PSAY "| An. Micro: Entrada: ____/____/____  ____:____h  Laudo: ____/____/____  ____:____h  ____________ |"
      @ prow()+1,001 PSAY "|                                                                                                 |"
 	   @ prow()+1,001 PSAY "| Aprovacao : ____/____/____  ____:____h   ______________________________________________________ |"
      @ prow()+1,001 PSAY "|                                                                                                 |" 
 	   @ prow()+1,001 PSAY "| _______________________________________________________________________________________________ |"
      @ prow()+1,001 PSAY "|                                                                                                 |" 
 	   @ prow()+1,001 PSAY "| _______________________________________________________________________________________________ |"
      @ prow()+1,001 PSAY "|                                                                                                 |" 
 	   @ prow()+1,001 PSAY "| _______________________________________________________________________________________________ |"
      @ prow()+1,001 PSAY "|                                                                                                 |" 
 	   @ prow()+1,001 PSAY "| _______________________________________________________________________________________________ |"
 	   reclock("SD1",.F.)
 	   SD1->D1_RECMAT:="S"
 	   msunlock()
   endif
 	sd1->(dbskip())
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif    
end
if prow()>0
	@ 66,00 PSAY " "
	setprc(0,0)
endif

set device to screen

setpgeject(.f.)

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return

Static function cab067()
	if mfirst
//		setprc(0,0)
		mpag:=1
		mfirst:=.f.
	else
	   mpag:=mpag+1 	
	endif
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Da nota fiscal     ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate a nota fiscal  ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Da serie           ?","mv_ch5","C",03,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate a serie        ?","mv_ch6","C",03,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Do produto         ?","mv_ch7","C",15,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"08","Ate o produto      ?","mv_ch8","C",15,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"09","Reimprime j� impres?","mv_ch9","C",01,0,0,"G",space(60),"mv_par09"       ,space(01)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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


/*
_______________________________________________________________________________
|                 Controle de Recebimento de Material								   |
|_____________________________________________________________________________|
|1� Etapa - Almoxarifado               | 2� Etapa - CQ                        |
| 999999 - XXXXXXXXXXXXXXXXXXXXXXXXXXX |--------------------------------------|
| xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx |1- As embalagens encontram-se integras|
| Lote Vitapan :     						|(sem deformacoes, rasgos, manchas e	|
| Data Validade:                       | umidade). 									|
| Lote origem..:                    	| (  ) De acordo    (  ) Em desacordo  |
| Qtde Recebida:            				|--------------------------------------|
| N� Volumes...:                       |2- Nome, Data de Validade e Lote do   |
| Fornecedor...:                       | produto (embalagem X laudo fornecedor|
|													| (  ) De acordo    (  ) Em desacordo  |
| Data Entrada.:  	   					|--------------------------------------|
| NF n�........:                    	| Fabricante :_________________________|
| ___________________________________  | Data: _____/____/____                |
| ___________________________________  | Amostragem : ________________________| 
| ___________________________________  | _____________________________________| 
| ___________________________________  | _____________________________________| 
|______________________________________|______________________________________|*/


