/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao ³ VIT344 ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 12/06/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emissao da Pre-Nota Html ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso ³ Especifico para Vitapan ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao ³ 1.0 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function vit344()
titulo := "EMISSAO DA PRE-NOTA HTML"
cdesc1 := "Este programa ira emitir a pre-nota em formato HTML"
cdesc2 := ""
cdesc3 := ""
tamanho := "M"
limite := 132
cstring :="SC5"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT344"
aLinha :={}
nlastkey:=0
lcontinua:=.t.
wDescVitNF := 0

//Acrescentado para impressão de relatorio pela tela de pedido.
if FUNNAME() == "MATA410" 
	MV_PAR01 := SC5->C5_NUM
	MV_PAR02 := SC5->C5_NUM
	MV_PAR03 := 4
else
	cperg:="PERGVIT344"
	_pergsx1()
	pergunte(cperg,.f.)
	wnrel:="VIT344"+Alltrim(cusername)
	wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)
endif
//Acrescentado para impressão de relatorio pela tela de pedido.
if nlastkey==27
set filter to
return
endif

setdefault(areturn,cstring)

ntipo:=if(areturn[4]==1,15,18)

if nlastkey==27
set filter to
return
endif
rptstatus({|| rptdetail()})
return

static function rptdetail()
cbcont:=0
_mpag:=1
_nlinha :=1
li :=80
cbtxt :=space(10)

_cestado :=getmv("MV_ESTADO")
_cnorte :=getmv("MV_NORTE")
_nicmpad :=getmv("MV_ICMPAD")
_c:=1
_limprime:=.f.

_cfilda0:=xfilial("DA0")
_cfilsa1:=xfilial("SA1")
_cfilsa3:=xfilial("SA3")
_cfilsa4:=xfilial("SA4")
_cfilsb1:=xfilial("SB1")
_cfilsc5:=xfilial("SC5")
_cfilsc6:=xfilial("SC6")
_cfilsc9:=xfilial("SC9")
_cfilse4:=xfilial("SE4")
_cfilsf4:=xfilial("SF4")
_cfilsf7:=xfilial("SF7")

da0->(dbsetorder(1))
sa1->(dbsetorder(1))
sa3->(dbsetorder(1))
sa4->(dbsetorder(1))
sb1->(dbsetorder(1))
sc5->(dbsetorder(1))
sc6->(dbsetorder(1))
sc9->(dbsetorder(1))
se4->(dbsetorder(1))
sf4->(dbsetorder(1))
sf7->(dbsetorder(1))

setregua(val(mv_par02)-val(mv_par01))

sc5->(dbseek(_cfilsc5+mv_par01,.t.))

//³ INÍCIO DO CÓDIGO HTML

_itens:=.f.

_cMsg := ''
_cMsg += '<html>'
_cMsg += '<head>'
_cMsg += '<title>Pr&eacute; Nota</title>'
_cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
_cMsg += '</head>'
_cMsg += '<body>'

while ! sc5->(eof()) .and. sc5->c5_filial==_cfilsc5 .and. sc5->c5_num<=mv_par02 .and. sc5->c5_num>=mv_par01 .and. lcontinua

incregua()
if sc5->c5_tipo=="N" // .or. sc5->c5_tipo=="O"
da0->(dbseek(_cfilda0+sc5->c5_tabela))
sa1->(dbseek(_cfilsa1+sc5->c5_cliente+sc5->c5_lojacli))
sa4->(dbseek(_cfilsa4+sc5->c5_transp))
se4->(dbseek(_cfilse4+sc5->c5_condpag))

if mv_par03==1 .or. mv_par03==3 .or. mv_par03==4 // Pendencia, faturado ou total
sc6->(dbseek(_cfilsc6+sc5->c5_num))

_fatorpos:=0.7234
if sa1->a1_est = "RJ" // 19%
_fatorneg:=0.7523
elseif sa1->a1_est $ "SP#MG" // 18%
_fatorneg:=0.7519
elseif sa1->a1_est = "PR" // 12%
_fatorneg:=0.7499
// elseif sa1->a1_est = "AM#AC#AP#RO" // Zona Franca
elseif da0->da0_status = "Z" // Zona Franca
_fatorneg:=0.7234
else
_fatorneg:=0.7515 // 17%
endif
if sc5->c5_percfat==100
_npicm :=0
_nbaseicm :=0
_nvalicm :=0
_nbaseret :=0
_nvalret :=0
_nbasegnr :=0
_nvalgnr :=0
_ndesczf :=0
_nvalmerc :=0
_ntotitens:=0
_nrepasse :=0
_nprep :=0
_amentes :={}
_limpcab :=.f.
_limprime :=.f.
_nprmax := 0
_nvalmax :=0
_npr := 0
_leitens(1)
_c:=1
else
_nregsc6:=sc6->(recno())
for _c:=1 to 2
_npicm :=0
_nbaseicm:=0
_nvalicm :=0
_nbaseret:=0
_nvalret :=0
_nbasegnr:=0
_nvalgnr :=0
_ndesczf :=0
_nvalmerc:=0
_ntotitens:=0
_nrepasse:=0
_nprep :=0
_amentes :={}
_limpcab :=.f.
_limprime:=.f.
_nprmax := 0
_nvalmax :=0
_npr := 0

if _c==2
sc6->(dbgoto(_nregsc6))
_mpag:=1
endif
_leitens(1)
next
endif

else // Liberado
sc9->(dbseek(_cfilsc9+sc5->c5_num))
_nregsc9:=sc9->(recno())
_lcont:=.t.
while ! sc9->(eof()) .and.;
sc9->c9_filial==_cfilsc9 .and.;
sc9->c9_pedido==sc5->c5_num .and.;
_lcont
if empty(sc9->c9_nfiscal)
if ! empty(sc9->c9_blest) .or. ! empty(sc9->c9_blcred)
_lcont:=.f.
endif
endif
sc9->(dbskip())
end
if _lcont
if sc5->c5_percfat==100
_npicm :=0
_nbaseicm:=0
_nvalicm :=0
_nbaseret:=0
_nvalret :=0
_nbasegnr:=0
_nvalgnr :=0
_ndesczf :=0
_nvalmerc:=0
_ntotitens:=0
_nrepasse:=0
_nprep :=0
_amentes :={}
_limpcab :=.f.
_limprime:=.f.
_nprmax := 0
_nvalmax :=0
_npr := 0
_c:=1

sc9->(dbgoto(_nregsc9))
_leitens(2)
else
for _c:=1 to 2
_npicm :=0
_nbaseicm:=0
_nvalicm :=0
_nbaseret:=0
_nvalret :=0
_nbasegnr:=0
_nvalgnr :=0
_ndesczf :=0
_nvalmerc:=0
_ntotitens:=0
_nrepasse:=0
_nprep :=0
_amentes :={}
_limpcab :=.f.
_limprime:=.f.
_nprmax := 0
_nvalmax :=0
_npr := 0
_mpag:=1
sc9->(dbgoto(_nregsc9))
_leitens(2)
next
endif
endif
endif
endif
sc5->(dbskip())

if !sc5->(eof()) .and.;
(sc5->c5_filial==_cfilsc5) .and.;
(sc5->c5_num<=mv_par02)

// quebra a pagina
_cMsg += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
_cMsg += "<br clear=all style='page-break-before:always'>"
_cMsg += '</span>'
_limpcab:=.t.
_mpag++
_nlinha:=1
endif

if labortprint
eject
lcontinua:=.f.
endif
end


_cMsg += '</body>'
_cMsg += '</html>'

//³ cria o arquivo em disco prenota.html e executa-o em seguida
_carquivo:="C:\WINDOWS\TEMP\PRENOTA.HTML"
nHdl := fCreate(_carquivo)
fWrite(nHdl,_cMsg,Len(_cMsg))
fClose(nHdl)
ExecArq(_carquivo)

set device to screen

ms_flush()
return

static function _leitens(_ntipo)
if _ntipo==1
while ! sc6->(eof()) .and.;
sc6->c6_filial==_cfilsc6 .and.;
sc6->c6_num==sc5->c5_num
if sc6->c6_blq<>"R "
sb1->(dbseek(_cfilsb1+sc6->c6_produto))
_ccateg:=left(sb1->b1_categ,1)
da0->(dbseek(_cfilda0+sc5->c5_tabela))
if if(sc5->c5_percfat==100,.t.,if(_c==1,_ccateg=="I" .or. da0->da0_status=="Z",_ccateg $ "NO" .and. da0->da0_status<>"Z"))
sf4->(dbseek(_cfilsf4+sc6->c6_tes))

// PREC.MAX CONSUMIDOR
if sc5->c5_tipocli="S" .AND. sf4->f4_stdesc = "2"
_npr:=round(sc6->c6_prunit,2)
else
_npr:=round(sc6->c6_prcven,2)
endif
///

if mv_par03==1 // Pendencia
_nqtd:=sc6->c6_qtdven-sc6->c6_qtdent-sc6->c6_qtdemp
if _nqtd>0
_nvalor:=round(_nqtd*sc6->c6_prcven,2)
_nvalst:=round(_nqtd*_npr,2)
_vericm()
_impitem()
endif
elseif mv_par03==3 // Faturado
_nqtd:=sc6->c6_qtdent
if _nqtd>0
_nvalor:=round(_nqtd*sc6->c6_prcven,2)
_nvalst:=round(_nqtd*_npr,2)
_vericm()
_impitem()
endif
elseif mv_par03==4 // Total
_nqtd:=sc6->c6_qtdven
_nvalor:=round(_nqtd*sc6->c6_prcven,2)
_nvalst:=round(_nqtd*_npr,2)
_vericm()
_impitem()
endif
endif
endif
sc6->(dbskip())
end
else
while ! sc9->(eof()) .and.;
sc9->c9_filial==_cfilsc9 .and.;
sc9->c9_pedido==sc5->c5_num
if empty(sc9->c9_nfiscal) .and.;
empty(sc9->c9_blest) .and.;
empty(sc9->c9_blcred)
sc6->(dbseek(_cfilsc6+sc9->c9_pedido+sc9->c9_item+sc9->c9_produto))
sb1->(dbseek(_cfilsb1+sc6->c6_produto))
da0->(dbseek(_cfilda0+sc5->c5_tabela))
_ccateg:=left(sb1->b1_categ,1)
if if(sc5->c5_percfat==100,.t.,if(_c==1,_ccateg=="I" .or. da0->da0_status=="Z",_ccateg $ "NO" .and. da0->da0_status<>"Z" ))
sf4->(dbseek(_cfilsf4+sc6->c6_tes))

// PREC.MAX CONSUMIDOR
if sc5->c5_tipocli="S" .AND. sf4->f4_stdesc = "2" // sc5->c5_licitac <> "S"
_npr:=round(sc6->c6_prunit,2)
else
_npr:=round(sc6->c6_prcven,2)
endif
///

_nqtd :=sc9->c9_qtdlib
_nvalor:=round(_nqtd*sc6->c6_prcven,2)
_nvalst:=round(_nqtd*_npr,2)
_vericm()
_impitem()
endif
endif
sc9->(dbskip())
end
endif
_improd()
return

static function _impcab()
if _mpag==1
_limpcab:=.t.
_mpag++
endif

if _limpcab
_limprime:=.t.
_limpcab:=.f.

// Dados da Empresa
_cMsg += '<table border="1" cellspacing="0" cellpadding="0" width="770" bordercolor="#000000" style="border-collapse: collapse">'
_cMsg += '<tr>'
_cMsg += '<td width="176" valign="top">'
_cMsg += '<table width="175" border="0" cellpadding="0" cellspacing="0">'
_cMsg += '<tr>'
_cMsg += '<td>'
_cMsg += '<p align="left"><font face="Arial Black" size="5">VITAMEDIC</font><br />'
_cMsg += '</td>'
_cMsg += '</tr>'
_cMsg += '<tr>'
_cMsg += '<td>'
_cMsg += '<p align="left"><font face=arial,verdana size=1>'+rtrim(sm0->m0_endcob)+' <br />'
_cMsg += rtrim(sm0->m0_cidcob)+' - '+sm0->m0_estcob+' <br />
_cMsg += 'CEP: '+transform((sm0->m0_cepcob),'@R 99999-999')+' <br />'
_cMsg += 'TEL.: '+alltrim(sm0->m0_tel)+' <br />'
_cMsg += 'CNPJ: '+transform((sm0->m0_cgc),'@R 99.999.999/9999-99')+'</font></p>'
_cMsg += '</td></tr></table></td>'

// Dados do Cliente
_cMsg += '<td width="446" valign="top">'
_cMsg += '<p><font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font><br />'
_cMsg += '<font face=arial,verdana size=3><b>'+sc5->c5_cliente+'/'+sc5->c5_lojacli+'-'+sa1->a1_nome+'</b></font></p>'
_cMsg += '<p><font face=arial,verdana size=1>'+sa1->a1_end+'<br />'
_cMsg += rtrim(sa1->a1_mun)+' - '+sa1->a1_est + replicate(" ",50-len(rtrim(sa1->a1_mun)+' - '+sa1->a1_est))
_cMsg +='CEP: '+transform((sa1->a1_cep),'@R 99999-999')+'<br />'
_cMsg += 'TEL.: ('+alltrim(sa1->a1_ddd)+') '+alltrim(sa1->a1_tel)+'<br />'
_cMsg += 'CNPJ: '+transform((sa1->a1_cgc),'@R 99.999.999/9999-99')+' INSCRI&Ccedil;&Atilde;O ESTADUAL: '+sa1->a1_inscr+'<br /></font></p></td>'

// Dados do Pedido
_cMsg += '<td width="148" valign="top">'
_cMsg += '<font face=arial,verdana size=2><center>&nbsp; </center>'
_cMsg += '<center>Pedido nº '+sc5->c5_num+'</center>'
_cMsg += '<center>'+if(mv_par03==1,'Pendencia',if(mv_par03==2,'Liberado',if(mv_par03==3,'Faturado','Total')))+'</center> <br />'
_cMsg += '<center>'+dtoc(sc5->c5_emissao)+'</center></font>'
_cMsg += '</td></tr></table><br />'


_cMsg += '<table border="1" cellspacing="0" cellpadding="0" width="770" style="border-collapse:collapse" bordercolor="#000000">'

sa3->(dbseek(_cfilsa3+sc5->c5_vend1))
_cMsg += '<tr><td width="522" colspan="3"><p><font face="Arial, Verdana" size="2"><b>Vendedor: </b>'+sc5->c5_vend1+' - '+sa3->a3_nome+'</font></p></td>'
_cMsg += '<td width="248"><p><font face="Arial, Verdana" size="2"><b>Comissão: </b>'+transform(sc5->c5_comis1,"@E 99.99")+'%</font></p></td></tr>'
_cMsg += '<tr><td width="522" colspan="3"><p><font face="Arial, Verdana" size="2"><b>Tabela: </b>'+sc5->c5_tabela+' - '+da0->da0_descri+'</font></p></td>'
_cMsg += '<td width="248"><p><font face="Arial, Verdana" size="2"><b>Desc. Itens:</b>'+transform(sc5->c5_descit,"@E 99.99")+'%</font></p></td></tr>'
_cMsg += '<tr><td width="332" colspan="2"><p><font face="Arial, Verdana" size="2"><b>Descontos: </b>'+transform(sc5->c5_desc1,"@E 99.99")+'% + '
_cMsg += transform(sc5->c5_desc2,"@E 99.99")+'% + '+transform(sc5->c5_desc3,"@E 99.99")+'% + '+transform(sc5->c5_desc4,"@E 99.99")+'</font></p></td>'
_cMsg += '<td width="190"><p><font face="Arial, Verdana" size="2"><b>Promoção: </b>'
_cMsg += if(sc5->c5_promoc=="N","Normal", if(sc5->c5_promoc=="M","M&aacute;ximo", if(sc5->c5_promoc=="P","Promo&ccedil;&atilde;o","Final")))+'</font></p></td>'
_cMsg += '<td width="248"><p><font face="Arial, Verdana" size="2"><b>Cond. Pgto.: </b>'+sc5->c5_condpag+" - "+se4->e4_descri+'</font></p></td></tr>'
_cMsg += '<tr><td width="248"><p><font face="Arial, Verdana" size="2"><b>Tipo Cliente: </b>'
_cMsg += if(sc5->c5_tipocli=="R","Revendedor",if(sc5->c5_tipocli=="F","Consumidor Final",if(sc5->c5_tipocli=="X","Exporta&ccedil;&atilde;o",if(sc5->c5_tipocli=="S","Solid&aacute;rio","Produto Rural"))))+'</font></p></td>'
_cMsg += '<td width="522" colspan="3"><p><font face="Arial, Verdana" size="2"><b>Transportadora: </b>'+sc5->c5_transp+" - "+sa4->a4_nome+'</font></p></td></tr>'
_cMsg += '</table>'

_cMsg += '<br />'

// Cabeçalho tabela de Itens

_cMsg += '<table border=1 cellspacing=0 cellpadding=0 width=770 bordercolor="#000000" style="border-collapse:collapse">'
_cMsg += '<tr><td width=31><p align="center"><font face="Arial, Verdana" size="1"><b>Item</b></font></p></td>'
_cMsg += '<td width=265><p align="center"><font face="Arial, Verdana" size="1"><b>Produto</b></font></p></td>'
_cMsg += '<td width=29><p align="center"><font face="Arial, Verdana" size="1"><b>UM</b></font></p></td>'
_cMsg += '<td width=73><p align="center"><font face="Arial, Verdana" size="1"><b>Quantidade</b></font></p></td>'
_cMsg += '<td width=94><p align="center"><font face="Arial, Verdana" size="1"><b>Preço Unit.</b></font></p></td>'
_cMsg += '<td width=69><p align="center"><font face="Arial, Verdana" size="1"><b>Vlr. Total</b></font></p></td>'
_cMsg += '<td width=41><p align="center"><font face="Arial, Verdana" size="1"><b>Desc.</b></font></p></td>'
_cMsg += '<td width=28><p align="center"><font face="Arial, Verdana" size="1"><b>TES</b></font></p></td>'
_cMsg += '<td width=32><p align="center"><font face="Arial, Verdana" size="1"><b>ICM</b></font></p></td>'
_cMsg += '<td width=34><p align="center"><font face="Arial, Verdana" size="1"><b>Prom</b></font></p></td>'
_cMsg += '<td width=26><p align="center"><font face="Arial, Verdana" size="1"><b>Cat</b></font></p></td>'
_cMsg += '<td width=48><p align="center"><font face="Arial, Verdana" size="1"><b>Pr.Max.</b></font></p></td></tr>'

endif
return

static function _impitem()
_impcab()
_nprmax:= 0
_fatorpos:=0.7234

if sa1->a1_est = "RJ" // 19%
_fatorneg:=0.7523
elseif sa1->a1_est $ "SP#MG" // 18%
_fatorneg:=0.7519
elseif sa1->a1_est = "PR" // 12%
_fatorneg:=0.7499
//elseif sa1->a1_est $ "AM#AC#AP#RO"
elseif da0->da0_status = "Z" // Zona Franca
_fatorneg:=0.7234
else
_fatorneg:=0.7515 // 17%
endif

if sc5->c5_desc3>0
_npreco :=round(sc6->c6_prcven/(1-sc5->c5_desc3/100),6)
_ntotal :=round(_nqtd*_npreco,2)
_nprep :=sc5->c5_desc3
_nrepasse+=_ntotal-_nvalor
if sb1->b1_categ $ "NO"
_nprmax:=round(sc6->c6_prunit/_fatorneg,6)
else
_nprmax:=round(sc6->c6_prunit/_fatorpos,6)
endif
else
if sc5->c5_licitac <> "S"
if sb1->b1_categ $ "NO"
_nprmax:=round(sc6->c6_prunit/_fatorneg,6)
else
_nprmax:=round(sc6->c6_prunit/_fatorpos,6)
endif
else
if sb1->b1_categ $ "NO"
_nprmax:=round(sc6->c6_prcven/_fatorneg,6)
else
_nprmax:=round(sc6->c6_prcven/_fatorpos,6)
endif
endif
_npreco :=sc6->c6_prcven
_ntotal :=_nvalor
endif

_nlinha++
_cMsg += '<tr><td><p align="center"><font face="Arial, Verdana" size="1">'+sc6->c6_item+'</font></p></td>'
_cMsg += '<td><p align="left"><font face="Arial, Verdana" size="1">'+left(sc6->c6_produto,6)+'-'+sb1->b1_desc+'</font></p></td>'
_cMsg += '<td><p align="center"><font face="Arial, Verdana" size="1">'+sb1->b1_um+'</font></p></td>'
_cMsg += '<td><p align="right"><font face="Arial, Verdana" size="1">'+transform(_nqtd,"@E 999,999,999.99999")+'</font></p></td>'
_cMsg += '<td><p align="right"><font face="Arial, Verdana" size="1">'+transform(_npreco,"@E 999,999.999999")+'</font></p></td>'
_cMsg += '<td><p align="right"><font face="Arial, Verdana" size="1">'+transform(_ntotal,"@E 999,999,999.99999")+'</font></p></td>'
_cMsg += '<td><p align="right"><font face="Arial, Verdana" size="1">'+transform(sc6->c6_descpr,"@E 99.99")+'</font></p></td>'
_cMsg += '<td><p align="center"><font face="Arial, Verdana" size="1">'+sc6->c6_tes+'</font></p></td>'
_cMsg += '<td><p align="center"><font face="Arial, Verdana" size="1">'+transform(_npicm,"@E 99")+'</font></p></td>'
_cMsg += '<td><p align="center"><font face="Arial, Verdana" size="1">'+sc6->c6_promoc+'</font></p></td>'
_cMsg += '<td><p align="center"><font face="Arial, Verdana" size="1">'+sb1->b1_categ+'</font></p></td>'
_cMsg += '<td><p align="right"><font face="Arial, Verdana" size="1">'+transform(_nprmax,"@E 9999.99")+'</font></p></td></tr>'

_ntotitens+=_ntotal
_nvalmerc+=_nvalor
_nvalmax += _nprmax*_nqtd
if ! empty(sf4->f4_formula)
_i:=ascan(_amentes,sf4->f4_formula)
if _i==0
aadd(_amentes,sf4->f4_formula)
endif
endif

if _nlinha>35
// quebra a pagina

_cMsg += '</table>'
_cMsg += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
_cMsg += "<br clear=all style='page-break-before:always'>"
_cMsg += '</span>'
_limpcab:=.t.
_impcab()
_nlinha:=1
_mpag:=1
endif

return

static function _improd()
if _limprime

_cMsg += '<tr><td width=492 colspan=5><p align="left"><font face="Arial, Verdana" size="1"> TOTAL MERCADORIAS</font></p></td>'
// _cMsg += '<td width=69><p align="right"><font face="Arial, Verdana" size="1">'+transform(_nvalmerc,"@E 999,999,999.99")+'</font></p></td>'
_cMsg += '<td width=69><p align="right"><font face="Arial, Verdana" size="1">'+transform(_ntotitens,"@E 999,999,999.99")+'</font></p></td>'
_cMsg += '<td width=209 colspan=6><p align="right"><font face="Arial, Verdana" size="1">'+transform(_nvalmax,"@E 999,999,999.99")+'</font></p></td></tr></table>'

_cMsg += '<br />'

_cMsg += '<table border="1" cellspacing="0" cellpadding="0" width="770" bordercolor="#000000" style="border-collapse:collapse">'
_cMsg += '<tr><td width=769 valign="top"><p><b><font face="Arial, Verdana" size="1">&nbsp;</font></b><br />'
_cMsg += '<b><font face="Arial, Verdana" size="1">Mensagens da Nota Fiscal</font></b><br />'
_cMsg += '<font face="Arial, Verdana" size="1">'

if _nrepasse>0
_cMsg += 'DESCONTO REF. REPASSE '+transform(_nprep,"@E 99.99")+'%: '+transform(_nrepasse,"@E 999,999,999.99")+'<br />'
endif

if _ndesczf>0
_cMsg += 'SUFRAMA '+sa1->a1_suframa+' - Deducao de 12% de ICMS:'+transform(_ndesczf,"@E 999,999,999.99")+'<br />'
_nvalmerc-=_ndesczf
endif

for _i:=1 to len(_amentes)
_cMsg += formula(_amentes[_i])+'<br />'
next

if ! empty(sc5->c5_menpad)
_cMsg += formula(sc5->c5_menpad)+'<br />'
endif

if ! empty(sc5->c5_mennota)
_cMsg += sc5->c5_mennota+'<br /></font>'
endif

if ! empty(SC5->C5_PDESCAB)
//*****************************************************
// Roberto Fiuza 06/08/15 desconto NF 
wDescVitNF := (_nvalmerc+_nvalret) * ( SC5->C5_PDESCAB / 100 )
_cMsg += 'DESCONTO NF ' + ALLTRIM(STR(SC5->C5_PDESCAB,5,2)) + '% NO VALOR DE ' + ALLTRIM(transform(wDescVitNF,"@E 999,999,999.99")) +'<br /></font>'
endif



_cMsg += '<b><font face="Arial, Verdana" size="1">&nbsp;</font></p></td></tr></table>'
_cMsg += '<br />'

// Tabela de Impostos
_cMsg += '<table border="1" cellspacing="0" cellpadding="0" width="770" bordercolor="#000000" style="border-collapse:collapse">'
_cMsg += '<tr><td width=128 bgcolor="#D9D9D9"><center><b><font face="Arial, Verdana" size="1">BASE ICMS</font></b></center></td>'
_cMsg += '<td width=128 bgcolor="#D9D9D9"><center><b><font face="Arial, Verdana" size="1">VALOR ICMS</font></b></center></td>'
_cMsg += '<td width=128 bgcolor="#D9D9D9"><center><b><font face="Arial, Verdana" size="1">BASE SUBS.</font></b></center></td>'
_cMsg += '<td width=128 bgcolor="#D9D9D9"><center><b><font face="Arial, Verdana" size="1">VAL.ICMS SUBS.</font></b></center></td>'
_cMsg += '<td width=129 bgcolor="#D9D9D9"><center><b><font face="Arial, Verdana" size="1">TOTAL MERCADORIA</font></b></center></td>'
_cMsg += '<td width=129 bgcolor="#D9D9D9"><center><b><font face="Arial, Verdana" size="1">TOTAL DA NOTA</font></b></center></td></tr>'
_cMsg += '<tr><td align="right"><font face="Arial, Verdana" size="1">'+transform(_nbaseicm,"@E 999,999,999.99")+'</font></td>'
_cMsg += '<td align="right"><font face="Arial, Verdana" size="1">'+transform(_nvalicm,"@E 999,999,999.99")+'</font></td>'
_cMsg += '<td align="right"><font face="Arial, Verdana" size="1">'+transform(_nbaseret,"@E 999,999,999.99")+'</font></td>'
_cMsg += '<td align="right"><font face="Arial, Verdana" size="1">'+transform(_nvalret,"@E 999,999,999.99")+'</font></td>'
_cMsg += '<td align="right"><font face="Arial, Verdana" size="1">'+transform(_nvalmerc,"@E 999,999,999.99")+'</font></td>'
_cMsg += '<td align="right"><font face="Arial, Verdana" size="1">'+transform(_nvalmerc+_nvalret-wDescVitNF,"@E 999,999,999.99")+'</font></td></tr></table>'

if sc5->c5_geragnr=="S"
_cMsg += '<br />'
_cMsg += '<table border="1" cellspacing="0" cellpadding="0" width="256" bordercolor="#000000" style="border-collapse:collapse">'
_cMsg += '<tr><td width=128 bgcolor="#D9D9D9"><center><b><font face="Arial, Verdana" size="1">BASE GNR</font></b></center></td>'
_cMsg += '<td width=128 bgcolor="#D9D9D9"><center><b><font face="Arial, Verdana" size="1">VALOR GNR</font></b></center></td>'
_cMsg += '<tr><td align="right"><font face="Arial, Verdana" size="1">'+transform(_nbasegnr, "@E 999,999,999.99")+'</font></td>'
_cMsg += '<td align="right"><font face="Arial, Verdana" size="1">'+transform(_nvalgnr, "@E 999,999,999.99")+'</font></td></tr></table>'
endif

if _c==1
// quebra a pagina
_cMsg += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
_cMsg += "<br clear=all style='page-break-before:always'>"
_cMsg += '</span>'
_limpcab:=.t.
_nlinha:=1
_limprime:=.f.
endif
endif
return

static function _vericm()
_nbaseicmp:=0
_nvalicmp :=0
if sf4->f4_icm=="S"
if (sc5->c5_tipocli=="F" .and.;
empty(sa1->a1_inscr)) .or. sf4->f4_tpmov="U"
_npicm:=if(sb1->b1_picm>0,sb1->b1_picm,_nicmpad)
elseif sa1->a1_est==_cestado
_npicm:=if(sb1->b1_picm>0,sb1->b1_picm,_nicmpad)
elseif sa1->a1_est$_cnorte .and.;
at(_cestado,_cnorte)==0
_npicm:=7
elseif sc5->c5_tipocli=="X"
_npicm:=13
else
_npicm:=12
endif

_nbaseicmp+=_nvalor
if sf4->f4_baseicm>0
_nbaseicmp:=noround(_nbaseicmp*(sf4->f4_baseicm/100),2)
endif
_nvalicmp:=noround(_nbaseicmp*(_npicm/100),2)

if sa1->a1_calcsuf $ "I/S" .and.;
! empty(sa1->a1_suframa) .and.;
sc5->c5_tipocli<>"F" .and. sf4->f4_tpmov<>"U"
_ndesczf+=_nvalicmp
else
_nbaseicm+=_nbaseicmp
_nvalicm +=_nvalicmp
endif

if sc5->c5_tipocli=="S" .and.;
sf4->f4_incsol=="S"
sf7->(dbseek(_cfilsf7+sb1->b1_grtrib+sa1->a1_grptrib))
_lok:=.f.
while ! sf7->(eof()) .and.;
sf7->f7_filial==_cfilsf7 .and.;
alltrim(sf7->f7_grtrib)==alltrim(sb1->b1_grtrib) .and.;
sf7->f7_grpcli==sa1->a1_grptrib .and.;
! _lok
if sf7->f7_est==sa1->a1_est
_lok:=.t.
_nbaseretp:=noround(_nvalst*(1+sf7->f7_margem/100),2)
if sf4->f4_bsicmst>0
_nbaseretp:=noround(_nbaseretp*(sf4->f4_bsicmst/100),2)
endif
_nvalretp:=noround(_nbaseretp*(sf7->f7_aliqdst/100),2)-_nvalicmp
_nbaseret+=_nbaseretp
_nvalret +=_nvalretp
endif
sf7->(dbskip())
end
elseif sc5->c5_geragnr=="S"
sf7->(dbseek(_cfilsf7+sb1->b1_grtrib+sa1->a1_grptrib))
_lok:=.f.
while ! sf7->(eof()) .and.;
sf7->f7_filial==_cfilsf7 .and.;
alltrim(sf7->f7_grtrib)==alltrim(sb1->b1_grtrib) .and.;
sf7->f7_grpcli==sa1->a1_grptrib .and.;
! _lok
if sf7->f7_est==sa1->a1_est
_lok:=.t.
_nbasegnrp:=noround(_nvalor*(1+sf7->f7_margem/100),2)
if sf7->f7_bsicmst>0
_nbasegnrp:=noround(_nbasegnrp*(sf7->f7_bsicmst/100),2)
endif
_nvalgnrp:=noround(_nbasegnrp*(sf7->f7_aliqdst/100),2)-_nvalicmp
_nbasegnr+=_nbasegnrp
_nvalgnr +=_nvalgnrp
endif
sf7->(dbskip())
end
endif
endif


return



//***********************************************************************
Static Function ExecArq(_carquivo)
//***********************************************************************
LOCAL cDrive := ""
LOCAL cDir := ""
LOCAL cPathFile := ""
LOCAL cCompl := ""
LOCAL nRet := 0

//³ Retira a ultima barra invertida ( se houver )
cPathFile := _carquivo

SplitPath(cPathFile, @cDrive, @cDir )
cDir := Alltrim(cDrive) + Alltrim(cDir)

//³ Faz a chamada do aplicativo associado ³
nRet := ShellExecute( "Open", cPathFile,"",cDir, 1)

If nRet <= 32
cCompl := ""
If nRet == 31
cCompl := " Nao existe aplicativo associado a este tipo de arquivo!"
EndIf
Aviso( "Atencao !", "Nao foi possivel abrir o objeto '" + AllTrim(cPathFile) + "'!" + cCompl, { "Ok" }, 2 )
EndIf

Return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do pedido ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01" ,space(15) ,space(30),space(15),space(15) ,space(30),space(15),space(15) ,space(30),space(15),space(15) ,space(30),space(15),space(15) ,space(30)," "})
aadd(_agrpsx1,{cperg,"02","Ate o pedido ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02" ,space(15) ,space(30),space(15),space(15) ,space(30),space(15),space(15) ,space(30),space(15),space(15) ,space(30),space(15),space(15) ,space(30)," "})
aadd(_agrpsx1,{cperg,"03","Imprime ?","mv_ch3","N",01,0,0,"C",space(60),"mv_par03" ,"Pendencia" ,space(30),space(15),"Liberado" ,space(30),space(15),"Faturado" ,space(30),space(15),"Total" ,space(30),space(15),space(15) ,space(30)," "})

for _i:=1 to len(_agrpsx1)
if ! sx1->(dbseek(_agrpsx1[_i,1]+_agrpsx1[_i,2]))
sx1->(reclock("SX1",.t.))
sx1->x1_grupo :=_agrpsx1[_i,01]
sx1->x1_ordem :=_agrpsx1[_i,02]
sx1->x1_pergunt:=_agrpsx1[_i,03]
sx1->x1_variavl:=_agrpsx1[_i,04]
sx1->x1_tipo :=_agrpsx1[_i,05]
sx1->x1_tamanho:=_agrpsx1[_i,06]
sx1->x1_decimal:=_agrpsx1[_i,07]
sx1->x1_presel :=_agrpsx1[_i,08]
sx1->x1_gsc :=_agrpsx1[_i,09]
sx1->x1_valid :=_agrpsx1[_i,10]
sx1->x1_var01 :=_agrpsx1[_i,11]
sx1->x1_def01 :=_agrpsx1[_i,12]
sx1->x1_cnt01 :=_agrpsx1[_i,13]
sx1->x1_var02 :=_agrpsx1[_i,14]
sx1->x1_def02 :=_agrpsx1[_i,15]
sx1->x1_cnt02 :=_agrpsx1[_i,16]
sx1->x1_var03 :=_agrpsx1[_i,17]
sx1->x1_def03 :=_agrpsx1[_i,18]
sx1->x1_cnt03 :=_agrpsx1[_i,19]
sx1->x1_var04 :=_agrpsx1[_i,20]
sx1->x1_def04 :=_agrpsx1[_i,21]
sx1->x1_cnt04 :=_agrpsx1[_i,22]
sx1->x1_var05 :=_agrpsx1[_i,23]
sx1->x1_def05 :=_agrpsx1[_i,24]
sx1->x1_cnt05 :=_agrpsx1[_i,25]
sx1->x1_f3 :=_agrpsx1[_i,26]
sx1->(msunlock())
endif
next
return