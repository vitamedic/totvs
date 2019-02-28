#include "rwmake.ch"  
#INCLUDE "TOPCONN.CH"

User Function vit112a()        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CQUERY,CARQ,ACAMPOS,")

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VIT112A  ³ Autor ³ Gardenia              ³ Data ³ 18/10/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Browse para consulta dos pedidos pendentes dos clientes    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Vitapan                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


cquery:=			" SELECT D1_DOC,D1_COD,D1_DESCPRO,D1_QUANT,D1_UM,D1_VUNIT,D1_TOTAL,"
cquery:=cquery+" D1_FORNECE,D1_LOJA,D1_PEDIDO,D1_EMISSAO,D1_SERIE"
cquery:=cquery+" FROM "+RETSQLNAME("SD1")
cquery:=cquery+" WHERE D1_FILIAL='"+XFILIAL("SD1")+"'"
cquery:=cquery+" AND D_E_L_E_T_<>'*'"
cquery:=cquery+" AND D1_COD='"+SB1->B1_COD+"'"
cquery:=cquery+" ORDER BY D1_EMISSAO"
tcquery cquery new alias "TMP"
tcsetfield("TMP","D1_QUANT","N",15,3)
tcsetfield("TMP","D1_VUNIT","N",15,7)
tcsetfield("TMP","D1_TOTAL","N",15,3)
tcsetfield("TMP","D1_EMISSAO","D",8,0)

carq:=criatrab(,.f.)
dbselectarea("TMP")
copy to &carq
tmp->(dbclosearea())
dbusearea(.t.,,carq,"TMP")

_cfilsa1:=xfilial("SA1")
sa1->(dbsetorder(1))
sa1->(dbseek(_cfilsa1+sd1->d1_fornece+sd1->d1_loja))
                       

//cquery:=			' SELECT D1_DOC,D1_QUANT,D1_UM,D1_VUNIT,D1_TOTAL,'
//cquery:=cquery+' D1_FORNECE,D1_LOJA,D1_PEDIDO,D1_EMISSAO,D1_SERIE'


acampos:={}
aadd(acampos,{"D1_DOC"    ,"Documento"   ,"@!",                    06,0})
aadd(acampos,{"D1_SERIE"  ,"Serie"  	  ,"@!",                    03,0})
aadd(acampos,{"D1_EMISSAO","Emissao"     ,"@!",                    08,0})
aadd(acampos,{"D1_QUANT"  ,"Quantidade"  ,"@E 999,999,999.99",     15,2})
aadd(acampos,{"D1_VUNIT"  ,"Vl.Unitario" ,"@E 999,999.9999999",    15,7})
aadd(acampos,{"D1_TOTAL"  ,"Total"       ,"@E 999,999,999.99",     15,2})
aadd(acampos,{"D1_FORNECE","Fornecedor"  ,"@!",                    06,0})
aadd(acampos,{"D1_LOJA"   ,"Loja"        ,"@!",                    02,0})
aadd(acampos,{"D1_PEDIDO" ,"Pedido"      ,"@!",                    06,0})
tmp->(dbgotop())
@ 130,001 to 420,635 dialog odlg title "Consulta Notas de entrada"
@ 025,005 to 140,320 browse "TMP" fields acampos
@ 005,010 button "_Visualizar" size 40,15 action execblock("VIT112D",.f.,.f.)
@ 005,060 button "_Sair" size 40,15 action close(odlg)
activate dialog odlg //centered

tmp->(dbclosearea())
ferase(carq+getdbextension())
return
