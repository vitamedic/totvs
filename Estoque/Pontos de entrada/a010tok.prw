/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � A010TOK  � Autor � Heraildo C. de Freitas� Data � 29/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de Entrada na Alteracao de Produtos para Envio DE    ���
���          � E-Mail para a Contabilidade para Verificacao dos Dados     ���
���          � Fiscais e Contabeis                                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

user function a010tok()
local ohtml
Local lExecuta := .T. 
Local _Saldo := 0
_contab:=.f.
_tecnica:=.f.
_cq:=.f.
_manut:=.f.
_diretoria:=.f.

if altera
	if sm0->m0_codigo=="01"
		_Saldo:= U_Saldo(M->B1_COD)
		If m->b1_msblql == "1" .and. _Saldo > 0
			lExecuta := .F.
			ALERT("Produto com Saldo !!! Procure o respons�vel")
		ELSE
			_aalt:={}
			for _ni:=1 to sb1->(fcount())
				_ccampo:=sb1->(fieldname(_ni))
				_cvar:="M->"+_ccampo
				if valtype(&_cvar)<>"U" .and.;
					&_cvar<>sb1->(fieldget(_ni))
					
					sx3->(dbsetorder(2))
					sx3->(dbseek(_ccampo))
					sxa->(dbsetorder(1))
					if sxa->(dbseek(sx3->x3_arquivo+sx3->x3_folder))
						_cpasta:=sxa->xa_descric
					else
						_cpasta:="Outros"
					endif
					
					//Informa��es na Aba Impostos ou campo B1_CONTA aciona mensagem para contabilidade
					if (alltrim(_cpasta)=="Impostos") .or. (alltrim(_ccampo)=="B1_CONTA")
						_contab:=.t.
					endif
					//Altera��es em Cadastro produtos tipo "PA"/"PL"/"MP"/"EE"/"EN"
					if ((alltrim(_ccampo)=="B1_TIPO") .or. (alltrim(_ccampo)=="B1_DESC")) .and.;
						(m->b1_tipo $ "PA*PL*MP*EE*EN*PN")                                              //Guilherme Teodoro - 08/07/2016 - Inclus�o do Tipo Nutrac�utico
						_tecnica:=.t.
					elseif (m->b1_tipo $ "LA")
						_cq:=.t.
					elseif (m->b1_tipo $ "MA")
						_manut:=.t.
					endif
					
					if ((alltrim(_ccampo)=="B1_TIPO") .or. (alltrim(_ccampo)=="B1_DESC")) .and.;
						(m->b1_tipo $ "PA*PL*PN")                                                       //Guilherme Teodoro - 08/07/2016 - Inclus�o do Tipo Nutrac�utico
						_diretoria:=.t.
					endif
					aadd(_aalt,{sx3->x3_titulo,_cpasta,sb1->(fieldget(_ni)),&_cvar})
				endif
			next
			
			if len(_aalt)>0
				_cpara:="report_custos@vitamedic.ind.br;report_ti@vitamedic.ind.br"  // Tratar Recebimentos aqui  //Guilherme Teodoro - 08/07/2016 - Atualiza��o dos emails
				
				//e-mails para Contabilidade
				if _contab
					_cpara+=";report_contabilidade@vitamedic.ind.br"
				endif
				
				//e-mails para �rea t�cnica
				if _tecnica
					//Ger�ncia do Controle de Qualidade
					_cpara+=";report_cql@vitamedic.ind.br"
					
					//Ger�ncia de Desenvolvimento e Encarregado Desenvolvimento de Embalagens
					_cpara+=";report_desenvolvimento@vitamedic.ind.br;report_marketing@vitamedic.ind.br"
					
					//Ger�ncia de Garantia da Qualidade e Controle de Documenta��es (CEDOC)
					_cpara+=";report_garantia@vitamedic.ind.br"
				endif
				
				if _cq
					//Ger�ncia do Controle de Qualidade
					_cpara+=";report_cql@vitamedic.ind.br"
				endif
				
				if _manut
					//Ger�ncia de Manuten��o
					_cpara+=";report_manutencao@vitamedic.ind.br"
				endif
				
				if _diretoria
					//Diretoria Executiva
					_cpara+=";report_diretoria@vitamedic.ind.br"
				endif
				
				
				oProcess:=TWFProcess():New("000004","Alteracao do cadastro de produto")
				oProcess:NewTask("000001","\workflow\alteracao do cadastro de produto.htm" )
				oProcess:cSubject:="Vitamedic - alteracao do cad.do produto: "+alltrim(sb1->b1_cod)
				oProcess:bReturn:=""
				oProcess:cTo:=_cpara
				oHTML:=oProcess:oHTML
				
				oHTML:ValByName("CODIGO"   ,sb1->b1_cod)
				oHTML:ValByName("DESCRICAO",sb1->b1_desc)
				oHTML:ValByName("USUARIO"  ,cusername)
				oHTML:ValByName("DATA"     ,dtoc(date()))
				oHTML:ValByName("HORA"     ,time())
				
				for _ni:=1 to len(_aalt)
					aadd((oHTML:ValByName("TB.CAMPO"   )),_aalt[_ni,1])
					aadd((oHTML:ValByName("TB.PASTA"   )),_aalt[_ni,2])
					aadd((oHTML:ValByName("TB.ANTERIOR")),_aalt[_ni,3])
					aadd((oHTML:ValByName("TB.ATUAL"   )),_aalt[_ni,4])
				next
				
				oProcess:Start()
				wfsendmail()
			endif
		endif		
	endif
endif
return(lExecuta)




/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � EstLote  �Autor � Ricardo Fiuza's    �Data � 11/11/15  ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Funcao para retornar o saldo - empenho			          ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

User Function Saldo(_lProduto)

local _lProduto
//	local _lLocal
local _lSaldo

cQuery 	:= " SELECT SUM(B2_QATU) SALDO "
cQuery	+= " FROM " + retsqlname("SB2")+" SB2 "
cQuery 	+= " WHERE SB2.D_E_L_E_T_ <> '*' "
cQuery 	+= " AND B2_COD = '"+_lProduto+"'"

cQuery :=changequery(cQuery)

tcquery cQuery new alias "TMP3"
_lSaldo := tmp3->saldo
TMP3->(DBCLOSEAREA())

return(_lSaldo)

