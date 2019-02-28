/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT353   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 11/02/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Acompanhamento Diario de Apontamentos de Produção          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "dialog.ch"
#include "topconn.ch"

user function vit353()
nordem  :=""
tamanho :="G"
limite  :=220
titulo  :="ACOMPANHAMENTO DIARIO APONTAMENTO DE PRODUCAO"
cdesc1  :="Este programa ira emitir uma lista com os apontamentos de producao "
cdesc2  :="realizados por período ordenados diariamente"
cdesc3  :=""
cstring :="SD3"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT353"
wnrel   :="VIT353"+Alltrim(cusername)
alinha  :={}
aordem  :={"Dt.Entrada + Linha","Dt.Entrada + Produto","Linha","Produto"}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)

cperg:="PERGVIT353"
_pergsx1()
pergunte(cperg,.f.)


wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo :=if(areturn[4]==1,15,18)
nordem:=areturn[8]

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
_cfilsra:=xfilial("SD3")
sd3->(dbsetorder(1))

//----------------------------------------------------------------------------------------------------------------//
// Exportacao de dados para o Excel.
//----------------------------------------------------------------------------------------------------------------//

_aCabec := {}
_aDados := {}
_aSaldo := {}

If !ApOleClient("MSExcel")
   MsgAlert("Microsoft Excel não instalado!")
   Return
EndIf

if nordem==1
	_aCabec := {"Dt Entrada","Grupo","Codigo","Produto","OP","Qtde","Qtd UN Farma","Qtd Nucleos"}
elseif nordem==2
	_aCabec := {"Dt Entrada","Codigo","Produto","Grupo","OP","Qtde","Qtd UN Farma","Qtd Nucleos"}
elseif nordem==3
	_aCabec := {"Grupo","Dt Entrada","Codigo","Produto","OP","Qtde","Qtd UN Farma","Qtd Nucleos"}
else
	_aCabec := {"Codigo","Produto","Dt Entrada","Grupo","OP","Qtde","Qtd UN Farma","Qtd Nucleos"}
endif

processa({|| _querys()})
tmp1->(dbgotop())

_dtent   := ctod("  /  /  ")
_grupo   := ""
_produto := "" 

_subqtd   := 0
_totqtd   := 0
_subfarma := 0
_totfarma := 0  
_subnucleo:= 0
_totnucleo:= 0
_linha    := 1

if mv_par05==1
	if nordem==1
		
		While !tmp1->(Eof())         	
			//_aCabec := {"Dt Entrada","Grupo","Codigo","Produto","OP","Qtde","Qtd UN Farma","Qtd Nucleos"}
			if _dtent==tmp1->entrada
				AAdd(_aDados, {" ", tmp1->grupo, tmp1->codigo, tmp1->produto, tmp1->op, tmp1->qtd_cx, tmp1->qtd_farma, tmp1->qtd_nucleo})
				_subqtd += tmp1->qtd_cx
				_totqtd += tmp1->qtd_cx				
				_subfarma += tmp1->qtd_farma
				_totfarma += tmp1->qtd_farma
				_subnucleo += tmp1->qtd_nucleo
				_totnucleo += tmp1->qtd_nucleo
			else 
				if _linha<>1
					AAdd(_aDados, {"Sub Total ", _dtent, " ", " ", " ", _subqtd, _subfarma, _subnucleo})
					AAdd(_aDados, {" ", " "," "," "," "," "," "," "})
				else 
					_linha++
				endif
				AAdd(_aDados, {tmp1->entrada, " "," "," "," "," "," "," "})
				AAdd(_aDados, {" ", tmp1->grupo, tmp1->codigo, tmp1->produto, tmp1->op, tmp1->qtd_cx, tmp1->qtd_farma, tmp1->qtd_nucleo})
				_dtent:=tmp1->entrada
						
				_subqtd := tmp1->qtd_cx
				_totqtd += tmp1->qtd_cx				
				_subfarma := tmp1->qtd_farma
				_totfarma += tmp1->qtd_farma
				_subnucleo := tmp1->qtd_nucleo
				_totnucleo += tmp1->qtd_nucleo
			endif
			tmp1->(dbSkip())
		end
		AAdd(_aDados, {"Sub Total ", _dtent, " ", " ", " ", _subqtd, _subfarma, _subnucleo})

	elseif nordem==2
		While !tmp1->(Eof())         	
			//_aCabec := {"Dt Entrada","Codigo","Produto","Grupo","OP","Qtde","Qtd UN Farma","Qtd Nucleos"}
			if _dtent==tmp1->entrada
				AAdd(_aDados, {" ", tmp1->codigo, tmp1->produto, tmp1->grupo, tmp1->op, tmp1->qtd_cx, tmp1->qtd_farma})   
				_subqtd += tmp1->qtd_cx
				_totqtd += tmp1->qtd_cx				
				_subfarma += tmp1->qtd_farma
				_totfarma += tmp1->qtd_farma				
				_subnucleo += tmp1->qtd_nucleo
				_totnucleo += tmp1->qtd_nucleo
			else 
				if _linha<>1
					AAdd(_aDados, {"Sub Total ", _dtent, " ", " ", " ", _subqtd, _subfarma, _subnucleo})
					AAdd(_aDados, {" ", " "," "," "," "," "," "," "})
				else
					_linha++
				endif
				AAdd(_aDados, {tmp1->entrada, " "," "," "," "," "," "," "})
				AAdd(_aDados, {" ", tmp1->codigo, tmp1->produto, tmp1->grupo, tmp1->op, tmp1->qtd_cx, tmp1->qtd_farma, tmp1->qtd_nucleo})
				_dtent:=tmp1->entrada		
					
				_subqtd := tmp1->qtd_cx
				_totqtd += tmp1->qtd_cx				
				_subfarma := tmp1->qtd_farma
				_totfarma += tmp1->qtd_farma
				_subnucleo := tmp1->qtd_nucleo
				_totnucleo += tmp1->qtd_nucleo
			endif
			tmp1->(dbSkip())
		end
		AAdd(_aDados, {"Sub Total ", _dtent, " ", " ", " ", _subqtd, _subfarma, _subnucleo})

	elseif nordem==3
		While !tmp1->(Eof())         	
			//_aCabec := {"Grupo","Dt Entrada","Codigo","Produto","OP","Qtde","Qtd UN Farma","Qtd Nucleos"}
			if _grupo==tmp1->grupo
				AAdd(_aDados, {" ", tmp1->entrada, tmp1->codigo, tmp1->produto, tmp1->op, tmp1->qtd_cx, tmp1->qtd_farma, tmp1->qtd_nucleo})
				_subqtd += tmp1->qtd_cx
				_totqtd += tmp1->qtd_cx				
				_subfarma += tmp1->qtd_farma
				_totfarma += tmp1->qtd_farma				
				_subnucleo += tmp1->qtd_nucleo
				_totnucleo += tmp1->qtd_nucleo
			else 
				if _linha<>1
					AAdd(_aDados, {"Sub Total ", _grupo, " ", " ", " ", _subqtd, _subfarma, _subnucleo})
					AAdd(_aDados, {" ", " "," "," "," "," "," "," "})
				else
					_linha++
				endif
				AAdd(_aDados, {tmp1->grupo, " "," "," "," "," "," "," "})
				AAdd(_aDados, {" ", tmp1->entrada, tmp1->codigo, tmp1->produto, tmp1->op, tmp1->qtd_cx, tmp1->qtd_farma, tmp1->qtd_nucleo})
				_grupo := tmp1->grupo			
					
				_subqtd := tmp1->qtd_cx
				_totqtd += tmp1->qtd_cx				
				_subfarma := tmp1->qtd_farma
				_totfarma += tmp1->qtd_farma
				_subnucleo := tmp1->qtd_nucleo
				_totnucleo += tmp1->qtd_nucleo
			endif
			tmp1->(dbSkip())
		end
		AAdd(_aDados, {"Sub Total ", _grupo, " ", " ", " ", _subqtd, _subfarma, _subnucleo})

	else
		While !tmp1->(Eof())         	
			//_aCabec := {"Codigo","Produto","Dt Entrada","Grupo","OP","Qtde","Qtd UN Farma","Qtd Nucleos"}
			if _produto==tmp1->codigo
				AAdd(_aDados, {" ", " ", tmp1->entrada, tmp1->grupo, tmp1->op, tmp1->qtd_cx, tmp1->qtd_farma, tmp1->qtd_nucleo})
				_subqtd += tmp1->qtd_cx
				_totqtd += tmp1->qtd_cx				
				_subfarma += tmp1->qtd_farma
				_totfarma += tmp1->qtd_farma				
				_subnucleo += tmp1->qtd_nucleo
				_totnucleo += tmp1->qtd_nucleo
			else 
				if _linha<>1
					AAdd(_aDados, {"Sub Total ", _produto, " ", " ", " ", _subqtd, _subfarma, _subnucleo})
					AAdd(_aDados, {" ", " "," "," "," "," "," "," "})
				else
					_linha++
				endif
				AAdd(_aDados, {tmp1->codigo, tmp1->produto," "," "," "," "," "," "})
				AAdd(_aDados, {" ", " ", tmp1->entrada, tmp1->grupo, tmp1->op, tmp1->qtd_cx, tmp1->qtd_farma, tmp1->qtd_nucleo})
				_produto := tmp1->codigo
					
				_subqtd := tmp1->qtd_cx
				_totqtd += tmp1->qtd_cx				
				_subfarma := tmp1->qtd_farma
				_totfarma += tmp1->qtd_farma
				_subnucleo := tmp1->qtd_nucleo
				_totnucleo += tmp1->qtd_nucleo
			endif
			tmp1->(dbSkip())
		end                        
		AAdd(_aDados, {"Sub Total ", _produto, " ", " ", " ", _subqtd, _subfarma, _subnucleo})
		
	endif                                  
	AAdd(_aDados, {" ", " "," "," "," "," "," "," "})
	AAdd(_aDados, {"Total ", " ", " ", " ", " ", _totqtd, _totfarma, _totnucleo})

else
	if nordem==1	
		While !tmp1->(Eof())         	
			AAdd(_aDados, {tmp1->entrada, tmp1->grupo, tmp1->codigo, tmp1->produto, tmp1->op, tmp1->qtd_cx, tmp1->qtd_farma, tmp1->qtd_nucleo})
			tmp1->(dbSkip())
		end
	elseif nordem==2
		While !tmp1->(Eof())         	
			AAdd(_aDados, {tmp1->entrada, tmp1->codigo, tmp1->produto, tmp1->grupo, tmp1->op, tmp1->qtd_cx, tmp1->qtd_farma, tmp1->qtd_nucleo})
			tmp1->(dbSkip())
		end
	elseif nordem==3
		While !tmp1->(Eof())         	
			AAdd(_aDados, {tmp1->grupo, tmp1->entrada, tmp1->codigo, tmp1->produto, tmp1->op, tmp1->qtd_cx, tmp1->qtd_farma, tmp1->qtd_nucleo})
			tmp1->(dbSkip())
		end
	else
		While !tmp1->(Eof())         	
			AAdd(_aDados, {tmp1->codigo, tmp1->produto, tmp1->entrada, tmp1->grupo, tmp1->op, tmp1->qtd_cx, tmp1->qtd_farma, tmp1->qtd_nucleo})
			tmp1->(dbSkip())
		end
	endif
endif
	
if mv_par04 > mv_par03
	if nordem==1
		DlgToExcel({ {"ARRAY", "ENTRADAS ENTRE "+dtos(mv_par03)+" E "+dtos(mv_par04)+" - POR DT.ENTRADA E LINHA", _aCabec, _aDados} })
    elseif nordem==2
		DlgToExcel({ {"ARRAY", "ENTRADAS ENTRE "+dtos(mv_par03)+" E "+dtos(mv_par04)+" - POR DT.ENTRADA E PRODUTO", _aCabec, _aDados} })
    elseif nordem==3
		DlgToExcel({ {"ARRAY", "ENTRADAS ENTRE "+dtos(mv_par03)+" E "+dtos(mv_par04)+" - POR LINHA", _aCabec, _aDados} })
	else 
		DlgToExcel({ {"ARRAY", "ENTRADAS ENTRE "+dtos(mv_par03)+" E "+dtos(mv_par04)+" - POR PRODUTO", _aCabec, _aDados} })
	endif
else
	if nordem==1
		DlgToExcel({ {"ARRAY", "ENTRADAS EM "+dtos(mv_par03)+" - POR DT.ENTRADA E LINHA", _aCabec, _aDados} })
    elseif nordem==2
		DlgToExcel({ {"ARRAY", "ENTRADAS EM "+dtos(mv_par03)+" - POR DT.ENTRADA E PRODUTO", _aCabec, _aDados} })
    elseif nordem==3
		DlgToExcel({ {"ARRAY", "ENTRADAS EM "+dtos(mv_par03)+" - POR LINHA", _aCabec, _aDados} })
	else 
		DlgToExcel({ {"ARRAY", "ENTRADAS EM "+dtos(mv_par03)+" - POR PRODUTO", _aCabec, _aDados} })
	endif
endif

//AAdd(_aSaldo,_aCabec)

tmp1->(dbclosearea())

set device to screen

ms_flush()
return

static function _querys()

_cquery:=" SELECT"
_cquery+="   CODIGO,"
_cquery+="   PRODUTO,"
_cquery+="   GRUPO,"
_cquery+="   OP,"
_cquery+="   Sum(QUANT) QTD_CX,"
_cquery+="   Sum(QTD_FARMA) QTD_FARMA,"
_cquery+="   Sum(QTD_NUCLEO) QTD_NUCLEO,"
_cquery+="   ENTRADA"
_cquery+="   FROM "
_cquery+="     (SELECT"
_cquery+="        D3_COD CODIGO,"
_cquery+="        B1_DESC PRODUTO,"
_cquery+="        CASE"
_cquery+="           WHEN BM_GRUPO='PA01' THEN 'LIQ.MENOR VOLUME'"
_cquery+="           WHEN BM_GRUPO='PA02' THEN 'LIQ.MAIOR VOLUME'"
_cquery+="           WHEN BM_GRUPO='PA03' THEN 'SEMI-SOLIDOS'"
_cquery+="           WHEN BM_GRUPO IN ('PA04','PA05','PA06','PA07','PA10','PA12') THEN 'TERCEIRIZADOS'"
_cquery+="           ELSE 'SOLIDOS'"
_cquery+="        END GRUPO,"
_cquery+="        SubStr(D3_OP,1,6) OP,"
_cquery+="        D3_QUANT QUANT,"
_cquery+="        (D3_QUANT*B1_CONVFH) QTD_FARMA,"
_cquery+="        (D3_QUANT*B1_CONV) QTD_NUCLEO,"
_cquery+="        D3_EMISSAO ENTRADA"
_cquery+="        FROM "
_cquery+=  retsqlname("SD3")+" SD3,"
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SBM")+" SBM"
_cquery+="     WHERE SD3.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' AND SBM.D_E_L_E_T_=' '"
_cquery+="       AND D3_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+="       AND D3_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
_cquery+="       AND D3_ESTORNO<>'S'"
_cquery+="       AND D3_TM='001'"
_cquery+="       AND D3_QUANT>0"
_cquery+="       AND D3_COD=B1_COD"
_cquery+="       AND B1_TIPO IN ('PA','PL')"
_cquery+="       AND B1_GRUPO=BM_GRUPO"
_cquery+="     )"
_cquery+=" GROUP BY CODIGO, PRODUTO, GRUPO, OP, ENTRADA"

if nordem==1
	_cquery+=" ORDER BY ENTRADA, GRUPO, PRODUTO"
elseif nordem==2
	_cquery+=" ORDER BY ENTRADA, PRODUTO"
elseif nordem==3
	_cquery+=" ORDER BY GRUPO, ENTRADA"
else
	_cquery+=" PRODUTO, ENTRADA"
endif


_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","QTD_CX","N",15,2)
tcsetfield("TMP1","QTD_FARMA","N",15,2)
tcsetfield("TMP1","QTD_NUCLEO","N",15,2)
tcsetfield("TMP1","ENTRADA","D")

return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto             ?","mv_ch1","C",08,0,0,"G",space(60)   ,"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto          ?","mv_ch2","C",08,0,0,"G",space(60)   ,"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Da data de entrada     ?","mv_ch3","D",08,0,0,"G",space(60)   ,"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate a dt.de entrada    ?","mv_ch4","D",08,0,0,"G",space(60)   ,"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Totalizador Grupos     ?","mv_ch5","N",01,0,0,"C",space(60)   ,"mv_par05"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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