#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function VIT048()    


SetPrvt("CTEST,TAMANHO,NHORA,LIMITE,TITULO,CDESC1")
SetPrvt("CDESC2,CDESC3,CBCONT,CBTXT,NORDEM,CSTRING")
SetPrvt("NOMEPROG,ALINHA,M_PAG,LTEST,WNREL,NSUPTIT")
SetPrvt("NSUPDES,NSUPREC,NCORTIT,NCORDES,NCORREC,NTOTTIT")
SetPrvt("NTOTDES,NTOTREC,ARETURN,CPERG,MV_PAR01,MV_PAR02")
SetPrvt("MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06,MV_PAR07,MV_PAR08")
SetPrvt("MV_PAR09,MV_PAR10,MV_PAR11,MV_PAR12,MV_PAR13,MV_PAR14")
SetPrvt("LI,CCODVEND,NVALDESC,NVALREC,CTITREL,CQUERY")
SetPrvt("ACAMPOS,CNOMEARQ,CVEND1,DDATA,_AGRPSX1,_I")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 08/02/02 ==> #INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa  ³  VIT048   ³Autor ³Gardenia Ilany       ³ Data ³ 08/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Relatorio de Titulos a Receber no Periodo                  ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan - SigaFin Versao 4.07 SQL          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


cTest    := 1
Tamanho  := "M"
nHora    := Time()
Limite   := 135
Titulo   := "Titulos Vencidos e a Receber"
cDesc1   := "Este programa ira emitir o relatorio de titulos a Receber de "
cDesc2   := "Acordo com os parametros"
cDesc3   := ""
cbCont   := 0
cbTxt    := ""
nOrdem   := ""
cString  := "SE1"
NomeProg := "VIT048"
aLinha   := {}
m_pag    := 0
lTest    := .T.
wnRel    := "VIT048"+Alltrim(cusername)
nSupTit  := 0
nSupDes  := 0
nSupRec  := 0
nCorTit  := 0
nCorDes  := 0
nCorRec  := 0
nTotTit  := 0
nTotDes  := 0
nTotRec  := 0
aReturn  := {"Zebrado",1,"administracao",1,2,1,"",0}
cPerg    := "PERGVIT048"

_pergsx1()
pergunte(cperg,.f.)

WnRel:=SetPrint(cString,wnRel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)
If nLastkey == 27 .Or. LastKey() == 27
  Set Filter To
  Return
EndIf
SetDefault(aReturn,cString)
rptStatus({||Imptit2()})// Substituido pelo assistente de conversao do AP6 IDE em 08/02/02 ==> rptStatus({||Execute(Imptit2)})
Return
/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ IMPTIT2   ³Autor ³Gardenia Ilany           ³ Data ³ 08/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ vitapan     - Sigafin Versao 4.07 SQL                             ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao dos Titulos do Contas a Receber                     ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/02/02 ==> Function ImpTit2
Static Function ImpTit2()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³mv_par01  := Do Banco           C  03   ³
//³mv_par02  := Ate Banco          C  03   ³
//³mv_par03  := Da Emissao         D  08   ³
//³mv_par04  := Ate Emissao        D  08   ³
//³mv_par05  := Do Vencimento      D  08   ³
//³mv_par06  := Ate Vencimento     D  08   ³
//³mv_par07  := Do Cliente         C  06   ³
//³mv_par08  := Da Loja            C  02   ³
//³mv_par09  := Ate Cliente        C  06   ³
//³mv_par10  := Ate Loja           C  02   ³
//³mv_par11  := Do Representante   C  06   ³
//³mv_par12  := Ate Representante  C  06   ³
//³mv_par13  := Da Natureza        C  02   ³
//³mv_par14  := Ate Natureza       C  02   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := aReturn[8]
//SeleArq()
//CriaArq()
_cfilse1:=xfilial("SE1")
_cfilsa3:=xfilial("SA3")
_cfilsa1:=xfilial("SA1")
sa3->(dbsetorder(1))
sa1->(dbsetorder(1))
_cindse1 :=criatrab(,.f.)
_cchave :="E1_FILIAL+E1_VEND1+E1_CLIENTE+E1_LOJA+DTOS(E1_VENCTO)"
se1->(indregua("se1",_cindse1,_cchave))
//if !empty(mv_par11)
//	se1->(dbseek(_cfilse1+mv_par11))
//endif	
If Eof()
  lTest := .F.
EndIf
SetRegua(RecCount())
@ 00,00 PSAY AvalImp(Limite)
ImpCabec()
_ntotval := 0
_ntotsal := 0 
_passou :=.F.
_ttotrec:=0
Do While !Eof() .And. lTest == .T.
  if se1->e1_saldo <=0
     dbSelectArea("SE1")
	  dbSkip()
	  loop
   endif
//  if (se1->e1_cliente < mv_par07 .and. se1->e1_loja < mv_par08 ) .or.( se1->e1_cliente > mv_par09 .and. se1->e1_loja > mv_par10)
    if (se1->e1_cliente < mv_par07 ) .or.( se1->e1_cliente > mv_par09 )
     dbSelectArea("SE1")
	  dbSkip()
	  loop
  endif  
  if se1->e1_vend1 < mv_par11 .or. se1->e1_vend1 > mv_par12 
     dbSelectArea("SE1")
	  dbSkip()
	  loop
  endif  
  if se1->e1_naturez < mv_par13 .or. se1->e1_naturez > mv_par14 
     dbSelectArea("SE1")
	  dbSkip()
	  loop
  endif  
  if se1->e1_portado < mv_par01 .or. se1->e1_portado > mv_par02 
     dbSelectArea("SE1")
	  dbSkip()
	  loop
  endif  
  if se1->e1_emissao < mv_par03 .or. se1->e1_emissao > mv_par04 
     dbSelectArea("SE1")
	  dbSkip()
	  loop
  endif  
  if se1->e1_vencto < mv_par05 .or. se1->e1_vencto > mv_par06 
     dbSelectArea("SE1")
	  dbSkip()
	  loop
  endif  
  cCodVend := SE1->E1_VEND1
  sa3->(dbseek(_cfilsa3+ccodvend))
  IncRegua()                              
  _nrepval := 0
  _nrepsal := 0
  _passou = .T.
  _tvendrec :=0
  @ li,000 PSAY "Representante..:"
  @ li,017 PSAY Alltrim(se1->e1_vend1)+"-"+Alltrim(SA3->A3_NOME)
  li := li + 1
  Do While cCodVend == se1->e1_vend1 .And. !Eof()
	  if se1->e1_saldo <=0
  	    dbSelectArea("SE1")
		 dbSkip()
		 loop
  	   endif
	  if (se1->e1_cliente < mv_par07  ) .or.( se1->e1_cliente > mv_par09 )
  		  dbSelectArea("SE1")
		  dbSkip()
		  loop
	  endif  
	  if se1->e1_vend1 < mv_par11 .or. se1->e1_vend1 > mv_par12 
   	  dbSelectArea("SE1")
		  dbSkip()
		  loop
	  endif  
  	  if se1->e1_naturez < mv_par13 .or. se1->e1_naturez > mv_par14 
	     dbSelectArea("SE1")
  		  dbSkip()
  		  loop
	  endif  
	  if se1->e1_portado < mv_par01 .or. se1->e1_portado > mv_par02 
	     dbSelectArea("SE1")
		  dbSkip()
		  loop
	  endif  
	  if se1->e1_emissao < mv_par03 .or. se1->e1_emissao > mv_par04 
  		  dbSelectArea("SE1")
	     dbSkip()
	     loop
	  endif  
	  if se1->e1_vencto < mv_par05 .or. se1->e1_vencto > mv_par06 
	     dbSelectArea("SE1")
		  dbSkip()
		  loop
	  endif  
	 _cCodCli := se1->e1_cliente       
	 _cloja :=se1->e1_loja
    _nSupTit := 0
    _nSupRec := 0
   sa1->(dbseek(_cfilsa1+_ccodcli))
   _tclirec :=0
    li := li + 1
    @ li,000 PSAY se1->e1_cliente Picture "999999"         
    @ li,010 PSAY SubStr(sa1->a1_nome,1,23) Picture "@!"
    @ li,053 PSAY substr(sa1->a1_tel,1,12) Picture "@!"
    li := li + 1
	 Do While cCodVend == se1->e1_vend1 .And. _cCodCli == se1->e1_cliente .and. se1->e1_loja==_cloja .and.  !Eof()
		  if se1->e1_saldo <=0
	  	    dbSelectArea("SE1")
			 dbSkip()
			 loop
	  	   endif
		  if (se1->e1_cliente < mv_par07  ) .or.( se1->e1_cliente > mv_par09 )
	  		  dbSelectArea("SE1")
			  dbSkip()
			  loop                                        
		  endif  
		  if se1->e1_vend1 < mv_par11 .or. se1->e1_vend1 > mv_par12 
	   	  dbSelectArea("SE1")
			  dbSkip()
			  loop
		  endif  
  		  if se1->e1_naturez < mv_par13 .or. se1->e1_naturez > mv_par14 
		     dbSelectArea("SE1")
  			  dbSkip()
  			  loop
		  endif  
		  if se1->e1_portado < mv_par01 .or. se1->e1_portado > mv_par02 
		     dbSelectArea("SE1")
			  dbSkip()
			  loop
		  endif  
		  if se1->e1_emissao < mv_par03 .or. se1->e1_emissao > mv_par04 
  			  dbSelectArea("SE1")
		     dbSkip()
		     loop
		  endif  
		  if se1->e1_vencto < mv_par05 .or. se1->e1_vencto > mv_par06 
		     dbSelectArea("SE1")
			  dbSkip()
			  loop
		  endif  
       if se1->e1_saldo >0
		    @ li,000 PSAY se1->e1_prefixo+' '+se1->e1_num+"-"+se1->e1_parcela+" "+se1->e1_tipo
		    @ li,018 PSAY DtoC(se1->e1_emissao)
		    @ li,027 PSAY DtoC(se1->e1_vencto)
		    @ li,036 PSAY se1->e1_valor Picture "@E 9,999,999.99"
		    @ li,049 PSAY se1->e1_portado   
		    @ li,053 PSAY se1->e1_valor+se1->e1_juros-se1->e1_saldo Picture "@E 9,999,999.99"
		    @ li,066 PSAY se1->e1_valor-se1->e1_saldo Picture "@E 9,999,999.99"
		    @ li,079 PSAY se1->e1_juros Picture "@E 9,999,999.99"
		    @ li,092 PSAY se1->e1_baixa 
		    @ li,101 PSAY se1->e1_descont Picture "@E 9,999,999.99"
          @ li,114 PSAY se1->e1_saldo Picture "@E 9,999,999.99"
	    endif
	    nSupTit := nSupTit + se1->e1_valor
		 nSupRec := nSupRec + se1->e1_saldo
		 _nSupTit := _nSupTit + se1->e1_valor
		 _nSupRec := _nSupRec + se1->e1_saldo
		 _nrepval := _nrepval + se1->e1_valor
		 _nrepsal := _nrepsal + se1->e1_saldo
		 _ntotval := _ntotval + se1->e1_valor
		 _ntotsal := _ntotsal + se1->e1_saldo
 
	    _tclirec += SE1->E1_VALOR+SE1->E1_JUROS-SE1->E1_SALDO
	    _tvendrec += SE1->E1_VALOR+SE1->E1_JUROS-SE1->E1_SALDO
	    _ttotrec += SE1->E1_VALOR+SE1->E1_JUROS-SE1->E1_SALDO
		 
	 
		 li := li + 1
		 If li >= 58
		    ImpCabec()
		    @ li,000 PSAY Replicate("-",135)
		    li := li + 1
		 EndIf
		 dbSelectArea("SE1")
		 dbSkip()
	    If Eof()
	      Exit
	    EndIf
	 enddo  
	 if _nsuprec > 0
	    @ li,000 PSAY "Total Cliente -->"
   	 @ li,036 PSAY _nSupTit Picture "@E 9,999,999.99"
   	 @ li,053 PSAY _tclirec Picture "@E 9,999,999.99"
	    @ li,114 PSAY _nSupRec Picture "@E 9,999,999.99"
   	 li := li + 1
    endif	 
  EndDo  
  if nsuprec > 0
	  @ li,000 PSAY "Total Representante -->"
     @ li,036 PSAY _nrepval Picture "@E 9,999,999.99"
  	  @ li,053 PSAY _tvendrec Picture "@E 9,999,999.99"
  	  @ li,114 PSAY _nrepsal Picture "@E 9,999,999.99"
	  li := li + 2
  endif  
  if !eof()
//	  ImpCabec()
  endif	  
EndDo
se1->(retindex("SE1"))
ferase(_cindse1+se1->(ordbagext()))
//ImpRodape()
//Eject
dbSelectArea("se1")
dbCloseArea("se1")
Set Device To Screen
If aReturn[5] == 1
  Set Printer To
  dbCommitAll()
  OurSpool(wnRel)
EndIf
ms_Flush()
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ IMPCABEC  ³Autor ³Gardenia Ilany           ³ Data ³ 08/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitapan - Sigafin Versao 4.07 SQL                             ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao do Cabecalho Do Relatorio                           ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/02/02 ==> Function ImpCabec
Static Function ImpCabec()
cTitRel := "Por Ordem de Representante+Cliente+Vencimento"
m_Pag := m_Pag + 1
@ 00,000 PSAY Replicate("*",135)
@ 01,000 PSAY Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL)
@ 01,059 PSAY "Relacao Titulos a Receber"
@ 01,113 PSAY "Folha...:"
@ 01,128 PSAY StrZero(m_Pag,3)
@ 02,000 PSAY "C.I./VIT048/v.6.09"
@ 02,056 PSAY "Emissoes Entre "+DtoC(mv_par03)+" e "+DtoC(mv_par04)
@ 02,113 PSAY "DT. Ref.: "+DtoC(dDataBase)
@ 03,000 PSAY "Hora...: "+ SubStr(nHora,1,8)
@ 03,028 PSAY PadC(cTitRel,84)
@ 03,113 PSAY "Emissao.: "+DtoC(Date())
@ 04,000 PSAY Replicate("-",135)
//                       10        20        30        40        50        60        70        80        90        100       110       120       130
//             0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012

@ 05,000 PSAY "Codigo    Nome Cliente                                  Telefone"
@ 06,000 PSAY "Numero    +P+Tp  Emissao  Vencto        Vlr.Tit.Bco     Vlr.Pago    Pago Tit.    Pago Jrs. Baixa        Vl.Desc.    A Receber" 
@ 07,000 PSAY "---------------------------------------------------------------------------------------------------------------------------------------"
li := 08
dbSelectArea("SE1")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ IMPRODAPE ³Autor ³Gardenia Ilany           ³ Data ³ 08/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitapan - Sigafin Versao 4.07 SQL                             ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao do Rodape do Relatorio                              ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/02/02 ==> Function ImpRodape
Static Function ImpRodape()
@ li,000 PSAY Replicate("-",135)
li := li + 1
@ li,000 PSAY "T O T A L  G E R A L -->"
@ li,036 PSAY _nTotval Picture "@E 9,999,999.99"
@ li,053 PSAY _ttotrec Picture "@E 9,999,999.99"
@ li,114 PSAY _nTotsal Picture "@E 9,999,999.99"
li := li + 1
@ li,000 PSAY Replicate("-",135)
li := li + 1
//@ li,000 PSAY "O C.I. Faz Parte da Sua Solucao"
@ li,109 PSAY "Hora Termino.:"+SubStr(Time(),1,8)
li := li + 1
@ li,000 PSAY Replicate("*",135)
Return



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³mv_par01  := Do Banco           C  03   ³
//³mv_par02  := Ate Banco          C  03   ³
//³mv_par03  := Da Emissao         D  08   ³
//³mv_par04  := Ate Emissao        D  08   ³
//³mv_par05  := Do Vencimento      D  08   ³
//³mv_par06  := Ate Vencimento     D  08   ³
//³mv_par07  := Do Cliente         C  06   ³
//³mv_par08  := Da Loja            C  02   ³
//³mv_par09  := Ate Cliente        C  06   ³
//³mv_par10  := Ate Loja           C  02   ³
//³mv_par11  := Do Representante   C  06   ³
//³mv_par12  := Ate Representante  C  06   ³
//³mv_par13  := Da Natureza        C  02   ³
//³mv_par14  := Ate Natureza       C  02   ³




// Substituido pelo assistente de conversao do AP6 IDE em 08/02/02 ==> static function _pergsx1()

Static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do Banco           ?","mv_ch1","C",03,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA6"})
aadd(_agrpsx1,{cperg,"02","Ate o Banco        ?","mv_ch2","C",03,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA6"})
aadd(_agrpsx1,{cperg,"03","Da Emissao         ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate a Emissao      ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Do Vencimento      ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate o Vencimento   ?","mv_ch6","D",08,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Do Cliente         ?","mv_ch7","C",06,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"08","Da Loja            ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Ate o Cliente      ?","mv_ch9","C",06,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"10","Ate a Loja         ?","mv_ch10","C",02,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Do Representante   ?","mv_ch11","C",06,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"12","Ate o Representante?","mv_ch12","C",06,0,0,"G",space(60),"mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"13","Da Natureza        ?","mv_ch13","C",10,0,0,"G",space(60),"mv_par13"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SED"})
aadd(_agrpsx1,{cperg,"14","Ate a Natureza     ?","mv_ch14","C",10,0,0,"G",space(60),"mv_par14"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SED"})

	
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

