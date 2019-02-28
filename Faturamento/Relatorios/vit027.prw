/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT027   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 13/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³PEDIDOS PENDENTES                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ESPECIFICO PARA VITAMEDIC                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"
#include "ap5mail.ch"


user function vit027()   
cArq:=""
cInd:=""
aStru:={}

@ 0,0 To 260 , 200 Dialog oDialog Title OemToAnsi("Pedidos Pendentes")
@ 010,10  Button OemToAnsi("_Relatorio")  Size 80,30 Action _ProcRel()
@ 050,10  Button OemToAnsi("_E-Mail")    Size 80,30 Action _Mail()
@ 090,10  Button OemToAnsi("_Cancela")  Size 80,30 Action Close(oDialog)
Activate Dialog oDialog Centered

return
//***********************************************************************
Static Function _ProcRel()
//**********************************************
Close(oDialog)
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="PEDIDOS PENDENTES"
cdesc1   :="Este programa ira emitir a relacao de pedidos pendentes"
cdesc2   :=""
cdesc3   :=""
cstring  :="SC5"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT027"
wnrel    :="VIT027"
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT027"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.f.)

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

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

cabec1:="PERIODO DE "+dtoc(mv_par01)+" A "+dtoc(mv_par02)
cabec2:="PEDIDO   DATA   CODIGO DESCRICAO               QT.SOL QT.PEN        VALOR ESTOQ."

_cfilsa1:=xfilial("SA1")
_cfilsa3:=xfilial("SA3")
_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsc5:=xfilial("SC5")
_cfilsc6:=xfilial("SC6")
_cfilsc9:=xfilial("SC9")
_cfilsf4:=xfilial("SF4")
sa1->(dbsetorder(1))
sa3->(dbsetorder(1))
sb1->(dbsetorder(1))
sb2->(dbsetorder(1))
sc5->(dbsetorder(1))
sc6->(dbsetorder(1))
sc9->(dbsetorder(1))
sf4->(dbsetorder(1))

// PESQUISA CODIGO DO SUPERVISOR
sa3->(dbsetorder(7))
if sa3->(dbseek(_cfilsa3+__cuserid))
 _cgerente:=sa3->a3_cod
else
 _cgerente:=space(6)
endif

sa3->(dbsetorder(1))


processa({|| _geratmp(.F.)})

_ntotger:=0

setprc(0,0)

setregua(sc6->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
      lcontinua

 cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
 _cvendedor:=tmp1->vendedor
 _ntotrep:=0
 _limpven:=.f.

 while ! tmp1->(eof()) .and.;
   tmp1->vendedor==_cvendedor .and.;
   lcontinua

  _ccliente:=tmp1->cliente
  _cloja   :=tmp1->loja
  _ntotcli :=0
  _limpcli:=.f.

  while ! tmp1->(eof()) .and.;
    tmp1->vendedor==_cvendedor .and.;
    tmp1->cliente==_ccliente .and.;
    tmp1->loja==_cloja .and.;
    lcontinua

   incregua()
   if prow()>54
    cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
   endif
   _nqtdlib:=0
   sb2->(dbseek(_cfilsb2+tmp1->produto+tmp1->locpad))
   sc9->(dbseek(_cfilsc9+tmp1->numero+tmp1->item))
   while ! sc9->(eof()) .and.;
    sc9->c9_filial==_cfilsc9 .and.;
    sc9->c9_pedido==tmp1->numero .and.;
    sc9->c9_item==tmp1->item
 
    if empty(sc9->c9_nfiscal) .and.;
     empty(sc9->c9_blcred) .and.;
     empty(sc9->c9_blest)
     _nqtdlib+=sc9->c9_qtdlib
    endif
    sc9->(dbskip())
   end
   _nqtdpen:=tmp1->qtdpen-_nqtdlib
   _nsaldo :=sb2->b2_qatu-sb2->b2_reserva-sb2->b2_qemp

   if _nqtdpen>0
    if (mv_par14==1 .and. _nsaldo > 0) .or. (mv_par14==2)
     _nvalor :=round(_nqtdpen*tmp1->prcven,2)
     if ! _limpcli
      @ prow()+1,000 PSAY left(tmp1->nomecli,25)+" Cid.: "+alltrim(left(tmp1->cidade,12))+"-"+tmp1->estado
      @ prow(),048   PSAY "Vend.: "+left(tmp1->nomevend,25)

      sa3->(dbsetorder(1))
      sa3->(dbseek(_cfilsa3+tmp1->vendedor))
      _super:=sa3->a3_super            

      sa3->(dbseek(_cfilsa3+_super))

      @ prow()+1,000 PSAY "Gerente: "+left(sa3->a3_nome,30)
      @ prow()+1,000 PSAY " "
      _limpcli:=.t.
      _limpven:=.t.
     endif
     @ prow()+1,000 PSAY sc5->c5_licitac+tmp1->numero
     @ prow(),007   PSAY tmp1->emissao
     @ prow(),016   PSAY left(tmp1->produto,6)
     @ prow(),023   PSAY left(tmp1->descpro,23)
     @ prow(),047   PSAY tmp1->qtdven picture "@E 999999"
     @ prow(),054   PSAY _nqtdpen     picture "@E 999999"
     @ prow(),061   PSAY _nvalor      picture "@E 9,999,999.99"
     @ prow(),074   PSAY _nsaldo      picture "@E 999999"
     _ntotcli+=_nvalor
    endif 
   endif
   tmp1->(dbskip())
   if labortprint
    @ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
    eject
    lcontinua:=.f.
   endif
  end
  if _limpcli
   @ prow()+2,000 PSAY "Total ======== > > >"
   @ prow(),061   PSAY _ntotcli picture "@E 9,999,999.99"
   @ prow()+1,000 PSAY " "
   _ntotrep+=_ntotcli
  endif
 end
 if _limpven
  @ prow()+1,000 PSAY "Total do representante"
  @ prow(),061   PSAY _ntotrep picture "@E 9,999,999.99"
  _ntotger+=_ntotrep
 endif
end
if prow()>54
   cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
endif

@ prow()+2,000 PSAY "Total geral"
@ prow(),061   PSAY _ntotger picture "@E 9,999,999.99"
roda(cbcont,cbtxt)

set device to screen

tmp1->(dbclosearea())
FErase(cArq+getdbextension()) //fiuzza
FErase(cInd+OrdBagExt())      //fiuzza

if areturn[5]==1
   set print to
   dbcommitall()
   ourspool(wnrel)
endIf

ms_flush()
return

//***********************************************************************
Static Function _Mail()
//***********************************************************************
Private cPass     := GetMv("MV_RELPSW")
Private cAccount  := GetMv("MV_RELACNT")
Private cServer   := GetMv("MV_RELSERV")

//Verifica o e-mail do usuario...
PswOrder(2)
PswSeek(cUserName,.T.)
aRet := PswRet()
If Len(AllTrim(aRet[1,14])) > 0
 cAccount := AllTrim(aRet[1,14])
EndIf

Private cAssunto  := 'Pedidos Pendentes'
Private cMSG := ""

Close(oDialog)

//Verifica o e-mail do funcionario...
PswOrder(2)
PswSeek(cUserName,.T.)
aRet := PswRet()
If Len(AllTrim(aRet[1,14])) > 0
 cAccount := AllTrim(aRet[1,14])
EndIf

cperg:="PERGVIT027"
_pergsx1()
pergunte(cperg,.f.)


aOpPrc  := {"Vendedor  ","Tela",""}
nOpPrc := 1
cPara    := space(40)                  

@ 106,74 To 346,606 Dialog oDialog Title OemToAnsi("Relatorio -- Email")
@ 9,12 To 63,196 Title OemToAnsi("Pedidos Pendentes") Object Quadro
@ 25,24 Say OemToAnsi("Este programa enviara o relatorio Pedidos Pendentes") Size 150,8
@ 38,25 Say OemToAnsi("por e-mail no formato Html conforme os parametros") Size 150,8
@ 49,26 Say OemToAnsi("os parametros especificados.") Size 42,8

@ 67,25 Say OemToAnsi("Enviar Para:") Size 34,8
@ 77,25 Radio aOpPrc Var nOpPrc
@ 94,33 Get cPara Size 115,10

@ 13,207 Button OemToAnsi("_Confirma") Size 36,16 Action Processa({|| _ProcMail()})
@ 30,207 Button OemToAnsi("_Cancela") Size 36,16 Action Close(oDialog)
@ 47,207 Button OemToAnsi("_Parametros") Size 36,16 Action Pergunte(cPerg,.T.)
Activate Dialog oDialog

Return

//***********************************************************************
static function _procmail()
//***********************************************************************
lcontinua:=.t.
If nOpPrc == 3 .AND. Len(alltrim(cPara)) == 0
 MsgStop("Informe o e-mail!!!")
 Return
EndIf

cServer  := alltrim(cServer)
cAccount:= GetMv("MV_RELACNT")
cPass    := alltrim(cPass)
cPara    := alltrim(cPara)

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass Result lResult
MailAuth(cAccount, cPass)
If !lResult
 MsgStop("Problemas na conexao com o servidor de e-mail!!!")
 Return
EndIf

cMsg := ""

If (nOpPrc == 2 .or. nOpPrc == 3)
 _abremail()
EndIf

_cfilsa1:=xfilial("SA1")
_cfilsa3:=xfilial("SA3")
_cfilsb1:=xfilial("SB1")
_cfilsc5:=xfilial("SC5")
_cfilsc6:=xfilial("SC6")
_cfilsc9:=xfilial("SC9")
_cfilsf4:=xfilial("SF4")
sa1->(dbsetorder(1))
sa3->(dbsetorder(1))
sb1->(dbsetorder(1))
sc5->(dbsetorder(1))
sc6->(dbsetorder(1))
sc9->(dbsetorder(1))
sf4->(dbsetorder(1))

// PESQUISA CODIGO DO SUPERVISOR
sa3->(dbsetorder(7))
if sa3->(dbseek(_cfilsa3+__cuserid))
 _cgerente:=sa3->a3_cod
else
 _cgerente:=space(6)
endif

sa3->(dbsetorder(1))

processa({|| _geratmp(nOpPrc == 1)})

_ntotger:=0

procregua(sc6->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
      lcontinua
 _cvendedor:=tmp1->vendedor
 _ntotrep:=0
 _limpven:=.f.
 If nOpPrc == 1
  cPara := tmp1->email
  _abremail()
 EndIf
 cMsg += '<p><b>Representante..: '+tmp1->nomevend+'</b></p>'
 while ! tmp1->(eof()) .and.;
   tmp1->vendedor==_cvendedor .and.;
   lcontinua
  _ccliente:=tmp1->cliente
  _cloja   :=tmp1->loja
  _ntotcli :=0
  _limpcli:=.f.
  while ! tmp1->(eof()) .and.;
    tmp1->vendedor==_cvendedor .and.;
    tmp1->cliente==_ccliente .and.;
    tmp1->loja==_cloja .and.;
    lcontinua
   incproc()
   _nqtdlib:=0
   sc9->(dbseek(_cfilsc9+tmp1->numero+tmp1->item))
   while ! sc9->(eof()) .and.;
     sc9->c9_filial==_cfilsc9 .and.;
     sc9->c9_pedido==tmp1->numero .and.;
     sc9->c9_item==tmp1->item
    if empty(sc9->c9_nfiscal) .and.;
     empty(sc9->c9_blcred) .and.;
     empty(sc9->c9_blest)
     _nqtdlib+=sc9->c9_qtdlib
    endif
    sc9->(dbskip())
   end
   _nqtdpen:=tmp1->qtdpen-_nqtdlib
   if _nqtdpen>0
    _nvalor :=round(_nqtdpen*tmp1->prcven,2)
    if ! _limpcli
     cMsg += '<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber1">'
     cMsg += '<tr><td width="83%" colspan="7">CLIENTE: '+left(tmp1->nomecli,25)+'&nbsp; CID.: '+alltrim(left(tmp1->cidade,12))+' - '+tmp1->estado+'</td></tr>'

     sa3->(dbsetorder(1))
     sa3->(dbseek(_cfilsa3+tmp1->vendedor))
     _super:=sa3->a3_super            
     sa3->(dbseek(_cfilsa3+_super))

     cMsg += '<tr><td width="83%" colspan="7">VEND.: '+left(tmp1->nomevend,25)+'&nbsp; &nbsp; GERENTE: '+alltrim(left(sa3->a3_nome,30))+'</td></tr>'
      cMsg += '<tr><td width="9%" align="center"><b>PEDIDO</b></td>'
        cMsg += '<td width="9%" align="center"><b>DATA</b></td>'
        cMsg += '<td width="9%" align="center"><b>CODIGO</b></td>'
        cMsg += '<td width="30%" align="center"><b>DESCRICAO</b></td>'
        cMsg += '<td width="8%" align="right"><b>QT. SOL</b></td>'
        cMsg += '<td width="8%" align="right"><b>QT. PEN</b></td>'
        cMsg += '<td width="10%" align="right"><b>VALOR </b></td></tr>'
     _limpcli:=.t.
     _limpven:=.t.
    endif
     cMsg += '<tr><td width="9%" align="center">'+sc5->c5_licitac+tmp1->numero+'</td>'
       cMsg += '<td width="9%" align="center">'+DToC(tmp1->emissao)+'</td>'
       cMsg += '<td width="9%" align="center">'+left(tmp1->produto,6)+'</td>'
       cMsg += '<td width="30%" align="center">'+left(tmp1->descpro,23)+'</td>'
       cMsg += '<td width="8%"><p align="right">'+Transform(tmp1->qtdven,'@E 999999')+'</td>'
       cMsg += '<td width="8%"><p align="right">'+Transform(_nqtdpen,'@E 999999')+'</td>'
       cMsg += '<td width="10%"><p align="right">'+Transform(_nvalor,'@E 9,999,999.99')+'</td></tr>'
    _ntotcli+=_nvalor
   endif
   tmp1->(dbskip())
  end
  if _limpcli
     cMsg += '<tr><td width="73%" colspan="6"><p align="right"><b>Total === &gt;&gt;&gt;</b></td>'
      cMsg += '<td width="10%"><p align="right">'+Transform(_ntotcli,'@E 9,999,999.99')+'</td></tr>'
   cMsg += '</table>'
   _ntotrep+=_ntotcli
  endif
 end
 if _limpven
  cMsg += '<p><b>Total Representante ===&gt;&gt;&gt; '+Transform(_ntotrep,'@E 9,999,999.99')+'</b></p>'
  _ntotger+=_ntotrep
 endif
 If nOpPrc == 1 .AND. tmp1->vendedor<>_cvendedor
  _Envia()
 EndIf
end
cMsg += '<p>&nbsp;</p>'
cMsg += '<p><b>Total Geral ===&gt;&gt;&gt; '+Transform(_ntotger,'@E 9,999,999.99')+'</b></p>'
If nOpPrc <> 1 
 _Envia()
EndIf
tmp1->(dbclosearea())
FErase(cArq+getdbextension())
FErase(cInd+OrdBagExt())
DISCONNECT SMTP SERVER
Return

//***********************************************************************
static function _abremail()
//***********************************************************************
cMsg := ""
cMsg += '<html>'
cMsg += '<head>'
cMsg += '<title>Pedidos Pendentes</title>'
cMsg += '</head>'
cMsg += '<body>'
cMsg += '<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber2">'
cMsg += '  <tr>'
cMsg += '    <td width="40%" rowspan="2">'
cMsg += '    <img border="0" src="http://www.vitamedic.ind.br/wp-content/uploads/2016/03/logo.png" width="120" height="50"></td>' // correçao da logo de vitapan para vitamedic Luiz Fernando Fiuza's
cMsg += '    <td width="47%" rowspan="2">'
cMsg += '<p align="left"><b><font size="6">Pedidos Pendentes</font></b></p>'
cMsg += '    </td>'
cMsg += '    <td width="33%"><font size="2"><b>Emissão.: '+DToc(dDataBase)+'</b></font></td>'
cMsg += '  </tr>'
cMsg += '  <tr>'
cMsg += '    <td width="33%"><font size="2"><b>Hora.......: '+Time()+'</b></font></td>'
cMsg += '  </tr>'
cMsg += '</table>'
cMsg += '<p><b>Período de</b> '+dtoc(mv_par01)+' <b>até</b> '+dtoc(mv_par02)+'</p>'
return

//***********************************************************************
Static Function _Envia()
//***********************************************************************
cMsg += '</body>'
cMsg += '</html>'
cPara := AllTrim(cPara)
cAccount:= GetMv("MV_RELACNT")
If nOpPrc == 1 .and. Len(AllTrim(cPara)) > 0 .and. Len(AllTrim(cMsg)) > 300
 //Alert("De: "+cAccount+" Para: "+cPara+" assunto: "+cAssunto)
 SEND MAIL FROM cAccount TO cPara SUBJECT cAssunto BODY cMsg Result lResult
 If !lResult
  MsgStop("Problemas no envio do e-mail: " + cPara)
 EndIf
ElseIf nOpPrc == 2
 nHdl := fCreate("C:\WINDOWS\TEMP\VIT027.HTML")
 fWrite(nHdl,cMsg,Len(cMsg))
 fClose(nHdl)
 ExecArq()
ElseIf nOpPrc == 3
 SEND MAIL FROM cAccount TO cPara SUBJECT cAssunto BODY cMsg Result lResult
 If !lResult
  MsgStop("Problemas no envio do e-mail")
 EndIf
EndIf
Return

//***********************************************************************
Static Function ExecArq()
//***********************************************************************
LOCAL cDrive     := ""
LOCAL cDir       := ""
LOCAL cPathFile  := ""
LOCAL cCompl     := ""
LOCAL nRet       := 0

//³ Retira a ultima barra invertida ( se houver )
cPathFile := "C:\WINDOWS\TEMP\VIT027.HTML"

SplitPath(cPathFile, @cDrive, @cDir )
cDir := Alltrim(cDrive) + Alltrim(cDir)

//³ Faz a chamada do aplicativo associado                                  ³
nRet := ShellExecute( "Open", cPathFile,"",cDir, 1)

If nRet <= 32
 cCompl := ""
 If nRet == 31
  cCompl := " Nao existe aplicativo associado a este tipo de arquivo!"
 EndIf
 Aviso( "Atencao !", "Nao foi possivel abrir o objeto '" + AllTrim(cPathFile) + "'!" + cCompl, { "Ok" }, 2 )
EndIf

Return


//***********************************************************************
static function _geratmp(lPar)
//***********************************************************************

aAdd(aStru,{"VENDEDOR","C",06,00})
aAdd(aStru,{"NOMEVEND","C",40,00})
aAdd(aStru,{"CLIENTE","C",06,00})
aAdd(aStru,{"LOJA","C",06,00})
aAdd(aStru,{"NOMECLI","C",40,00})
aAdd(aStru,{"NUMERO","C",06,00})
aAdd(aStru,{"EMISSAO","D",08,00})
aAdd(aStru,{"ITEM","C",02,00})
aAdd(aStru,{"PRODUTO","C",15,00})
aAdd(aStru,{"DESCPRO","C",40,00})
aAdd(aStru,{"QTDVEN","N",14,02})
aAdd(aStru,{"QTDPEN","N",14,02})
aAdd(aStru,{"PRCVEN","N",14,02})
aAdd(aStru,{"CIDADE","C",20,00})
aAdd(aStru,{"ESTADO","C",02,00})
aAdd(aStru,{"LOCPAD","C",02,00})
aAdd(aStru,{"EMAIL","C",50,00})

cArq := CriaTrab(aStru,.T.)
dbUseArea(.T.,,cArq,"TMP1",.T.)
cInd := CriaTrab(NIL,.F.)
//IndRegua("TMP1",cInd,"NOMEVEND+NOMECLI+NUMERO+DESCPRO",,,"Selecionando Registros...")  
IndRegua("TMP1",cInd,"NOMEVEND+NOMECLI+CLIENTE+LOJA+NUMERO+DESCPRO",,,"Selecionando Registros...")  // Fiuza 23/07/14

SA1->(dbSetOrder(1))
SA3->(dbSetOrder(1))
SB1->(dbSetOrder(1))
SC5->(dbSetOrder(2))
SC6->(dbSetOrder(1))
SF4->(dbSetOrder(1))
SC5->(dbSeek(xFilial()+DTOS(MV_PAR01)+MV_PAR09,.T.))
procregua(SC5->(LastRec()-RecNo()))

While !SC5->(EOF()) .AND.;
  SC5->C5_FILIAL == _cfilsc5 .AND.;
  SC5->C5_EMISSAO <= MV_PAR02 .AND.;
  SC5->C5_NUM <= MV_PAR10
  
 IncProc("Emissao.:"+DToC(SC5->C5_EMISSAO))

 _cvend:=sc5->(fieldget(fieldpos("C5_VEND"+alltrim(str(mv_par15,1)))))
 
 If _cvend < MV_PAR03 .OR. _cvend > MV_PAR04
  SC5->(dbSkip())
  Loop
 EndIf

 If SC5->C5_CLIENTE < MV_PAR05 .OR. SC5->C5_CLIENTE > MV_PAR07
  SC5->(dbSkip())
  Loop
 EndIf

 If SC5->C5_LOJACLI < MV_PAR06 .OR. SC5->C5_LOJACLI > MV_PAR08
  SC5->(dbSkip())
  Loop
 EndIf

 If MV_PAR13==1
  If SC5->C5_LICITAC == 'S'
   SC5->(dbSkip())
   Loop
  EndIf
 ElseIf MV_PAR13==2
  If SC5->C5_LICITAC <> 'S'
   SC5->(dbSkip())
   Loop
  EndIf
 EndIf

 SA3->(dbSeek(xFilial()+_cvend)) 
 If Empty(SA3->A3_EMAIL) .AND. lPar
  SC5->(dbSkip())
  Loop
 EndIf

 _mger:=if(empty(_cgerente),.t.,sa3->a3_super==_cgerente) // Valida Gerente Regional
  
   if _mger  
   /*  Valida se Cliente e Vendedor pertencem a Gerência Regional
     do usuário que está acessando (quando aplicável)
   */

  SC6->(dbSeek(xFilial()+SC5->C5_NUM))
  While !SC6->(EOF()) .AND. SC6->C6_FILIAL == _cFilSC6 .AND. SC6->C6_NUM == SC5->C5_NUM
   If SC6->(C6_QTDVEN-C6_QTDENT) <= 0
    SC6->(dbSkip())
    Loop
   EndIf

   If SC6->C6_BLQ  == 'R '
    SC6->(dbSkip())
    Loop
   EndIf
  
   SF4->(dbSeek(xFilial()+SC6->C6_TES))

   If mv_par11==1
    If SF4->F4_DUPLIC <> 'S'
     SC6->(dbSkip())
     Loop
    EndIf
   ElseIf mv_par11==2
    If SF4->F4_DUPLIC <> 'N'
     SC6->(dbSkip())
     Loop
    EndIf
   EndIf

   If mv_par12==1
    If SF4->F4_ESTOQUE <> 'S'
     SC6->(dbSkip())
     Loop
    EndIf
   ElseIf mv_par12==2
    If SF4->F4_ESTOQUE <> 'N'
     SC6->(dbSkip())
     Loop
    EndIf
   EndIf
  
  SB1->(dbSeek(xFilial()+SC6->C6_PRODUTO))
   IF mv_PAR16 <> 1 
   IF mv_PAR16 == 2 .and. SB1->B1_TIPO <> 'PA' //Somente PA
     SC6->(dbSkip())
     Loop     
   Endif
   IF mv_PAR16 == 3 .and. SB1->B1_TIPO <> 'PN' //Somente PN
     SC6->(dbSkip())
     Loop     
   Endif
    IF mv_PAR16 == 4 .and. SB1->B1_TIPO <> 'PD' //Somente PD
     SC6->(dbSkip())
     Loop     
   Endif
   ENDIF
   SA1->(dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
   sa3->(dbseek(xfilial()+sc5->c5_vend1))

   RecLock("TMP1",.T.)
   Replace;
   TMP1->VENDEDOR With SA3->A3_COD,;
   TMP1->NOMEVEND With SA3->A3_NOME,;
   TMP1->CLIENTE  With SC5->C5_CLIENTE,;
   TMP1->LOJA     With SC5->C5_LOJACLI,;
   TMP1->NOMECLI  With SA1->A1_NOME,;
   TMP1->NUMERO   With SC5->C5_NUM,;
   TMP1->EMISSAO  With SC5->C5_EMISSAO,;
   TMP1->ITEM     With SC6->C6_ITEM,;
   TMP1->PRODUTO  With SC6->C6_PRODUTO,;
   TMP1->DESCPRO  With SB1->B1_DESC,;
   TMP1->QTDVEN   With SC6->C6_QTDVEN,;
   TMP1->QTDPEN   With SC6->(C6_QTDVEN-C6_QTDENT),;
   TMP1->PRCVEN   With SC6->C6_PRCVEN,;
   TMP1->CIDADE   With SA1->A1_MUN,;
   TMP1->ESTADO   With SA1->A1_EST,;
   TMP1->LOCPAD   With SB1->B1_LOCPAD,;
   TMP1->EMAIL    With SA3->A3_EMAIL
   TMP1->(MsUnLock())
   SC6->(dbSkip()) 
  EndDo
 endif
 SC5->(dbSkip())
EndDo
TMP1->(dbGoTop())
/*
_cquery:=" SELECT"
_cquery+=" C5_VEND1 VENDEDOR,A3_NOME NOMEVEND,C5_CLIENTE CLIENTE,C5_LOJACLI LOJA,"
_cquery+=" A1_NOME NOMECLI,C5_NUM NUMERO,C5_EMISSAO EMISSAO,C6_ITEM ITEM,"
_cquery+=" C6_PRODUTO PRODUTO,B1_DESC DESCPRO,C6_QTDVEN QTDVEN,"
_cquery+=" (C6_QTDVEN-C6_QTDENT) QTDPEN,C6_PRCVEN PRCVEN,A1_MUN CIDADE,"
_cquery+=" A1_EST ESTADO,B1_LOCPAD LOCPAD, A3_EMAIL EMAIL"
_cquery+=" FROM "
_cquery+=  retsqlname("SA1")+" SA1,"
_cquery+=  retsqlname("SA3")+" SA3,"
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SC5")+" SC5,"
_cquery+=  retsqlname("SC6")+" SC6,"
_cquery+=  retsqlname("SF4")+" SF4"
_cquery+=" WHERE"
_cquery+="     SA1.D_E_L_E_T_<>'*'"
_cquery+=" AND SA3.D_E_L_E_T_<>'*'"
_cquery+=" AND SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SC5.D_E_L_E_T_<>'*'"
_cquery+=" AND SC6.D_E_L_E_T_<>'*'"
_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
_cquery+=" AND A1_FILIAL='"+_cfilsa1+"'"
_cquery+=" AND A3_FILIAL='"+_cfilsa3+"'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND C5_FILIAL='"+_cfilsc5+"'"
_cquery+=" AND C6_FILIAL='"+_cfilsc6+"'"
_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
_cquery+=" AND C6_NUM=C5_NUM"
_cquery+=" AND C6_PRODUTO=B1_COD"
_cquery+=" AND C6_TES=F4_CODIGO"
_cquery+=" AND C5_CLIENTE=A1_COD"
_cquery+=" AND C5_LOJACLI=A1_LOJA"
_cquery+=" AND C5_VEND1=A3_COD"
_cquery+=" AND C5_TIPO='N'"
_cquery+=" AND C5_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND C5_VEND1 BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND C5_CLIENTE BETWEEN '"+mv_par05+"' AND '"+mv_par07+"'"
_cquery+=" AND C5_LOJACLI BETWEEN '"+mv_par06+"' AND '"+mv_par08+"'"
_cquery+=" AND C5_NUM BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
_cquery+=" AND (C6_QTDVEN-C6_QTDENT)>0"
_cquery+=" AND C6_BLQ<>'R '"
If lPar
 _cquery+=" AND a3_email <> '"+space(30)+"'"
EndIf
if mv_par11==1
 _cquery+=" AND F4_DUPLIC='S'"
elseif mv_par11==2
 _cquery+=" AND F4_DUPLIC='N'"
endif
if mv_par12==1
 _cquery+=" AND F4_ESTOQUE='S'"
elseif mv_par12==2
 _cquery+=" AND F4_ESTOQUE='N'"
endif
if mv_par13==1
 _cquery+=" AND C5_LICITAC<>'S'"
elseif mv_par13==2
 _cquery+=" AND C5_LICITAC='S'"
endif
_cquery+=" ORDER BY"
_cquery+=" A3_NOME,C5_VEND1,A1_NOME,C5_CLIENTE,C5_LOJACLI,C5_NUM,B1_DESC,C6_PRODUTO"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","QTDVEN" ,"N",06,0)
tcsetfield("TMP1","QTDPEN" ,"N",06,0)
tcsetfield("TMP1","PRCVEN" ,"N",18,6)*/
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do vendedor        ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"04","Ate o vendedor     ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"05","Do cliente         ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"06","Da loja            ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Ate o cliente      ?","mv_ch7","C",06,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"08","Ate a loja         ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Do pedido          ?","mv_ch9","C",06,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Ate o pedido       ?","mv_chA","C",06,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","TES qto. duplicata ?","mv_chB","N",01,0,0,"C",space(60),"mv_par11"       ,"Gera"           ,space(30),space(15),"Nao gera"       ,space(30),space(15),"Ambos"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"12","TES qto. estoque   ?","mv_chC","N",01,0,0,"C",space(60),"mv_par12"       ,"Movimenta"      ,space(30),space(15),"Nao movimenta"  ,space(30),space(15),"Ambos"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"13","Tipo Pedido        ?","mv_chD","N",01,0,0,"C",space(60),"mv_par13"       ,"Normal"         ,space(30),space(15),"Licitações"     ,space(30),space(15),"Todos"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"14","Itens c/ Estoque   ?","mv_chE","N",01,0,0,"C",space(60),"mv_par14"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"15","Considera vendedor ?","mv_chF","N",01,0,0,"C",space(60),"mv_par15"       ,"Vendedor 1"     ,space(30),space(15),"Vendedor 2"     ,space(30),space(15),"Vendedor 3"     ,space(30),space(15),"Vendedor 4"     ,space(30),space(15),"Vendedor 5"     ,space(30),"   "})
aadd(_agrpsx1,{cperg,"16","Considera Tipo Produto ?","mv_chG","N",01,0,0,"C",space(60),"mv_par16"       ,"Todos "     ,space(30),space(15),"Somente PA"     ,space(30),space(15),"Somente PN"     ,space(30),space(15),"Somente PD"     ,space(30),space(15),"Somente PA"        ,space(30),"   "})
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
PEDIDO   DATA   CODIGO DESCRICAO               QT.SOL QT.PEN        VALOR ESTOQ.
999999 99/99/99 999999 XXXXXXXXXXXXXXXXXXXXXXX 999999 999999 9.999.999,99 999999
*/


/*Layout Html
<html>

<head>
<title>Pedidos Pendentes</title>
</head>

<body>

<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber2">
  <tr>
    <td width="40%" rowspan="2">
    <img border="0" src="http://img.terra.com.br/capa/logoterra.gif" width="120" height="50"></td>
    <td width="47%" rowspan="2">

<p align="left"><b><font size="6">Pedidos Pendentes</font></b></p>
    </td>
    <td width="33%"><font size="2"><b>Emissão.: 99/99/99</b></font></td>
  </tr>
  <tr>
    <td width="33%"><font size="2"><b>Hora.......: 99:99:99</b></font></td>
  </tr>
</table>
<p><b>Período de</b> 99/99/99 <b>até</b> 99/99/99</p>

<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber1">
  <tr><td width="83%" colspan="7">CLIENTE: XXXXXXXXXXXXXXXXXXXX&nbsp; CID.: XXXXXXXXXXXXXXX - XX&nbsp; VEND.: XXXXXXXXXXXXXXXXXXXX</td></tr>
  <tr><td width="9%" align="center"><b>PEDIDO</b></td>
    <td width="9%" align="center"><b>DATA</b></td>
    <td width="9%" align="center"><b>CODIGO</b></td>
    <td width="30%" align="center"><b>DESCRICAO</b></td>
    <td width="8%" align="right"><b>QT. SOL</b></td>
    <td width="8%" align="right"><b>QT. PEN</b></td>
    <td width="10%" align="right"><b>VALOR </b></td></tr>
  <tr><td width="9%" align="center">XXXXXX</td>
    <td width="9%" align="center">99/99/99</td>
    <td width="9%" align="center">XXXXXX</td>
    <td width="30%" align="center">XXXXXXXXXXXXXXXXXXXXXXX</td>
    <td width="8%"><p align="right">999999</td>
    <td width="8%"><p align="right">999999</td>
    <td width="10%"><p align="right">9.999.999,99</td></tr>
  <tr><td width="73%" colspan="6"><p align="right"><b>Total === &gt;&gt;&gt;</b></td>
    <td width="10%"><p align="right">9.999.999,99</td></tr>
  </table>

<p>&nbsp;</p>
<p><b>Total Representante ===&gt;&gt;&gt; 9.999.999,99</b></p>

<p>&nbsp;</p>
<p><b>Total Geral ===&gt;&gt;&gt; 9.999.999,99</b></p>

</body>

</html>