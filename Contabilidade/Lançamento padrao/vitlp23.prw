/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �VITLP23   �Autor  �Heraildo C. Freitas � Data �  27/11/03   ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna a conta contabil de debito no lancamento           ���
���          � padronizado de requisicao                                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � LP 666/001                                                 ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Alteracao � 08/03/04 - Revisao para novo plano de contas               ���
�������������������������������������������������������������������������Ŀ��
�����������������������������������������������������������������������������
*/




#include "rwmake.ch"

user function vitlp23()
Local _aarea:= getarea()
_cconta:="INDEF. TM "+sd3->d3_tm
dbselectarea("SZA")
DbsetOrder(1)
If  sza->(dbseek(xFilial("SZA")+SD3->D3_GRUPO+substr(SD3->D3_CC,1,2)+SD3->D3_TM))
	_cConta :=  if(Empty(SZA->ZA_CONTA),"CTA SEM SZA "+SD3->D3_GRUPO,SZA->ZA_CONTA)  
Else
	if sd3->d3_tm$"501"                // BONIFICACAO
		if (sb1->b1_grtrib=="001") .or. (sb1->b1_grtrib=="003") //lista positiva
			_cconta:="3401011113301"        //????-utilizacao
		else                       
			_cconta:="3401010113101"		//lista negativa
		endif
	elseif sd3->d3_tm$"502"            // REQ. MAT. CONSUMO
		if substr(sd3->d3_cc,1,2)=="29" .or. substr(sd3->d3_cc,1,2)=="28" // CUSTO (INDUSTRIA)
			if empty(sb1->b1_ctacus)
				_cconta:="CTA.CUSTO GRUPO "+SD3->D3_GRUPO
			else
				_cconta:=sb1->b1_ctacus
			endif
		else                            // DESPESA (ADMINISTRACAO)
			if empty(sb1->b1_ctades)
				_cconta:="CTA.DESP.GRUPO "+SD3->D3_GRUPO
			else
				_cconta:=sb1->b1_ctades
			endif
		endif
	elseif sd3->d3_tm$"505"            // REQ. BRINDES
		_cconta:="4102020616603"
	elseif sd3->d3_tm$"506/508/504"        // REQ. PI / SAIDA POR AJUSTE - inventario
		if sb1->b1_tipo=="PA"
			_cconta:="4102029916707"
		elseif sb1->b1_tipo$"MP/EE/EN/PI" .and. sd3->d3_cc <> "22000000"
			_cconta:="3501010116104"
		else
			_cconta:="4101029913614"
		endif
	elseif sd3->d3_tm=="507"          // ENC.P/DESTRUICAO
		_cconta:="ENC. P/ DESTRUICAO"
	elseif sd3->d3_tm=="509"          // REQ.P/DESENVOLVIMENTO/CQ
		_cconta:="3501029918608"
	elseif sd3->d3_tm=="510"          // REQ.P/OP/REEMBALAGEM
		_cconta:="3401011313502"
	endif
Endif
restarea(_aarea)
return(_cconta)