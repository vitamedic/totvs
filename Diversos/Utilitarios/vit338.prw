/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT338   � Autor � Alex J�nio de Miranda � Data � 23/01/09 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Programa para Envio de E-Mail Alertando sobre Validade do  ���
���          � Certificado Digital Via Schedule                           ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
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

_cmensagem:="Este e-mail serve para notifica��o acerca da expira��o do <P>"
_cmensagem+="Certificado Digital NFe.<P>"
_cmensagem+="A validade � 16/06/2012.<P>"
_cmensagem+="<P>"
_cmensagem+="� necess�rio que seja providenciado um novo certificado com os<P>"
_cmensagem+="�rg�os competentes para tal, no m�ximo com at� 20 dias antes da expira��o<P>"
_cmensagem+="para evitar impossibilidades de faturamento.<P>"
_cmensagem+="Favor notificar o Departamento de Contabilidade, do recebimento deste,<P>"
_cmensagem+="para que sejam tomadas as devidas provid�ncias.<P>"
_cmensagem+="<P>"
_cmensagem+="<P>"
_cmensagem+="Depto. TI<P>"
_cmensagem+="Vitamedic Ind�stria Farmac�utica Ltda<P>"
_cmensagem+="Data: "+dtoc(date())+"<P>"
_cmensagem+="Hora: "+time()+"<P>"

_canexos  :="" // caminho completo dos arquivos a serem anexados, separados por ;
_lavisa   :=.f.
u_envemail(_cde,_cconta,_csenha,_cpara,_ccc,_ccco,_cassunto,_cmensagem,_canexos,_lavisa)

reset environment
return()
