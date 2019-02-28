/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±
±±³Programa  ³ FC010CON ³ Autor ³ Heraildo C. de Freitas³ Data ³ 07/03/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Consulta Especifica na Posicao de Clientes                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function fc010con()
_aarea   :=getarea()
_aareada0:=da0->(getarea())
_aareasa1:=sa1->(getarea())
_aareasb1:=sb1->(getarea())
_aareasc5:=sc5->(getarea())
_aareasc6:=sc6->(getarea())
_aareasc9:=sc9->(getarea())
_aareasd2:=sd2->(getarea())
_aarease1:=se1->(getarea())
_aarease4:=se4->(getarea())
_aareasf2:=sf2->(getarea())

_cfilda0:=xfilial("DA0")
_cfilsa4:=xfilial("SA4")
_cfilsb1:=xfilial("SB1")
_cfilsc5:=xfilial("SC5")
_cfilsc6:=xfilial("SC6")
_cfilsc9:=xfilial("SC9")
_cfilsd2:=xfilial("SD2")
_cfilse1:=xfilial("SE1")
_cfilse4:=xfilial("SE4")
_cfilsf2:=xfilial("SF2")
da0->(dbsetorder(1))
sa4->(dbsetorder(1))
sb1->(dbsetorder(1))
sc5->(dbsetorder(3))
sc6->(dbsetorder(1))
sc9->(dbsetorder(1))
sd2->(dbsetorder(3))
se1->(dbsetorder(1))
se4->(dbsetorder(1))
sf2->(dbsetorder(2))

_carqtmp1:=""
_carqtmp2:=""

processa({|| _geratmp()})

tmp1->(dbgotop())
tmp2->(dbgotop())
sc5->(dbsetorder(1))
sf2->(dbsetorder(1))

_acampos1:={}
aadd(_acampos1,{"NOTA"   ,"Nota"          ,                   ,09,0})
aadd(_acampos1,{"SERIE"  ,"Serie"         ,                   ,03,0})
aadd(_acampos1,{"EMISSAO","Emissao"       ,                   ,08,0})
aadd(_acampos1,{"VALFAT" ,"Valor faturado","@E 999,999,999.99",12,2})
aadd(_acampos1,{"VOLUME" ,"Volumes"       ,"@E 999,999"       ,06,0})
aadd(_acampos1,{"PEDIDO" ,"Pedido"        ,                   ,06,0})
aadd(_acampos1,{"NOMETRA","Transportadora",                   ,40,0})
aadd(_acampos1,{"DTPENTR","Prev. Entrega ",                   ,08,0})
aadd(_acampos1,{"DTENTR" ,"Data Entrega  ",                   ,08,0})
aadd(_acampos1,{"OBSFR"  ,"Obs.Frete     ",                   ,80,0})

_acampos2:={}
aadd(_acampos2,{"PEDIDO" ,"Pedido"         ,                   ,06,0})
aadd(_acampos2,{"VALOR"  ,"Valor pendencia","@E 999,999,999.99",12,2})
aadd(_acampos2,{"EMISSAO","Emissao"        ,                   ,08,0})

@ 020,002 to 520,790 dialog odlg1 title "Consultas especificas"

@ 002,002 say "Cliente: "+sa1->a1_cod+"/"+sa1->a1_loja+"-"+alltrim(sa1->a1_nome)

@ 012,002 say "Faturamento"
@ 020,002 to 120,360 browse "TMP1" fields _acampos1

@ 122,002 say "Pedidos pendentes"
@ 130,002 to 248,360 browse "TMP2" fields _acampos2

@ 020,365 bmpbutton type 15 action _vernota()
@ 130,365 bmpbutton type 15 action _verped()
@ 235,365 bmpbutton type 1  action close(odlg1)
	
activate dialog odlg1

tmp1->(dbclosearea())
tmp2->(dbclosearea())
ferase(_carqtmp1+getdbextension())
ferase(_carqtmp2+getdbextension())

restarea(_aarea)
da0->(restarea(_aareada0))
sa1->(restarea(_aareasa1))
sb1->(restarea(_aareasb1))
sc5->(restarea(_aareasc5))
sc6->(restarea(_aareasc6))
sc9->(restarea(_aareasc9))
sd2->(restarea(_aareasd2))
se1->(restarea(_aarease1))
se4->(restarea(_aarease4))
sf2->(restarea(_aareasf2))
return

static function _vernota()
_aesttmp:={}
aadd(_aesttmp,{"PRODUTO"  ,"C",15,0})
aadd(_aesttmp,{"DESCRICAO","C",40,0})
aadd(_aesttmp,{"QUANT"    ,"N",09,0})
aadd(_aesttmp,{"PRCVEN"   ,"N",16,6})
aadd(_aesttmp,{"TOTAL"    ,"N",12,2})

_carqtmp3:=criatrab(_aesttmp,.t.)
dbusearea(.t.,,_carqtmp3,"TMP3",.f.,.f.)

sd2->(dbseek(_cfilsd2+tmp1->nota+tmp1->serie))
while ! sd2->(eof()) .and.;
		sd2->d2_filial==_cfilsd2 .and.;
		sd2->d2_doc==tmp1->nota
	if sd2->d2_serie==tmp1->serie
		sb1->(dbseek(_cfilsb1+sd2->d2_cod))
		tmp3->(dbappend())
		tmp3->produto  :=sd2->d2_cod
		tmp3->descricao:=sb1->b1_desc
		tmp3->quant    :=sd2->d2_quant
		tmp3->prcven   :=sd2->d2_prcven
		tmp3->total    :=sd2->d2_total
	endif
	sd2->(dbskip())
end

_cduplic:=""
se1->(dbseek(_cfilse1+tmp1->serie+tmp1->nota))
while ! se1->(eof()) .and.;
		se1->e1_filial==_cfilse1 .and.;
		se1->e1_prefixo==tmp1->serie .and.;
		se1->e1_num==tmp1->nota
	if se1->e1_tipo=="NF " .and.;
		se1->e1_cliente==sa1->a1_cod .and.;
		se1->e1_loja==sa1->a1_loja
		_cduplic+=dtoc(se1->e1_vencto)+"   "+alltrim(transform(se1->e1_valor,"@E 999,999,999.99"))+" | "
	endif
	se1->(dbskip())
end

tmp3->(dbgotop())
sc5->(dbseek(_cfilsc5+tmp1->pedido))
da0->(dbseek(_cfilda0+sc5->c5_tabela))
sf2->(dbseek(_cfilsf2+tmp1->nota+tmp1->serie))
se4->(dbseek(_cfilse4+sf2->f2_cond))

_acampos3:={}
aadd(_acampos3,{"PRODUTO"  ,"Produto"       ,                       ,15,0})
aadd(_acampos3,{"DESCRICAO","Descricao"     ,                       ,40,0})
aadd(_acampos3,{"QUANT"    ,"Quantidade"    ,"@E 999,999,999"       ,09,0})
aadd(_acampos3,{"PRCVEN"   ,"Preco unitario","@E 999,999,999.999999",12,2})
aadd(_acampos3,{"TOTAL"    ,"Valor total"   ,"@E 999,999,999.99"    ,12,2})

@ 020,002 to 520,790 dialog odlg2 title "Visualizacao de nota fiscal"

@ 002,002 say "Cliente: "+sa1->a1_cod+"/"+sa1->a1_loja+"-"+alltrim(sa1->a1_nome)
@ 012,002 say "Nota: "+tmp1->nota+;
				  " | Serie: "+tmp1->serie+;
				  " | Emissao: "+dtoc(tmp1->emissao)+;
				  " | Valor: "+alltrim(transform(tmp1->valfat,"@E 999,999,999.99"))+;
				  " | Volumes: "+alltrim(transform(tmp1->volume,"@E 999,999"))+;
				  " | Pedido: "+tmp1->pedido+;
				  " | Transportadora: "+alltrim(tmp1->nometra)
@ 022,002 say "Condicao: "+sf2->f2_cond+"-"+alltrim(se4->e4_descri)+;
				  " | Tabela: "+sc5->c5_tabela+"-"+alltrim(da0->da0_descri)
@ 032,002 say "Duplicatas: "+_cduplic

@ 040,002 to 248,360 browse "TMP3" fields _acampos3

@ 235,365 bmpbutton type 1  action close(odlg2)
	
activate dialog odlg2

tmp3->(dbclosearea())
ferase(_carqtmp3+getdbextension())
return

static function _verped()
_aesttmp:={}
aadd(_aesttmp,{"PRODUTO"  ,"C",15,0})
aadd(_aesttmp,{"DESCRICAO","C",40,0})
aadd(_aesttmp,{"QTDVEN"   ,"N",09,0})
aadd(_aesttmp,{"QTDENT"   ,"N",09,0})
aadd(_aesttmp,{"PENDENCIA","N",09,0})
aadd(_aesttmp,{"PRCVEN"   ,"N",16,6})
aadd(_aesttmp,{"TOTAL"    ,"N",12,2})

_carqtmp3:=criatrab(_aesttmp,.t.)
dbusearea(.t.,,_carqtmp3,"TMP3",.f.,.f.)

sc6->(dbseek(_cfilsc6+tmp2->pedido))
while ! sc6->(eof()) .and.;
		sc6->c6_filial==_cfilsc6 .and.;
		sc6->c6_num==tmp2->pedido
	if sc6->c6_blq<>"R "
		_nqtdpen:=sc6->c6_qtdven-sc6->c6_qtdent
		if _nqtdpen>0
			_nqtdlib:=0
			sc9->(dbseek(_cfilsc9+sc6->c6_num+sc6->c6_item))
			while ! sc9->(eof()) .and.;
					sc9->c9_filial==_cfilsc9 .and.;
					sc9->c9_pedido==sc6->c6_num .and.;
					sc9->c9_item==sc6->c6_item
				if empty(sc9->c9_nfiscal) .and.;
					empty(sc9->c9_blcred) .and.;
					empty(sc9->c9_blest)
					_nqtdlib+=sc9->c9_qtdlib
				endif
				sc9->(dbskip())
			end
			_nqtdpen-=_nqtdlib
			_nvalor :=round(_nqtdpen*sc6->c6_prcven,2)
			sb1->(dbseek(_cfilsb1+sc6->c6_produto))
			tmp3->(dbappend())
			tmp3->produto  :=sc6->c6_produto
			tmp3->descricao:=sb1->b1_desc
			tmp3->qtdven   :=sc6->c6_qtdven
			tmp3->qtdent   :=sc6->c6_qtdent
			tmp3->pendencia:=_nqtdpen
			tmp3->prcven   :=sc6->c6_prcven
			tmp3->total    :=_nvalor
		endif
	endif
	sc6->(dbskip())
end

tmp3->(dbgotop())
sc5->(dbseek(_cfilsc5+tmp2->pedido))
da0->(dbseek(_cfilda0+sc5->c5_tabela))
se4->(dbseek(_cfilse4+sc5->c5_condpag))

_acampos3:={}
aadd(_acampos3,{"PRODUTO"  ,"Produto"        ,                       ,15,0})
aadd(_acampos3,{"DESCRICAO","Descricao"      ,                       ,40,0})
aadd(_acampos3,{"QTDVEN"   ,"Qtde. vendida"  ,"@E 999,999,999"       ,09,0})
aadd(_acampos3,{"QTDENT"   ,"Qtde. entregue" ,"@E 999,999,999"       ,09,0})
aadd(_acampos3,{"PENDENCIA","Pendencia"      ,"@E 999,999,999"       ,09,0})
aadd(_acampos3,{"PRCVEN"   ,"Preco unitario" ,"@E 999,999,999.999999",12,2})
aadd(_acampos3,{"TOTAL"    ,"Valor pendencia","@E 999,999,999.99"    ,12,2})

@ 020,002 to 520,790 dialog odlg2 title "Visualizacao de pedido pendente"

@ 002,002 say "Cliente: "+sa1->a1_cod+"/"+sa1->a1_loja+"-"+alltrim(sa1->a1_nome)
@ 012,002 say "Pedido: "+tmp2->pedido+;
				  " | Emissao: "+dtoc(tmp2->emissao)+;
				  " | Valor: "+alltrim(transform(tmp2->valor,"@E 999,999,999.99"))
@ 022,002 say "Condicao: "+sc5->c5_condpag+"-"+alltrim(se4->e4_descri)+;
				  " | Tabela: "+sc5->c5_tabela+"-"+alltrim(da0->da0_descri)

@ 030,002 to 248,360 browse "TMP3" fields _acampos3

@ 235,365 bmpbutton type 1  action close(odlg2)
	
activate dialog odlg2

tmp3->(dbclosearea())
ferase(_carqtmp3+getdbextension())
return

static function _geratmp()
procregua(2)

incproc("Selecionando notas fiscais...")
_aesttmp:={}
aadd(_aesttmp,{"NOTA"   ,"C",09,0})
aadd(_aesttmp,{"SERIE"  ,"C",03,0})
aadd(_aesttmp,{"EMISSAO","D",08,0})
aadd(_aesttmp,{"VALFAT" ,"N",12,2})
aadd(_aesttmp,{"VOLUME" ,"N",06,0})
aadd(_aesttmp,{"PEDIDO" ,"C",06,0})
aadd(_aesttmp,{"NOMETRA","C",40,0})
aadd(_aesttmp,{"DTPENTR","D",08,0})
aadd(_aesttmp,{"DTENTR" ,"D",08,0})
aadd(_aesttmp,{"OBSFR"  ,"C",80,0})

_carqtmp1:=criatrab(_aesttmp,.t.)
dbusearea(.t.,,_carqtmp1,"TMP1",.f.,.f.)

_cfilsa2:=xfilial("SA2")
_cfilszb:=xfilial("SZB")
sa2->(dbsetorder(3))
szb->(dbsetorder(1))


sf2->(dbseek(_cfilsf2+sa1->a1_cod+sa1->a1_loja))
while ! sf2->(eof()) .and.;
		sf2->f2_filial==_cfilsf2 .and.;
		sf2->f2_cliente==sa1->a1_cod .and.;
		sf2->f2_loja==sa1->a1_loja
		sa4->(dbseek(_cfilsa4+sf2->f2_transp))
		_cgctransp:=sa4->a4_cgc
		sa2->(dbseek(_cfilsa2+_cgctransp))
		_codtransp:=sa2->a2_cod
		szb->(dbseek(_cfilszb+_codtransp+sa1->a1_est+"S"+sa1->a1_local))

	if ! sf2->f2_tipo$"BD" .and.;
		sf2->f2_emissao>=mv_par01 .and.;
		sf2->f2_emissao<=mv_par02
		sa4->(dbseek(_cfilsa4+sf2->f2_transp))
		sd2->(dbseek(_cfilsd2+sf2->f2_doc+sf2->f2_serie))
		tmp1->(dbappend())
		tmp1->nota   :=sf2->f2_doc
		tmp1->serie  :=sf2->f2_serie
		tmp1->emissao:=sf2->f2_emissao
		tmp1->valfat :=sf2->f2_valfat
		tmp1->volume :=sf2->f2_volume1
		tmp1->pedido :=sd2->d2_pedido
		tmp1->nometra:=sa4->a4_nome
		tmp1->obsfr:=sf2->f2_obsfr
		tmp1->dtentr:=sf2->f2_dtentrg
		if !empty(szb->zb_pzentre)
			tmp1->dtpentr:= szb->zb_pzentre+sf2->f2_emissao 
		else	
			tmp1->dtpentr:= ctod(space(08))
		endif	
	endif
	sf2->(dbskip())
end

incproc("Selecionando pedidos pendentes...")
_aesttmp:={}
aadd(_aesttmp,{"PEDIDO" ,"C",06,0})
aadd(_aesttmp,{"VALOR"  ,"N",12,2})
aadd(_aesttmp,{"EMISSAO","D",08,0})

_carqtmp2:=criatrab(_aesttmp,.t.)
dbusearea(.t.,,_carqtmp2,"TMP2",.f.,.f.)

sc5->(dbseek(_cfilsc5+sa1->a1_cod))
while ! sc5->(eof()) .and.;
		sc5->c5_cliente==sa1->a1_cod
	if ! sc5->c5_tipo$"BD" .and.;
		sc5->c5_lojacli==sa1->a1_loja .and.;
		empty(sc5->c5_nota)
		_nvalor:=0
		sc6->(dbseek(_cfilsc6+sc5->c5_num))
		while ! sc6->(eof()) .and.;
				sc6->c6_filial==_cfilsc6 .and.;
				sc6->c6_num==sc5->c5_num
			if sc6->c6_blq<>"R "
				_nqtdpen:=sc6->c6_qtdven-sc6->c6_qtdent
				if _nqtdpen>0
					_nqtdlib:=0
					sc9->(dbseek(_cfilsc9+sc6->c6_num+sc6->c6_item))
					while ! sc9->(eof()) .and.;
							sc9->c9_filial==_cfilsc9 .and.;
							sc9->c9_pedido==sc6->c6_num .and.;
							sc9->c9_item==sc6->c6_item
						if empty(sc9->c9_nfiscal) .and.;
							empty(sc9->c9_blcred) .and.;
							empty(sc9->c9_blest)
							_nqtdlib+=sc9->c9_qtdlib
						endif
						sc9->(dbskip())
					end
					_nqtdpen-=_nqtdlib
					_nvalor+=round(_nqtdpen*sc6->c6_prcven,2)
				endif
			endif
			sc6->(dbskip())
		end
		if _nvalor>0
			tmp2->(dbappend())
			tmp2->pedido :=sc5->c5_num
			tmp2->valor  :=_nvalor
			tmp2->emissao:=sc5->c5_emissao
		endif
	endif
	sc5->(dbskip())
end
return
