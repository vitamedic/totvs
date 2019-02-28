#include "rwmake.ch"       
#INCLUDE "TOPCONN.CH"

User Function VIT045()     

SetPrvt("CTEST,TAMANHO,NHORA,LIMITE,TITULO,CDESC1")
SetPrvt("CDESC2,CDESC3,CBCONT,NLASTKEY,CBTXT,CPERG")
SetPrvt("CSTRING,NOMEPROG,ALINHA,M_PAG,WNREL,ARETURN")
SetPrvt("MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06")
SetPrvt("DDATE,CNOMEMES,CTAMNOME,CQUER1,")

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
�۳Programa  �  VIT045   �Autor �Gardenia		        � Data � 08/03/2002 ���
�������������������������������������������������������������������������Ĵ��
�۳Descricao � Relatorio de Compensacao de horas                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan - Sigafin Versao 4.07 SQL          ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/
Set Century On
cTest    := 1
Tamanho  := "M"
nHora    := Time()
Limite   := 132
Titulo   := "Relacao de cargos e salarios"
cDesc1   := "Este programa ira emitir a relacao de cargos e salarios "
cDesc2   := "De acordo com os parametros..."
cDesc3   := ""
cbCont   := 0
nLastKey := 0
cbTxt    := ""
cString  := "SRA"
NomeProg := "VIT045"
aLinha   := {}
m_pag    := 0
wnRel    := "VIT045"+Alltrim(cusername)
aReturn:={"Zebrado",1,"administracao",1,2,1,"",0}

cperg    :="PERGVIT045"
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

�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
�۳Programa � IMPTIT2   �Autor �Gardenia              � Data � 08/03/2002 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan - Sigafin Versao 4.07 SQL          ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

// Substituido pelo assistente de conversao do AP6 IDE em 08/03/02 ==> Function ImpTit2
Static Function ImpTit2()
//SeleArq()
SetRegua(RecCount())

cbcont:=0
m_pag :=1
li    :=132
cbtxt :=space(10)
cabec1:="Matric. Colaborador                          Admissao    Cargo                           Escolaridade          Salario "
cabec2:=""

@ 00,00 PSAY AvalImp(Limite)

_cfilsrj:=xfilial("SRJ")
_cfilsra:=xfilial("SRA")
_cfilsx5:=xfilial("SX5")
srj->(dbsetorder(1))
sra->(dbsetorder(3))
sx5->(dbsetorder(1))

dbSelectArea("SRA")
dbGoTop()   
//Set SoftSeek On
//dbSeek(xFilial("SRA")+mv_par01)
//Set SoftSeek Off
_mpag:=0
_ntot :=0
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
Do While !Eof()
  If SRA->RA_SITFOLH =='D'
    dbSelectArea("SRA")
    dbSkip()
    Loop
  EndIf
  If SRA->RA_MAT < mv_par01 .or. SRA->RA_MAT > mv_par02
    dbSelectArea("SRA")
    dbSkip()
    Loop
  EndIf  
  _ntot++
  IncRegua()
	if prow()>55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
	endif
  @ prow()+1 ,00 PSAY sra->ra_mat
  @ prow(),08 PSAY substr(sra->ra_nome,1,35)
  srj->(dbseek(_cfilsrj+sra->ra_codfunc))
  @ prow(),45 PSAY sra->ra_admissao
  @ prow(),57 PSAY substr(srj->rj_desc,1,30)
  sx5->(dbseek(_cfilsx5+"26"+sra->ra_grinrai))
  @ prow(),90 PSAY substr(sx5->x5_descri,1,30)
  @ prow(),124 PSAY sra->ra_salario picture "@E 9,999.99"
  dbSelectArea("SRA")
  dbSkip()
  If Eof()
    Exit
  EndIf
EndDo    
@ prow()+3,00 PSAY "No. de Funcion�rios:" 
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
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
�۳Programa  � SELEARQ   �Autor �Gardenia             � Data � 08/03/2002 ���
�������������������������������������������������������������������������Ĵ��
�۳Descricao � Selecao de Dados para o Relatorio                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan - Sigafin Versao 4.07 SQL          ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
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




//����������������������������������������Ŀ
//�mv_par01  := Da Matricula       C  06   �
//�mv_par02  := Ate Matricula      C  06   �
//�mv_par03  := Da Dt. Admissao    D  08   �
//�mv_par04  := Ate Dt. Admissao   D  08   �
//�mv_par05  := Do Centro Custo    C  09   �
//�mv_par06  := Ate Centro Custo   C  09   �
//������������������������������������������


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da matricula       ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"02","Ate a matricula    ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
	
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
