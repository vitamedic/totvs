/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT329   ³ Autor ³ Reuber Abdias M. Jr.  ³ DATA ³ 12/02/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Exporta Excel Dados Referente Ultimas Compras por Solici-  ³±±
±±³          ³ tacao de Compra  (Banco Oracle) - Tabela Ultimos Pedidos   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit329()
cperg:="PERGVIT329"
_pergsx1()
if !pergunte(cperg,.t.)
	return(.f.)
endif

processa({|| _querys()})


/*abrindo a informação gerada e exportando para o excel*/

If MsgYesNo("Deseja Exportar Dados para Excel ?")
	
	Private _aCabec := {}
	Private _aDados := {}
	
	If !ApOleClient("MSExcel")
		MsgAlert("Microsoft Excel não instalado!")
		Return
	EndIf
	
	_aCabec:={"SOLICITACAO","ITEM","PRODUTO","DESCRICAO","QTDE_SOLICITADA","QTDE_PEDIDO","UN","PRECOUNIT","PRECOTOTAL","IPI",;
	"FORNECE","LOJA","NOMEFOR","FANTASIA","DDD","TELEFONE","EMISSAO","PEDIDO"}
	
	tmp1->(dbgotop())
	
	while !tmp1->(eof())
		
		processa({|| _query2(tmp1->produto)})
		
		tmp2->(dbgotop())
		
		while !tmp2->(eof())
			AAdd(_aDados, {tmp1->numsc, tmp1->item, tmp1->produto, tmp1->descricao, tmp1->quant, tmp2->quant, tmp2->un, tmp2->precounit, tmp2->precototal, tmp2->ipi,;
			tmp2->fornece, tmp2->loja, tmp2->nomefor, tmp2->fantasia, tmp2->ddd, tmp2->telefone, tmp2->emissao, tmp2->pedido})

			tmp2->(dbskip())
		end
		
		tmp2->(dbclosearea())
		tmp1->(dbskip())
	end
	
	DlgToExcel({ {"ARRAY", "Exportacao para o Excel", _aCabec, _aDados} })
	tmp1->(dbclosearea())
endif
return

/*********************************************************************************************************************************************************************/

static function _querys()

_cquery:= " SELECT "
_cquery+= " 	SC1.C1_NUM NUMSC,"
_cquery+= " 	SC1.C1_ITEM ITEM,"
_cquery+= " 	SC1.C1_PRODUTO PRODUTO,"
_cquery+= " 	SC1.C1_DESCRI DESCRICAO,"
_cquery+= " 	SC1.C1_QUANT QUANT"
_cquery+= " FROM SC1010 SC1"
_cquery+= " WHERE SC1.D_E_L_E_T_ = ' '"
_cquery+= " AND SC1.C1_NUM ='"+mv_par01+"'"
_cquery+= " ORDER BY C1_NUM, C1_ITEM"

_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"     
tcsetfield("TMP1","QUANT","N",15,5)

return



static function _query2(_produto)

_cquer2:= " SELECT *"
_cquer2+= " FROM ("
_cquer2+= " 	SELECT SC7.C7_PRODUTO PRODUTO,"
_cquer2+= " 		SC7.C7_DESCRI DESCRICAO,"
_cquer2+= " 	    SC7.C7_QUANT QUANT,"
_cquer2+= " 	    SC7.C7_UM UN,"
_cquer2+= "			SC7.C7_PRECO PRECOUNIT,"
_cquer2+= " 	    SC7.C7_TOTAL PRECOTOTAL,"
_cquer2+= " 	    SC7.C7_IPI IPI,"
_cquer2+= " 	    SC7.C7_FORNECE FORNECE,"
_cquer2+= " 	    SC7.C7_LOJA LOJA,"
_cquer2+= " 	    SA2.A2_NOME NOMEFOR,"
_cquer2+= " 	    SA2.A2_NREDUZ FANTASIA,"
_cquer2+= " 	    SA2.A2_DDD DDD,"
_cquer2+= " 	    SA2.A2_TEL TELEFONE,"
_cquer2+= " 	    SC7.C7_EMISSAO EMISSAO,"
_cquer2+= " 	    SC7.C7_NUM PEDIDO"
_cquer2+= " 	FROM SC7010 SC7, SA2010 SA2"
_cquer2+= " 	WHERE SC7.C7_PRODUTO = '"+_produto+"'"
_cquer2+= " 	AND SA2.A2_COD = SC7.C7_FORNECE"
_cquer2+= " 	AND SA2.A2_LOJA = SC7.C7_LOJA"
_cquer2+= " 	AND SC7.D_E_L_E_T_ = ' '"
_cquer2+= " 	ORDER BY SC7.C7_EMISSAO DESC)"
_cquer2+= " WHERE ROWNUM <= 3"
_cquer2+= " ORDER BY EMISSAO DESC"

_cquer2:=changequery(_cquer2)
tcquery _cquer2 new alias "TMP2"
tcsetfield("TMP2","QUANT","N",15,5)
tcsetfield("TMP2","PRECOUNIT","N",15,5)
tcsetfield("TMP2","PRECOTOTAL","N",15,2)
tcsetfield("TMP2","IPI","N",15,2)
tcsetfield("TMP2","EMISSAO" ,"D",08,0)

return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Solicitação        ?","mv_ch1","C",06,0,0,"G",space(60)   ,"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
