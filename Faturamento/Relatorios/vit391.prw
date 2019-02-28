/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �Matr010   � Autor �Liber de Esteban       � Data � 10/05/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relacao de Produtos                                         ���
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

#INCLUDE "MATR010.CH" 
#INCLUDE "PROTHEUS.CH"

User Function vit391()

Local cReport	:= "MATR010"	//Nome do Programa
Local cAlias	:= "SB1"		//Alias da tabela
Local cTitle	:= STR0012      //"Listagem de Produtos"
Local cDesc		:= STR0013      //"Este relat�rio apresenta uma rela��o dos Produtos cadastrados."
Local lInd		:= .T.			//Retorna Indice SIX

If FindFunction("TRepInUse") .And. TRepInUse()
	MPReport(cReport,cAlias,cTitle,cDesc,,lInd)	
Else
	u_MATRX10R3()
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR010R3� Autor � Wagner Xavier         � Data � 05.09.91 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Emiss�o da rela��o de Materiais (Release 3)                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MATR010R3(void)                                            ���
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
User Function MatrX10R3()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL wnrel
LOCAL CbCont,cabec1,cabec2,cabec3,nPos
LOCAL tamanho:= "M"
LOCAL limite := 132
LOCAL titulo := OemToAnsi(STR0001)	//"Relacao de Materiais"
LOCAL cDesc1 := OemToAnsi(STR0002)	//"Emissao do Cadastro de Materiais"
LOCAL cDesc2 := OemToAnsi(STR0003)	//"Ira imprimir os dados dos produtos de acordo"
LOCAL cDesc3 := OemToAnsi(STR0004)	//"com a configuracao do usuario."

PRIVATE aReturn := { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE aLinha:= { }
PRIVATE nomeprog:="MATR010",nLastKey := 0

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
cabec1   := STR0007	//"RELACAO COMPLETA DO CADASTRO DE MATERIAIS"
cabec2   := " "
cabec3   := " "
cString  := "SB1"
li       := 80
m_pag    := 1
aOrd     := {OemToAnsi(STR0008),OemToAnsi(STR0009),OemToAnsi(STR0010),OemToAnsi(STR0011)}		//" Por Codigo         "###" Por Tipo           "###" Por Descricao      "###" Por Grupo          "
wnrel    := "MATR010"                   // nome default do relatorio em disco

Private AParDef := {}
wnrel:=SetPrint(cString,wnrel,"ParamDef(cAlias)",@Titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,,Tamanho)

If nLastKey = 27 
    dbClearFilter()
   Return
Endif

// Setar filtro dinamico 
cFiltro := "B1_TIPO $ 'PA'"
SET FILTER TO &(cFiltro)

SetDefault(aReturn,cString)

If nLastKey = 27
    dbClearFilter()
   Return
Endif

//��������������������������������������������������������������Ŀ
//� Monta Array para identificacao dos campos dos arquivos       �
//����������������������������������������������������������������
RptStatus({|lEnd| R010Imp(@lEnd,Cabec1,Cabec2,Cabec3,limite,tamanho,cbCont,wnrel)},Titulo)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R010IMP  � Autor � Cristina M. Ogura     � Data � 10.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR010                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function R010Imp(lEnd,Cabec1,Cabec2,Cabec3,limite,tamanho,cbCont,wnrel)

If Len(aReturn) > 8
    Mont_dic(cString)
else
    Mont_Array(cString)
endif

ImpCadast(Cabec1,Cabec2,Cabec3,NomeProg,Tamanho,Limite,cString,@lEnd)

IF li != 80
    roda(cbcont,cbtxt,"M")
EndIF

dbSelectArea("SB1")
dbClearFilter()
dbSetOrder(1)


If aReturn[5] = 1
   Set Printer TO 
   Commit
   ourspool(wnrel)
Endif
MS_FLUSH()
Return nil
