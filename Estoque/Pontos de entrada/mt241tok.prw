/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MT241TOK  矨utor  矵eraildo C. Freitas � Data �  04/12/03  潮�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北矰escricao � Valida a inclusao do movimento interno (mod. 2) verificando潮�
北�          � se a ordem de producao e o centro de custo foram informados潮�
北�          � No caso de devolucao valida se o produto devolvido foi     潮�
北�          � requisitado ou empenhado para a OP e se a quantidade       潮�
北�          � devolvida e maior que o requisitado ou empenhado           潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"
#include "topconn.ch"

user function mt241tok()
_lok:=.t.

if da241data<>ddatabase
	_lok:=.f.
	msginfo("A data do movimento n鉶 pode ser diferente da data base do sistema!")
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
					msginfo("Para este tipo de movimento a ordem de produ玢o deve ser informada!")
				endif
			else
				if ! empty(_cop)
					_lok:=.f.
					msginfo("Para este tipo de movimento a ordem de produ玢o n鉶 deve ser informada!")
				endif
				if empty(ccc)
					_lok:=.f.
					msginfo("Para este tipo de movimento o centro de custo deve ser informado!")
				endif
			endif
			
			// VALIDA敲O DA DEVOLU敲O SE O PRODUTO FOI REQUISITADO OU EMPENHADO
			
			if _lok .and.;
				! empty(_cop) .and.;
				ctm<"500" // DEVOLU敲O
				
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
