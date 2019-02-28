#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT321  ³ Autor ³ Reuber A. Moura Jr.   ³ Data ³ 26/08/04  ³±±
±±³                              Alex J. Miranda                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Transferencia de saldo disponivel para novo endereço       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gera a transferência do saldo disponivel para novo         ³±±
±±³          ³ endereco definido na tabela TRANSF no topconnect,          ³±±
±±³          ³ utilizando o MSExecAuto da rotina Mata261.                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/



user function vit321()

@ 00,000 TO 227,463 DIALOG oDlg TITLE "Transferencia de Enderecos tabela TRANSF"
@ 08,010 TO 84,222
@ 23,16 SAY OemToAnsi("ESTE PROGRAMA DEVE SER EXECUTADO SOMENTE UMA VEZ E DEVE SER  ")
@ 33,16 SAY OemToAnsi("GERADA A TABELA TRANSF NO TOPCONNECT COM OS ENDERECOS EQUIVALENTES")
@ 91,140 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return



Static Function OkProc()
Processa( {|| RunProc() } )
Return


Static Function RunProc()

Local aArray := {}
Private lMsErroAuto := .F.

_cfilsb1:=xfilial("SB1")
_cfilsbf:=xfilial("SBF")

aArray := {{     "ENDER1",;								// 01.Numero do Documento
DATE()}}         						           		// 02.Data da Transferencia

sb1->(dbsetorder(1)) //Filial + Codigo
sbf->(dbsetorder(1)) //Filial + Data

processa({|| _geratmp()})
tmp1->(dbgotop())

while ! tmp1->(eof())
	
	_cnumseq :=getmv("MV_DOCSEQ")
	putmv("MV_DOCSEQ",soma1(_cnumseq))
	
	aAdd(aArray,{   tmp1->codigo,;                      // 01.Produto Origem
					tmp1->descricao,;                   // 02.Descricao
					tmp1->um,;							// 03.Unidade de Medida
					tmp1->armz,;						// 04.Local Origem
					tmp1->endant,;						// 05.Endereco Origem
					tmp1->codigo,;                      // 06.Produto Destino
					tmp1->descricao,;                   // 07.Descricao
					tmp1->um,;							// 08.Unidade de Medida
					tmp1->armz,;						// 09.Armazem Destino
					tmp1->endnew,;						// 10.Endereco Destino
					CriaVar("D3_NUMSERI",.F.),;     	// 11.Numero de Serie
					tmp1->lotectl,;						// 12.Lote Origem
					tmp1->numlote,;						// 13.Sublote
					CriaVar("D3_DTVALID",.F.),;     	// 14.Data de Validade
					CriaVar("D3_POTENCI",.F.),;     	// 15.Potencia do Lote
					tmp1->quant,;						// 16.Quantidade
					tmp1->qtsegum,;						// 17.Quantidade na 2 UM
					CriaVar("D3_ESTORNO",.F.),;     	// 18.Estorno
					_cnumseq,;							// 19.NumSeq
					tmp1->lotectl,;						// 20.Lote Destino
					CriaVar("D3_DTVALID",.F.);			// 21 DATA VALIDADE
	})
	
	
	tmp1->(dbskip())
end


MSExecAuto({|x,y| MATA261(x,y)},aArray,3) //Inclusao

If lMsErroAuto
	If lMsErroAuto
		mostraerro()
		DisarmTransaction()
		break
		
	EndIf
Else
	Alert("Ok")
Endif


tmp1->(dbclosearea())
return




static function _geratmp()
procregua(1)

_cquery:=" SELECT"
_cquery+=" SBF.BF_PRODUTO CODIGO,"
_cquery+=" SB1.B1_DESC    DESCRICAO,"
_cquery+=" SB1.B1_UM      UM,"
_cquery+=" SBF.BF_LOCAL   ARMZ,"
_cquery+=" SBF.BF_LOCALIZ ENDANT,"
_cquery+=" SBF.BF_LOTECTL LOTECTL,"
_cquery+=" SBF.BF_NUMLOTE NUMLOTE,"
_cquery+=" (SBF.BF_QUANT   - SBF.BF_EMPENHO) QUANT,"
_cquery+=" (SBF.BF_QTSEGUM - SBF.BF_EMPEN2)  QTSEGUM,"
_cquery+=" TRANSF.CMP_PARA ENDNEW"
_cquery+=" FROM "+retsqlname("SBF")+" SBF , "+retsqlname("SB1")+" SB1, TRANSF TRANSF"
_cquery+=" WHERE (SBF.BF_QUANT-SBF.BF_EMPENHO) <> 0"
_cquery+=" AND SBF.D_E_L_E_T_= ' '"
_cquery+=" AND SB1.D_E_L_E_T_= ' '"
_cquery+=" AND SB1.B1_COD = SBF.BF_PRODUTO"

// ********** A linha abaixo é para testar a rotina com um item
_cquery+=" AND SB1.B1_COD <> '104785'"

_cquery+=" AND SBF.BF_LOCALIZ = TRANSF.CMP_DE"
_cquery+=" AND BF_LOCAL IN ('02','03')"
_cquery+=" ORDER BY SBF.BF_LOCAL,SBF.BF_LOCALIZ"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","QUANT","N",11,2)
tcsetfield("TMP1","QTSEGUM","N",12,2)

return()

