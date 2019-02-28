#Include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINCMOV    บAutor  ณMicrosiga           บ Data ณ  12/26/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function IncMov()

Local oDlg
Local oBtn
Local cProd      := ''
Local cAlmox     := ''
Local nQuant     := 0
Local cLoteCtl   := ''
Local cLocaliz   := ''
Local lSai       := .T.

if Type("cEmpAnt")=='U' .OR. Type("cFilAnt")=='U' 
	RpcSetType(3)
	lConect := RpcSetEnv("01", Fil_TpProd:cFilial)
	if !lConect
		cMsgErr := "Nใo foi possํvel conectar na Empresa/Filial informadas!"
		lOk := .F.
	endif
endif

Do While lSai
	cProd    := CriaVar('D3_COD')
	cAlmox   := CriaVar('D3_LOCAL')
	nQuant   := CriaVar('D3_QUANT')
	cLoteCtl := CriaVar('D3_LOTECTL')
	cSublote := CriaVar('D3_NUMLOTE')
	cLocaliz := CriaVar('D3_LOCALIZ')
	DEFINE MSDIALOG oDlg FROM 0, 0 TO 220, 295 TITLE "Inclui Movtos no SD3/SD5/SDB" PIXEL
	@ 20, 10 SAY   'Produto'                 	 OF oDlg PIXEL
	@ 20, 50 MSGET cProd F3 'SB1' PICTURE "@!" OF oDlg PIXEL
	@ 30, 10 SAY   'Almoxarifado'          	 OF oDlg PIXEL
	@ 30, 50 MSGET cAlmox 			PICTURE "@!" OF oDlg PIXEL VALID SeekProd(@cProd, @cAlmox, @oDlg)
	@ 40, 10 SAY   'Quantidade'              	 OF oDlg PIXEL
	@ 40, 50 MSGET nQuant         PICTURE PesqPictQt('D3_QUANT',15) OF oDlg PIXEL
	@ 50, 10 SAY   'Lote      '              	 OF oDlg PIXEL
	@ 50, 50 MSGET cLoteCtl			PICTURE "@!" OF oDlg PIXEL
	@ 60, 10 SAY   'Sublote   '              	 OF oDlg PIXEL
	@ 60, 50 MSGET cSublote			PICTURE "@!" OF oDlg PIXEL   
	@ 70, 10 SAY   'Endereco  '              	 OF oDlg PIXEL
	@ 70, 50 MSGET cLocaliz			PICTURE "@!" OF oDlg PIXEL
	
	@ 80,10  BUTTON oBtn Prompt "SD3"   SIZE 20, 13 OF oDlg PIXEL Action (ProcSD3(cProd, cAlmox, nQuant, cLoteCtl, oDlg),oDlg:End())
	@ 80,35  BUTTON oBtn Prompt "SD5"   SIZE 20, 13 OF oDlg PIXEL Action (ProcSD5(cProd, cAlmox, nQuant, cLoteCtl, oDlg),oDlg:End())
	@ 80,60  BUTTON oBtn Prompt "SDB"   SIZE 20, 13 OF oDlg PIXEL Action (ProcSDB(cProd, cAlmox, nQuant, cLoteCtl, cLocaliz, oDlg),oDlg:End())
	@ 80,85  BUTTON oBtn Prompt "Sair"  SIZE 20, 13 OF oDlg PIXEL Action (lSai:=.F.,oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTERED
EndDo

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINCMOV    บAutor  ณMicrosiga           บ Data ณ  12/26/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function SeekProd(cProd, cAlmox, oDlg)

Local lRet       := .T.

dbSelectArea('SB1')
dbSetOrder(1)
If !dbSeek(xFilial()+cProd+cAlmox)
	Aviso('IncMov', 'Produto nao encontrado no SB1!', {'Ok'})
	lRet := .F.
EndIf
oDlg:Refresh()

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINCMOV    บAutor  ณMicrosiga           บ Data ณ  12/26/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ProcSD3(cProd, cAlmox, nQuant, cLoteCtl)

Local lRet       := .T.

RecLock('SD3',.T.)
Replace D3_FILIAL  With xFilial('SD3')
Replace D3_COD     With cProd
Replace D3_QUANT   With Abs(QtdComp(nQuant))
Replace D3_CF      With If(QtdComp(nQuant)<QtdComp(0),'RE0','DE0')
Replace D3_CHAVE   With If(QtdComp(nQuant)<QtdComp(0),'E0','E9')
Replace D3_LOCAL   With cAlmox
Replace D3_DOC     With 'ACERTO'
Replace D3_EMISSAO With dDataBase
Replace D3_UM      With SB1->B1_UM
Replace D3_GRUPO   With SB1->B1_GRUPO
Replace D3_NUMSEQ  With ProxNum()
Replace D3_QTSEGUM With ConvUm(cProd,Abs(QtdComp(nQuant)),0,2)
Replace D3_SEGUM   With SB1->B1_SEGUM
Replace D3_TM      With If(QtdComp(nQuant)<QtdComp(0),'999','499')
Replace D3_TIPO    With SB1->B1_TIPO
Replace D3_CONTA   With SB1->B1_CONTA
Replace D3_USUARIO With SubStr(cUsuario,7,15)
Replace D3_LOTECTL With cLoteCtl
Replace D3_LOCALIZ With ''
Replace D3_IDENT   With ''
Replace D3_DTVALID With CtoD('  /  /  ')
MsUnLock()

/*
dbSelectArea('SB2')
dbSetOrder(1)
If !MsSeek(xFilial('SB2')+cProd+cAlmox, .F.)
	CriaSB2(cProd, cAlmox)
EndIf
RecLock('SB2', .F.)
Replace B2_QATU With If(QtdComp(nQuant)<QtdComp(0),(B2_QATU-Abs(nQuant)),(B2_QATU+Abs(nQuant)))
MsUnlock()

If B2_QATU < 0
	MsgAlert("B2 Negativo !!!","IncMov")
Else
*/

//EndIf


Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINCMOV    บAutor  ณMicrosiga           บ Data ณ  12/26/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ProcSD5(cProd, cAlmox, nQuant, cLoteCtl)

Local lRet       := .T.
Local aGravaSD5  := {}
Local nY         := 1
Local cSeekSB8   := ''
Local cNumLote   := ''
Local nResta     := 0

aAdd(aGravaSD5, {'SDB',;
	cProd,;
	cAlmox,;
	cLoteCtl,;
	cNumLote,;
	ProxNum(),;
	'ACERTO',;
	'UNI',;
	'',;
	If(QtdComp(nQuant)<QtdComp(0),'999','499'),;
	'',;
	'',;
	'',;
	Abs(QtdComp(nQuant)),;
	ConvUm(cProd,Abs(QtdComp(nQuant)),0,2),;
	dDataBase,;
	dDataBase+SB1->B1_PRVALID})

GravaSD5(aGravaSD5[nY,01],;
	aGravaSD5[nY,02],;
	aGravaSD5[nY,03],;
	aGravaSD5[nY,04],;
	If(!Empty(aGravaSD5[ny,05]),aGravaSD5[ny,05],NextLote(aGravaSD5[ny,02],"S")),;
	aGravaSD5[nY,06],;
	aGravaSD5[nY,07],;
	aGravaSD5[nY,08],;
	aGravaSD5[nY,09],;
	aGravaSD5[nY,10],;
	aGravaSD5[nY,11],;
	aGravaSD5[nY,12],;
	aGravaSD5[nY,13],;
	aGravaSD5[nY,14],;
	aGravaSD5[nY,15],;
	aGravaSD5[nY,16],;
	aGravaSD5[nY,17])

/*
nResta := Abs(nQuant)
dbSelectArea('SB8')
dbSetOrder(3) //-- B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
If MsSeek((cSeekSB8:=xFilial('SB8')+cProd+cAlmox+cLoteCtl)+cNumLote, .F.)
	Do While !Eof() .And. cSeekSB8 == B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL .And. nResta>0
		If QtdComp(nQuant) < QtdComp(0)
			If B8_SALDO > 0
				nResta := (nResta-If(B8_SALDO>=Abs(nQuant),Abs(nQuant),B8_SALDO))
				RecLock('SB8', .F.)
				Replace B8_SALDO With (B8_SALDO-If(B8_SALDO>=Abs(nQuant),Abs(nQuant),B8_SALDO))
				MsUnlock()
			EndIf
		Else
			nResta := (nResta-nQuant)
			RecLock('SB8', .F.)
			Replace B8_SALDO With (B8_SALDO+nQuant)
			MsUnlock()
		EndIf
		dbSkip()
	EndDo
Else
	If QtdComp(nQuant) < QtdComp(0)
		MsgAlert("Registro no SB8 nao encontrado !!!","IncMov")
	Else
		MsgAlert("Sera criado um Registro no SB8...","IncMov")
		CriaLote('SD5',cProd,cAlmox,cLoteCtl,SD5->D5_NUMLOTE,'','','',If(QtdComp(nQuant)<QtdComp(0),'999','499'),'MI','',SD5->D5_NUMSEQ,SD5->D5_DOC,SD5->D5_SERIE,'',Abs(nQuant),ConvUm(cProd,Abs(QtdComp(nQuant)),0,2),dDataBase,CtoD('  /  /  '),.F.)
	EndIf
EndIf

If nResta < 0
	MsgAlert("B8 Negativo !!!","IncMov")
Else
*/

//EndIf


Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINCMOV    บAutor  ณMicrosiga           บ Data ณ  12/26/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ProcSDB(cProd, cAlmox, nQuant, cLoteCtl, cLocaliz)

Local lRet       := .T.
Local aCriaSDB   := {}
Local nX         := 1

aAdd(aCriaSDB,{cProd,;
	cAlmox,;
	Abs(QtdComp(nQuant)),;
	cLocaliz,;
	'',;
	'ACERTO',;
	'UNI',;
	'',;
	'',;
	'',;
	'SDB',;
	dDataBase,;
	cLoteCtl,;
	'',;
	ProxNum(),;
	'499',;
	'M',;
	StrZero(1,Len(SDB->DB_ITEM)),;
	.F.,;
	0,;
	0})

CriaSDB( aCriaSDB[nX,01],;
	aCriaSDB[nX,02],;
	aCriaSDB[nX,03],;
	aCriaSDB[nX,04],;
	aCriaSDB[nX,05],;
	aCriaSDB[nX,06],;
	aCriaSDB[nX,07],;
	aCriaSDB[nX,08],;
	aCriaSDB[nX,09],;
	aCriaSDB[nX,10],;
	aCriaSDB[nX,11],;
	aCriaSDB[nX,12],;
	aCriaSDB[nX,13],;
	aCriaSDB[nX,14],;
	aCriaSDB[nX,15],;
	aCriaSDB[nX,16],;
	aCriaSDB[nX,17],;
	aCriaSDB[nX,18],;
	aCriaSDB[nX,19],;
	aCriaSDB[nX,20],;
	aCriaSDB[nX,21])


Return(lRet)