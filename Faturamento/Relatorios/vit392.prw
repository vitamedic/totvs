/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �Matr020   � Autor �Liber de Esteban       � Data � 10/05/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relacao de Clientes                                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
#INCLUDE "MATR020.CH" 
#INCLUDE "PROTHEUS.CH"


User Function vit392()

Local cReport	:= "MATR020"	//Nome do Programa
Local cAlias	:= "SA1"		//Alias da tabela
Local cTitle	:= STR0016      //"Listagem de Clientes"
Local cDesc		:= STR0017      //"Este relat�rio apresenta uma rela��o dos Clientes cadastrados."
Local lInd		:= .T.			//Retorna Indice SIX

If FindFunction("TRepInUse") .And. TRepInUse()
	MPReport(cReport,cAlias,cTitle,cDesc,,lInd)	
Else
	u_MATRX20R3()
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR020R3� Autor � Wagner Xavier         � Data � 05.09.91 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Emiss�o da Rela��o de Clientes                              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR020(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��� Edson   M.   �30/03/99�XXXXXX�Passar o tamanho na SetPrint.           ��� 
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MatrX20R3()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL CbCont,cabec1,cabec2,cabec3,nPos,wnrel,CbTxt
LOCAL tamanho:="M"
LOCAL limite :=132
LOCAL titulo:=OemToAnsi(STR0001)  //"Relacao de clientes"
LOCAL cDesc1:=OemToAnsi(STR0002)  //"Emissao do Cadastro de Clientes"
LOCAL cDesc2:=OemToAnsi(STR0003)  //"Ira imprimir os dados dos clientes      "
LOCAL cDesc3:=OemToAnsi(STR0004)  //"de acordo com a configuracao do usuario."
LOCAL aOrd  := {}
PRIVATE aReturn := { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE aLinha:= { }
PRIVATE nomeprog:="MATR020",nLastKey := 0
Private cRetTitle := RTrim(RetTitle("A1_CGC"))
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������

cbcont   := 0
cabec1   := OemToAnsi(STR0007)  //"RELACAO COMPLETA DO CADASTRO DE CLIENTES"
cabec2   := " "
cabec3   := " "
cString  := "SA1"
aOrd     := {OemToAnsi(STR0008),OemToAnsi(STR0009),OemToAnsi(STR0015)+cRetTitle}  //" Por Codigo         "###" Alfabetica         "###" Por + cRetTitle" 

wnrel    :="MATR020" 

Private AParDef := {}
wnrel:=SetPrint(cString,wnrel,"ParamDef(cAlias)",@Titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,,tamanho)

If nLastKey = 27
   dbClearFilter()
   Return
Endif

// PESQUISA CODIGO DO SUPERVISOR
_cfilsa3:=xfilial("SA3")
sa3->(dbsetorder(7))
if sa3->(dbseek(_cfilsa3+__cuserid))
	_cgerente:=sa3->a3_cod
else
	_cgerente:=space(6)
endif

// Setar filtro dinamico 
if _cgerente < "001000"
	cFiltro := "A1_VEND = '"+Alltrim(_cgerente)+"'"
	SET FILTER TO &(cFiltro)
endif

SetDefault(aReturn,cString)

If nLastKey = 27
	dbClearFilter()
   Return
Endif

RptStatus({|lEnd| R020Imp(@lEnd,Cabec1,Cabec2,Cabec3,limite,tamanho,cbCont,wnrel)},Titulo)

Return 
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R020IMP  � Autor � Cristina M. Ogura     � Data � 10.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR020                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function R020Imp(lEnd,Cabec1,Cabec2,Cabec3,limite,tamanho,cbCont,wnrel)

li       := 80
m_pag    := 1
cbtxt    := SPACE(10)
//��������������������������������������������������������������Ŀ
//� Monta Array para identificacao dos campos dos arquivos       �
//����������������������������������������������������������������
if Len(aReturn) > 8
	Mont_Dic(cString)
else
	Mont_Array(cString)
endif

ImpCadast(Cabec1,Cabec2,Cabec3,NomeProg,Tamanho,Limite,cString,@lEnd)

IF li != 80
	roda(cbcont,cbtxt,"M")
EndIF

dbSelectArea("SA1")
dbClearFilter()
dbSetOrder(1)

If aReturn[5] = 1
   Set Printer To 
   dbCommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()

Return Nil
