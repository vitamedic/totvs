/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ A010TOK  ³ Autor ³ Heraildo C. de Freitas³ Data ³ 29/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada na Alteracao de Produtos para Envio DE    ³±±
±±³          ³ E-Mail para a Contabilidade para Verificacao dos Dados     ³±±
±±³          ³ Fiscais e Contabeis                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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
			ALERT("Produto com Saldo !!! Procure o responsável")
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
					
					//Informações na Aba Impostos ou campo B1_CONTA aciona mensagem para contabilidade
					if (alltrim(_cpasta)=="Impostos") .or. (alltrim(_ccampo)=="B1_CONTA")
						_contab:=.t.
					endif
					//Alterações em Cadastro produtos tipo "PA"/"PL"/"MP"/"EE"/"EN"
					if ((alltrim(_ccampo)=="B1_TIPO") .or. (alltrim(_ccampo)=="B1_DESC")) .and.;
						(m->b1_tipo $ "PA*PL*MP*EE*EN*PN")                                              //Guilherme Teodoro - 08/07/2016 - Inclusão do Tipo Nutracêutico
						_tecnica:=.t.
					elseif (m->b1_tipo $ "LA")
						_cq:=.t.
					elseif (m->b1_tipo $ "MA")
						_manut:=.t.
					endif
					
					if ((alltrim(_ccampo)=="B1_TIPO") .or. (alltrim(_ccampo)=="B1_DESC")) .and.;
						(m->b1_tipo $ "PA*PL*PN")                                                       //Guilherme Teodoro - 08/07/2016 - Inclusão do Tipo Nutracêutico
						_diretoria:=.t.
					endif
					aadd(_aalt,{sx3->x3_titulo,_cpasta,sb1->(fieldget(_ni)),&_cvar})
				endif
			next
			
			if len(_aalt)>0
				_cpara:="report_custos@vitamedic.ind.br;report_ti@vitamedic.ind.br"  // Tratar Recebimentos aqui  //Guilherme Teodoro - 08/07/2016 - Atualização dos emails
				
				//e-mails para Contabilidade
				if _contab
					_cpara+=";report_contabilidade@vitamedic.ind.br"
				endif
				
				//e-mails para Área técnica
				if _tecnica
					//Gerência do Controle de Qualidade
					_cpara+=";report_cql@vitamedic.ind.br"
					
					//Gerência de Desenvolvimento e Encarregado Desenvolvimento de Embalagens
					_cpara+=";report_desenvolvimento@vitamedic.ind.br;report_marketing@vitamedic.ind.br"
					
					//Gerência de Garantia da Qualidade e Controle de Documentações (CEDOC)
					_cpara+=";report_garantia@vitamedic.ind.br"
				endif
				
				if _cq
					//Gerência do Controle de Qualidade
					_cpara+=";report_cql@vitamedic.ind.br"
				endif
				
				if _manut
					//Gerência de Manutenção
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ EstLote  ³Autor ³ Ricardo Fiuza's    ³Data ³ 11/11/15  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao para retornar o saldo - empenho			          ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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

