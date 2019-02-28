#include "rwmake.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT385   � Autor � Wesley Lomazzi        � Data � 10/01/12 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Programa utilizado para bloquear  os  ambientes  utilizados���
���          � que estao fora do ambiente padrao  da empresa.  O  ambiente���
���          � padr�o est� configurado no parametro MV_AMBPADR. Caso o usu���
���          � ario utilize um ambiente que esta fora do ambiente padr�o o���
���          � sistema verificara na tabela ZDD se existe a libera��o   do���
���          � ambiente para o usu�rio na data indicada.                  ���
�������������������������������������������������������������������������Ĵ��
���Chamada   � Este programa � chamado pelo arquivo sx2, conforme abaixo: ���
���          � alterar o conteudo do campo x2_rotina = u_fechapro() para a���
���          � tabela sx5.                                                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Vitapan Industria Farmac�utica                             ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
*/

User Function vit385() 
Public  _camblib 	:= upper(Alltrim(getenvserver())) 		// ambiente utilizado (ambiente atual)
Private _cambpad	:= upper(Alltrim(GetMv("MV_AMBPADR")))	// ambiente padrao da empresa

_dUsuario     	  := PSWRET()
_dptUsuario	  := substr((_dUsuario[1][12]),1,3)
_codUsuario	  := RETCODUSR()
// Caso o ambiente atual seja diferente do ambiente padrao da empresa o sistema faz a verifica��o na tabela ZDD se existe a libera��o tempor�ria
// para o usu�rio
If _codUsuario == '000000'
	return
EndIf

If !_dptUsuario $ ("GTI")
	If !(_camblib == _cambpad) 
		zdd->(dbsetorder(1)) 
		If !zdd->(Dbseek(xFilial("ZDD")+__cuserid+_camblib+space((10-len(_camblib)))+dtos(date())))
			final("Ambiente bloqueado. Utilize o ambiente "+_cambpad) // finaliza o sistema
		Endif
	Endif
EndIf
 
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AFATA019 � Autor � Andr� Almeida      � Data �  10/01/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de ambientes liberados X usuario				  ���
�������������������������������������������������������������������������͹��
���Uso       � Abelha Rainha                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit386()
	zdd->(dbsetorder(1))

	axcadastro("ZDD","Ambientes Liberados X Usuario")
return()
