/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT338   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 23/01/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Programa para Envio de E-Mail Alertando sobre Validade do  ³±±
±±³          ³ Certificado Digital Via Schedule                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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

_cmensagem:="Este e-mail serve para notificação acerca da expiração do <P>"
_cmensagem+="Certificado Digital NFe.<P>"
_cmensagem+="A validade é 16/06/2012.<P>"
_cmensagem+="<P>"
_cmensagem+="É necessário que seja providenciado um novo certificado com os<P>"
_cmensagem+="órgãos competentes para tal, no máximo com até 20 dias antes da expiração<P>"
_cmensagem+="para evitar impossibilidades de faturamento.<P>"
_cmensagem+="Favor notificar o Departamento de Contabilidade, do recebimento deste,<P>"
_cmensagem+="para que sejam tomadas as devidas providências.<P>"
_cmensagem+="<P>"
_cmensagem+="<P>"
_cmensagem+="Depto. TI<P>"
_cmensagem+="Vitamedic Indústria Farmacêutica Ltda<P>"
_cmensagem+="Data: "+dtoc(date())+"<P>"
_cmensagem+="Hora: "+time()+"<P>"

_canexos  :="" // caminho completo dos arquivos a serem anexados, separados por ;
_lavisa   :=.f.
u_envemail(_cde,_cconta,_csenha,_cpara,_ccc,_ccco,_cassunto,_cmensagem,_canexos,_lavisa)

reset environment
return()
