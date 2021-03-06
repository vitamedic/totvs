#include "rwmake.ch"       
#INCLUDE "TOPCONN.CH"

User Function VIT129()     

SetPrvt("CTEST,TAMANHO,NHORA,LIMITE,TITULO,CDESC1")
SetPrvt("CDESC2,CDESC3,CBCONT,NLASTKEY,CBTXT,CPERG")
SetPrvt("CSTRING,NOMEPROG,ALINHA,M_PAG,WNREL,ARETURN")
SetPrvt("MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06")
SetPrvt("DDATE,CNOMEMES,CTAMNOME,CQUER1,")

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
圹砅rograma  �  VIT129   矨utor 矴ardenia			     � Data � 08/03/2002 驰�
圹媚哪哪牧哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪篡�
圹矰escricao � Relatorio de Compensacao de Horas                          驰�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan - Sigafin Versao 4.07 SQL          潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/



Set Century On
cTest    := 1
Tamanho  := "M"
nHora    := Time()
Limite   := 132
Titulo   := "Funcionarios com ferias vencidas"
cDesc1   := "Este programa ira emitir o relatorio de funcionarios com ferias vencidas"
cDesc2   := "De acordo com os parametros..."
cDesc3   := ""
cbCont   := 0
nLastKey := 0
cbTxt    := ""
cString  := "SRA"
NomeProg := "VIT129"
aLinha   := {}
m_pag    := 0
wnRel    := "VIT129"+Alltrim(cusername)
aReturn:={"Zebrado",1,"administracao",1,2,1,"",0}

cperg    :="PERGVIT129"
_pergsx1()
pergunte(cperg,.f.)

ntipo :=if(areturn[4]==1,15,18)
nordem:=areturn[8]

wnrel:=SetPrint(cString,wnRel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

if nlastkey==27
	set filter to
	return
endif

SetDefault(aReturn,cString)

ntipo :=if(areturn[4]==1,15,18)

If nLastkey == 27 .Or. LastKey() == 27
  Set Filter To
  Return
EndIf
rptStatus({||Imptit2()})
Set Century Off
Return
/*

苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
圹谀哪哪哪哪履哪哪哪哪哪履哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪目圹
圹砅rograma � IMPTIT2   矨utor 矴ardenia                 � Data � 08/03/2002 驰�
圹媚哪哪穆哪聊哪哪哪哪哪聊哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪拇圹
圹砋so   � VITAPAN - Sigafin Versao 4.07 SQL                             驰�
圹媚哪哪牧哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇圹
7劾哪哪哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪氽�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/03/02 ==> Function ImpTit2
Static Function ImpTit2()
//SeleArq()
SetRegua(RecCount())
@ 00,00 PSAY AvalImp(Limite)
_cfilsrf:=xfilial("SRF")
srf->(dbsetorder(1))
_cfilsi3:=xfilial("SI3")
si3->(dbsetorder(1))

dbSelectArea("SRA")
dbSetOrder(8)
dbGoTop()   
//Set SoftSeek On
//dbSeek(xFilial("SRA")+mv_par01)
//Set SoftSeek Off
setprc(0,0)
_mpag:=0
cabec1:="Matricula Colaborador                               Dt.Admissao   Dt.Base Ferias    Dt.Mx.Ferias Dias F.Venc. Dias F.Prop. "    
cabec2:=''
_ntot:=0
//cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
Do While !Eof()
  If sra->ra_sitfolh =='D'
    dbSelectArea("SRA")
    dbSkip()
    Loop
  EndIf
  If sra->ra_cc < mv_par03 .or. sra->ra_cc > mv_par04
    dbSelectArea("SRA")
    dbSkip()
    Loop
  EndIf
  If sra->ra_mat < mv_par01 .or. sra->ra_mat > mv_par02
    dbSelectArea("SRA")
    dbSkip()
    Loop
  EndIf
  IncRegua()
  _cc := sra->ra_cc
  si3->(dbseek(_cfilsi3+_cc))
  _passou :=.f.
  Do While !Eof() .and. _cc==sra->ra_cc
  	 If sra->ra_sitfolh =='D'
   	dbSelectArea("SRA")
    	dbSkip()
	   Loop
 	 EndIf
    If sra->ra_cc < mv_par03 .or. sra->ra_cc > mv_par04
      dbSelectArea("SRA")
      dbSkip()
      Loop
    EndIf
  	 If sra->ra_mat < mv_par01 .or. sra->ra_mat > mv_par02
    	dbSelectArea("SRA")
	   dbSkip()
	   Loop
	 EndIf
  	 if  prow()>55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
	 endif                
    _cmat := sra->ra_mat
    srf->(dbseek(_cfilsrf+_cmat))
    _dias := date()-srf->rf_databas
    _dias := _dias/30
    _dias := _dias*2.5
	 if  _dias <30 .or. (!empty(srf->rf_dataini))
      dbSelectArea("SRA")
      dbSkip()
      Loop
    endIf
    if ! _passou 
		 cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
		 @ prow()+1,000 PSAY si3->i3_desc
		 _passou := .T.
	 endif	 
    @ prow()+1 ,00 PSAY sra->ra_mat
    @ prow(),10 PSAY sra->ra_nome
    @ prow(),54 PSAY sra->ra_admissao
    @ prow(),70 PSAY srf->rf_databas                    
    _mmeses :=srf->rf_dfervat/2.5    
    if _mmeses < 12
      _mmeses :=12
    endif  
    _maxfer := srf->rf_databas + (_mmeses*30.4167)                   
    _maxfer := _maxfer +(10*30.4167)
    @ prow(), 85 PSAY _maxfer
    @ prow(),100 PSAY int(_dias)
    @ prow(),115 PSAY srf->rf_dferaat
    _ntot++
    dbSelectArea("SRA")
    dbSkip()
    If Eof()
      Exit
    EndIf
  enddo 
EndDo   
@ prow()+3,00 PSAY "No. de Funcion醨ios:" 
@ prow(),23 PSAY _ntot picture "9999"


Set Filter To
Set Device To Screen
If aReturn[5] == 1
  Set Printer To
  dbCommitAll()
  OurSpool(wnRel)
EndIf
ms_Flush()
Set Century Off
Return
/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
圹谀哪哪哪哪履哪哪哪哪哪履哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪目圹
圹砅rograma � SELEARQ   矨utor 矴ardenia                 � Data � 08/03/2002 驰�
圹媚哪哪穆哪聊哪哪哪哪哪聊哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪拇圹
圹砋so   � VITAPAN - Sigafin Versao 4.07 SQL                             驰�
圹媚哪哪牧哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇圹
圹矰escricao � Selecao de dados para o relatorio                             驰�
圹滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁圹
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/03/02 ==> Function SeleArq
Static Function SeleArq()
/*
// versao SQL ja Esta Pronto Ok
  cQuer1 :=          ' SELECT * FROM ' + RetSqlName("SRA")
  cQuer1 := cQuer1 + ' WHERE D_E_L_E_T_ = " " '
  cQuer1 := cQuer1 + ' AND RA_FILIAL    = "'+xFilial("SRA")+'"'
  cQuer1 := cQuer1 + ' AND RA_MAT      >= "'+mv_par01+'"'
  cQuer1 := cQuer1 + ' AND RA_MAT      <= "'+mv_par02+'"'
  cQuer1 := cQuer1 + ' AND RA_ADMISSA  >= "'+DtoS(mv_par03)+'"'
  cQuer1 := cQuer1 + ' AND RA_ADMISSA  <= "'+DtoS(mv_par04)+'"'
  cQuer1 := cQuer1 + ' AND RA_CC       >= "'+mv_par05+'"'
  cQuer1 := cQuer1 + ' AND RA_CC       <= "'+mv_par06+'"'
  TCQuery cQuer1 NEW ALIAS "TRA"
  dbSelectArea("TRA")
  dbGoTop()
*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 08/03/02




//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//砿v_par01  := Da Matricula       C  06   �
//砿v_par02  := Ate Matricula      C  06   �
//砿v_par03  := Da Dt. Admissao    D  08   �
//砿v_par04  := Ate Dt. Admissao   D  08   �
//砿v_par05  := Do Centro Custo    C  09   �
//砿v_par06  := Ate Centro Custo   C  09   �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da matricula       ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"02","Ate a matricula    ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"03","Da matricula       ?","mv_ch3","C",09,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SI3"})
aadd(_agrpsx1,{cperg,"04","Ate a matricula    ?","mv_ch4","C",09,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SI3"})
	
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
