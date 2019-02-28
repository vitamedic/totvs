/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT378   ³Autor ³ André Almeida Alves    ³Data ³ 26/06/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Workflow Avisar caso Exista Empenho Diferente da Estrutura ³±±
±±³          ³ do Produto.                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "dialog.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#INCLUDE "protheus.ch"

user function vit379()
//prepare environment empresa "01" filial "01" tables "SG1,SD4,SC2"
cperg:="PERGVIT379"
_pergsx1()
if pergunte(cperg,.t.) .and.;
	msgyesno("Confirma geração do relatório de Divergencia entre SG1 x SD4?")
	processa({|| vit379f()})
	msginfo("Relatório gerado com sucesso.!")
endif

/*/{Protheus.doc} vit379f

	(long_description)
	@type  Static Function
	@author user
	@since date
	@version version
	@param param, param_type, param_descr
	@return return, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
 Static Function vit379f
	
	_dDataAtu	:= mv_par01
	_dDataLim	:= mv_par02
	_cOpDe		:= mv_par03
	_cOpAte		:= mv_par04
	_cEmailDest	:= mv_par05
//	_dDataAtu	:= date()
//	_dDataLim	:= date()-1

	_lEnviMail	:= .F.
	Public		_lRet
	_lRet		:= .F.
												
	_cconta   	:=getmv("MV_WFACC")
	_csenha   	:=getmv("MV_WFPASSW") 
	_cde		:= _cconta
	_cpara		:= "vit379@vitamedic.ind.br"
	_ccc		:= _cEmailDest
	_ccco		:= " "
	_lavisa		:= .t.
	_cassunto	:= " "
	_cmensagem	:= " "
	_carq		:=	"difemp.htm"
	_cdirdocs	:=	msdocpath()   //M:\protheus_data\dirdoc\co01\shared
	_canexos	:= 	_cdirdocs+"\"+_carq
	ferase(_cdirdocs+"\"+_carq)

	IF(SELECT("ARQ") > 0)
		ARQ->(DBCLOSEAREA())
	ENDIF

	cQuery_ 	:= " SELECT * FROM "
	cQuery_		+= retsqlname("SC2")+" SC2"
	cQuery_ 	+= " WHERE sc2.d_e_l_e_t_ = ' '"
	cQuery_ 	+= " AND c2_emissao between '"+dtos(_dDataAtu)+"' and '"+dtos(_dDataLim)+"'"
	cQuery_ 	+= " AND c2_num between '"+_cOpDe+"' and '"+_cOpAte+"'"
	//cQuery_ 	+= " AND c2_emissao between '20180913' and '20180913'"

	cQuery_:=changequery(cQuery_)
	MEMOWRIT("\sql\vit379.sql",cQuery_)
	TCQUERY cQuery_ NEW ALIAS "ARQ"
	ARQ->(dbgotop())

	_cPriOp	:= arq->C2_NUM

	//sc2->(DbSetOrder(1))
	//sc2->(dbseek("01"+_cPriOp))

	While !ARQ->(Eof()) 

		if substr(ARQ->c2_produto,1,1) <> "1"
		
			_cProdP	:= Alltrim(ARQ->c2_produto)

			IF(SELECT("TMP1") > 0)
				TMP1->(DBCLOSEAREA())
			ENDIF
		
			_cQuery 	:= " 	SELECT"
			_cQuery 	+= " G1_COMP,"
			_cQuery 	+= " B1_DESC,"
			_cQuery 	+= " SUM(G1_QUANT) ESTRUTURA,"
			_cQuery 	+= " NVL((SELECT"
			_cQuery 	+= " 	SUM(D4_QTDEORI)"
			_cQuery 	+= " 	FROM SD4010 SD4"
			_cQuery 	+= " 	WHERE SD4.D_E_L_E_T_ = ' '"
			_cQuery 	+= " 	AND D4_COD = G1_COMP"
			_cQuery 	+= " 	AND D4_OP = '"+ARQ->c2_num+ARQ->c2_item+ARQ->c2_sequen+"'),0) EMPENHO"
			_cQuery 	+= " FROM SG1010 SG1"
			_cQuery 	+= " 	INNER JOIN SB1010 SB1 ON G1_COMP = B1_COD"
			_cQuery 	+= " WHERE SG1.D_E_L_E_T_ = ' ' "
			_cQuery 	+= " AND G1_COD = '"+ARQ->c2_produto+"'"
			_cQuery 	+= " GROUP BY G1_COMP, B1_DESC"
			_cQuery 	+= " ORDER BY 2"

			_cQuery:=changequery(_cQuery)
			MEMOWRIT("\sql\vit379a.sql",_cQuery)
			TCQUERY _cQuery NEW ALIAS "TMP1"
			u_setfield("TMP1")
							
			tmp1->(dbgotop())
			
			while !tmp1->(eof())   // Percorre o select feito na tabela TMP
				_cDif		:= tmp1->empenho - tmp1->estrutura
				_cOp		:= ARQ->c2_num+ARQ->c2_item+ARQ->c2_sequen
				//_cOp		:= tmp1->d4_op
				_cProduto 	:= tmp1->g1_comp
				
				IF(SELECT("TMP4") > 0)
					TMP4->(DBCLOSEAREA())
				ENDIF
				_cQuery3 	:= " 	select MAX(d4_potenci) potencia"
				_cQuery3 	+= " from sd4010"
				_cQuery3 	+= " where d_e_l_e_t_ = ' '"
				_cQuery3 	+= " and d4_op = '"+_cOp+"'"
				_cQuery3 	+= " and d4_cod = '"+_cProduto+"'"
				
				_cQuery3:=changequery(_cQuery3)
				MEMOWRIT("\sql\vit379d.sql",_cQuery3)
				TCQUERY _cQuery3 NEW ALIAS "TMP4"
				
				_cUsaPot	:= tmp4->potencia
				
				if _cUsaPot <> 0
					u_verifpot(_cOp, _cProduto, _cProdP)
				endif
		
				if _cDif <> 0 .and. _cUsaPot = 0
						_lEnviMail := .T.
				elseif _lRet .and. _cDif <> 0
					_lEnviMail := .T.
				endif
				_cmensagem 	:= "OP -> "+Alltrim(_cOp)
				_cmensagem 	+= " -  Produto -> "+chr(10)+chr(13)+Alltrim(_cProdP)+chr(10)+chr(13)
				_cDesc 		:= POSICIONE("SB1",1,xFilial("SB1")+_cProdP,"B1_DESC")
				_cDescComp 	:= POSICIONE("SB1",1,xFilial("SB1")+_cProduto,"B1_DESC")
				_cmensagem 	+= " - "+Alltrim(_cDesc)
				_cassunto	:= "EMPENHO DIFERENTE DA ESTRUTURA DO PRODUTO - OP "+Substr(_cOp,1,6)
				tmp1->(dbskip())
			end  // Finaliza o while na tabela TMP
			
			if _lEnviMail
				u_MontArq()
				u_mail379(_cde,_cconta,_csenha,_cpara,_ccc,_ccco,_cassunto,_cmensagem,_canexos,_lavisa)
			endif
			ARQ->(dbskip())
			_lEnviMail := .F.
		else
			ARQ->(dbskip())
		endif
	end
	arq->(dbclosearea())
	//reset environment
return() 

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MONTARQ  ³Autor ³ André Almeida Alves     ³Data ³ 14/08/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Monta Arquivo para Enviar E-Mail                            ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Funcao para Criar o Arquivo                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
user function MontArq()

//*************************************** Cria cabeçalho principal **********************************************************************                                 
_nhandle:=fcreate(_cdirdocs+"\"+_carq,0)
fwrite(_nhandle,'<html>'+chr(13)+chr(10))
fwrite(_nhandle,'<head>'+chr(13)+chr(10))
fwrite(_nhandle,'<meta http-equiv="Content-Language" content="pt-br">'+chr(13)+chr(10))
fwrite(_nhandle,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">'+chr(13)+chr(10))
fwrite(_nhandle,'<title>Relatorios de Lotes a vencer</title>'+chr(13)+chr(10))
fwrite(_nhandle,'</head>'+chr(13)+chr(10))
fwrite(_nhandle,'<body>'+chr(13)+chr(10))

fwrite(_nhandle,'<table border="1" width="100%" id="table1" style="border-collapse: collapse" bordercolor="#FFFFFF">'+chr(13)+chr(10))
fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
//fwrite(_nhandle,'<td width="260"><p style="margin-top: 0; margin-bottom: 0"><img height="54" src="http://www.vitapan.com.br/logovitapan.png" width="217"></td>'+chr(13)+chr(10)) 
fwrite(_nhandle,'<td width="260"><p style="margin-top: 0; margin-bottom: 0"><img height="54" src="http://10.1.1.40/laudo0101.png" width="217"></td>'+chr(13)+chr(10)) //Guilherme 21/08/15//Para que o endereço do logo seja reolvido pelo named.
fwrite(_nhandle,'<td align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#0000FF">OP com Divergencia no Empenho -> Aviso: '+dtoc(date())+' '+time()+'</font></b></p>'+chr(13)+chr(10))
fwrite(_nhandle,'</td>'+chr(13)+chr(10))
fwrite(_nhandle,'</tr>'+chr(13)+chr(10))
fwrite(_nhandle,'</table>'+chr(13)+chr(10))

sb1->(DbSetOrder(1))
sb1->(dbseek("01"+sc2->c2_produto))

fwrite(_nhandle,'<p align="center" style="margin-top: 0; margin-bottom: 0">&nbsp;</p>'+chr(13)+chr(10))
fwrite(_nhandle,'<p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#0000FF">OP do Produto '+Alltrim(sb1->b1_cod)+' - '+Alltrim(sb1->b1_desc)+ '  com divergencia nos empenhos.</font></b></p>'+chr(13)+chr(10))
fwrite(_nhandle,'<table border="1" width="100%" id="table1" style="border-collapse: collapse" bordercolor="#FFFFFF">'+chr(13)+chr(10))
fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">OP</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">PRODUTO</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">DESCRICAO</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">QT_ESTRUTURA</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">QT_EMPENHO</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">DIFERENCA</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'</tr>'+chr(13)+chr(10))	

//*************************************** Alimenta corpo do grid **********************************************************************                                 
tmp1->(dbgotop())
while !tmp1->(eof())   // Percorre o select feito na tabela sd4
  
	fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+Alltrim(_cOp)+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+Alltrim(tmp1->g1_comp)+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+Alltrim(_cDescComp)+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+alltrim(transform(tmp1->estrutura,"@E 999,999,999.99"))+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+alltrim(transform(tmp1->empenho,"@E 999,999,999.99"))+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+alltrim(transform(tmp1->empenho-tmp1->estrutura,"@E 999,999,999.99"))+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'</tr>'+chr(13)+chr(10))
	
	tmp1->(dbskip())
end

fwrite(_nhandle,'</body>'+chr(13)+chr(10))
fwrite(_nhandle,'</html>'+chr(13)+chr(10))
fclose(_nhandle)
            

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MAILVEND  ³Autor ³ André Almeida Alves     ³Data: 28/05/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia E-Mail                                                ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Funcao para Criar o Cabecalho                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
user function mail379(_cde,_cconta,_csenha,_cpara,_ccc,_ccco,_cassunto,_cmensagem,_canexos,_lavisa)
_cserver:=getmv("MV_WFSMTP")

_lconectou:=.f.
_lenviado :=.f.
_ldesconec:=.f.

connect smtp server _cserver account _cconta password _csenha result _lconectou
MailAuth(_cconta, _csenha)

if _lconectou
	send mail from _cde to _cpara subject _cassunto body _cmensagem attachment _canexos result _lenviado
	if !_lenviado 
		_cerro:=""
		get mail error _cerro
		msginfo(_cerro)
	endif
	disconnect smtp server result _ldesconec
else
	msginfo("Problemas na conexao com servidor de E-Mail - "+_cserver)
endif
return() 

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VERIFPOT  ³Autor ³ André Almeida Alves   ³Data ³ 28/05/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia E-Mail                                                ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Funcao para Calcular a Potencia                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
user function VerifPot(_cOp, _cProduto, _cProdP)
_lRet 	:= .F.
_aDados	:= {}
_aVet	:= {}
_l		:= 1

_cQuery1 := " select"
_cQuery1 += " d4_potenci pot_sd4, sum(d4_qtdeori) qtd_sd4"
_cQuery1 += " from sd4010"
_cQuery1 += " where d_e_l_e_t_ = ' '"
_cQuery1 += " and d4_op = '"+_cOp+"'"
_cQuery1 += " and d4_cod = '"+_cProduto+"'"
_cQuery1 += " group by d4_potenci"
                    
_cQuery1:=changequery(_cQuery1)
MEMOWRIT("\sql\vit379b.sql",_cQuery1)
TCQUERY _cQuery1 NEW ALIAS "TMP2"
u_setfield("TMP2")

_cQuery2 := " select"
_cQuery2 += " g1_potenci pot_sg1, sum(g1_quant) qtd_sg1"
_cQuery2 += " from sg1010"
_cQuery2 += " where d_e_l_e_t_ = ' '"
_cQuery2 += " and g1_cod = '"+_cProdP+"'"
_cQuery2 += " and g1_comp = '"+_cProduto+"'"
_cQuery2 += " group by g1_potenci"

_cQuery2:=changequery(_cQuery2)
MEMOWRIT("\sql\vit379c.sql",_cQuery2)
TCQUERY _cQuery2 NEW ALIAS "TMP3"
u_setfield("TMP3")

while !tmp2->(eof())   // Percorre o select feito na tabela TMP2
	if _l = 1
		_cQtd_sg1	:= tmp3->qtd_sg1
		_cPot_sg1	:= tmp3->pot_sg1
		_cPot_sd4	:= tmp2->pot_sd4
		_Qtd_sd4	:= tmp2->qtd_sd4
		_Qtd_CalcPot:= (_cQtd_sg1*_cPot_sg1)/_cPot_sd4
		_Qtd_Rest	:= _Qtd_CalcPot - _Qtd_sd4
		
		_aVet	:= {}
		aadd(_aVet, _cQtd_sg1)        // Quantidade Padrao
		aadd(_aVet, _cPot_sg1)		// Potencia Padrao
		aadd(_aVet, _cPot_sd4)		// Potencia desejada
		aadd(_aVet, _Qtd_sd4)		// Quantidade empenhada
		aadd(_aVet, _Qtd_CalcPot) //retorna a quantidade nescessaria do produto com a potencia desejada
		aadd(_aVet, _Qtd_Rest)	// Quantidade restante na potencia igual a _aVet[_l][6]
		aadd(_aDados, _aVet)
	else
		_cQtd_sg1	:= _aDados[_l-1][6]
		_cPot_sg1	:= _aDados[_l-1][3]
		_cPot_sd4	:= tmp2->pot_sd4
		_Qtd_sd4	:= tmp2->qtd_sd4
		_Qtd_CalcPot:= (_cQtd_sg1*_cPot_sg1)/_cPot_sd4
		_Qtd_Rest	:= _Qtd_CalcPot - _Qtd_sd4
		
		_aVet	:= {}
		aadd(_aVet, _aDados[_l-1][6])        // Quantidade Padrao
		aadd(_aVet, _aDados[_l-1][3])		// Potencia Padrao
		aadd(_aVet, tmp2->pot_sd4)		// Potencia desejada
		aadd(_aVet, tmp2->qtd_sd4)		// Quantidade empenhada
		aadd(_aVet, _Qtd_CalcPot) //retorna a quantidade nescessaria do produto com a potencia desejada
		aadd(_aVet, _Qtd_Rest)	// Quantidade restante na potencia igual a _aVet[_l][6]
		aadd(_aDados, _aVet)	
	endif
	tmp2->(dbskip())
	_l := _l+1
end  // Finaliza o while na tabela TMP2

if _aDados[_l-1][6] > 1 .or. _aDados[_l-1][6] < -1
	_lRet := .T.  //retorna verdadeiro: Existe diferença da quantidade empenhada da quantidade padrão.
endif

TMP2->(DBCLOSEAREA())
TMP3->(DBCLOSEAREA())
return(_lRet)

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Da Ordem de Prod   ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SC2"})
aadd(_agrpsx1,{cperg,"04","Ate Ordem de Prod  ?","mv_ch4","C",15,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SC2"})
aadd(_agrpsx1,{cperg,"05","E-mail             ?","mv_ch5","C",100,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
for _i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[_i,1]+_agrpsx1[_i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[_i,01]
		sx1->x1_ordem  :=_agrpsx1[_i,02]
		sx1->x1_pergunt:=_agrpsx1[_i,03]
		sx1->x1_variavl:=_agrpsx1[_i,04]
		sx1->x1_tipo   :=_agrpsx1[_i,05]
		sx1->x1_tamanho:=_agrpsx1[_i,06]
		sx1->x1_decimal:=_agrpsx1[_i,07]
		sx1->x1_presel :=_agrpsx1[_i,08]
		sx1->x1_gsc    :=_agrpsx1[_i,09]
		sx1->x1_valid  :=_agrpsx1[_i,10]
		sx1->x1_var01  :=_agrpsx1[_i,11]
		sx1->x1_def01  :=_agrpsx1[_i,12]
		sx1->x1_cnt01  :=_agrpsx1[_i,13]
		sx1->x1_var02  :=_agrpsx1[_i,14]
		sx1->x1_def02  :=_agrpsx1[_i,15]
		sx1->x1_cnt02  :=_agrpsx1[_i,16]
		sx1->x1_var03  :=_agrpsx1[_i,17]
		sx1->x1_def03  :=_agrpsx1[_i,18]
		sx1->x1_cnt03  :=_agrpsx1[_i,19]
		sx1->x1_var04  :=_agrpsx1[_i,20]
		sx1->x1_def04  :=_agrpsx1[_i,21]
		sx1->x1_cnt04  :=_agrpsx1[_i,22]
		sx1->x1_var05  :=_agrpsx1[_i,23]
		sx1->x1_def05  :=_agrpsx1[_i,24]
		sx1->x1_cnt05  :=_agrpsx1[_i,25]
		sx1->x1_f3     :=_agrpsx1[_i,26]
		sx1->(msunlock())
	endif
next
return
