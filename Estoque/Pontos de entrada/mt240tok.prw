/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MT240TOK  �Autor  �Heraildo C. Freitas � Data �  04/12/03  ���
�������������������������������������������������������������������������͹��
���Descricao � Valida a inclusao do movimento interno verificando se a    ���
���          � ordem de producao e o centro de custo foram informados     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
#include "topconn.ch"

user function mt240tok()
_lok:=.t.

_cfilsd3:=xfilial("SD3")
_cfilsd4:=xfilial("SD4")

if m->d3_emissao<>ddatabase
	_lok:=.f.
	msginfo("A data do movimento n�o pode ser diferente da data base do sistema!")
elseif m->d3_tm$"101/503"
	if empty(m->d3_op)
		_lok:=.f.
		msginfo("Para este tipo de movimento a ordem de produ��o deve ser informada!")
	endif
else
	if ! empty(m->d3_op)
		_lok:=.f.
		msginfo("Para este tipo de movimento a ordem de produ��o n�o deve ser informada!")
	endif
	if empty(m->d3_cc)
		_lok:=.f.
		msginfo("Para este tipo de movimento o centro de custo deve ser informado!")
	endif
endif

// VALIDA��O DA DEVOLU��O SE O PRODUTO FOI REQUISITADO OU EMPENHADO
if _lok .and.;
	! empty(m->d3_op) .and.;
	m->d3_tm<"500"  // DEVOLU��O
	
	_cquery:=" SELECT"
	_cquery+=" SUM(D5_QUANT) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SD5")+" SD5"
	_cquery+=" WHERE"
	_cquery+="     SD5.D_E_L_E_T_<>'*'"
	_cquery+=" AND D5_FILIAL='"+_cfilsd5+"'"
	_cquery+=" AND D5_OP='"+_cop+"'"
	_cquery+=" AND D5_PRODUTO='"+_ccod+"'"
	_cquery+=" AND D5_LOCAL='"+_clocal+"'"
	_cquery+=" AND D5_LOTECTL='"+_clotectl+"'"
	_cquery+=" AND D5_ORIGLAN>='500'"
	_cquery+=" AND D5_ESTORNO<>'S'"
	
	
	_cquery+=" UNION ALL"
	
	_cquery+=" SELECT"
	_cquery+=" SUM(D4_QUANT) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SD4")+" SD4"
	_cquery+=" WHERE"
	_cquery+="     SD4.D_E_L_E_T_<>'*'"
	_cquery+=" AND D4_FILIAL='"+_cfilsd4+"'"
	_cquery+=" AND D4_OP='"+m->d3_op+"'"
	_cquery+=" AND D4_COD='"+m->d3_cod+"'"
	_cquery+=" AND D4_LOCAL='"+m->d3_local+"'"
	_cquery+=" AND D4_LOTECTL='"+m->d3_lotectl+"'"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP1"
	tcsetfield("TMP1","QUANT","N",11,2)
	
	_nquantop:=0
	tmp1->(dbgotop())
	while ! tmp1->(eof())
		
		_nquantop+=tmp1->quant
		
		tmp1->(dbskip())
	end
	tmp1->(dbclosearea())
	
	if m->d3_quant>_nquantop
		_lok:=.f.
		msgstop(m->d3_quant)
		msgstop(_nquantop)
		msginfo("Quantidade devolvida maior que a quantidade requisitada/empenhada! - "+m->d3_cod)
	endif
endif
return(_lok)
