/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MT241TOK  �Autor  �Heraildo C. Freitas � Data �  04/12/03  ���
�������������������������������������������������������������������������͹��
���Descricao � Valida a inclusao do movimento interno (mod. 2) verificando���
���          � se a ordem de producao e o centro de custo foram informados���
���          � No caso de devolucao valida se o produto devolvido foi     ���
���          � requisitado ou empenhado para a OP e se a quantidade       ���
���          � devolvida e maior que o requisitado ou empenhado           ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
#include "topconn.ch"

user function mt241tok()
_lok:=.t.

if da241data<>ddatabase
	_lok:=.f.
	msginfo("A data do movimento n�o pode ser diferente da data base do sistema!")
else
	_cfilsd3:=xfilial("SD3")
	_cfilsd4:=xfilial("SD4")
	_cfilsd5:=xfilial("SD5")
	
	_npop     :=ascan(aheader,{|x| upper(alltrim(x[2]))=="D3_OP"})
	_npcod    :=ascan(aheader,{|x| upper(alltrim(x[2]))=="D3_COD"})
	_npquant  :=ascan(aheader,{|x| upper(alltrim(x[2]))=="D3_QUANT"})
	_nplocal  :=ascan(aheader,{|x| upper(alltrim(x[2]))=="D3_LOCAL"})
	_nplotectl:=ascan(aheader,{|x| upper(alltrim(x[2]))=="D3_LOTECTL"})
	_npdelet  :=len(aheader)+1
	_ni       :=1
	while _lok .and.;
		_ni<=len(acols)
		
		if ! acols[_ni,_npdelet]
			_cop     :=acols[_ni,_npop]
			_ccod    :=acols[_ni,_npcod]
			_nquant  :=acols[_ni,_npquant]
			_clocal  :=acols[_ni,_nplocal]
			_clotectl:=acols[_ni,_nplotectl]
			if ctm$"101/503"
				if empty(_cop)
					_lok:=.f.
					msginfo("Para este tipo de movimento a ordem de produ��o deve ser informada!")
				endif
			else
				if ! empty(_cop)
					_lok:=.f.
					msginfo("Para este tipo de movimento a ordem de produ��o n�o deve ser informada!")
				endif
				if empty(ccc)
					_lok:=.f.
					msginfo("Para este tipo de movimento o centro de custo deve ser informado!")
				endif
			endif
			
			// VALIDA��O DA DEVOLU��O SE O PRODUTO FOI REQUISITADO OU EMPENHADO
			
			if _lok .and.;
				! empty(_cop) .and.;
				ctm<"500" // DEVOLU��O
				
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
				_cquery+=" AND D4_OP='"+_cop+"'"
				_cquery+=" AND D4_COD='"+_ccod+"'"
				_cquery+=" AND D4_LOCAL='"+_clocal+"'"
				_cquery+=" AND (D4_LOTECTL='"+_clotectl+"' OR D4_LOTECTL='        ')"
				
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
				
				if _nquant>_nquantop
					_lok:=.f.
					msginfo("Quantidade devolvida maior que a quantidade requisitada/empenhada!")
				endif
			endif
		endif
		
		_ni++
	end
endif
return(_lok)
