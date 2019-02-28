/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT254 ³ Autor ³ Alex Júnio de Miranda   ³ Data ³ 20/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Geracao do Arquivo para Envio à Anvisa - Referente à       ³±±
±±³          ³ Producao e Comercializacao dos Produtos Genericos          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracao ³ 11/07/08 - Adequação de querys para considerar todos os    ³±±
±±³          ³ produtos genéricos.                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"       
#include "topconn.ch"

User Function VIT254()     


SetPrvt("_CARQ,_LCONTINUA,_HDL,")

Private _cperg := "PERGVIT254"

_pergsx1()

pergunte(_cPerg,.t.)

_passou:=.t.

if (mv_par01<='00') .or. (mv_par01>'12')
	_passou:=.f. 
endif

if ! _passou
	msginfo("Mês de Referência informado inválido!")
	return
endif

if msgbox("Confirma geracao do(s) arquivo(s) para transmissao?","Atencao","YESNO")
	processa({|| _geraarq()})
	msginfo("Arquivo(s) gerado(s) com sucesso!")
	sysrefresh()
endif
return



Static function _geraarq()
_cfilsb1:=xfilial("SB1")
_cfilsa1:=xfilial("SA1")
_cfilsd2:=xfilial("SD2")
_cfilsd1:=xfilial("SD1")
_cfilsd3:=xfilial("SD3")
_cfilsb5:=xfilial("SB5")
_cfilcc2:=xfilial("CC2")
sb1->(dbsetorder(1))
sa1->(dbsetorder(1))
sd2->(dbsetorder(3))
sd1->(dbsetorder(2))
sd3->(dbsetorder(1))
sb5->(dbsetorder(1))
cc2->(dbsetorder(1))

lcontinua:= .t.

if (mv_par01=='01') .or. (mv_par01=='03') .or. (mv_par01=='05') .or. (mv_par01=='07') .or.;
	(mv_par01=='08') .or. (mv_par01=='10') .or. (mv_par01=='12')	
		_dia:='31'
elseif (mv_par01=='02') 
   if (mv_par02=='2004') .or. (mv_par02=='2008')
		_dia:='29'
	else
		_dia:='28'
	endif
else
	_dia:='30'	
endif        

_dtini:=ctod('01/'+mv_par01+'/'+mv_par02)
_dtfim:=ctod(_dia+'/'+mv_par01+'/'+mv_par02)

_carq:="C:\WINDOWS\TEMP\ANS"+mv_par01+mv_par02+".txt"
if file(_carq)
	_lcontinua:=msgbox("O arquivo "+_carq+" ja existe! Sobrepor?","Atencao","YESNO")
	if _lcontinua
		ferase(_carq)
	endif
endif                                    

_hdl:=fcreate(_carq,0)
_header()

processa({|| _querys()})
processa({|| _query2()})
processa({|| _query3()})

procregua(tmp1->(lastrec()))


//*************************************************************************************//
//                                                                                     //
//                  REGISTRO 2 - APRESENTAÇÕES COM/SEM VENDAS E COM/SEM                //
//                       PRODUÇÕES INFORMADAS NO PERIODO                               //
//                                                                                     //
//*************************************************************************************//

tmp3->(dbgotop())

while ! tmp3->(eof())

	tmp1->(dbgotop())
	
	_achou:=.f. 
	while ! tmp1->(eof()) .and.;
			! _achou
		if (tmp3->cod==tmp1->cod)
			_achou:=.t.
		endif
		tmp1->(dbskip())
	end

	//INFORMAÇÕES DO TOTAL DAS VENDAS (QUANTIDADE E VALOR) POR PRODUTO/APRESENTAÇÃO

	//INFORMAÇÕES DO TOTAL DAS VENDAS (QUANTIDADE E VALOR) POR PRODUTO/APRESENTAÇÃO
	_qtdeven:=0
	_vrven:=0
	_lcontinua:=.t.

	tmp2->(dbgotop())
	while ! tmp2->(eof()) .and.;
		lcontinua
		if (tmp3->cod==tmp2->cod) .and.;
			(tmp2->tipomov=='V')
			_qtdeven+=tmp2->quant
			_vrven+=tmp2->total
		endif
		tmp2->(dbskip())
	end

	if (! _achou) .and. (_qtdeven<>0)

		fwrite(_hdl,"'2'")                       				// TIPO DE REGISTRO: 2- Movimentos de produção / apresentação
		fwrite(_hdl,";'"+rtrim(tmp3->codbar)+"'")   			// CÓDIGO DE BARRAS DO PRODUTO/APRESENTAÇÃO
		fwrite(_hdl,";'"+tmp3->anvisa+"'")         				// CÓDIGO DE REGISTRO ANVISA DO PRODUTO/APRESENTAÇÃO
		fwrite(_hdl,";'"+rtrim(tmp3->descri)+"'")     			// DESCRIÇÃO GENÉRICA DO PRODUTO
		fwrite(_hdl,";'"+tmp3->um+"'")             				// EMBALAGEM DO PRODUTO
		fwrite(_hdl,";'"+ltrim(str(tmp3->conv,4,0))+"'")      	// QUANTIDADE POR EMBALAGEM
		fwrite(_hdl,";'"+rtrim(tmp3->forma)+"'")    			// FORMA FARMACÊUTICA
		fwrite(_hdl,";'"+rtrim(tmp3->adm)+"'")      			// VIA DE ADMINISTRAÇÃO
		fwrite(_hdl,";'"+rtrim(tmp3->classe)+"'")   			// CLASSE TERAPÊUTICA
		fwrite(_hdl,";'"+tmp3->uso+"'")         	 			// USO CONTÍNUO (S)im OU (N)ão
		fwrite(_hdl,";'"+_substpt(ltrim(str(tmp3->prfab,12,2)))+"'")    // PREÇO DE FÁBRICA
		fwrite(_hdl,";'"+_substpt(ltrim(str(tmp3->partm,4,2)))+"'")     // PARTICIPAÇÃO NO MERCADO (INFORMADO 0,00)
		fwrite(_hdl,";'"+tmp3->origem+"'")         				// ORIGEM DO PRODUTO (I)mportado, Fabricação (P)rópria, (T)erceirizada
                                                         
		// CAPACIDADE MÁXIMA DE PRODUÇÃO MENSAL PARA CADA PRODUTO
		fwrite(_hdl,";'"+alltrim(tmp3->capmxme)+"'")  
		fwrite(_hdl,";'0'")        // QTDE PRODUZIDA NO MÊS DE REFERÊNCIA
		fwrite(_hdl,";'0'")        // TOTAL DE LOTES PRODUZIDOS NO MÊS DE REFERÊNCIA	
		fwrite(_hdl,";'"+ltrim(str(_qtdeven,12,0))+"'")       	// QUANTIDADE VENDIDA NO MERCADO INTERNO
		fwrite(_hdl,";'"+_substpt(ltrim(str(_vrven,12,2)))+"'") // VALOR DAS VENDAS NO MERCADO INTERNO - FATURAMENTO
		fwrite(_hdl,";'0'")                        				// QUANTIDADE VENDIDA NO MERCADO EXTERNO
		fwrite(_hdl,";'0,00'")                     				// VALOR DAS VENDAS NO MERCADO EXTERNO
		fwrite(_hdl,";'"+alltrim(tmp3->numatv)+"'")             // NÚMERO DE PRINCÍPIOS ATIVOS

		if alltrim(tmp3->numatv)=='1'
			fwrite(_hdl,";'"+alltrim(tmp3->dcb1)+"'")                // DCB DO PRINCÍPIO ATIVO
			fwrite(_hdl,";'"+alltrim(tmp3->dosag1)+"'")         // CONCENTRACAO DA DOSAGEM DO PRINCÍPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->undsg1)+"'")         // UNID.MEDIDA CONCENTRAÇÃO DA DOSAGEM DO PRINC. ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->qdtat1)+"'")         // QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->undsg1)+"'")  		// INID.MEDIDA QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 01
		elseif alltrim(tmp3->numatv)=='2'
			fwrite(_hdl,";'"+alltrim(tmp3->dcb1)+"'")                // DCB DO PRINCÍPIO ATIVO
			fwrite(_hdl,";'"+alltrim(tmp3->dosag1)+"'")         // CONCENTRACAO DA DOSAGEM DO PRINCÍPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->undsg1)+"'")         // UNID.MEDIDA CONCENTRAÇÃO DA DOSAGEM DO PRINC. ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->qdtat1)+"'")         // QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->undsg1)+"'")  		// INID.MEDIDA QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->dcb2)+"'")                // DCB DO PRINCÍPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->dosag2)+"'")         // CONCENTRACAO DA DOSAGEM DO PRINCÍPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->undsg2)+"'")         // UNID.MEDIDA CONCENTRAÇÃO DA DOSAGEM DO PRINC. ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->qdtat2)+"'")         // QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->undsg2)+"'")  		// INID.MEDIDA QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 02
		else
			fwrite(_hdl,";'"+alltrim(tmp3->dcb1)+"'")                // DCB DO PRINCÍPIO ATIVO
			fwrite(_hdl,";'"+alltrim(tmp3->dosag1)+"'")         // CONCENTRACAO DA DOSAGEM DO PRINCÍPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->undsg1)+"'")         // UNID.MEDIDA CONCENTRAÇÃO DA DOSAGEM DO PRINC. ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->qdtat1)+"'")         // QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->undsg1)+"'")  		// INID.MEDIDA QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->dcb2)+"'")                // DCB DO PRINCÍPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->dosag2)+"'")         // CONCENTRACAO DA DOSAGEM DO PRINCÍPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->undsg2)+"'")         // UNID.MEDIDA CONCENTRAÇÃO DA DOSAGEM DO PRINC. ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->qdtat2)+"'")         // QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->undsg2)+"'")  		// INID.MEDIDA QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->dcb3)+"'")                // DCB DO PRINCÍPIO ATIVO 03
			fwrite(_hdl,";'"+alltrim(tmp3->dosag3)+"'")         // CONCENTRACAO DA DOSAGEM DO PRINCÍPIO ATIVO 03
			fwrite(_hdl,";'"+alltrim(tmp3->undsg3)+"'")         // UNID.MEDIDA CONCENTRAÇÃO DA DOSAGEM DO PRINC. ATIVO 03
			fwrite(_hdl,";'"+alltrim(tmp3->qdtat3)+"'")         // QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 03
			fwrite(_hdl,";'"+alltrim(tmp3->undsg3)+"'")  		// INID.MEDIDA QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 03
		endif

		fwrite(_hdl,chr(13)+chr(10))               				// MUDANCA DE LINHA
		incproc()

	elseif (! _achou) .and. (_qtdeven==0)

		fwrite(_hdl,"'2'")                       				// TIPO DE REGISTRO: 2- Movimentos de produção / apresentação
		fwrite(_hdl,";'"+rtrim(tmp3->codbar)+"'")   			// CÓDIGO DE BARRAS DO PRODUTO/APRESENTAÇÃO
		fwrite(_hdl,";'"+tmp3->anvisa+"'")         				// CÓDIGO DE REGISTRO ANVISA DO PRODUTO/APRESENTAÇÃO
		fwrite(_hdl,";'"+rtrim(tmp3->descri)+"'")     			// DESCRIÇÃO GENÉRICA DO PRODUTO
		fwrite(_hdl,";'"+tmp3->um+"'")             				// EMBALAGEM DO PRODUTO
		fwrite(_hdl,";'"+ltrim(str(tmp3->conv,4,0))+"'")      	// QUANTIDADE POR EMBALAGEM
		fwrite(_hdl,";'"+rtrim(tmp3->forma)+"'")    			// FORMA FARMACÊUTICA
		fwrite(_hdl,";'"+rtrim(tmp3->adm)+"'")      			// VIA DE ADMINISTRAÇÃO
		fwrite(_hdl,";'"+rtrim(tmp3->classe)+"'")   			// CLASSE TERAPÊUTICA
		fwrite(_hdl,";'"+tmp3->uso+"'")         	 			// USO CONTÍNUO (S)im OU (N)ão
		fwrite(_hdl,";'"+_substpt(ltrim(str(tmp3->prfab,12,2)))+"'")    // PREÇO DE FÁBRICA
		fwrite(_hdl,";'"+_substpt(ltrim(str(tmp3->partm,4,2)))+"'")     // PARTICIPAÇÃO NO MERCADO (INFORMADO 0,00)
		fwrite(_hdl,";'"+tmp3->origem+"'")         				// ORIGEM DO PRODUTO (I)mportado, Fabricação (P)rópria, (T)erceirizada
                                                         
		// CAPACIDADE MÁXIMA DE PRODUÇÃO MENSAL PARA CADA PRODUTO
		fwrite(_hdl,";'"+alltrim(tmp3->capmxme)+"'")  
		fwrite(_hdl,";'0'")        // QTDE PRODUZIDA NO MÊS DE REFERÊNCIA
		fwrite(_hdl,";'0'")        // TOTAL DE LOTES PRODUZIDOS NO MÊS DE REFERÊNCIA	
		fwrite(_hdl,";'0,00'")     // QUANTIDADE VENDIDA NO MERCADO INTERNO
		fwrite(_hdl,";'0,00'")	   // VALOR DAS VENDAS NO MERCADO INTERNO - FATURAMENTO
		fwrite(_hdl,";'0'")                        				// QUANTIDADE VENDIDA NO MERCADO EXTERNO
		fwrite(_hdl,";'0,00'")                     				// VALOR DAS VENDAS NO MERCADO EXTERNO
		fwrite(_hdl,";'"+alltrim(tmp3->numatv)+"'")             // NÚMERO DE PRINCÍPIOS ATIVOS

		if alltrim(tmp3->numatv)=='1'
			fwrite(_hdl,";'"+alltrim(tmp3->dcb1)+"'")                // DCB DO PRINCÍPIO ATIVO
			fwrite(_hdl,";'"+alltrim(tmp3->dosag1)+"'")         // CONCENTRACAO DA DOSAGEM DO PRINCÍPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->undsg1)+"'")         // UNID.MEDIDA CONCENTRAÇÃO DA DOSAGEM DO PRINC. ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->qdtat1)+"'")         // QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->undsg1)+"'")  		// INID.MEDIDA QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 01
		elseif alltrim(tmp3->numatv)=='2'
			fwrite(_hdl,";'"+alltrim(tmp3->dcb1)+"'")                // DCB DO PRINCÍPIO ATIVO
			fwrite(_hdl,";'"+alltrim(tmp3->dosag1)+"'")         // CONCENTRACAO DA DOSAGEM DO PRINCÍPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->undsg1)+"'")         // UNID.MEDIDA CONCENTRAÇÃO DA DOSAGEM DO PRINC. ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->qdtat1)+"'")         // QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->undsg1)+"'")  		// INID.MEDIDA QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->dcb2)+"'")                // DCB DO PRINCÍPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->dosag2)+"'")         // CONCENTRACAO DA DOSAGEM DO PRINCÍPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->undsg2)+"'")         // UNID.MEDIDA CONCENTRAÇÃO DA DOSAGEM DO PRINC. ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->qdtat2)+"'")         // QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->undsg2)+"'")  		// INID.MEDIDA QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 02
		else
			fwrite(_hdl,";'"+alltrim(tmp3->dcb1)+"'")                // DCB DO PRINCÍPIO ATIVO
			fwrite(_hdl,";'"+alltrim(tmp3->dosag1)+"'")         // CONCENTRACAO DA DOSAGEM DO PRINCÍPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->undsg1)+"'")         // UNID.MEDIDA CONCENTRAÇÃO DA DOSAGEM DO PRINC. ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->qdtat1)+"'")         // QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->undsg1)+"'")  		// INID.MEDIDA QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->dcb2)+"'")                // DCB DO PRINCÍPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->dosag2)+"'")         // CONCENTRACAO DA DOSAGEM DO PRINCÍPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->undsg2)+"'")         // UNID.MEDIDA CONCENTRAÇÃO DA DOSAGEM DO PRINC. ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->qdtat2)+"'")         // QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->undsg2)+"'")  		// INID.MEDIDA QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->dcb3)+"'")                // DCB DO PRINCÍPIO ATIVO 03
			fwrite(_hdl,";'"+alltrim(tmp3->dosag3)+"'")         // CONCENTRACAO DA DOSAGEM DO PRINCÍPIO ATIVO 03
			fwrite(_hdl,";'"+alltrim(tmp3->undsg3)+"'")         // UNID.MEDIDA CONCENTRAÇÃO DA DOSAGEM DO PRINC. ATIVO 03
			fwrite(_hdl,";'"+alltrim(tmp3->qdtat3)+"'")         // QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 03
			fwrite(_hdl,";'"+alltrim(tmp3->undsg3)+"'")  		// INID.MEDIDA QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 03
		endif

		fwrite(_hdl,chr(13)+chr(10))               				// MUDANCA DE LINHA
		incproc()

	elseif _achou 

		tmp1->(dbgotop())

		while ! tmp1->(eof()) .and.;
			(tmp3->cod<>tmp1->cod)
			tmp1->(dbskip())
		end

		fwrite(_hdl,"'2'")                         					// TIPO DE REGISTRO: 2- Movimentos de produção / apresentação
		fwrite(_hdl,";'"+rtrim(tmp1->codbar)+"'")   				// CÓDIGO DE BARRAS DO PRODUTO/APRESENTAÇÃO
		fwrite(_hdl,";'"+tmp1->anvisa+"'")         					// CÓDIGO DE REGISTRO ANVISA DO PRODUTO/APRESENTAÇÃO
		fwrite(_hdl,";'"+rtrim(tmp1->descri)+"'")     				// DESCRIÇÃO GENÉRICA DO PRODUTO
		fwrite(_hdl,";'"+tmp1->um+"'")             					// EMBALAGEM DO PRODUTO
		fwrite(_hdl,";'"+ltrim(str(tmp1->conv,4,0))+"'")      		// QUANTIDADE POR EMBALAGEM
		fwrite(_hdl,";'"+rtrim(tmp1->forma)+"'")    				// FORMA FARMACÊUTICA
		fwrite(_hdl,";'"+rtrim(tmp1->adm)+"'")      				// VIA DE ADMINISTRAÇÃO
		fwrite(_hdl,";'"+rtrim(tmp1->classe)+"'")   				// CLASSE TERAPÊUTICA
		fwrite(_hdl,";'"+tmp1->uso+"'")         	 				// USO CONTÍNUO (S)im OU (N)ão
		fwrite(_hdl,";'"+_substpt(ltrim(str(tmp1->prfab,12,2)))+"'")    // PREÇO DE FÁBRICA
		fwrite(_hdl,";'"+_substpt(ltrim(str(tmp1->partm,4,2)))+"'")     // PARTICIPAÇÃO NO MERCADO (INFORMADO 0,00)
		fwrite(_hdl,";'"+tmp1->origem+"'")         					// ORIGEM DO PRODUTO (I)mportado, Fabricação (P)rópria, (T)erceirizada
                                                        
		_dcb1:= tmp1->dcb1
		_dcb2:= tmp1->dcb2
		_dcb3:= tmp1->dcb3
		_nativo:=tmp1->numatv
		_codpro:= tmp1->cod
		_qtdeprod:=0
		_qtdeven:=0
		_vrven:=0
		_totlote:=0         
		_lcontinua:=.t.

		// CAPACIDADE MÁXIMA DE PRODUÇÃO MENSAL PARA CADA PRODUTO
		fwrite(_hdl,";'"+alltrim(tmp1->capmxme)+"'")  

		//INFORMAÇÕES DA PRODUÇÃO
		while ! tmp1->(eof()) .and.;
			tmp1->cod==_codpro .and.;
			lcontinua
		
			_lote:= tmp1->lote
			_totlote++    								 			// TOTAL DE LOTES PRODUZIDOS NO MÊS                                                     
			_qtdeprod+=tmp1->quant            						// QTDE PRODUZIDA NO MÊS (POR PRODUTO)
			tmp1->(dbskip())			
		end

		fwrite(_hdl,";'"+ltrim(str(_qtdeprod,20,0))+"'")      		// QTDE PRODUZIDA NO MÊS DE REFERÊNCIA
		fwrite(_hdl,";'"+ltrim(str(_totlote,3,0))+"'")        		// TOTAL DE LOTES PRODUZIDOS NO MÊS DE REFERÊNCIA	

		//INFORMAÇÕES DO TOTAL DAS VENDAS (QUANTIDADE E VALOR) POR PRODUTO/APRESENTAÇÃO
		tmp2->(dbgotop())
		while ! tmp2->(eof()) .and.;
			lcontinua
			if (_codpro==tmp2->cod) .and.;
				(tmp2->tipomov=='V')
				_qtdeven+=tmp2->quant
				_vrven+=tmp2->total
			endif
	
			tmp2->(dbskip())
		end

		fwrite(_hdl,";'"+ltrim(str(_qtdeven,12,0))+"'")  	      	// QUANTIDADE VENDIDA NO MERCADO INTERNO
		fwrite(_hdl,";'"+_substpt(ltrim(str(_vrven,12,2)))+"'")  	// VALOR DAS VENDAS NO MERCADO INTERNO - FATURAMENTO
		fwrite(_hdl,";'0'")              	          				// QUANTIDADE VENDIDA NO MERCADO EXTERNO
		fwrite(_hdl,";'0,00'")              	       				// VALOR DAS VENDAS NO MERCADO EXTERNO
		fwrite(_hdl,";'"+alltrim(_nativo)+"'")              		// NÚMERO DE PRINCÍPIOS ATIVOS
		if alltrim(tmp3->numatv)=='1'
			fwrite(_hdl,";'"+alltrim(_dcb1)+"'")                // DCB DO PRINCÍPIO ATIVO
			fwrite(_hdl,";'"+alltrim(tmp3->dosag1)+"'")         // CONCENTRACAO DA DOSAGEM DO PRINCÍPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->undsg1)+"'")         // UNID.MEDIDA CONCENTRAÇÃO DA DOSAGEM DO PRINC. ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->qdtat1)+"'")         // QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->undsg1)+"'")  		// INID.MEDIDA QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 01
		elseif alltrim(tmp3->numatv)=='2'
			fwrite(_hdl,";'"+alltrim(_dcb1)+"'")                // DCB DO PRINCÍPIO ATIVO
			fwrite(_hdl,";'"+alltrim(tmp3->dosag1)+"'")         // CONCENTRACAO DA DOSAGEM DO PRINCÍPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->undsg1)+"'")         // UNID.MEDIDA CONCENTRAÇÃO DA DOSAGEM DO PRINC. ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->qdtat1)+"'")         // QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->undsg1)+"'")  		// INID.MEDIDA QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(_dcb2)+"'")                // DCB DO PRINCÍPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->dosag2)+"'")         // CONCENTRACAO DA DOSAGEM DO PRINCÍPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->undsg2)+"'")         // UNID.MEDIDA CONCENTRAÇÃO DA DOSAGEM DO PRINC. ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->qdtat2)+"'")         // QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->undsg2)+"'")  		// INID.MEDIDA QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 02
		else
			fwrite(_hdl,";'"+alltrim(_dcb1)+"'")                // DCB DO PRINCÍPIO ATIVO
			fwrite(_hdl,";'"+alltrim(tmp3->dosag1)+"'")         // CONCENTRACAO DA DOSAGEM DO PRINCÍPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->undsg1)+"'")         // UNID.MEDIDA CONCENTRAÇÃO DA DOSAGEM DO PRINC. ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->qdtat1)+"'")         // QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(tmp3->undsg1)+"'")  		// INID.MEDIDA QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 01
			fwrite(_hdl,";'"+alltrim(_dcb2)+"'")                // DCB DO PRINCÍPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->dosag2)+"'")         // CONCENTRACAO DA DOSAGEM DO PRINCÍPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->undsg2)+"'")         // UNID.MEDIDA CONCENTRAÇÃO DA DOSAGEM DO PRINC. ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->qdtat2)+"'")         // QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(tmp3->undsg2)+"'")  		// INID.MEDIDA QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 02
			fwrite(_hdl,";'"+alltrim(_dcb3)+"'")                // DCB DO PRINCÍPIO ATIVO 03
			fwrite(_hdl,";'"+alltrim(tmp3->dosag3)+"'")         // CONCENTRACAO DA DOSAGEM DO PRINCÍPIO ATIVO 03
			fwrite(_hdl,";'"+alltrim(tmp3->undsg3)+"'")         // UNID.MEDIDA CONCENTRAÇÃO DA DOSAGEM DO PRINC. ATIVO 03
			fwrite(_hdl,";'"+alltrim(tmp3->qdtat3)+"'")         // QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 03
			fwrite(_hdl,";'"+alltrim(tmp3->undsg3)+"'")  		// INID.MEDIDA QUANTIDADE UTILIZADA DE PRINCIPIO ATIVO 03
		endif

		fwrite(_hdl,chr(13)+chr(10))               				// MUDANCA DE LINHA                                                       
		incproc()


	endif
	tmp3->(dbskip())
end
                                                                                           

//*************************************************************************************//
//                                                                                     //
//                  REGISTRO 3 - INFORMAÇÕES DAS MOVIMENTAÇÕES                         //
//                       (VENDAS E DEVOLUÇÕES POR CLIENTE)                             //
//                                                                                     //
//*************************************************************************************//


//INFORMAÇÕES DAS MOVIMENTAÇÕES (VENDAS E DEVOLUÇÕES) POR PRODUTO/APRESENTAÇÃO E CLIENTE
tmp2->(dbgotop())                    

while ! tmp2->(eof()) .and. lcontinua

	fwrite(_hdl,"'3'")                         					// TIPO DE REGISTRO: 3- Vendas/Devoluções e Clientes
	fwrite(_hdl,";'"+rtrim(tmp2->codbar)+"'")         			// CÓDIGO DE BARRAS DO PRODUTO/APRESENTAÇÃO
	fwrite(_hdl,";'"+tmp2->anvisa+"'")         					// CÓDIGO DE REGISTRO ANVISA DO PRODUTO/APRESENTAÇÃO
	fwrite(_hdl,";'"+tmp2->cgc+"'")            					// CNPJ DO CLIENTE
	fwrite(_hdl,";'"+rtrim(tmp2->nome)+"'")     				// NOME DO CLIENTE
	fwrite(_hdl,";'"+substr(tmp2->tipo,1,1)+"'")				// INFORMAR TIPO DO CLIENTE
	fwrite(_hdl,";'"+rtrim(tmp2->ender)+"'")    				// ENDEREÇO DO CLIENTE
	fwrite(_hdl,";'"+rtrim(tmp2->bairro)+"'")   				// BAIRRO DO CLIENTE
	cc2->(dbseek(_cfilcc2+tmp2->est+tmp2->codmun))
//	fwrite(_hdl,";'"+rtrim(tmp2->mun)+"'")            			// CIDADE DO CLIENTE
	fwrite(_hdl,";'"+rtrim(cc2->cc2_mun)+"'")            			// CIDADE DO CLIENTE

	fwrite(_hdl,";'"+tmp2->est+"'")            					// ESTADO (UF) DO CLIENTE
	fwrite(_hdl,";'"+tmp2->cep+"'")            					// CEP DO CLIENTE
	fwrite(_hdl,";'"+tmp2->tipomov+"'")        					// TIPO DE MOVIMENTO: (D)evolução / (V)enda
	fwrite(_hdl,";'"+rtrim(tmp2->lote)+"'")     				// Nº DO LOTE VENDIDO/DEVOLVIDO
	fwrite(_hdl,";'"+ltrim(str(tmp2->quant,12,0))+"'")			// QUANTIDADE VENDIDA/DEVOLVIDA

	fwrite(_hdl,chr(13)+chr(10))               					// MUDANCA DE LINHA
	incproc()

	tmp2->(dbskip())
end 

tmp1->(dbclosearea())
tmp2->(dbclosearea())
tmp3->(dbclosearea())
fclose(_hdl)

return


//*************************************************************************************//
//                                                                                     //
//      SUBSTITUI O "." PARA DECIMAIS POR "," CONFORME PADRÃO BRASILEIRO               //
//                                                                                     //
//*************************************************************************************//


static function _substpt(_cadeia)
	_car:=""
	_cadres:=''
	for _i:=1 to len(_cadeia)
		_car:=substr(_cadeia,_i,1)
		if _car=="."
			_car:=","
		endif       
		_cadres+=_car
	next
  
return(_cadres)



//*************************************************************************************//
//                                                                                     //
//      INFORMAÇÕES SOBRE O RESPONSÁVEL PELA APRESENTAÇÃO DAS INFORMAÇÕES              //
//                                                                                     //
//*************************************************************************************//

static function _header() 
	// REGISTRO HEADER                                    
	fwrite(_hdl,"'1'")                         					// TIPO DE REGISTRO: 1- Responsável pelas informações
	fwrite(_hdl,";'"+mv_par03+"'")              				// CPF DO RESPONSÁVEL
	fwrite(_hdl,";'"+rtrim(mv_par04)+"'")              			// NOME DO RESPONSÁVEL
	fwrite(_hdl,";'"+rtrim(mv_par05)+"'")              			// E-MAIL DO RESPONSÁVEL
	fwrite(_hdl,";'"+rtrim(mv_par06)+"'")              			// No. DO TELEFONE DO RESPONSÁVEL
	fwrite(_hdl,";'"+mv_par02+"'")              				// ANO DE REFERÊNCIA DAS INFORMAÇÕES
	fwrite(_hdl,";'"+mv_par01+"'")              				// MÊS DE REFERÊNCIA DAS INFORMAÇÕES
	fwrite(_hdl,chr(13)+chr(10))               					// MUDANCA DE LINHA
return 


//*************************************************************************************//
//                                                                                     //
//      INFORMAÇÕES SOBRE OS PRODUTOS QUE SÃO GENÉRICOS E SUAS PRODUÇÕES NO PERÍODO    //
//                                                                                     //
//*************************************************************************************//


static function _querys()

incproc("Selecionando produtos genericos...")

_cquery:=" SELECT"
_cquery+=" B1_COD COD,"
_cquery+=" B1_CODBAR CODBAR,"
_cquery+=" B1_ANVISA ANVISA,"
_cquery+=" B5_CEME DESCRI,"  									//(B5_CEME) - Descrição Genérica Cadastro de Complemento de Produtos
//_cquery+=" 'CAPTOPRIL' DESCRI,"  								//Implementar busca para novos produtos (B5_CEME)

_cquery+=" B1_UM UM,"
_cquery+=" B1_CONV CONV,"

// FORMA FARMACÊUTICA
_cquery+=" CASE"
_cquery+="   WHEN B5_FORMA='01'"
_cquery+="       THEN 'COMPRIMIDO SIMPLES'"
_cquery+="   WHEN B5_FORMA='02'"
_cquery+="       THEN 'COMPRIMIDO REVESTIDO'"
_cquery+="   WHEN B5_FORMA='03'"
_cquery+="       THEN 'DRAGEA'"
_cquery+="   WHEN B5_FORMA='04'"
_cquery+="       THEN 'SUSPENSAO'"
_cquery+="   WHEN B5_FORMA='05'"
_cquery+="       THEN 'SOLUCAO ORAL'"
_cquery+="   WHEN B5_FORMA='06'"
_cquery+="       THEN 'ELIXIR'"
_cquery+="   WHEN B5_FORMA='07'"
_cquery+="       THEN 'CAPSULA'"
_cquery+="   WHEN B5_FORMA='08'"
_cquery+="       THEN 'SOLUCAO INJETAVEL'"
_cquery+="   WHEN B5_FORMA='09'"
_cquery+="       THEN 'SUSPENSAO INJETAVEL'"
_cquery+="   WHEN B5_FORMA='10'"
_cquery+="       THEN 'SOLUCAO OFTALMICA'"
_cquery+="   WHEN B5_FORMA='11'"
_cquery+="       THEN 'CREME'"
_cquery+="   WHEN B5_FORMA='12'"
_cquery+="       THEN 'POMADA'"
_cquery+="   ELSE 'SHAMPOO'"
_cquery+=" END FORMA,"
//_cquery+=" 'COMPRIMIDO SIMPLES' FORMA,"        				//Implementar busca para novos produtos (criar campo B5_FORMA)

// FORMA ADMINISTRAÇÃO DO MEDICAMENTO
_cquery+=" CASE"
_cquery+="   WHEN B5_ADMIN='1'"
_cquery+="       THEN 'ORAL'"
_cquery+="   WHEN B5_FORMA='2'"
_cquery+="       THEN 'PARENTERAL'"
_cquery+="   ELSE 'TOPICO'"
_cquery+=" END ADM,"
//_cquery+=" 'ORAL' ADM,"        					  			//Implementar busca para novos produtos (criar campo B5_ADMIN)

_cquery+=" B5_CLASSE CLASSE,"
//_cquery+=" 'ANTI-HIPERTENSIVO' CLASSE,"        				//Implementar busca para novos produtos (criar campo B5_CLASSE)

// USO CONTÍNUO
_cquery+=" CASE"
_cquery+="   WHEN B5_USO='1'"
_cquery+="       THEN 'S'"	
_cquery+="   ELSE 'N'"	
_cquery+=" END USO,"
//_cquery+=" 'S' USO,"									  		//Implementar busca para novos produtos (criar campo B5_USO)

_cquery+=" B5_PRV2 PRFAB,"
_cquery+=" '0,00' PARTM,"
_cquery+=" 'P' ORIGEM,"
_cquery+=" SUM(D3_QUANT) QUANT,"
_cquery+=" D3_OP LOTE,"
_cquery+=" B1_DCB1 DCB1,"
_cquery+=" B5_DOSAG1 DOSAG1,"
_cquery+=" B5_UNDSG1 UNDSG1,"
_cquery+=" B5_QDTAT1 QDTAT1,"
_cquery+=" B1_DCB2 DCB2,"
_cquery+=" B5_DOSAG2 DOSAG2,"
_cquery+=" B5_UNDSG2 UNDSG2,"
_cquery+=" B5_QDTAT2 QDTAT2,"
_cquery+=" B1_DCB3 DCB3,"
_cquery+=" B5_DOSAG3 DOSAG3,"
_cquery+=" B5_UNDSG3 UNDSG3,"
_cquery+=" B5_QDTAT3 QDTAT3,"
_cquery+=" B5_NUMATV NUMATV,"
_cquery+=" B5_CAPMXME CAPMXME"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SB5")+" SB5,"
_cquery+=  retsqlname("SD3")+" SD3"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SB5.D_E_L_E_T_<>'*'"
_cquery+=" AND SD3.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B5_FILIAL='"+_cfilsb5+"'"
_cquery+=" AND D3_FILIAL='"+_cfilsd3+"'"
_cquery+=" AND B1_TPPROD='1'"
//_cquery+=" AND B1_COD IN (SELECT DISTINCT(SB51.B5_COD) FROM "+retsqlname("SB5")+" SB51 WHERE SB51.D_E_L_E_T_<>'*' AND SB51.B5_COD<'001000')"
//_cquery+=" AND B1_COD IN ('000294         ','000619         ','000794         ')"         //Implementar busca para novos produtos (Produtos PA contidos no SB5)
_cquery+=" AND B1_COD = B5_COD"
_cquery+=" AND B1_COD = D3_COD"
_cquery+=" AND D3_EMISSAO BETWEEN '"+dtos(_dtini)+"' AND '"+dtos(_dtfim)+"'"
_cquery+=" AND D3_CF='PR0'"
_cquery+=" AND D3_ESTORNO<>'S'"
_cquery+=" AND D3_TIPO='PA'"
_cquery+=" AND D3_QUANT>0"
_cquery+=" GROUP BY B1_COD,B1_CODBAR,B1_ANVISA,B5_CEME,B1_UM,B1_CONV,B5_FORMA,B5_ADMIN,B5_CLASSE,B5_USO,B5_PRV2,D3_OP,B1_DCB1,B5_DOSAG1,B5_UNDSG1,"
_cquery+=" B5_QDTAT1,B1_DCB2,B5_DOSAG2,B5_UNDSG2,B5_QDTAT2,B1_DCB3,B5_DOSAG3,B5_UNDSG3,B5_QDTAT3,B5_NUMATV,B5_CAPMXME"
_cquery+=" ORDER BY"
_cquery+=" B1_COD,D3_OP"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","CONV","N",4,0)
tcsetfield("TMP1","PRFAB","N",12,2)
tcsetfield("TMP1","QUANT","N",12,0)
tcsetfield("TMP1","PARTM","N",4,2)

return




//*************************************************************************************//
//                                                                                     //
//      INFORMAÇÕES SOBRE MOVIMENTAÇÕES (VENDAS E DEVOLUÇÕES) DOS PRODUTOS GENÉRICOS   //
//                                                                                     //
//*************************************************************************************//


static function _query2()

incproc("Selecionando movimentacoes (vendas e devolucoes)...")

_cquery2:=" SELECT"
_cquery2+=" B1_COD COD,"
_cquery2+=" B1_CODBAR CODBAR,"
_cquery2+=" B1_ANVISA ANVISA,"
_cquery2+=" A1_CGC CGC,"  						
_cquery2+=" A1_NOME NOME,"
_cquery2+=" A1_END ENDER,"                               
_cquery2+=" A1_BAIRRO BAIRRO,"        
_cquery2+=" A1_MUN MUN,"        		
_cquery2+=" A1_COD_MUN CODMUN,"        		
_cquery2+=" A1_EST EST,"        
_cquery2+=" A1_CEP CEP,"				
_cquery2+=" A1_TIPOESP TIPO,"				
_cquery2+=" D2_LOTECTL LOTE,"
_cquery2+=" D2_QUANT QUANT,"
_cquery2+=" D2_TOTAL TOTAL,"
_cquery2+=" 'V' TIPOMOV"
_cquery2+=" FROM "
_cquery2+=  retsqlname("SB1")+" SB1,"
_cquery2+=  retsqlname("SA1")+" SA1,"
_cquery2+=  retsqlname("SD2")+" SD2"
_cquery2+=" WHERE"
_cquery2+="     SB1.D_E_L_E_T_<>'*'"
_cquery2+=" AND SA1.D_E_L_E_T_<>'*'"
_cquery2+=" AND SD2.D_E_L_E_T_<>'*'"
_cquery2+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery2+=" AND A1_FILIAL='"+_cfilsa1+"'"
_cquery2+=" AND D2_FILIAL='"+_cfilsd2+"'"
_cquery2+=" AND B1_TPPROD='1'"
//_cquery2+=" AND B1_COD IN (SELECT DISTINCT(SB51.B5_COD) FROM "+retsqlname("SB5")+" SB51 WHERE SB51.D_E_L_E_T_<>'*' AND SB51.B5_COD<'001000')"
//_cquery2+=" AND B1_COD IN ('000294         ','000619         ','000794         ')"         //Implementar busca para novos produtos (criar campo)
_cquery2+=" AND B1_COD = D2_COD"
_cquery2+=" AND D2_EMISSAO BETWEEN '"+dtos(_dtini)+"' AND '"+dtos(_dtfim)+"'"
_cquery2+=" AND D2_CLIENTE=A1_COD"
_cquery2+=" AND D2_LOJA=A1_LOJA"
if mv_par07==2  //Informa Cliente Sem Registro na ANVISA?
   _cquery2+=" AND A1_AUTORIZ<>' '"
endif

_cquery2+=" UNION ALL"

_cquery2+=" SELECT"
_cquery2+=" B1_COD COD,"
_cquery2+=" B1_CODBAR CODBAR,"
_cquery2+=" B1_ANVISA ANVISA,"
_cquery2+=" A1_CGC CGC,"  						
_cquery2+=" A1_NOME NOME,"
_cquery2+=" A1_END ENDER,"
_cquery2+=" A1_BAIRRO BAIRRO,"        
_cquery2+=" A1_MUN MUN,"        		
_cquery2+=" A1_COD_MUN CODMUN,"        		
_cquery2+=" A1_EST EST,"        
_cquery2+=" A1_CEP CEP,"				
_cquery2+=" A1_TIPOESP TIPO,"				
_cquery2+=" D1_LOTECTL LOTE,"
_cquery2+=" D1_QUANT QUANT,"
_cquery2+=" D1_TOTAL TOTAL,"
_cquery2+=" 'D' TIPOMOV"
_cquery2+=" FROM "
_cquery2+=  retsqlname("SB1")+" SB1,"
_cquery2+=  retsqlname("SA1")+" SA1,"
_cquery2+=  retsqlname("SD1")+" SD1"
_cquery2+=" WHERE"
_cquery2+="     SB1.D_E_L_E_T_<>'*'"
_cquery2+=" AND SA1.D_E_L_E_T_<>'*'"
_cquery2+=" AND SD1.D_E_L_E_T_<>'*'"
_cquery2+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery2+=" AND A1_FILIAL='"+_cfilsa1+"'"
_cquery2+=" AND D1_FILIAL='"+_cfilsd1+"'"
_cquery2+=" AND B1_TPPROD='1'"
//_cquery2+=" AND B1_COD IN (SELECT DISTINCT(SB51.B5_COD) FROM "+retsqlname("SB5")+" SB51 WHERE SB51.D_E_L_E_T_<>'*' AND SB51.B5_COD<'001000')"
//_cquery2+=" AND B1_COD IN ('000294         ','000619         ','000794         ')"         //Implementar busca para novos produtos (criar campo)
_cquery2+=" AND B1_COD = D1_COD"
_cquery2+=" AND D1_DTDIGIT BETWEEN '"+dtos(_dtini)+"' AND '"+dtos(_dtfim)+"'"
_cquery2+=" AND D1_FORNECE=A1_COD"
_cquery2+=" AND D1_LOJA=A1_LOJA"
if mv_par07==2  //Informa Cliente Sem Registro na ANVISA?
   _cquery2+=" AND A1_AUTORIZ<>' '"
endif
_cquery2+=" ORDER BY"
_cquery2+=" 1,5"

_cquery2:=changequery(_cquery2)

tcquery _cquery2 new alias "TMP2"
tcsetfield("TMP2","QUANT","N",12,0)
tcsetfield("TMP2","TOTAL","N",12,2)

return


//*************************************************************************************//
//                                                                                     //
//  INFORMAÇÕES SOBRE OS PRODUTOS QUE SÃO GENÉRICOS E NÃO TEVE PRODUÇÕES NO PERÍODO    //
//                                                                                     //
//*************************************************************************************//


static function _query3()

incproc("Selecionando produtos genericos...")

_cquery3:=" SELECT"
_cquery3+=" B1_COD COD,"
_cquery3+=" B1_CODBAR CODBAR,"
_cquery3+=" B1_ANVISA ANVISA,"
_cquery3+=" B5_CEME DESCRI,"
//_cquery3+=" 'CAPTOPRIL' DESCRI,"  							//Implementar busca para novos produtos (B5_CEME)
_cquery3+=" B1_UM UM,"
_cquery3+=" B1_CONV CONV,"
// FORMA FARMACÊUTICA
_cquery3+=" CASE"
_cquery3+="   WHEN B5_FORMA='01'"
_cquery3+="       THEN 'COMPRIMIDO SIMPLES'"
_cquery3+="   WHEN B5_FORMA='02'"
_cquery3+="       THEN 'COMPRIMIDO REVESTIDO'"
_cquery3+="   WHEN B5_FORMA='03'"
_cquery3+="       THEN 'DRAGEA'"
_cquery3+="   WHEN B5_FORMA='04'"
_cquery3+="       THEN 'SUSPENSAO'"
_cquery3+="   WHEN B5_FORMA='05'"
_cquery3+="       THEN 'SOLUCAO ORAL'"
_cquery3+="   WHEN B5_FORMA='06'"
_cquery3+="       THEN 'ELIXIR'"
_cquery3+="   WHEN B5_FORMA='07'"
_cquery3+="       THEN 'CAPSULA'"
_cquery3+="   WHEN B5_FORMA='08'"
_cquery3+="       THEN 'SOLUCAO INJETAVEL'"
_cquery3+="   WHEN B5_FORMA='09'"
_cquery3+="       THEN 'SUSPENSAO INJETAVEL'"
_cquery3+="   WHEN B5_FORMA='10'"
_cquery3+="       THEN 'SOLUCAO OFTALMICA'"
_cquery3+="   WHEN B5_FORMA='11'"
_cquery3+="       THEN 'CREME'"
_cquery3+="   WHEN B5_FORMA='12'"
_cquery3+="       THEN 'POMADA'"
_cquery3+="   ELSE 'SHAMPOO'"
_cquery3+=" END FORMA,"

// FORMA ADMINISTRAÇÃO DO MEDICAMENTO
_cquery3+=" CASE"
_cquery3+="   WHEN B5_ADMIN='1'"
_cquery3+="       THEN 'ORAL'"
_cquery3+="   WHEN B5_FORMA='2'"
_cquery3+="       THEN 'PARENTERAL'"
_cquery3+="   ELSE 'TOPICO'"
_cquery3+=" END ADM,"
//_cquery3+=" 'ORAL' ADM,"        					  			//Implementar busca para novos produtos (criar campo)

_cquery3+=" B5_CLASSE CLASSE,"

// USO CONTÍNUO
_cquery3+=" CASE"
_cquery3+="   WHEN B5_USO='1'"
_cquery3+="       THEN 'S'"	
_cquery3+="   ELSE 'N'"	
_cquery3+=" END USO,"
//_cquery3+=" 'S' USO,"									  		//Implementar busca para novos produtos (criar campo) 	

_cquery3+=" B5_PRV2 PRFAB,"
_cquery3+=" '0,00' PARTM,"
_cquery3+=" 'P' ORIGEM,"
_cquery3+=" (SELECT coalesce(Sum(D3_QUANT),0) FROM "+retsqlname("SD3")+" SD3 WHERE SD3.D_E_L_E_T_=' ' AND SD3.D3_COD=B1_COD AND SD3.D3_EMISSAO BETWEEN '"+dtos(_dtini)+"' AND '"+dtos(_dtfim)+"' AND SD3.D3_CF='PR0' AND SD3.D3_ESTORNO<>'S' AND D3_QUANT>0) QUANT,"
_cquery3+=" '0' LOTE,"
_cquery3+=" B1_DCB1 DCB1,"
_cquery3+=" B5_DOSAG1 DOSAG1,"
_cquery3+=" B5_UNDSG1 UNDSG1,"
_cquery3+=" B5_QDTAT1 QDTAT1,"
_cquery3+=" B1_DCB2 DCB2,"
_cquery3+=" B5_DOSAG2 DOSAG2,"
_cquery3+=" B5_UNDSG2 UNDSG2,"
_cquery3+=" B5_QDTAT2 QDTAT2,"
_cquery3+=" B1_DCB3 DCB3,"
_cquery3+=" B5_DOSAG3 DOSAG3,"
_cquery3+=" B5_UNDSG3 UNDSG3,"
_cquery3+=" B5_QDTAT3 QDTAT3,"
_cquery3+=" B5_NUMATV NUMATV,"
_cquery3+=" B5_CAPMXME CAPMXME"
_cquery3+=" FROM "
_cquery3+=  retsqlname("SB1")+" SB1,"
_cquery3+=  retsqlname("SB5")+" SB5"
_cquery3+=" WHERE"
_cquery3+="     SB1.D_E_L_E_T_<>'*'"
_cquery3+=" AND SB5.D_E_L_E_T_<>'*'"
_cquery3+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery3+=" AND B5_FILIAL='"+_cfilsb5+"'"
_cquery3+=" AND B1_TPPROD='1'"
//_cquery3+=" AND B1_COD IN (SELECT DISTINCT(SB51.B5_COD) FROM "+retsqlname("SB5")+" SB51 WHERE SB51.D_E_L_E_T_<>'*' AND SB51.B5_COD<'001000')"
//_cquery3+=" AND B1_COD IN ('000294         ','000619         ','000794         ')"         //Implementar busca para novos produtos (Produtos PA contidos no SB5)
_cquery3+=" AND B1_COD = B5_COD"
_cquery3+=" ORDER BY"
_cquery3+=" B1_COD"

_cquery3:=changequery(_cquery3)
 
MemoWrite("/sql/vit254_3.sql",_cquery3)

tcquery _cquery3 new alias "TMP3"
tcsetfield("TMP3","CONV","N",4,0)
tcsetfield("TMP3","PRFAB","N",12,2)
tcsetfield("TMP3","QUANT","N",12,0)
tcsetfield("TMP3","PARTM","N",4,2)

return



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Mês Referencia     ?","mv_ch1","C",02,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"02","Ano Referencia     ?","mv_ch2","C",04,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"03","CPF do Responsavel ?","mv_ch3","C",11,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"04","Nome do Responsavel?","mv_ch4","C",30,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"05","E-mail Responsavel ?","mv_ch5","C",30,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"06","Telefone do Resp.  ?","mv_ch6","C",30,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"07","Cliente s/ANVISA   ?","mv_ch7","N",01,0,0,"C",space(60),"mv_par07"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})                                        

for i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[i,1]+_agrpsx1[i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[i,01]
		sx1->x1_ordem  :=_agrpsx1[i,02]
		sx1->x1_pergunt:=_agrpsx1[i,03]
		sx1->x1_variavl:=_agrpsx1[i,04]
		sx1->x1_tipo   :=_agrpsx1[i,05]
		sx1->x1_tamanho:=_agrpsx1[i,06]
		sx1->x1_decimal:=_agrpsx1[i,07]
		sx1->x1_presel :=_agrpsx1[i,08]
		sx1->x1_gsc    :=_agrpsx1[i,09]
		sx1->x1_valid  :=_agrpsx1[i,10]
		sx1->x1_var01  :=_agrpsx1[i,11]
		sx1->x1_def01  :=_agrpsx1[i,12]
		sx1->x1_cnt01  :=_agrpsx1[i,13]
		sx1->x1_var02  :=_agrpsx1[i,14]
		sx1->x1_def02  :=_agrpsx1[i,15]
		sx1->x1_cnt02  :=_agrpsx1[i,16]
		sx1->x1_var03  :=_agrpsx1[i,17]
		sx1->x1_def03  :=_agrpsx1[i,18]
		sx1->x1_cnt03  :=_agrpsx1[i,19]
		sx1->x1_var04  :=_agrpsx1[i,20]
		sx1->x1_def04  :=_agrpsx1[i,21]
		sx1->x1_cnt04  :=_agrpsx1[i,22]
		sx1->x1_var05  :=_agrpsx1[i,23]
		sx1->x1_def05  :=_agrpsx1[i,24]
		sx1->x1_cnt05  :=_agrpsx1[i,25]
		sx1->x1_f3     :=_agrpsx1[i,26]
		sx1->(msunlock())
	endif
next
return
