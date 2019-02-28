#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT322  ³ Autor ³ Reuber A. Moura Jr.   ³ Data ³ 04/08/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Aplica Inventario digitado no SB7                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gera a aplicacao do Inventario digitado no SB7 gerando     ³±±
±±³          ³ Lancamentos no SD3 atraves da Rotina MSExecAuto da         ³±±
±±³          ³ rotina MATA240                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/



user function vit322()

@ 00,000 TO 227,463 DIALOG oDlg TITLE "Efetiva Inventario dos Saldos"
@ 08,010 TO 84,222
@ 23,16 SAY OemToAnsi("ESTE PROGRAMA DEVE SER EXECUTADO SOMENTE UMA VEZ PARA EFETIVAR")
@ 33,16 SAY OemToAnsi("AJUSTES NAS TABELAS DE SALDOS DE ACORDO COM O INVENTARIO LANCADO")
@ 43,16 SAY OemToAnsi("NA TABELA SB7. O AJUSTE E FEITO ATRAVES DO EXECAUTO NO SD3.")
@ 91,140 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return



Static Function OkProc()
Processa( {|| RunProc() } )
Return


Static Function RunProc()

Private lMsErroAuto := .F.

_cfilsb1:=xfilial("SB1")
_cfilsb1:=xfilial("SB2")
_cfilsb1:=xfilial("SB8")
_cfilsb7:=xfilial("SB7")
_cfilsbf:=xfilial("SBF")

sb1->(dbsetorder(1)) //Filial + Codigo
sb2->(dbsetorder(1)) 
sb8->(dbsetorder(1)) 
sb7->(dbsetorder(1)) //Filial + dtos(Data)+ Codigo + Local
sbf->(dbsetorder(1)) //Filial + Data

processa({|| _geratmp()})
tmp1->(dbgotop())

while ! tmp1->(eof())

	aArray := {}

	_cnumseq :=getmv("MV_DOCSEQ")						// Busca Próximo Nº para Seqüência
	putmv("MV_DOCSEQ",soma1(_cnumseq))					// Atualiza Parâmetro com nº seqüência

/*
_aCM := PegaCMAtu(tmp1->cod,tmp1->arm) //PEGA O CUSTO MEDIO

//VERIFICA SE O CUSTO VIRA COM VALOR ZERO

if _aCM[1] == 0
	_ncusto := Posicione("SB1",1,xFilial("SB1")+tmp1->cod,"B1_UPRC")
	_ncusto := IIf(_ncusto == 0,1,ncusto)
else
	_ncusto := aCM[1]
endIf
*/	
	aArray:= {	{"D3_FILIAL"	,"01"					,nil},;			// 01.Filial
				{"D3_COD"		,tmp1->cod				,nil},;         // 02.Produto 
				{"D3_DOC"		,"INVENT"				,nil},;			// 03.Numero Documento
				{"D3_EMISSAO"	,tmp1->emissao			,nil},;			// 04.Data Emissao
				{"D3_CC"		,"29050101"				,nil},;			// 05.CC
				{"D3_GRUPO"		,tmp1->grupo			,nil},;			// 06.Grupo
				{"D3_LOCAL"		,tmp1->arm				,nil},;			// 07.Local 				
				{"D3_UM"		,tmp1->um				,nil},;			// 08.UM
				{"D3_NUMSEQ"	,_cnumseq				,nil},;         // 09.Numero Sequencia
				{"D3_SEGUM"		,tmp1->segum			,nil},;			// 10.2a UM
				{"D3_CONTA"		,tmp1->conta			,nil},;			// 11.Conta Contabil
				{"D3_QUANT"		,tmp1->quant			,nil},;			// 12.Quantidade
				{"D3_QTSEGUM"	,tmp1->qtsegum			,nil},;			// 13.Quantidade 2a UM
				{"D3_TIPO"		,tmp1->tipo				,nil},;			// 14.Tipo
				{"D3_LOCALIZ"	,tmp1->localiz			,nil},;			// 15.Endereco
				{"D3_TPESTR"	,tmp1->tpestr			,nil},;			// 16.TPEstr
				{"D3_NUMSERI"	,tmp1->numseri			,nil},;			// 17.Numero Serie
				{"D3_LOTECTL"	,tmp1->lotectl			,nil},;			// 18.Numero Lote
				{"D3_NUMLOTE"	,tmp1->numlote			,nil},;			// 19.Numero Sub-Lote
				{"D3_USUARIO"	,SubStr(cUsuario,7,15)	,nil},;			// 20.Usuário
				{"D3_DTVALID"	,tmp1->dtvalid			,nil},;			// 21.Data Validade
				{"D3_TM"		,tmp1->tm				,nil},;    		// 22.TM
				{"D3_CF"		,tmp1->cf				,nil},;    		// 23.CF
				{"D3_CHAVE"		,tmp1->chave			,nil}}     		// 24.Chave
	
	MSExecAuto({|x,y,z| MATA240(x,y,z)},aArray,,3) //Inclusao

	If lMsErroAuto
		If lMsErroAuto
			mostraerro()
			Alert("cod: "+tmp1->cod+" - Lt: "+tmp1->lotectl+" - End: "+tmp1->localiz)
			DisarmTransaction()
			//break		
		EndIf		
	Endif
	
	tmp1->(dbskip())
end

tmp1->(dbclosearea())
return



static function _geratmp()
procregua(1)

_cquery:=" SELECT * FROM("
_cquery+=" SELECT"
_cquery+="   B7_FILIAL FILIAL,"
_cquery+="   B7_COD COD,"
_cquery+="   B7_LOCAL ARM,"
_cquery+="   B7_DOC DOC,"
_cquery+="   CASE"
_cquery+="      WHEN (COALESCE(SALDOSBF,0) - B7_QUANT) > 0 THEN TRUNC(CAST((COALESCE(SALDOSBF,0) - B7_QUANT) AS NUMERIC (15,2)),1)"
_cquery+="      WHEN (COALESCE(SALDOSBF,0) - B7_QUANT) < 0 THEN TRUNC(CAST((B7_QUANT - COALESCE(SALDOSBF,0)) AS NUMERIC (15,2)),1)"
_cquery+="      ELSE 0"
_cquery+="   END  QUANT,"
_cquery+="   CASE"
_cquery+="     WHEN (COALESCE(SALDOSBF,0) - B7_QUANT) > 0 THEN '999'"
_cquery+="     WHEN (COALESCE(SALDOSBF,0) - B7_QUANT) < 0 THEN '499'"
_cquery+="     ELSE '---'"
_cquery+="   END TM,"
_cquery+="   CASE"
_cquery+="     WHEN (COALESCE(SALDOSBF,0) - B7_QUANT) > 0 THEN ' '"
_cquery+="     ELSE NUMLOTE"
_cquery+="   END NUMLOTE,"
_cquery+="   CASE"
_cquery+="     WHEN (COALESCE(SALDOSBF,0) - B7_QUANT) > 0 THEN 'RE0'"
_cquery+="     WHEN (COALESCE(SALDOSBF,0) - B7_QUANT) < 0 THEN 'DE0'"
_cquery+="     ELSE '---'"
_cquery+="   END CF,"
_cquery+="   'E0' CHAVE,"
_cquery+="   CONTA,"
_cquery+="   TIPO,"
_cquery+="   GRUPO,"
_cquery+="   UM,"
_cquery+="   SEGUM,"
_cquery+="   CASE"
_cquery+="     WHEN TIPOCONV = 'D' THEN"
_cquery+="         CASE"
_cquery+="           WHEN (COALESCE(SALDOSBF,0) - B7_QUANT) > 0 THEN TRUNC(CAST((COALESCE(SALDOSBF,0) - B7_QUANT)/CONV AS NUMERIC (15,2)),1)"
_cquery+="           WHEN (COALESCE(SALDOSBF,0) - B7_QUANT) < 0 THEN TRUNC(CAST((B7_QUANT - COALESCE(SALDOSBF,0))/CONV AS NUMERIC (15,2)),1)"
_cquery+="           ELSE 0"
_cquery+="         END"
_cquery+="     WHEN TIPOCONV = 'M' THEN"
_cquery+="         CASE"
_cquery+="           WHEN (COALESCE(SALDOSBF,0) - B7_QUANT) > 0 THEN TRUNC(CAST((COALESCE(SALDOSBF,0) - B7_QUANT)*CONV AS NUMERIC (15,2)),1)"
_cquery+="           WHEN (COALESCE(SALDOSBF,0) - B7_QUANT) < 0 THEN TRUNC(CAST((B7_QUANT - COALESCE(SALDOSBF,0))*CONV AS NUMERIC (15,2)),1)"
_cquery+="           ELSE 0"
_cquery+="         END"
_cquery+="   END QTSEGUM,"
_cquery+="   B7_DATA EMISSAO,"
_cquery+="   B7_LOTECTL LOTECTL,"
_cquery+="   B7_DTVALID DTVALID,"
_cquery+="   B7_LOCALIZ LOCALIZ,"
_cquery+="   B7_NUMSERI NUMSERI,"
_cquery+="   B7_TPESTR TPESTR"
_cquery+="   FROM("
_cquery+="   SELECT"
_cquery+="     SB7.B7_FILIAL,"
_cquery+="     SB7.B7_COD,"
_cquery+="     SB7.B7_LOCAL,"
_cquery+="     SB7.B7_TIPO,"
_cquery+="     SB7.B7_DOC,"
_cquery+="     SB7.B7_QUANT,"
_cquery+="     SB1.B1_TIPCONV TIPOCONV,"
_cquery+="     SB1.B1_CONV CONV,"
_cquery+="     SB1.B1_CONTA CONTA,"
_cquery+="     SB1.B1_TIPO TIPO,"
_cquery+="     SB1.B1_GRUPO GRUPO,"
_cquery+="     SB1.B1_UM UM,"
_cquery+="     SB1.B1_SEGUM SEGUM,"
_cquery+="     CASE"
_cquery+="          WHEN SB7.B7_LOTECTL = ' ' THEN (SELECT SB2.B2_QATU FROM SB2010 SB2 WHERE SB2.B2_COD = SB7.B7_COD AND SB2.B2_LOCAL = SB7.B7_LOCAL AND SB2.D_E_L_E_T_ = ' ')"
_cquery+="          WHEN (SB7.B7_LOCALIZ = ' ' AND SB7.B7_LOTECTL <> ' ') THEN (SELECT Sum(SB8.B8_SALDO) FROM SB8010 SB8 WHERE SB8.B8_PRODUTO = SB7.B7_COD AND SB8.B8_LOCAL = SB7.B7_LOCAL AND SB8.B8_LOTECTL = SB7.B7_LOTECTL AND SB8.D_E_L_E_T_ = ' ')"
_cquery+="          ELSE (SELECT SBF.BF_QUANT FROM SBF010 SBF WHERE SBF.BF_PRODUTO = SB7.B7_COD AND SBF.BF_LOCALIZ = SB7.B7_LOCALIZ AND SBF.BF_LOCAL = SB7.B7_LOCAL AND SBF.BF_LOTECTL = SB7.B7_LOTECTL AND SBF.D_E_L_E_T_ = ' ')"
_cquery+="     END SALDOSBF,"

_cquery+="     SB7.B7_DATA,"
_cquery+="     SB7.B7_LOTECTL,"
_cquery+="     (SELECT SBF.BF_NUMLOTE FROM SBF010 SBF WHERE SBF.BF_PRODUTO = SB7.B7_COD AND SBF.BF_LOCAL = SB7.B7_LOCAL AND SBF.BF_LOTECTL = SB7.B7_LOTECTL AND SBF.D_E_L_E_T_ = ' ' AND SBF.BF_LOCALIZ = SB7.B7_LOCALIZ) NUMLOTE,
_cquery+="     SB7.B7_DTVALID,"
_cquery+="     SB7.B7_LOCALIZ,"
_cquery+="     SB7.B7_NUMSERI,"
_cquery+="     SB7.B7_TPESTR"
_cquery+="   FROM SB7010 SB7, SB1010 SB1"
_cquery+="   WHERE SB7.B7_DOC = '201411MP'"
_cquery+="   AND SB1.B1_COD = SB7.B7_COD"
_cquery+="   AND SB1.D_E_L_E_T_ = ' '"
_cquery+="   AND SB7.D_E_L_E_T_ = ' '))"
_cquery+="   WHERE TM <> '---'"
_cquery+="   AND QUANT > 0.1"
_cquery+="   ORDER BY COD, ARM, LOTECTL, LOCALIZ"

_cquery:=changequery(_cquery)
MemoWrite("/sql/inventario.sql",_cquery)
tcquery _cquery new alias "TMP1"                      
tcsetfield("TMP1","QUANT","N",11,1)
tcsetfield("TMP1","QTSEGUM","N",12,1)
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","DTVALID","D")

return()