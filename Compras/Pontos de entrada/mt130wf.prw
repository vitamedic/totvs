/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT130WF  ³ Autor ³ Heraildo C. de Freitas³ Data ³21/09/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada para Envio de E-Mail com a Cotacao para   ³±±
±±³          ³ o Fornecedor                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "tbiconn.ch"
#include "tbicode.ch"

user function mt130wf(oprocess)
_cfilsa2:=xfilial("SA2")
_cfilsb1:=xfilial("SB1")
_cfilsc8:=xfilial("SC8")
_cfilse4:=xfilial("SE4")

_cnum:=paramixb[1] // NUMERO DA COTACAO

sc8->(dbsetorder(1))
sc8->(dbseek(_cfilsc8+_cnum))
while ! sc8->(eof()) .and.;
	sc8->c8_filial==_cfilsc8 .and.;
	sc8->c8_num==_cnum
	
	_cfornece:=sc8->c8_fornece
	_cloja   :=sc8->c8_loja
	_cpara   :="report_suprimentos@vitamedic.ind.br" //alltrim(sa2->a2_email)     //Guilherme Teodoro em 08/07/2016 - Correção dos emails
	_ccc     :="report@vitamedic.ind.br"
	
	sa2->(dbsetorder(1))
	sa2->(dbseek(_cfilsa2+_cfornece+_cloja))
	if ! empty(_cpara) .and.;
		msgyesno("Enviar e-mail para o fornecedor "+_cfornece+"/"+_cloja+"-"+alltrim(sa2->a2_nome)+" ("+_cpara+")?")
		
		_acond:={}
		se4->(dbsetorder(1))
		if ! empty(sa2->a2_cond)
			if se4->(dbseek(_cfilse4+sa2->a2_cond))
				aadd(_acond,se4->e4_codigo+" - "+se4->e4_descri)
			endif
		endif
		
		se4->(dbseek(_cfilse4))
		while ! se4->(eof()) .and.;
			se4->e4_filial==_cfilse4
			
			if se4->e4_codigo<>sa2->a2_cond
				aadd(_acond,se4->e4_codigo+" - "+se4->e4_descri)
			endif
			
			se4->(dbskip())
		end
		
		oprocess:=twfprocess():new("000005","COTACAO DE PRECOS")
		oprocess:newtask("COTACAO","\workflow\cotacao.htm")
		
		ohtml:=oprocess:ohtml
		
		ohtml:valbyname("NUMCOT"  ,_cnum)
		ohtml:valbyname("VALIDADE",sc8->c8_valida)
		ohtml:valbyname("CODFOR"  ,_cfornece)
		ohtml:valbyname("LOJAFOR" ,_cloja)
		ohtml:valbyname("NOMEFOR" ,alltrim(sa2->a2_nome))
		ohtml:valbyname("ENDERECO",alltrim(sa2->a2_end))
		ohtml:valbyname("BAIRRO"  ,alltrim(sa2->a2_bairro))
		ohtml:valbyname("CIDADE"  ,alltrim(sa2->a2_mun))
		ohtml:valbyname("ESTADO"  ,sa2->a2_est)
		ohtml:valbyname("FONE"    ,alltrim(sa2->a2_tel))
		ohtml:valbyname("FAX"     ,alltrim(sa2->a2_fax))
		ohtml:valbyname("CONTATO" ,alltrim(sc8->c8_contato))
		ohtml:valbyname("EMAIL"   ,alltrim(sa2->a2_email))
		
		while ! sc8->(eof()) .and.;
			sc8->c8_filial==_cfilsc8 .and.;
			sc8->c8_num==_cnum .and.;
			sc8->c8_fornece==_cfornece .and.;
			sc8->c8_loja==_cloja
			
			sb1->(dbsetorder(1))
			sb1->(dbseek(_cfilsb1+sc8->c8_produto))
			
			aadd((ohtml:valbyname("TB.ITEM"       )),sc8->c8_item)
			aadd((ohtml:valbyname("TB.CODIGO"     )),alltrim(sc8->c8_produto))
			aadd((ohtml:valbyname("TB.DESCRICAO"  )),alltrim(sb1->b1_desc))
			aadd((ohtml:valbyname("TB.QUANTIDADE" )),alltrim(transform(sc8->c8_quant,"@E 999,999,999.99")))
			aadd((ohtml:valbyname("TB.UN"         )),sc8->c8_um)
			aadd((ohtml:valbyname("TB.NECESSIDADE")),dtoc(sc8->c8_datprf))
			aadd((ohtml:valbyname("TB.VALUNIT"    )),transform(0,"@E 999,999,999.999999"))
			aadd((ohtml:valbyname("TB.TOTAL"      )),transform(0,"@E 999,999,999.99"))
			aadd((ohtml:valbyname("TB.ICMS"       )),transform(0,"@E 99.99"))
			aadd((ohtml:valbyname("TB.IPI"        )),transform(0,"@E 99.99"))
			aadd((ohtml:valbyname("TB.PREVFAT"    )),"  /  /  ")
			aadd((ohtml:valbyname("TB.VENCPROD"   )),"  /  /  ")
			
			sc8->(dbskip())
		end
		
		ohtml:valbyname("SUBTOTAL" ,transform(0,"@E 999,999,999.99"))
		ohtml:valbyname("DESCONTO" ,transform(0,"@E 999,999,999.99"))
		ohtml:valbyname("TOTALICMS",transform(0,"@E 999,999,999.99"))
		ohtml:valbyname("TOTALIPI" ,transform(0,"@E 999,999,999.99"))
		ohtml:valbyname("FRETE"    ,transform(0,"@E 999,999,999.99"))
		ohtml:valbyname("TPFRETE"  ,{"CIF","FOB"})
		ohtml:valbyname("ENCFIN"   ,transform(0,"@E 999,999,999.99"))
		ohtml:valbyname("TOTALPED" ,transform(0,"@E 999,999,999.99"))
		ohtml:valbyname("CONDPAG"  ,_acond)
		
		_cdata:=alltrim(str(day(date()),2))+" de "+lower(mesextenso(date()))+" de "+str(year(date()),4)+"."
		
		ohtml:valbyname("DATA"     ,_cdata)
		ohtml:valbyname("COMPRADOR",alltrim(usrfullname(__cuserid)))
		ohtml:valbyname("EMAILCOMP",alltrim(usrretmail(__cuserid)))
		
		oprocess:csubject:="Vitamedic - Cotacao de Precos "+_cnum //21/02/2017 Luiz Fiuza
		oprocess:cto     :=_cpara
		oprocess:ccc     :=_ccc
		oprocess:breturn :="U_MT130WFR()" // RETORNO - ATUALIZA A COTACAO
		oprocess:btimeout:={{"U_MT130WFT()",10,0,0}} // TIMEOUT EM 10 DIAS
		rastreiawf(oprocess:fprocessid+"."+oprocess:ftaskid,oprocess:fproccode,"100001","COTACAO "+_cnum+" ENVIADA PARA O FORNECEDOR "+_cfornece+"/"+_cloja+"-"+sa2->a2_nome,cusername)
		oprocess:start()
		wfsendmail()
	else
		while ! sc8->(eof()) .and.;
			sc8->c8_filial==_cfilsc8 .and.;
			sc8->c8_num==_cnum .and.;
			sc8->c8_fornece==_cfornece .and.;
			sc8->c8_loja==_cloja
			
			sc8->(dbskip())
		end
	endif
end
return()

// TIMEOUT
user function mt130wft()
conout("TIMEOUT MT130WF")
return()

// RETORNO
user function mt130wfr(oprocess)
_cfilsc8:=xfilial("SC8")

_cnum     :=oprocess:ohtml:retbyname("NUMCOT")
_dvalidade:=ctod(oprocess:ohtml:retbyname("VALIDADE"))
_cfornece :=oprocess:ohtml:retbyname("CODFOR")
_cloja    :=oprocess:ohtml:retbyname("LOJAFOR")
_cnomefor :=oprocess:ohtml:retbyname("NOMEFOR")
_cendereco:=oprocess:ohtml:retbyname("ENDERECO")
_cbairro  :=oprocess:ohtml:retbyname("BAIRRO")
_ccidade  :=oprocess:ohtml:retbyname("CIDADE")
_cestado  :=oprocess:ohtml:retbyname("ESTADO")
_cfone    :=oprocess:ohtml:retbyname("FONE")
_cfax     :=oprocess:ohtml:retbyname("FAX")
_ccontato :=oprocess:ohtml:retbyname("CONTATO")
_cemail   :=oprocess:ohtml:retbyname("EMAIL")

_nsubtotal:=val(oprocess:ohtml:retbyname("SUBTOTAL"))
_ndesconto:=val(oprocess:ohtml:retbyname("DESCONTO"))
_ntoticms :=val(oprocess:ohtml:retbyname("TOTALICMS"))
_ntotipi  :=val(oprocess:ohtml:retbyname("TOTALIPI"))
_nfrete   :=val(oprocess:ohtml:retbyname("FRETE"))
_ctpfrete :=oprocess:ohtml:retbyname("TPFRETE")
_nencfin  :=val(oprocess:ohtml:retbyname("ENCFIN"))
_ntotalped:=val(oprocess:ohtml:retbyname("TOTALPED"))
_ccondpag :=oprocess:ohtml:retbyname("CONDPAG")

_cemailcom:=oprocess:ohtml:retbyname("EMAILCOMP")

_aitens:={}
for _ni:=1 to len(oprocess:ohtml:retbyname("TB.ITEM"))
	_citem    :=oprocess:ohtml:retbyname("TB.ITEM")[_ni]
	_ccodigo  :=oprocess:ohtml:retbyname("TB.CODIGO")[_ni]
	_cdesc    :=oprocess:ohtml:retbyname("TB.DESCRICAO")[_ni]
	_nquant   :=val(oprocess:ohtml:retbyname("TB.QUANTIDADE")[_ni])
	_cun      :=oprocess:ohtml:retbyname("TB.UN")[_ni]
	_dneces   :=ctod(oprocess:ohtml:retbyname("TB.NECESSIDADE")[_ni])
	_nvalunit :=val(oprocess:ohtml:retbyname("TB.VALUNIT")[_ni])
	_ntotal   :=val(oprocess:ohtml:retbyname("TB.TOTAL")[_ni])
	_nalicms  :=val(oprocess:ohtml:retbyname("TB.ICMS")[_ni])
	_nalipi   :=val(oprocess:ohtml:retbyname("TB.IPI")[_ni])
	_dprevfat :=ctod(oprocess:ohtml:retbyname("TB.PREVFAT")[_ni])
	_dvencprod:=ctod(oprocess:ohtml:retbyname("TB.VENCPROD")[_ni])
	_nprazoent:=_dprevfat-date()
	if _ctpfrete=="F"
		_nvalfre:=0
	else
		_nvalfre:=round(_nfrete*(_ntotal/_nsubtotal),2)
	endif
	
	aadd(_aitens,{_citem,_ccodigo,_cdesc,_nquant,_cun,_dneces,_nvalunit,_ntotal,_nalicms,_nalipi,_dprevfat,_dvencprod})
	
	sc8->(dbsetorder(1))
	if sc8->(dbseek(_cfilsc8+_cnum+_cfornece+_cloja+_citem))
		
		sc8->(reclock("SC8",.f.))
		sc8->c8_preco  :=_nvalunit
		sc8->c8_total  :=_ntotal
		sc8->c8_prazo  :=_nprazoent
		sc8->c8_aliipi :=_nalipi
		sc8->c8_picm   :=_nalicms
		sc8->c8_valfre :=_nvalfre
		sc8->c8_vldesc :=round(_ndesconto*(_ntotal/_nsubtotal),2)
		sc8->c8_valipi :=round(_ntotal*(_nalipi/100),2)
		sc8->c8_valicm :=round((_ntotal+_nvalfre)*(_nalicms/100),2)
		sc8->c8_baseicm:=_ntotal+_nvalfre
		sc8->c8_baseipi:=_ntotal
		sc8->c8_cond   :=substr(_ccondpag,1,3)
		sc8->c8_tpfrete:=substr(_ctpfrete,1,1)
		sc8->(msunlock())
	endif
next

rastreiawf(oprocess:fprocessid+"."+oprocess:ftaskid,oprocess:fproccode,"100002","Email respondido pelo fornecedor:"+_cfornece+"/"+_cloja+"-"+_cnomefor)

// ENVIA E-MAIL PARA O COMPRADOR INFORMANDO DA ATUALIZACAO DA COTACAO
//oprocess:=twfprocess():new("000005","COTACAO DE PRECOS")
oprocess:newtask("COTACAO","\workflow\cotacao atualizada.htm")

ohtml:=oprocess:ohtml

ohtml:valbyname("NUMCOT"  ,_cnum)
ohtml:valbyname("VALIDADE",dtoc(_dvalidade))
ohtml:valbyname("CODFOR"  ,_cfornece)
ohtml:valbyname("LOJAFOR" ,_cloja)
ohtml:valbyname("NOMEFOR" ,_cnomefor)
ohtml:valbyname("ENDERECO",_cendereco)
ohtml:valbyname("BAIRRO"  ,_cbairro)
ohtml:valbyname("CIDADE"  ,_ccidade)
ohtml:valbyname("ESTADO"  ,_cestado)
ohtml:valbyname("FONE"    ,_cfone)
ohtml:valbyname("FAX"     ,_cfax)
ohtml:valbyname("CONTATO" ,_ccontato)
ohtml:valbyname("EMAIL"   ,_cemail)

for _ni:=1 to len(_aitens)
	aadd((ohtml:valbyname("TB.ITEM"       )),_aitens[_ni,1])
	aadd((ohtml:valbyname("TB.CODIGO"     )),_aitens[_ni,2])
	aadd((ohtml:valbyname("TB.DESCRICAO"  )),_aitens[_ni,3])
	aadd((ohtml:valbyname("TB.QUANTIDADE" )),alltrim(transform(_aitens[_ni,4],"@E 999,999,999.99")))
	aadd((ohtml:valbyname("TB.UN"         )),_aitens[_ni,5])
	aadd((ohtml:valbyname("TB.NECESSIDADE")),dtoc(_aitens[_ni,6]))
	aadd((ohtml:valbyname("TB.VALUNIT"    )),alltrim(transform(_aitens[_ni,7],"@E 999,999,999.999999")))
	aadd((ohtml:valbyname("TB.TOTAL"      )),alltrim(transform(_aitens[_ni,8],"@E 999,999,999.99")))
	aadd((ohtml:valbyname("TB.ICMS"       )),alltrim(transform(_aitens[_ni,9],"@E 99.99")))
	aadd((ohtml:valbyname("TB.IPI"        )),alltrim(transform(_aitens[_ni,10],"@E 99.99")))
	aadd((ohtml:valbyname("TB.PREVFAT"    )),dtoc(_aitens[_ni,11]))
	aadd((ohtml:valbyname("TB.VENCPROD"   )),dtoc(_aitens[_ni,12]))
next

ohtml:valbyname("SUBTOTAL" ,transform(_nsubtotal,"@E 999,999,999.99"))
ohtml:valbyname("DESCONTO" ,transform(_ndesconto,"@E 999,999,999.99"))
ohtml:valbyname("TOTALICMS",transform(_ntoticms,"@E 999,999,999.99"))
ohtml:valbyname("TOTALIPI" ,transform(_ntotipi,"@E 999,999,999.99"))
ohtml:valbyname("FRETE"    ,transform(_nfrete,"@E 999,999,999.99"))
ohtml:valbyname("TPFRETE"  ,_ctpfrete)
ohtml:valbyname("ENCFIN"   ,transform(_nencfin,"@E 999,999,999.99"))
ohtml:valbyname("TOTALPED" ,transform(_ntotalped,"@E 999,999,999.99"))
ohtml:valbyname("CONDPAG"  ,_ccondpag)

_cpara:="report_suprimentos@vitamedic.ind.br" // _cemailcom
_ccc:="report@vitamedic.ind.br" // _cemailcom

oprocess:csubject:="Vitamedic - Cotacao de Precos Atualizada "+_cnum //21/02/2017 Luiz Fiuza
oprocess:cto     :=_cpara
oprocess:ccc     :=_ccc
oprocess:breturn :=""
oprocess:btimeout:={}
rastreiawf(oprocess:fprocessid+"."+oprocess:ftaskid,oprocess:fproccode,"100003","COTACAO "+_cnum+" ATUALIZADA ENVIADA PARA O COMPRADOR",cusername)
oprocess:start()
wfsendmail()
return()
