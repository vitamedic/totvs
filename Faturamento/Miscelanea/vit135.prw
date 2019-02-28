#include "rwmake.ch"        
#include "TOPCONN.CH"

User Function VIT135()      


SetPrvt("_CPERG,CCADASTRO,AROTINA,ACAMPOS,CMARCA,LGRADE,_CFILSF2")
SetPrvt("LINVERTE,CQUERY1,_CARQTMP1,_AGRPSX1,I,")

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT135  ³ Autor ³ Gardenia Ilany        ³ Data ³ 16/04/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Geracao do Arquivo Passes Fiscais Via Protocolo FTP        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


/*
Variaveis utilizadas para parametros
mv_par01,Da Nota 
mv_par02,Ate o Nota   
mv_par03,Da Emissao 
mv_par04,Ate a Emissao  
mv_par05,Transportadora 
mv_par06,Nº Remessa  
mv_par07,Inscrição Estadual
mv_par08,Nº Credenciamento 
mv_par09,CPF. Responsável 
mv_par10,UF do CPF Respons. 
*/

_cfilsf2:=xfilial("SF2")

_cperg:="PERGVIT135"
_pergsx1()
if pergunte(_cperg,.t.)
	processa({|| _querys()})

	ccadastro:="Selecionar notas para geracao de arquivo"

	arotina:={}
	aadd(arotina,{"Gerar arquivo",'execblock("VIT135A",.f.,.f.)',0,3})

	acampos:={}
	aadd(acampos,{ "OK"        ,"",""})
	aadd(acampos,{ "EMISSAO","","Emissao"})
	aadd(acampos,{ "SERIE"  ,"","Serie"})
	aadd(acampos,{ "DOC"    ,"","Nota"})
//	aadd(acampos,{ "VALFAT" ,"","Valor fatura"})
//	aadd(acampos,{ "VALBRUT","","Valor bruto"})
	aadd(acampos,{ "CLIENTE","","Cliente"})
	aadd(acampos,{ "TRANSP" ,"","Transportadora"})
	aadd(acampos,{ "LOJA"   ,"","Loja"})
	aadd(acampos,{ "EST"    ,"","Estado"})

	cmarca    :=getmark()
	lgrade    :=.t.
	linverte  :=.t.
	markbrowse("TMP1","OK",,acampos,@linverte,@cmarca)

	tmp1->(dbclosearea())
	ferase(_carqtmp1+getdbextension())
endif
return


Static function _querys()
procregua(2)
incproc("Selecionando notas fiscais...")
_cquery:=" SELECT"
_cquery+=" F2_DOC DOC,F2_CLIENTE CLIENTE,F2_EMISSAO EMISSAO,F2_EST EST,F2_VALBRUT VALBRUT,"
_cquery+=" F2_SERIE SERIE,F2_LOJA LOJA,F2_TRANSP TRANSP,F2_VALFAT VALFAT,'   ' OK"
_cquery+=" FROM "
_cquery+=  retsqlname("SF2")+" SF2,"
_cquery+=" WHERE"
_cquery+="     SF2.D_E_L_E_T_<>'*'"
_cquery+=" AND F2_FILIAL='"+_cfilsf2+"'"
_cquery+=" AND F2_TRANSP='"+mv_par05+"'"
_cquery+=" AND F2_DOC  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND F2_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
_cquery+=" AND F2_CLIENTE BETWEEN '"+mv_par11+"' AND '"+mv_par13+"'"
_cquery+=" AND F2_LOJA BETWEEN '"+mv_par12+"' AND '"+mv_par14+"'"
_cquery+=" AND F2_SERIE BETWEEN '"+mv_par15+"' AND '"+mv_par15+"'"
_cquery+=" ORDER BY F2_DOC,F2_CLIENTE,F2_LOJA"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","VALBRUT"  ,"N",15,2)
tcsetfield("TMP1","VALFAT"  ,"N",15,2)

incproc("Selecionando notas fiscais...")
_carqtmp1:=criatrab(,.f.)
copy to &_carqtmp1
tmp1->(dbclosearea())
dbusearea(.t.,,_carqtmp1,"TMP1",.f.)
return


Static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Da Nota            ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"02","Ate o Nota         ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"03","Da Emissao         ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"04","Ate a Emissao      ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"05","Transportadora     ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA4"})
aadd(_agrpsx1,{_cperg,"06","Nº Remessa         ?","mv_ch6","N",08,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"07","Inscrição Estadual ?","mv_ch7","N",09,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"08","Nº Credenciamento  ?","mv_ch8","N",05,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"09","CPF. Responsável   ?","mv_ch9","N",11,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"10","UF do CPF Respons. ?","mv_ch10","C",02,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
for i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[i,1]+_agrpsx1[i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[i,01]
		sx1->x1_ordem  :=_agrpsx1[i,02]
		sx1->x1_pergunt:=_agrpsx1[i,03]
		sx1->x1_variavl:=_agrpsx1[i,04]
		sx1->x1_tipo   :=_agrpsx1[i,05]
		sx1->x1_tamanho:=_agrpsx1[i,06]
		sx1->x1_decimal:=_agrpsx1[i,07]
		sx1->x1_presel :=_agrpsx1[i,08]
		sx1->x1_gsc    :=_agrpsx1[i,09]
		sx1->x1_valid  :=_agrpsx1[i,10]
		sx1->x1_var01  :=_agrpsx1[i,11]
		sx1->x1_def01  :=_agrpsx1[i,12]
		sx1->x1_cnt01  :=_agrpsx1[i,13]
		sx1->x1_var02  :=_agrpsx1[i,14]
		sx1->x1_def02  :=_agrpsx1[i,15]
		sx1->x1_cnt02  :=_agrpsx1[i,16]
		sx1->x1_var03  :=_agrpsx1[i,17]
		sx1->x1_def03  :=_agrpsx1[i,18]
		sx1->x1_cnt03  :=_agrpsx1[i,19]
		sx1->x1_var04  :=_agrpsx1[i,20]
		sx1->x1_def04  :=_agrpsx1[i,21]
		sx1->x1_cnt04  :=_agrpsx1[i,22]
		sx1->x1_var05  :=_agrpsx1[i,23]
		sx1->x1_def05  :=_agrpsx1[i,24]
		sx1->x1_cnt05  :=_agrpsx1[i,25]
		sx1->x1_f3     :=_agrpsx1[i,26]
		sx1->(msunlock())
	endif
next
return
