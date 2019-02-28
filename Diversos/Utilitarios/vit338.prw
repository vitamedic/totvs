/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT338   � Autor � Alex J鷑io de Miranda � Data � 23/01/09 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Programa para Envio de E-Mail Alertando sobre Validade do  潮�
北�          � Certificado Digital Via Schedule                           潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "tbicode.ch"

user function vit338()
prepare environment empresa "01" filial "01" tables "SA1"

_cde      :="Servidor Protheus - Aviso <"+getmv("MV_WFMAIL")+">"
_cconta   :=getmv("MV_WFACC")
_csenha   :=getmv("MV_WFPASSW")
_cpara:="report_contabilidade@vitamedic.ind.br;faturamento@vitamedic.ind.br;ti@vitamedic.ind.br"  // Tratar Recebimentos aqui
_ccc:="adm@vitamedic.ind.br"

//_cpara:="gti@vitamedic.ind.br"  // Tratar Recebimentos aqui
_ccc:=""


_ccco     :="" // com copia oculta
_cassunto :="Aviso sobre Vencimento Certificado Digital NFe"

_cmensagem:="Este e-mail serve para notifica玢o acerca da expira玢o do <P>"
_cmensagem+="Certificado Digital NFe.<P>"
_cmensagem+="A validade � 16/06/2012.<P>"
_cmensagem+="<P>"
_cmensagem+="� necess醨io que seja providenciado um novo certificado com os<P>"
_cmensagem+="髍g鉶s competentes para tal, no m醲imo com at� 20 dias antes da expira玢o<P>"
_cmensagem+="para evitar impossibilidades de faturamento.<P>"
_cmensagem+="Favor notificar o Departamento de Contabilidade, do recebimento deste,<P>"
_cmensagem+="para que sejam tomadas as devidas provid阯cias.<P>"
_cmensagem+="<P>"
_cmensagem+="<P>"
_cmensagem+="Depto. TI<P>"
_cmensagem+="Vitamedic Ind鷖tria Farmac陁tica Ltda<P>"
_cmensagem+="Data: "+dtoc(date())+"<P>"
_cmensagem+="Hora: "+time()+"<P>"

_canexos  :="" // caminho completo dos arquivos a serem anexados, separados por ;
_lavisa   :=.f.
u_envemail(_cde,_cconta,_csenha,_cpara,_ccc,_ccco,_cassunto,_cmensagem,_canexos,_lavisa)

reset environment
return()
