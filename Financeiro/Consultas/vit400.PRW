/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FLUXO    ³ Autor ³ Alberto Olegario      ³ Data ³ 19/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Consulta Posicao Financeira Consolidada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

#translate RGB( <nRed>, <nGreen>, <nBlue> ) => ;
              ( <nRed> + ( <nGreen> * 256 ) + ( <nBlue> * 65536 ) )

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//
//                        Low Intensity colors
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//

#define CLR_BLACK             0               // RGB(   0,   0,   0 )
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 )
#define CLR_GREEN         32768               // RGB(   0, 128,   0 )
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 )
#define CLR_RED             128               // RGB( 128,   0,   0 )
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 )
#define CLR_BROWN         32896               // RGB( 128, 128,   0 )
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 )
#define CLR_LIGHTGRAY  CLR_HGRAY

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//
//                       High Intensity Colors
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//

#define CLR_GRAY        8421504               // RGB( 128, 128, 128 )
#define CLR_HBLUE      16711680               // RGB(   0,   0, 255 )
#define CLR_HGREEN        65280               // RGB(   0, 255,   0 )
#define CLR_HCYAN      16776960               // RGB(   0, 255, 255 )
#define CLR_HRED            255               // RGB( 255,   0,   0 )
#define CLR_HMAGENTA   16711935               // RGB( 255,   0, 255 )
#define CLR_YELLOW        65535               // RGB( 255, 255,   0 )
#define CLR_WHITE      16777215               // RGB( 255, 255, 255 )

#xcommand DEFINE FONT <oFont> ;
             [ NAME <cName> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <from:FROM USER> ] ;
             [ <bold: BOLD> ] ;
             [ <italic: ITALIC> ] ;
             [ <underline: UNDERLINE> ] ;
             [ WEIGHT <nWeight> ] ;
             [ OF <oDevice> ] ;
             [ NESCAPEMENT <nEscapement> ] ;
       => ;
          <oFont> := TFont():New( <cName>, <nWidth>, <nHeight>, <.from.>,;
                     [<.bold.>],<nEscapement>,,<nWeight>, [<.italic.>],;
                     [<.underline.>],,,,,, [<oDevice>] )


user function vit400()
cperg:="PERGVIT400"
_pergsx1()
if pergunte(cperg,.t.)
	_cfilse1:=xfilial("SE1")
	_cfilse2:=xfilial("SE2")
	_cfilse5:=xfilial("SE5")
	se1->(dbsetorder(7))
	se2->(dbsetorder(3))
	se5->(dbsetorder(1))
	
	_aesttmp1:={}
	aadd(_aesttmp1,{"PREFIXO","C",03,0})
	aadd(_aesttmp1,{"NUMERO" ,"C",06,0})
	aadd(_aesttmp1,{"PARCELA","C",01,0})
	aadd(_aesttmp1,{"TIPO"   ,"C",03,0})
	aadd(_aesttmp1,{"VENCREA","D",08,0})
	aadd(_aesttmp1,{"VALOR"  ,"N",12,2})
	aadd(_aesttmp1,{"BAIXA"  ,"D",08,0})
	aadd(_aesttmp1,{"CLIFOR" ,"C",06,0})
	aadd(_aesttmp1,{"LOJA"   ,"C",02,0})
	aadd(_aesttmp1,{"NOME"   ,"C",20,0})
	aadd(_aesttmp1,{"HIST"   ,"C",40,0})
	
	_carqtmp1:=criatrab(_aesttmp1,.t.)
	dbusearea(.t.,,_carqtmp1,"TMP1",.f.,.f.)
	
	_carqtmp2:=criatrab(_aesttmp1,.t.)
	dbusearea(.t.,,_carqtmp2,"TMP2",.f.,.f.)
	_cindtmp2:=criatrab(,.f.)
	_cchave  :="DTOS(BAIXA)+DTOS(VENCREA)+PREFIXO+NUMERO+PARCELA+TIPO"
	tmp2->(indregua("TMP2",_cindtmp2,_cchave,,,"Selecionando registros..."))
	
	_carqtmp3:=criatrab(_aesttmp1,.t.)
	dbusearea(.t.,,_carqtmp3,"TMP3",.f.,.f.)
	
	_carqtmp4:=criatrab(_aesttmp1,.t.)
	dbusearea(.t.,,_carqtmp4,"TMP4",.f.,.f.)
	
	_carqtmp5:=criatrab(_aesttmp1,.t.)
	dbusearea(.t.,,_carqtmp5,"TMP5",.f.,.f.)
	_cindtmp5:=criatrab(,.f.)
	_cchave  :="DTOS(BAIXA)+DTOS(VENCREA)+PREFIXO+NUMERO+PARCELA+TIPO"
	tmp5->(indregua("TMP5",_cindtmp5,_cchave,,,"Selecionando registros..."))
	
	_carqtmp6:=criatrab(_aesttmp1,.t.)
	dbusearea(.t.,,_carqtmp6,"TMP6",.f.,.f.)
	
	_carqtmp7:=criatrab(_aesttmp1,.t.)
	dbusearea(.t.,,_carqtmp7,"TMP7",.f.,.f.)
	_cindtmp7:=criatrab(,.f.)
	_cchave  :="DTOS(BAIXA)+DTOS(VENCREA)+PREFIXO+NUMERO+PARCELA+TIPO"
	tmp7->(indregua("TMP7",_cindtmp7,_cchave,,,"Selecionando registros..."))
	
	_carqtmp8:=criatrab(_aesttmp1,.t.)
	dbusearea(.t.,,_carqtmp8,"TMP8",.f.,.f.)
	
	_carqtmp9:=criatrab(_aesttmp1,.t.)
	dbusearea(.t.,,_carqtmp9,"TMP9",.f.,.f.)
	_cindtmp9:=criatrab(,.f.)
	_cchave  :="DTOS(BAIXA)+DTOS(VENCREA)+PREFIXO+NUMERO+PARCELA+TIPO"
	tmp9->(indregua("TMP9",_cindtmp9,_cchave,,,"Selecionando registros..."))
	
	_carqtmpa:=criatrab(_aesttmp1,.t.)
	dbusearea(.t.,,_carqtmpa,"TMPA",.f.,.f.)
	
	_acampos1:={}
	aadd(_acampos1,{"PREFIXO","Prf"       ,                   ,"03","00"})
	aadd(_acampos1,{"NUMERO" ,"Numero"    ,                   ,"06","00"})
	aadd(_acampos1,{"PARCELA","P"         ,                   ,"01","00"})
	aadd(_acampos1,{"TIPO"   ,"Tipo"      ,                   ,"03","00"})
	aadd(_acampos1,{"VENCREA","Vencto."   ,                   ,"08","00"})
	aadd(_acampos1,{"VALOR"  ,"Valor"     ,"@E 999,999,999.99","12","02"})
	aadd(_acampos1,{"BAIXA"  ,"Baixa"     ,                   ,"08","00"})
	aadd(_acampos1,{"CLIFOR" ,"Cliente"   ,                   ,"06","00"})
	aadd(_acampos1,{"LOJA"   ,"Lj"        ,                   ,"02","00"})
	aadd(_acampos1,{"NOME"   ,"Nome"      ,                   ,"20","00"})
	aadd(_acampos1,{"HIST"   ,"Historico" ,                   ,"40","00"})
	
	_acampos2:={}
	aadd(_acampos2,{"PREFIXO","Prf"       ,                   ,"03","00"})
	aadd(_acampos2,{"NUMERO" ,"Numero"    ,                   ,"06","00"})
	aadd(_acampos2,{"PARCELA","P"         ,                   ,"01","00"})
	aadd(_acampos2,{"TIPO"   ,"Tipo"      ,                   ,"03","00"})
	aadd(_acampos2,{"VENCREA","Vencto."   ,                   ,"08","00"})
	aadd(_acampos2,{"VALOR"  ,"Valor"     ,"@E 999,999,999.99","12","02"})
	aadd(_acampos2,{"BAIXA"  ,"Baixa"     ,                   ,"08","00"})
	aadd(_acampos2,{"CLIFOR" ,"Fornecedor",                   ,"06","00"})
	aadd(_acampos2,{"LOJA"   ,"Lj"        ,                   ,"02","00"})
	aadd(_acampos2,{"NOME"   ,"Nome"      ,                   ,"20","00"})
	aadd(_acampos2,{"HIST"   ,"Historico" ,                   ,"40","00"})
	
	_nreceber :=0
	_nrecebido:=0
	_nch2     :=0
	_nch2rec  :=0
	_nrecper  :=0
	_npagar   :=0
	_npago    :=0
	
	processa({|| _receber()})
	processa({|| _recper()})
	processa({|| _pagar()})
	
	_ndifrec  :=_nreceber-_nrecebido
	_ndifch2  :=_nch2-_nch2rec
	_ndifpag  :=_npagar-_npago
	_nsaldo   :=_nreceber-_npagar
	
	_creceber :=transform(_nreceber ,"@E 999,999,999.99")
	_crecebido:=transform(_nrecebido,"@E 999,999,999.99")
	_cdifrec  :=transform(_ndifrec  ,"@E 999,999,999.99")+" "+transform(round((_ndifrec/_nreceber)*100,2),"@E 9999.99")+" %"
	_cch2     :=transform(_nch2     ,"@E 999,999,999.99")
	_cch2rec  :=transform(_nch2rec  ,"@E 999,999,999.99")
	_cdifch2  :=transform(_ndifch2  ,"@E 999,999,999.99")+" "+transform(round((_ndifch2/_nch2    )*100,2),"@E 9999.99")+" %"
	_crecper  :=transform(_nrecper  ,"@E 999,999,999.99")
	_cpagar   :=transform(_npagar   ,"@E 999,999,999.99")
	_cpago    :=transform(_npago    ,"@E 999,999,999.99")
	_cdifpag  :=transform(_ndifpag  ,"@E 999,999,999.99")+" "+transform(round((_ndifpag/_npagar)*100,2)  ,"@E 9999.99")+" %"
	_csaldo   :=transform(_nsaldo   ,"@E 999,999,999.99")+" "+transform(round((_npagar/_nreceber)*100,2) ,"@E 9999.99")+" %"

	define font ofont name "COURIER NEW" size 07,18 bold
	@ 160,001 to 500,450 dialog odlg1 title "Posicao financeira consolidada no periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
	
	@ 005,005 say "Total a receber"
	@ 005,046 say _creceber  color CLR_HRED,CLR_WHITE  object ovar
	ovar:setfont(ofont)
	@ 005,140 bmpbutton type 15 action _vertmp("TMP1")
	
	@ 020,005 say "Total recebido"
	@ 020,046 say _crecebido color CLR_HBLUE,CLR_WHITE object ovar
	ovar:setfont(ofont)
	@ 020,140 bmpbutton type 15 action _vertmp("TMP2")
	
	@ 035,005 say "Diferenca"
	@ 035,046 say _cdifrec   color CLR_HRED,CLR_WHITE  object ovar
	ovar:setfont(ofont)
	@ 035,140 bmpbutton type 15 action _vertmp("TMP3")
	
	@ 050,005 say "CH 2a.devolucao"
	@ 050,046 say _cch2      color CLR_HRED,CLR_WHITE  object ovar
	ovar:setfont(ofont)
	@ 050,140 bmpbutton type 15 action _vertmp("TMP4")
	
	@ 065,005 say "CH 2a.dev.receb"
	@ 065,046 say _cch2rec   color CLR_HBLUE,CLR_WHITE object ovar
	ovar:setfont(ofont)
	@ 065,140 bmpbutton type 15 action _vertmp("TMP5")
	
	@ 080,005 say "Difer.CH 2a.dev"
	@ 080,046 say _cdifch2   color CLR_HRED,CLR_WHITE  object ovar
	ovar:setfont(ofont)
	@ 080,140 bmpbutton type 15 action _vertmp("TMP6")
	
	@ 095,005 say "Rec. no periodo"
	@ 095,046 say _crecper   color CLR_HRED,CLR_WHITE  object ovar
	ovar:setfont(ofont)
	@ 095,140 bmpbutton type 15 action _vertmp("TMP7")
	
	@ 110,005 say "Total a pagar"
	@ 110,046 say _cpagar    color CLR_HBLUE,CLR_WHITE object ovar
	ovar:setfont(ofont)
	@ 110,140 bmpbutton type 15 action _vertmp("TMP8")
	
	@ 125,005 say "Total pago"
	@ 125,046 say _cpago     color CLR_HRED,CLR_WHITE  object ovar
	ovar:setfont(ofont)
	@ 125,140 bmpbutton type 15 action _vertmp("TMP9")
	
	@ 140,005 say "Diferenca"
	@ 140,046 say _cdifpag   color CLR_HBLUE,CLR_WHITE object ovar
	ovar:setfont(ofont)
	@ 140,140 bmpbutton type 15 action _vertmp("TMPA")
	
	@ 155,005 say "Saldo"
	if _nsaldo>=0
		@ 155,046 say _csaldo color CLR_HBLUE,CLR_WHITE object ovar
		ovar:setfont(ofont)
	else
		@ 155,046 say _csaldo color CLR_HRED,CLR_WHITE  object ovar
		ovar:setfont(ofont)
	endif
	
	@ 005,185 bmpbutton type 1 action close(odlg1)
	
	activate dialog odlg1 centered
	
	_cindtmp2+=tmp2->(ordbagext())
	_cindtmp5+=tmp5->(ordbagext())
	_cindtmp7+=tmp7->(ordbagext())
	_cindtmp9+=tmp9->(ordbagext())
	tmp1->(dbclosearea())
	tmp2->(dbclosearea())
	tmp3->(dbclosearea())
	tmp4->(dbclosearea())
	tmp5->(dbclosearea())
	tmp6->(dbclosearea())
	tmp7->(dbclosearea())
	tmp8->(dbclosearea())
	tmp9->(dbclosearea())
	tmpa->(dbclosearea())
	ferase(_carqtmp1+".dbf")
	ferase(_carqtmp2+".dbf")
	ferase(_carqtmp3+".dbf")
	ferase(_carqtmp4+".dbf")
	ferase(_carqtmp5+".dbf")
	ferase(_carqtmp6+".dbf")
	ferase(_carqtmp7+".dbf")
	ferase(_carqtmp8+".dbf")
	ferase(_carqtmp9+".dbf")
	ferase(_carqtmpa+".dbf")
	ferase(_cindtmp2)
	ferase(_cindtmp5)
	ferase(_cindtmp7)
	ferase(_cindtmp9)
endif
return

static function _receber()
procregua(se1->(lastrec()))
se1->(dbsetorder(7))
se1->(dbseek(_cfilse1+dtos(mv_par01),.t.))
while ! se1->(eof()) .and.;
		se1->e1_filial==_cfilse1 .and.;
		se1->e1_vencrea<=mv_par02
	incproc("Selecionando titulos a receber "+dtoc(se1->e1_vencrea))
	if substr(se1->e1_tipo,3,1)<>"-" .and.;
		se1->e1_flagfat<>"S"
		if se1->e1_prefixo=="CH2" //.or. ! empty(se1->e1_dtdev2)
			// TOTAL DE CHEQUES 2a. DEVOLUCAO
			_nch2+=se1->e1_valor
			tmp4->(dbappend())
			tmp4->prefixo:=se1->e1_prefixo
			tmp4->numero :=se1->e1_num
			tmp4->parcela:=se1->e1_parcela
			tmp4->tipo   :=se1->e1_tipo
			tmp4->vencrea:=se1->e1_vencrea
			tmp4->valor  :=se1->e1_valor
			tmp4->baixa  :=se1->e1_baixa
			tmp4->clifor :=se1->e1_cliente
			tmp4->loja   :=se1->e1_loja
			tmp4->nome   :=se1->e1_nomcli
			tmp4->hist   :=se1->e1_hist
			if se1->e1_valor>se1->e1_saldo
				// CHEQUES 2a. DEVOLUCAO RECEBIDOS
				_nordse5:=se5->(indexord())
				_cchave :=_cfilse5+se1->e1_prefixo+se1->e1_num+se1->e1_parcela+se1->e1_tipo+se1->e1_cliente+se1->e1_loja
				se5->(dbsetorder(7))
				se5->(dbseek(_cchave))
				while ! se5->(eof()) .and.;
						se5->e5_filial+se5->e5_prefixo+se5->e5_numero+se5->e5_parcela+se5->e5_tipo+se5->e5_clifor+se5->e5_loja==_cchave
					if ((se5->e5_tipodoc$"BA/BL/CP/VL" .and. se5->e5_recpag=="R") .or. (se5->e5_tipodoc$"ES" .and. se5->e5_recpag=="P")) .and.;
						se5->e5_motbx<>"LIQ" .and.;
						se5->e5_situaca<>"C"
						_nvalor:=(se5->e5_valor+se5->e5_vldesco-se5->e5_vljuros-se5->e5_vlmulta-se5->e5_vlcorre)
						if se5->e5_recpag=="R"
							tmp5->(dbappend())
							tmp5->prefixo:=se1->e1_prefixo
							tmp5->numero :=se1->e1_num
							tmp5->parcela:=se1->e1_parcela
							tmp5->tipo   :=se1->e1_tipo
							tmp5->vencrea:=se1->e1_vencrea
							tmp5->baixa  :=se5->e5_data
							tmp5->clifor :=se1->e1_cliente
							tmp5->loja   :=se1->e1_loja
							tmp5->nome   :=se1->e1_nomcli
							tmp5->hist   :=se5->e5_histor
							tmp5->valor  :=_nvalor
							_nch2rec     +=_nvalor
						else
							tmp5->(dbappend())
							tmp5->prefixo:=se1->e1_prefixo
							tmp5->numero :=se1->e1_num
							tmp5->parcela:=se1->e1_parcela
							tmp5->tipo   :=se1->e1_tipo
							tmp5->vencrea:=se1->e1_vencrea
							tmp5->baixa  :=se5->e5_data
							tmp5->clifor :=se1->e1_cliente
							tmp5->loja   :=se1->e1_loja
							tmp5->nome   :=se1->e1_nomcli
							tmp5->hist   :=se5->e5_histor
							tmp5->valor  :=_nvalor*(-1)
							_nch2rec     -=_nvalor
						endif
					endif
					se5->(dbskip())
				end
				se5->(dbsetorder(_nordse5))
			endif
			if se1->e1_saldo>0
				// CHEQUES 2a. DEVOLUCAO A RECEBER
				tmp6->(dbappend())
				tmp6->prefixo:=se1->e1_prefixo
				tmp6->numero :=se1->e1_num
				tmp6->parcela:=se1->e1_parcela
				tmp6->tipo   :=se1->e1_tipo
				tmp6->vencrea:=se1->e1_vencrea
				tmp6->valor  :=se1->e1_saldo
				tmp6->baixa  :=se1->e1_baixa
				tmp6->clifor :=se1->e1_cliente
				tmp6->loja   :=se1->e1_loja
				tmp6->nome   :=se1->e1_nomcli
				tmp6->hist   :=se1->e1_hist
			endif
		elseif empty(se1->e1_tipoliq) .or. se1->e1_saldo>0
			if se1->e1_tipo$"NCC/RA "
				// NOTAS DE CREDITO E RECEBIMENTOS ANTECIPADOS
				_nvaltit:=se1->e1_valor*(-1)
			elseif empty(se1->e1_tipoliq)
				// TITULOS QUE NAO SOFRERAM LIQUIDACAO
				_nvaltit:=se1->e1_valor
			else
				// TITULOS QUE SOFRERAM LIQUIDACAO
				_nvalliq:=0
				_nordse5:=se5->(indexord())
				_cchave :=_cfilse5+se1->e1_prefixo+se1->e1_num+se1->e1_parcela+se1->e1_tipo+se1->e1_cliente+se1->e1_loja
				se5->(dbsetorder(7))
				se5->(dbseek(_cchave))
				while ! se5->(eof()) .and.;
						se5->e5_filial+se5->e5_prefixo+se5->e5_numero+se5->e5_parcela+se5->e5_tipo+se5->e5_clifor+se5->e5_loja==_cchave
					if se5->e5_motbx=="LIQ" .and.;
						se5->e5_tipodoc$"BA/ES" .and.;
						se5->e5_situaca<>"C"
						if se5->e5_recpag=="R"
							_nvalliq+=(se5->e5_valor+se5->e5_vldesco-se5->e5_vljuros-se5->e5_vlmulta-se5->e5_vlcorre)
						else
							_nvalliq-=(se5->e5_valor+se5->e5_vldesco-se5->e5_vljuros-se5->e5_vlmulta-se5->e5_vlcorre)
						endif
					endif
					se5->(dbskip())
				end
				se5->(dbsetorder(_nordse5))
				_nvaltit:=se1->e1_valor-_nvalliq
			endif
			if _nvaltit<>0
				_nreceber+=_nvaltit
				tmp1->(dbappend())
				tmp1->valor  :=_nvaltit
				tmp1->prefixo:=se1->e1_prefixo
				tmp1->numero :=se1->e1_num
				tmp1->parcela:=se1->e1_parcela
				tmp1->tipo   :=se1->e1_tipo
				tmp1->vencrea:=se1->e1_vencrea
				tmp1->baixa  :=se1->e1_baixa
				tmp1->clifor :=se1->e1_cliente
				tmp1->loja   :=se1->e1_loja
				tmp1->nome   :=se1->e1_nomcli
				tmp1->hist   :=se1->e1_hist
			endif
			if se1->e1_valor>se1->e1_saldo
				_nordse5:=se5->(indexord())
				_cchave :=_cfilse5+se1->e1_prefixo+se1->e1_num+se1->e1_parcela+se1->e1_tipo+se1->e1_cliente+se1->e1_loja
				se5->(dbsetorder(7))
				se5->(dbseek(_cchave))
				while ! se5->(eof()) .and.;
						se5->e5_filial+se5->e5_prefixo+se5->e5_numero+se5->e5_parcela+se5->e5_tipo+se5->e5_clifor+se5->e5_loja==_cchave
					if ((se5->e5_tipodoc$"BA/BL/CP/VL" .and. se5->e5_recpag=="R") .or. (se5->e5_tipodoc$"ES" .and. se5->e5_recpag=="P")) .and.;
						se5->e5_motbx<>"LIQ" .and.;
						se5->e5_situaca<>"C"
						_nvalor      :=(se5->e5_valor+se5->e5_vldesco-se5->e5_vljuros-se5->e5_vlmulta-se5->e5_vlcorre)
						if se5->e5_recpag=="R"
							tmp2->(dbappend())
							tmp2->prefixo:=se1->e1_prefixo
							tmp2->numero :=se1->e1_num
							tmp2->parcela:=se1->e1_parcela
							tmp2->tipo   :=se1->e1_tipo
							tmp2->vencrea:=se1->e1_vencrea
							tmp2->baixa  :=se5->e5_data
							tmp2->clifor :=se1->e1_cliente
							tmp2->loja   :=se1->e1_loja
							tmp2->nome   :=se1->e1_nomcli
							tmp2->hist   :=se5->e5_histor
							if se1->e1_tipo$"NCC/RA "
								_nrecebido -=_nvalor
								tmp2->valor:=_nvalor*(-1)
							else
								_nrecebido +=_nvalor
								tmp2->valor:=_nvalor
							endif
						else
							tmp2->(dbappend())
							tmp2->prefixo:=se1->e1_prefixo
							tmp2->numero :=se1->e1_num
							tmp2->parcela:=se1->e1_parcela
							tmp2->tipo   :=se1->e1_tipo
							tmp2->vencrea:=se1->e1_vencrea
							tmp2->baixa  :=se5->e5_data
							tmp2->clifor :=se1->e1_cliente
							tmp2->loja   :=se1->e1_loja
							tmp2->nome   :=se1->e1_nomcli
							tmp2->hist   :=se5->e5_histor
							if se1->e1_tipo$"NCC/RA "
								_nrecebido +=_nvalor
								tmp2->valor:=_nvalor
							else
								_nrecebido -=_nvalor
								tmp2->valor:=_nvalor*(-1)
							endif
						endif
					endif
					se5->(dbskip())
				end
				se5->(dbsetorder(_nordse5))
			endif
			if se1->e1_saldo>0
				tmp3->(dbappend())
				if se1->e1_tipo$"NCC/RA "
					// NOTAS DE CREDITO E RECEBIMENTOS ANTECIPADOS
					tmp3->valor:=se1->e1_saldo*(-1)
				else
					// DEMAIS TITULOS
					tmp3->valor:=se1->e1_saldo
				endif
				tmp3->prefixo:=se1->e1_prefixo
				tmp3->numero :=se1->e1_num
				tmp3->parcela:=se1->e1_parcela
				tmp3->tipo   :=se1->e1_tipo
				tmp3->vencrea:=se1->e1_vencrea
				tmp3->baixa  :=se1->e1_baixa
				tmp3->clifor :=se1->e1_cliente
				tmp3->loja   :=se1->e1_loja
				tmp3->nome   :=se1->e1_nomcli
				tmp3->hist   :=se1->e1_hist
			endif
		endif
	endif
	se1->(dbskip())
end
return

static function _recper()
procregua(se5->(lastrec()))
se1->(dbsetorder(1))
se5->(dbseek(_cfilse5+dtos(mv_par01),.t.))
while ! se5->(eof()) .and.;
		se5->e5_filial==_cfilse5 .and.;
		se5->e5_data<=mv_par02
	incproc("Selecionando titulos recebidos "+dtoc(se5->e5_data))
	if se5->e5_tipodoc$"BA/BL/CP/VL" .and.;
		se5->e5_recpag=="R" .and.;
		se5->e5_motbx=="NOR" .and.;
		! empty(se5->e5_numero) .and.;
		se1->(dbseek(_cfilse1+se5->e5_prefixo+se5->e5_numero+se5->e5_parcela+se5->e5_tipo)) .and.;
		se5->e5_situaca<>"C"
		_nordse5:=se5->(indexord())
		_nregse5:=se5->(recno())
		_cchave :=se5->e5_filial+se5->e5_prefixo+se5->e5_numero+se5->e5_parcela+se5->e5_tipo+se5->e5_clifor+se5->e5_loja+se5->e5_seq
		_nvalor :=0
		se5->(dbsetorder(7))
		se5->(dbseek(_cchave))
		while ! se5->(eof()) .and.;
				se5->e5_filial+se5->e5_prefixo+se5->e5_numero+se5->e5_parcela+se5->e5_tipo+se5->e5_clifor+se5->e5_loja+se5->e5_seq==_cchave
			if ((se5->e5_tipodoc$"BA/BL/CP/VL" .and. se5->e5_recpag=="R") .or. (se5->e5_tipodoc$"ES" .and. se5->e5_recpag=="P")) .and.;
				se5->e5_motbx=="NOR" .and.;
				se5->e5_situaca<>"C"
				if se5->e5_recpag=="R"
					_nvalor+=se5->e5_valor
				else
					_nvalor-=se5->e5_valor
				endif
			endif
			se5->(dbskip())
		end
		se5->(dbsetorder(_nordse5))
		se5->(dbgoto(_nregse5))
		if _nvalor>0
			tmp7->(dbappend())
			tmp7->prefixo:=se5->e5_prefixo
			tmp7->numero :=se5->e5_numero
			tmp7->parcela:=se5->e5_parcela
			tmp7->tipo   :=se5->e5_tipo
			tmp7->vencrea:=se1->e1_vencrea
			tmp7->baixa  :=se5->e5_data
			tmp7->clifor :=se5->e5_clifor
			tmp7->loja   :=se5->e5_loja
			tmp7->nome   :=se1->e1_nomcli
			tmp7->hist   :=se5->e5_histor
			tmp7->valor:=se5->e5_valor
			_nrecper+=se5->e5_valor
		endif
	endif
	se5->(dbskip())
end
return

static function _pagar()
procregua(se2->(lastrec()))
se2->(dbseek(_cfilse2+dtos(mv_par01),.t.))
while ! se2->(eof()) .and.;
		se2->e2_filial==_cfilse2 .and.;
		se2->e2_vencrea<=mv_par02
	incproc("Selecionando titulos a pagar "+dtoc(se2->e2_vencrea))
	if substr(se2->e2_tipo,3,1)<>"-" .and.;
		se2->e2_flagfat<>"S"
		tmp8->(dbappend())
		if se2->e2_tipo$"NDF/PA "
			// NOTAS DE DEBITO E PAGAMENTOS ANTECIPADOS
			_npagar-=se2->e2_valor
			tmp8->valor:=se2->e2_valor*(-1)
		else
			// DEMAIS TITULOS
			_npagar+=se2->e2_valor
			tmp8->valor:=se2->e2_valor
		endif
		tmp8->prefixo:=se2->e2_prefixo
		tmp8->numero :=se2->e2_num
		tmp8->parcela:=se2->e2_parcela
		tmp8->tipo   :=se2->e2_tipo
		tmp8->vencrea:=se2->e2_vencrea
		tmp8->baixa  :=se2->e2_baixa
		tmp8->clifor :=se2->e2_fornece
		tmp8->loja   :=se2->e2_loja
		tmp8->nome   :=se2->e2_nomfor
		tmp8->hist   :=se2->e2_hist
		if se2->e2_valor<>se2->e2_saldo
			tmp9->(dbappend())
			if se2->e2_tipo$"NDF/PA "
				// NOTAS DE DEBITO E PAGAMENTOS ANTECIPADOS
				_npago-=(se2->e2_valor-se2->e2_saldo)
				tmp9->valor:=(se2->e2_valor-se2->e2_saldo)*(-1)
			else
				// DEMAIS TITULOS
				_npago+=(se2->e2_valor-se2->e2_saldo)
				tmp9->valor:=(se2->e2_valor-se2->e2_saldo)
			endif
			tmp9->prefixo:=se2->e2_prefixo
			tmp9->numero :=se2->e2_num
			tmp9->parcela:=se2->e2_parcela
			tmp9->tipo   :=se2->e2_tipo
			tmp9->vencrea:=se2->e2_vencrea
			tmp9->baixa  :=se2->e2_baixa
			tmp9->clifor :=se2->e2_fornece
			tmp9->loja   :=se2->e2_loja
			tmp9->nome   :=se2->e2_nomfor
			tmp9->hist   :=se2->e2_hist
		endif
		if se2->e2_saldo>0
			tmpa->(dbappend())
			if se2->e2_tipo$"NDF/PA "
				// NOTAS DE DEBITO E PAGAMENTOS ANTECIPADOS
				tmpa->valor:=se2->e2_saldo*(-1)
			else
				// DEMAIS TITULOS
				tmpa->valor:=se2->e2_saldo
			endif
			tmpa->prefixo:=se2->e2_prefixo
			tmpa->numero :=se2->e2_num
			tmpa->parcela:=se2->e2_parcela
			tmpa->tipo   :=se2->e2_tipo
			tmpa->vencrea:=se2->e2_vencrea
			tmpa->baixa  :=se2->e2_baixa
			tmpa->clifor :=se2->e2_fornece
			tmpa->loja   :=se2->e2_loja
			tmpa->nome   :=se2->e2_nomfor
			tmpa->hist   :=se2->e2_hist
		endif
	endif
	se2->(dbskip())
end
return

static function _vertmp(_carq)
if _carq=="TMP1"
	_ctitulo:="Total de titulos a receber no periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
	_nvalor :=_nreceber
	_acampos:=_acampos1
	tmp1->(dbgotop())
elseif _carq=="TMP2"
	_ctitulo:="Titulos recebidos no periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
	_nvalor :=_nrecebido
	_acampos:=_acampos1
	tmp2->(dbgotop())
elseif _carq=="TMP3"
	_ctitulo:="Titulos a receber no periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
	_nvalor :=_ndifrec
	_acampos:=_acampos1
	tmp3->(dbgotop())
elseif _carq=="TMP4"
	_ctitulo:="Total de cheques 2a. devolucao no periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
	_nvalor :=_nch2
	_acampos:=_acampos1
	tmp4->(dbgotop())
elseif _carq=="TMP5"
	_ctitulo:="Cheques 2a. devolucao recebidos no periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
	_nvalor :=_nch2rec
	_acampos:=_acampos1
	tmp5->(dbgotop())
elseif _carq=="TMP6"
	_ctitulo:="Cheques 2a. devolucao a receber no periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
	_nvalor :=_ndifch2
	_acampos:=_acampos1
	tmp6->(dbgotop())
elseif _carq=="TMP7"
	_ctitulo:="Total de titulos recebidos no periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
	_nvalor :=_nrecper
	_acampos:=_acampos1
	tmp7->(dbgotop())
elseif _carq=="TMP8"
	_ctitulo:="Total de titulos a pagar no periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
	_nvalor :=_npagar
	_acampos:=_acampos2
	tmp8->(dbgotop())
elseif _carq=="TMP9"
	_ctitulo:="Titulos pagos no periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
	_nvalor :=_npago
	_acampos:=_acampos2
	tmp9->(dbgotop())
elseif _carq=="TMPA"
	_ctitulo:="Titulos a pagar no periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
	_nvalor :=_ndifpag
	_acampos:=_acampos2
	tmpa->(dbgotop())
endif

@ 000,000 to 315,660 dialog odlg2 title _ctitulo

@ 002,002 say "Valor: "+transform(_nvalor,"@E 999,999,999.99")

@ 010,002 to 155,280 browse _carq fields _acampos

@ 010,290 bmpbutton type 1 action close(odlg2)
@ 030,290 bmpbutton type 6 action _imprime(_carq,_ctitulo)

activate dialog odlg2 centered
return

static function _imprime(_carq,_ctitulo)
nordem  :=""
tamanho :="M"
limite  :=132
titulo  :=_ctitulo
cdesc1  :="Este programa ira emitir a relacao de "+titulo
cdesc2  :=""
cdesc3  :=""
cstring :="SE1"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT400"
wnrel   :="VIT400"+Alltrim(cusername)
alinha  :={}
nlastkey:=0
lcontinua:=.t.

cperg:=""

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)

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

rptstatus({|| rptdetail(_carq)})
return

//*******************************************
//Funcao rptdetail - impressao do relatorio
//*******************************************

static function rptdetail(_carq)
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

if _carq<="TMP7"
	cabec1:="Prf Numero P Tip Vencto.real          Valor Dt.baixa Cliente                                            Historico"
else
	cabec1:="Prf Numero P Tip Vencto.real          Valor Dt.baixa Fornecedor                                         Historico"
endif
cabec2:=""

setprc(0,0)

dbselectarea(_carq)

_nreg:=recno()

setregua(lastrec())

_ntottit  :=0
_ntotvalor:=0
dbgotop()
while ! eof() .and.;
		lcontinua
	_ntitdia:=0
	_nvaldia:=0
	if _carq$"TMP2/TMP5/TMP7/TMP9"
		_ddata:=baixa
		_ccond:="baixa==_ddata"
	else
		_ddata:=vencrea
		_ccond:="vencrea==_ddata"
	endif
	while ! eof() .and.;
			&_ccond .and.;
			lcontinua
		incregua()
		if prow()==0 .or. prow()>55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
		endif
		@ prow()+1,000 PSAY prefixo
		@ prow(),004   PSAY numero
		@ prow(),011   PSAY parcela
		@ prow(),013   PSAY tipo
		@ prow(),019   PSAY vencrea
		@ prow(),029   PSAY valor picture "@E 999,999,999.99"
		@ prow(),044   PSAY baixa
		@ prow(),053   PSAY clifor+"/"+loja+"-"+nome
		@ prow(),104   PSAY hist
		_ntitdia++
		_nvaldia+=valor
		dbskip()
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
	end
	@ prow()+1,000 PSAY replicate("-",limite)
	@ prow()+1,000 PSAY "TOTAL DO DIA "+dtoc(_ddata)
	@ prow(),029   PSAY _nvaldia picture "@E 999,999,999.99"
	@ prow(),044   PSAY str(_ntitdia,6)+" TITULO(S)"
	@ prow()+1,000 PSAY ""
	_ntottit  +=_ntitdia
	_ntotvalor+=_nvaldia
end

if prow()>0 .and.;
	lcontinua
	if prow()>55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
	endif
	@ prow()+1,000 PSAY replicate("-",limite)
	@ prow()+1,000 PSAY "TOTAL DO PERIODO "
	@ prow(),029   PSAY _ntotvalor picture "@E 999,999,999.99"
	@ prow(),044   PSAY str(_ntottit,6)+" TITULO(S)"
	roda(cbcont,cbtxt)
endif

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endIf

ms_flush()
dbgoto(_nreg)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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

static function _pergimp()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do vencimento      ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate o vencimento   ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Da baixa           ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate a baixa        ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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

/*
Prf Numero P Tip Vencto.real          Valor Dt.baixa Cliente                                            Historico
xxx 999999 x xxx   99/99/99  999.999.999,99 99/99/99 999999/99-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxx
*/
