#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³VIT375    ³Autor  ³Andre Almeida       ³ Data ³  02/04/12   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Desc.     ³ Rotina para Alimentar a Tabela ZAB                         ³±±
±±³          ³ Cadastros de Ticket para Sorteio de um Carro Zero KM       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

user function vit375

if msgyesno("Deseja criar o Cadastro com os tickets? ")  
                                                                                        
	cQUERY := "	SELECT sd2.d2_emissao, sd2.d2_cliente,  sd2.d2_loja, sa1.a1_nome, sd2.d2_doc, SUM(sd2.d2_total) valor"
	cQUERY += " FROM sd2010 sd2,  sc5010 sc5,  sf4010 sf4,  sb1010 sb1,  da0010 da0, sf2010 sf2, sa1010 sa1"
	cQUERY += " WHERE sc5.d_e_l_e_t_ = ' '"
	cQUERY += " AND sd2.d_e_l_e_t_ = ' '"
	cQUERY += " AND sf4.d_e_l_e_t_ = ' '"
	cQUERY += " and sf2.d_e_l_e_t_ = ' '"
	cQUERY += " and sb1.d_e_l_e_t_ = ' '"
	cQUERY += " and sf2.f2_doc     = sd2.d2_doc"
	cQUERY += " and sf2.f2_serie   = sd2.d2_serie"
	cQUERY += " AND sd2.d2_pedido  = sc5.c5_num"
	cQUERY += " AND sd2.d2_tes     = sf4.f4_codigo"
	cQUERY += " AND sd2.d2_cod     = sb1.b1_cod"
	cQUERY += " AND da0.da0_codtab = sc5.c5_tabela"
	cQUERY += "	and sd2.d2_cliente = sa1.a1_cod"
	cQUERY += " and sd2.d2_loja    = sa1.a1_loja"
	cQUERY += " AND sb1.b1_tipo    IN ('PA','PL')"
	cQUERY += " AND sd2.d2_cliente NOT IN ('228695','228695','228695','005873','841079','935554','995371','652030','729178')"
	cQUERY += " and sc5.c5_tabela  IN('096','097','098','099','100','101','102')"
	cQUERY += " AND sc5.c5_licitac <> 'S'"
	cQUERY += " AND sb1.b1_apreven = '1'"
	cQUERY += " AND sf4.f4_codigo  <> '526'"
	cQUERY += " AND sf4.f4_duplic  = 'S'"
	cQUERY += " AND sf4.f4_estoque = 'S'"
	cQUERY += " AND sd2.d2_nfori   = ' '"
	cQUERY += " and sf2.f2_tipo    IN ('N','C')"
	cQUERY += " AND sd2.d2_emissao BETWEEN '20120213' AND '20120330' "
	cQUERY += " GROUP BY sd2.d2_emissao, sd2.d2_cliente, sd2.d2_loja, sa1.a1_nome, sd2.d2_doc"
	cQUERY += " order by 2,3"
	
	cquery:=changequery(cquery)
	MEMOWRIT("\sql\vit375.sql",cQUERY)
	TCQUERY cQUERY NEW ALIAS "TMP"
	u_setfield("TMP")
	
	procregua(0)
    Dbselectarea('TMP')
	tmp->(dbgotop())	
	
	sa1->(Dbsetorder(1))
	_Cont 		:= Strzero(1,2)
	_cTicket	:= Strzero(1,3)
	_nTotalCli 	:= 0
	_cCli       := ""
	_cLoja		:= ""
	_cAcum		:= 0
	_vTicket	:= 10000	
	
	while tmp->(!eof())  

		if _cCli <> Alltrim(tmp->d2_cliente) .and. _cLoja <> Alltrim(tmp->d2_loja)
			_cAcum := 0
	    endif		
    
		IF reclock("ZAB",.T.)   				//.T. CRIA UM NOVO REGISTRO
			zab->zab_filial := xFILIAL("ZAB") 
			zab->zab_ticket := _Cont
			zab->zab_cli	:= tmp->d2_cliente
			zab->zab_loja	:= tmp->d2_loja
			zab->zab_dia	:= tmp->d2_emissao
			zab->zab_nome	:= tmp->a1_nome
			zab->zab_nota	:= tmp->d2_doc
			zab->zab_valor	:= tmp->valor
			_cAcum			+= tmp->valor
			zab->zab_acum	:= _cAcum
			msunlock()
		endif

		_cCli       := tmp->d2_cliente
		_cLoja		:= tmp->d2_loja
		TMP->(dbskip())
	 enddo
	 tmp->(dbclosearea())
endif
return