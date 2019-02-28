/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ENVEMAIL � Autor � Heraildo C. Freitas   � Data � 02/02/06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Envia Email Conforme os Parametros Passados                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
#include 'ap5mail.ch'

user function envemail(_cde,_cconta,_csenha,_cpara,_ccc,_ccco,_cassunto,_cmensagem,_canexos,_lavisa)
_cserver:=getmv("MV_WFSMTP")

_lconectou:=.f.
_lenviado :=.f.
_ldesconec:=.f.

connect smtp server _cserver account _cconta password _csenha result _lconectou
MailAuth(_cconta, _csenha)

if _lconectou
//	mailauth(_cde,_csenha)
	send mail from _cde to _cpara cc _ccc bcc _ccco subject _cassunto body _cmensagem attachment _canexos result _lenviado
	if _lenviado 
		if _lavisa
//			msginfo("E-mail enviado com sucesso!")
		endif 
	else
		_cerro:=""
		get mail error _cerro
		msginfo(_cerro)
	endif
	disconnect smtp server result _ldesconec
else
	msginfo("Problemas na conexao com servidor de E-Mail - "+_cserver)
endif
return()
