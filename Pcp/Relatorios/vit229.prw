/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT229  ³Autor ³Aline B. Pereira  ³Data ³  14/04/2005      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gerenciamento de Compras                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "topconn.ch"

user function VIT229()
nordem   :=""
tamanho  :="G" // P , M   ou G
limite   :=220 // 80, 132 ou 220
titulo   :="GERENCIAMENTO DE COMPRAS"
cdesc1   :="Este programa ira emitir o gerenciamento de compras"
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT229"
wnrel    :="VIT229"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT229"
_pergsx1()
pergunte(cperg,.f.)

if nlastkey==27
	set filter to
	return
endif

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.f.)

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

rptstatus({|| rptdetail()},titulo)
return

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)
_ccq  :=getmv("MV_CQ")

titulo+=" - MES/ANO DE REFERENCIA: "+mv_par07+"/"+mv_par08
cabec1:="CODIGO DESCRICAO                                  MES     ESTOQUE     EXPLOSAO  % EST.   SOLICIT.     PEDIDO     EMPENHO     TOTAL A  %COBERT. QUANT. A     AJUSTE       VALOR     VALOR        LOTE      EMBALAGEM"
cabec2:="                                                            DIA          PMP     EXPL.    COMPRA      COMPRA                 RECEBER   DESEJ.  COMPRAR     LOTE MIN.   DE COMPRA  UNITARIO     MINIMO       PADRAO"

//cabec1:="CODIGO DESCRICAO                                  MES     ESTOQUE     EXPLOSAO  % EST.   SOLICIT.     PEDIDO     EMPENHO     TOTAL A  %COBERT. QUANT. A     AJUSTE       VALOR     VALOR        LOTE      EMBALAGEM"
//cabec2:="                                                            DIA          PMP     EXPL.    COMPRA      COMPRA                 RECEBER   DESEJ.  COMPRAR     LOTE MIN.   UNITARIO  DE COMPRA     MINIMO       PADRAO"

//CODIGO DESCRICAO                                  MES     ESTOQUE     EXPLOSAO  % EST.   SOLICIT.     PEDIDO     EMPENHO     TOTAL A  %COBERT. QUANT. A     AJUSTE       VALOR     VALOR        LOTE      EMBALAGEM"
//                                                            DIA          PMP     EXPL.    COMPRA      COMPRA                 RECEBER   DESEJ.  COMPRAR     LOTE MIN.   UNITARIO  DE COMPRA     MINIMO       PADRAO"
//999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/9999 999.999.999 999.999.999 999.99 999.999.999 999.999.999 999.999.999 999.999.999 999.99 999.999.999 999.999.999 999.999,99 999.999,99 999.999.999 999.999.999,99

/*
// ********  LAYOUT ANTIGO **********

CODIGO DESCRICAO                                  ESTOQUE   COBERTURA   SOLICIT.     PEDIDO     EMPENHO     EXPLOSAO     TOTAL     QUANT. A     AJUSTE      MES      SALDO    MERCADO SEGURANCA
DIA        DIAS      COMPRA      COMPRA                    PMP       SAIDAS    COMPRAR     LOTE MIN.             FINAL              DIAS
999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999.999 999999,99 999.999.999 999.999.999 999.999.999 999.999.999 999.999.999 999.999.999 999.999.999 99/9999 999.999.999 XXXXXXX 999999,99
*/

_adataini:=array(mv_par09)
_adatafim:=array(mv_par09)
for _i:=1 to mv_par09
	if _i==1
		_nmes:=val(mv_par07)
		_nano:=val(mv_par08)
		_adataini[_i]:=ctod("01/"+strzero(_nmes,2)+"/"+strzero(_nano,4))
		_adatafim[_i]:=lastday(_adataini[_i])
	else
		if _nmes==12
			_nmes:=1
			_nano++
		else
			_nmes++
		endif
		_adataini[_i]:=ctod("01/"+strzero(_nmes,2)+"/"+strzero(_nano,4))
		_adatafim[_i]:=lastday(_adataini[_i])
	endif
next


_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsb8:=xfilial("SB8")
_cfilsc1:=xfilial("SC1")
_cfilsc7:=xfilial("SC7")
_cfilsg1:=xfilial("SG1")
_cfilshc:=xfilial("SHC")
_cfilsc2:=xfilial("SC2")

sc2->(dbsetorder(1))


_aestrut:={}
aadd(_aestrut,{"PRODUTO"  ,"C",15,0})
aadd(_aestrut,{"DESCRI"   ,"C",80,0})
aadd(_aestrut,{"MES"      ,"C",02,0})
aadd(_aestrut,{"ANO"      ,"C",04,0})
aadd(_aestrut,{"NECES"    ,"N",15,2})
aadd(_aestrut,{"LM"       ,"N",15,2})
aadd(_aestrut,{"LOCPAD"   ,"C",02,0})
aadd(_aestrut,{"EMBPAD"   ,"N",15,2})
//aadd(_aestrut,{"EMBPAD"   ,"C",15,2})
aadd(_aestrut,{"ULTCOM"   ,"N",15,2})

_carqtmp1:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp1,"TMP1",.f.,.f.)

_cindtmp11:=criatrab(,.f.)
_cchave   :="PRODUTO+ANO+MES"
tmp1->(indregua("TMP1",_cindtmp11,_cchave))

_cindtmp12:=criatrab(,.f.)
_cchave   :="DESCRI+PRODUTO+ANO+MES"
tmp1->(indregua("TMP1",_cindtmp12,_cchave))

tmp1->(dbclearind())
tmp1->(dbsetindex(_cindtmp11))
tmp1->(dbsetindex(_cindtmp12))

processa({|| _geratmp()})

setprc(0,0)

setregua(sb1->(lastrec()))

tmp1->(dbsetorder(2))
tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	if prow()==0 .or. prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	_cproduto:=tmp1->produto
	_cdescpro1:=left(tmp1->descri,40)
	_cdescpro2:=substr(tmp1->descri,41,40)
	_nembpad:=tmp1->embpad
	_nultcompra:=tmp1->ultcom             
   //	_nvalcompra:=
	_i:=1
	
	@ prow()+1,000 PSAY left(_cproduto,6)
	@ prow(),007   PSAY _cdescpro1
	
	while ! tmp1->(eof()) .and.;
		tmp1->produto==_cproduto .and.;
		lcontinua
		incregua()
		
		// ESTOQUE DIA
		if _i==1
//			_ddataini:=ctod("01/"+tmp1->mes+"/"+tmp1->ano)
			_ddataini:=_adataini[_i]
			_ddatafim:=lastday(_ddataini)
			_nmes:=val(mv_par07)
			_nmesf:=_nmes+1
			_nano:=val(mv_par08)
			if _nmes==12
				_nmes:=01
				_nano++
			endif
			_nsaldo  :=0
			_nempenho:=0
			sb2->(dbsetorder(1))
			if sb2->(dbseek(_cfilsb2+_cproduto+tmp1->locpad))
				_nsaldo  +=sb2->b2_qatu
				_nempenho+=sb2->b2_qemp
			endif
			if sb2->(dbseek(_cfilsb2+_cproduto+_ccq))
				_nsaldo  +=sb2->b2_qatu
				_nempenho+=sb2->b2_qemp
			endif
			
			// SOLICITACAO DE COMPRA EM ATRASO
			_cquery:=" SELECT"
			_cquery+=" SUM(C1_QUANT-C1_QUJE) QUANT"
			_cquery+=" FROM "
			_cquery+=  retsqlname("SC1")+" SC1"
			_cquery+=" WHERE "
			_cquery+="     SC1.D_E_L_E_T_<>'*'"
			_cquery+=" AND C1_FILIAL='"+_cfilsc1+"'"
			_cquery+=" AND C1_PRODUTO='"+tmp1->produto+"'"
			_cquery+=" AND C1_QUANT-C1_QUJE>0"
			_cquery+=" AND C1_DATPRF<'"+dtos(_ddataini)+"'"
			
			_cquery:=changequery(_cquery)
			
			tcquery _cquery alias "TMP2" new
			tcsetfield("TMP2","QUANT","N",15,2)
			
			tmp2->(dbgotop())
			_nsolicat:=int(tmp2->quant)
			tmp2->(dbclosearea())
			
			// PEDIDO DE COMPRA EM ATRASO
			_cquery:=" SELECT"
			_cquery+=" SUM(C7_QUANT-C7_QUJE) QUANT"
			_cquery+=" FROM "
			_cquery+=  retsqlname("SC7")+" SC7"
			_cquery+=" WHERE "
			_cquery+="     SC7.D_E_L_E_T_<>'*'"
			_cquery+=" AND C7_FILIAL='"+_cfilsc7+"'"
			_cquery+=" AND C7_PRODUTO='"+tmp1->produto+"'"
			_cquery+=" AND C7_QUANT-C7_QUJE>0"
			_cquery+=" AND C7_RESIDUO=' '"
			_cquery+=" AND C7_DATPRF<'"+dtos(_ddataini)+"'"
			
			_cquery:=changequery(_cquery)
			
			tcquery _cquery alias "TMP2" new
			tcsetfield("TMP2","QUANT","N",15,2)
			
			tmp2->(dbgotop())
			_npedidoat:=int(tmp2->quant)
			tmp2->(dbclosearea())
			if ! empty(_nsolicat) .or. ! empty(_npedidoat)
				@ prow(),070   PSAY _nsolicat  picture "@E 999,999,999"
				@ prow(),082   PSAY _npedidoat picture "@E 999,999,999"
				@ prow()+1,000 PSAY ""
			endif
		else
			_ddataini:=_adataini[_i]
			_ddatafim:=_adatafim[_i]
			_nsaldo:=_nsaldofim
		endif
		_nsaldo  :=int(_nsaldo)
		_nempenho:=int(_nempenho)
		
		// TOTAL SAIDAS
		if _i==1
			if strzero(month(_ddataini),2)==tmp1->mes .and. strzero(year(_ddataini),4)==tmp1->ano
				_nneces:=int(tmp1->neces)+_nempenho
			else
				_nneces:=_nempenho
			endif
		else
			if strzero(month(_ddataini),2)==tmp1->mes .and. strzero(year(_ddataini),4)==tmp1->ano
				_nneces:=int(tmp1->neces)
			else
				_nneces:=0
			endif
		endif
		
		// LOTE MINIMO
		_nlm:=int(tmp1->lm)
		
		// COBERTURA DIAS
		_ncobert:=round(_nsaldo/(_nneces/30),2)
		
		// SOLICITACAO DE COMPRA
		_cquery:=" SELECT"
		_cquery+=" SUM(C1_QUANT-C1_QUJE) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SC1")+" SC1"
		_cquery+=" WHERE "
		_cquery+="     SC1.D_E_L_E_T_<>'*'"
		_cquery+=" AND C1_FILIAL='"+_cfilsc1+"'"
		_cquery+=" AND C1_PRODUTO='"+tmp1->produto+"'"
		_cquery+=" AND (C1_QUANT-C1_QUJE)>0"
		_cquery+=" AND C1_DATPRF BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(_ddatafim)+"'"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery alias "TMP2" new
		tcsetfield("TMP2","QUANT","N",15,2)
		
		tmp2->(dbgotop())
		_nsolic:=int(tmp2->quant)
		tmp2->(dbclosearea())
		
		// PEDIDO DE COMPRA
		_cquery:=" SELECT"
		_cquery+=" SUM(C7_QUANT-C7_QUJE) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SC7")+" SC7"
		_cquery+=" WHERE "
		_cquery+="     SC7.D_E_L_E_T_<>'*'"
		_cquery+=" AND C7_FILIAL='"+_cfilsc7+"'"
		_cquery+=" AND C7_PRODUTO='"+tmp1->produto+"'"
		_cquery+=" AND (C7_QUANT-C7_QUJE)>0"
		_cquery+=" AND C7_RESIDUO=' '"
		_cquery+=" AND C7_DATPRF BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(_ddatafim)+"'"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery alias "TMP2" new
		tcsetfield("TMP2","QUANT","N",15,2)
		
		tmp2->(dbgotop())
		_npedido:=int(tmp2->quant)
		tmp2->(dbclosearea())
		
		// EXPLOSAO PMP
		if strzero(month(_ddataini),2)==tmp1->mes .and. strzero(year(_ddataini),4)==tmp1->ano
			_nexplosao:=int(tmp1->neces)
		else
			_nexplosao:=0
		endif
		// QUANTIDADE A COMPRAR
		if _i==1
			_ncomprar:=int(_nneces-(_nsaldo+_nsolic+_npedido+_nsolicat+_npedidoat))
		else
			_ncomprar:=int(_nneces-(_nsaldo+_nsolic+_npedido))
		endif
		if _ncomprar<0
			_ncomprar:=0
		endif
		
		// AJUSTE LOTE MINIMO
		if _ncomprar%_nlm>0
			_nquantlm:=int(_ncomprar/_nlm)+1
			_najustelm:=int(_nquantlm*_nlm)
		else
			_najustelm:=_ncomprar
		endif
		
		// SALDO FINAL
		if _i==1
			_nsaldofim:=(_nsaldo+_nsolic+_npedido+_nsolicat+_npedidoat+_najustelm)-(_nneces)
		else
			_nsaldofim:=(_nsaldo+_nsolic+_npedido+_najustelm)-(_nneces)
		endif
		if _i==2
			@ prow(),007   PSAY _cdescpro2
		endif

//CODIGO DESCRICAO                                  MES     ESTOQUE     EXPLOSAO  % EST.   SOLICIT.     PEDIDO     EMPENHO     TOTAL A  %COBERT. QUANT. A     AJUSTE       VALOR     VALOR        LOTE      EMBALAGEM"
//                                                            DIA          PMP     EXPL.    COMPRA      COMPRA                 RECEBER   DESEJ.  COMPRAR     LOTE MIN.   UNITARIO  DE COMPRA     MINIMO       PADRAO"
//999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/9999 999.999.999 999.999.999 999.99 999.999.999 999.999.999 999.999.999 999.999.999 999.99 999.999.999 999.999.999 999.999,99 999.999,99 999.999.999 999.999.999,99

		@ prow(),048 PSAY strzero(month(_ddataini),2)+"/"+strzero(year(_ddataini),4) // Mês
		@ prow(),056 PSAY _nsaldo    picture "@E 999,999,999" // Estoque Dia
		//**DESATIVADO @ prow(),060 PSAY _ncobert   picture "@E 999999.99"   // Cobertura Dias
		@ prow(),068 PSAY _nexplosao picture "@E 999,999,999" // Explosão PMP
		@ prow(),080 PSAY (_nexplosao/_nsaldo)*100 picture "@E 999.99" // % Estoque/Explosão 
		@ prow(),087 PSAY _nsolic    picture "@E 999,999,999" // Solicit. Compras
		@ prow(),099 PSAY _npedido   picture "@E 999,999,999" // Pedido Compras
		if _i==1
			@ prow(),111 PSAY _nempenho  picture "@E 999,999,999" // Empenho
		endif
		//**DESATIVADO @ prow(),118 PSAY _nneces    picture "@E 999,999,999" // Total Saídas
//		@ prow(),123 PSAY (_nsolic+_npedido+_nempenho)    picture "@E 999,999,999" // Total a Receber
		if _i==1
			@ prow(),123 PSAY (_nsolic+_npedido+_nsolicat+_npedidoat)    picture "@E 999,999,999" // Total a Receber
		else
			@ prow(),123 PSAY (_nsolic+_npedido)    picture "@E 999,999,999" // Total a Receber
		endif
      // buscar % Cobertura Desejado (SHC)
		// @ prow(),135 PSAY _ncomprar  picture "@E 999,999,999" // % Cobertura Desejado
		@ prow(),142 PSAY _ncomprar  picture "@E 999,999,999" // Quant. a Comprar
		@ prow(),154 PSAY _najustelm picture "@E 999,999,999" // Ajuste Lote Mínimo
		// **DESATIVADO @ prow(),162 PSAY _nsaldofim picture "@E 999,999,999" // Saldo Final
		_nvalunit:=_najustelm*_nultcompra
		@ prow(),166 PSAY _nvalunit picture "@E 999,999.99" // Valor Unitário
		@ prow(),177 PSAY _nultcompra picture "@E 999,999.99" // Valor de Compra
//		@ prow(),177 PSAY _nvalcompra picture "@E 999,999.99" // Valor de Compra
		@ prow(),188 PSAY _nlm        picture "@E 999,999,999" // Lote Mínimo
		
		@ prow(),200 PSAY _nembpad    picture "@E 999,999,999.99"// Embalagem Padrão
		// **DESATIVADO @ prow(),194 PSAY "" // SEGURANCA DIDAS
		@ prow()+1,000 PSAY ""
		_i++
		if strzero(month(_ddataini),2)==tmp1->mes .and. strzero(year(_ddataini),4)==tmp1->ano
			tmp1->(dbskip())
		endif
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			eject
			lcontinua:=.f.
		endif
	end
	@ prow()+1,000 PSAY replicate("-",limite)
end

cabec1:="ITENS SEM MOVIMENTACAO NO MRP"
//cabec2:="CODIGO DESCRICAO                                ARMAZEM  QUANTIDADE LOTE       VALIDADE S. C.  IT  NECES.  P. C.  IT ENTREGA"
cabec2:="CODIGO DESCRICAO                                ARMAZEM  QUANTIDADE LOTE       VALIDADE S. C.     NECESS P. C.   ENTREGA"
cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)

tmp3->(dbgotop())
while ! tmp3->(eof())
	
	tmp1->(dbsetorder(1))
	
	if ! tmp1->(dbseek(tmp3->produto))
		_lmudalin:=.f.
		_limpprod:=.t.
		sb8->(dbsetorder(1))
		sb8->(dbseek(_cfilsb8+tmp3->produto))
		while ! sb8->(eof()) .and.;
			sb8->b8_filial==_cfilsb8 .and.;
			sb8->b8_produto==tmp3->produto
			
			_nsaldolot:=0
			_clocal   :=sb8->b8_local
			_clotectl :=sb8->b8_lotectl
			_ddtvalid :=sb8->b8_dtvalid
			while ! sb8->(eof()) .and.;
				sb8->b8_filial==_cfilsb8 .and.;
				sb8->b8_produto==tmp3->produto .and.;
				sb8->b8_local==_clocal .and.;
				sb8->b8_lotectl==_clotectl
				_nsaldolot+=(sb8->b8_saldo-sb8->b8_empenho)
				sb8->(dbskip())
			end
			if prow()>60
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			if _nsaldolot>0
				if _limpprod
					@ prow()+1,000 PSAY left(tmp3->produto,6)
					@ prow(),007   PSAY left(tmp3->descri,40)
					_limpprod:=.f.
				endif
				if prow()>60
					cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
				endif
				if _lmudalin
					@ prow()+1,051 PSAY _clocal
				else
					@ prow(),051 PSAY _clocal
					_lmudalin:=.t.
				endif
				@ prow(),056   PSAY _nsaldolot picture "@E 999,999,999"
				@ prow(),068   PSAY _clotectl
				@ prow(),079   PSAY _ddtvalid
			endif
		end
		
		// SOLICITACAO DE COMPRA
		_cquery:=" SELECT"
		_cquery+=" C1_NUM NUMERO,C1_ITEM ITEM,C1_LOCAL LOCAL,(C1_QUANT-C1_QUJE) QUANT,C1_DATPRF DTNECES"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SC1")+" SC1"
		_cquery+=" WHERE "
		_cquery+="     SC1.D_E_L_E_T_<>'*'"
		_cquery+=" AND C1_FILIAL='"+_cfilsc1+"'"
		_cquery+=" AND C1_PRODUTO='"+tmp3->produto+"'"
		_cquery+=" AND (C1_QUANT-C1_QUJE)>0"
		_cquery+=" ORDER BY"
		_cquery+=" C1_DATPRF,C1_NUM,C1_ITEM"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery alias "TMP2" new
		tcsetfield("TMP2","QUANT"  ,"N",15,2)
		tcsetfield("TMP2","DTNECES","D")
		
		tmp2->(dbgotop())
		while ! tmp2->(eof())
			if prow()>60
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			if _limpprod
				@ prow()+1,000 PSAY left(tmp3->produto,6)
				@ prow(),007   PSAY left(tmp3->descri,40)
				_limpprod:=.f.
			endif
			if prow()>60
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			if _lmudalin
				@ prow()+1,051 PSAY tmp2->local
			else
				@ prow(),051 PSAY tmp2->local
				_lmudalin:=.t.
			endif
			@ prow(),056   PSAY tmp2->quant picture "@E 999,999,999"
			@ prow(),088   PSAY tmp2->numero
			@ prow(),095   PSAY tmp2->dtneces
			tmp2->(dbskip())
		end
		tmp2->(dbclosearea())
		
		// PEDIDO DE COMPRA
		_cquery:=" SELECT"
		_cquery+=" C7_NUM NUMERO,C7_ITEM ITEM,C7_LOCAL LOCAL,(C7_QUANT-C7_QUJE) QUANT,C7_DATPRF ENTREGA"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SC7")+" SC7"
		_cquery+=" WHERE "
		_cquery+="     SC7.D_E_L_E_T_<>'*'"
		_cquery+=" AND C7_FILIAL='"+_cfilsc7+"'"
		_cquery+=" AND C7_PRODUTO='"+tmp3->produto+"'"
		_cquery+=" AND (C7_QUANT-C7_QUJE)>0"
		_cquery+=" AND C7_RESIDUO=' '"
		_cquery+=" ORDER BY"
		_cquery+=" C7_DATPRF,C7_NUM,C7_ITEM"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery alias "TMP2" new
		tcsetfield("TMP2","QUANT"  ,"N",15,2)
		tcsetfield("TMP2","ENTREGA","D")
		
		tmp2->(dbgotop())
		while ! tmp2->(eof())
			if prow()>60
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			if _limpprod
				@ prow()+1,000 PSAY left(tmp3->produto,6)
				@ prow(),007   PSAY left(tmp3->descri,40)
				_limpprod:=.f.
			endif
			if prow()>60
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			if _lmudalin
				@ prow()+1,051 PSAY tmp2->local
			else
				@ prow(),051 PSAY tmp2->local
				_lmudalin:=.t.
			endif
			@ prow(),056   PSAY tmp2->quant picture "@E 999,999,999"
			@ prow(),107   PSAY tmp2->numero
			@ prow(),114   PSAY tmp2->entrega
			tmp2->(dbskip())
		end
		tmp2->(dbclosearea())
	endif
	tmp3->(dbskip())
end

if prow()>0 .and.;
	lcontinua
	roda(cbcont,cbtxt)
endif

set device to screen

_cindtmp11+=tmp1->(ordbagext())
_cindtmp12+=tmp1->(ordbagext())
tmp1->(dbclosearea())
ferase(_carqtmp1+getdbextension())
ferase(_cindtmp11)
ferase(_cindtmp12)
tmp3->(dbclosearea())

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif

ms_flush()
return

static function _geratmp()
procregua(shc->(lastrec()))                

_ddataini:=_adataini[1]
_ddatafim:=_adatafim[mv_par09]
shc->(dbsetorder(1))
shc->(dbseek(_cfilshc+dtos(_ddataini),.t.))
while ! shc->(eof()) .and.;
	shc->hc_filial==_cfilshc .and.;
	shc->hc_data<=_ddatafim
	incproc("Calculando necessidades...")
	sb1->(dbsetorder(1))
	sb1->(dbseek(_cfilsb1+shc->hc_produto))
	_nregsb1:=sb1->(recno())    

	_calcnec(shc->hc_produto,sb1->b1_qb,shc->hc_quant,1)
	sb1->(dbgoto(_nregsb1))
	_calcpi(shc->hc_produto,sb1->b1_qb,shc->hc_quant)
	shc->(dbskip())
end                                              

incproc("Selecionando produtos...")
_cquery:=" SELECT"
_cquery+=" B1_COD PRODUTO,B1_DESC DESCRI"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1"
_cquery+=" WHERE "
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" ORDER BY"
_cquery+=" 2,1"

_cquery:=changequery(_cquery)
tcquery _cquery alias "TMP3" new
return

static function _calcnec(_ccodpro,_nqb,_nquant,_recursivo)
_cquer2:=""                   
_pmpatend:= 0
_explosao:=0 

sg1->(dbsetorder(1))
sg1->(dbseek(_cfilsg1+_ccodpro))

while ! sg1->(eof()) .and.;
	sg1->g1_filial==_cfilsg1 .and.;
	sg1->g1_cod==_ccodpro
	sb1->(dbsetorder(1))
	sb1->(dbseek(_cfilsb1+sg1->g1_comp)) 

	if sg1->g1_comp>=mv_par01 .and.;
		sg1->g1_comp<=mv_par02 .and.;
		left(sg1->g1_comp,3)<>"MOD"

			if sb1->b1_grupo>=mv_par03 .and.;
			sb1->b1_grupo<=mv_par04 .and.;
			sb1->b1_tipo>=mv_par05 .and.;
			sb1->b1_tipo<=mv_par06
			_nneces:=round((sg1->g1_quant/_nqb)*_nquant,2)
			if _recursivo==1
				_nregsg1:=sg1->(recno())
				_nregsg2:=sg1->(recno())
			else
				_nregsg2:=sg1->(recno())
			endif

			if sg1->(dbseek(_cfilsg1+sg1->g1_comp))			
				_calcnec(sg1->g1_cod,sb1->b1_qb,_nneces,2)
				sg1->(dbgoto(_nregsg1)) 
			else
				sg1->(dbgoto(_nregsg2))
								
				_cmes:=strzero(month(shc->hc_data),2)
				_cano:=strzero(year(shc->hc_data),4)

				incproc("Selecionando PMP ja atendido...")
				_cquer2:=" SELECT"
				_cquer2+=" SUM(C2_QUANT) QTPMP"
				_cquer2+=" FROM "
				_cquer2+=  retsqlname("SC2")+" SC2"
				_cquer2+=" WHERE "
				_cquer2+="     SC2.D_E_L_E_T_<>'*'"
				_cquer2+=" AND C2_FILIAL='"+_cfilsc2+"'"
				_cquer2+=" AND C2_PRODUTO = '"+_ccodpro+"'"
				_cquer2+=" AND C2_EMISSAO BETWEEN '"+_cano+_cmes+"01"+"' AND '"+dtos(lastday(ctod("01/"+_cmes+"/"+_cano)))+"'"
				
				_cquer2:=changequery(_cquer2)
				tcquery _cquer2 alias "TMP4" new
				tcsetfield("TMP4","QTPMP"  ,"N",15,2)                   
			
				tmp4->(dbgotop())
				_pmpatend:= int(tmp4->qtpmp)
				tmp4->(dbclosearea())
			
				if (_nquant - _pmpatend) < 0
					_explosao := 0
				else 
					_explosao := (_nquant - _pmpatend)
				endif
			
				_nneces:=round((sg1->g1_quant/_nqb)*_explosao,2)

				tmp1->(dbsetorder(1))
				if ! tmp1->(dbseek(sg1->g1_comp+_cano+_cmes))
					tmp1->(dbappend())
					tmp1->produto:=sg1->g1_comp
					tmp1->descri   :=sb1->b1_desc
					tmp1->mes    :=_cmes
					tmp1->ano    :=_cano
					tmp1->neces  :=_nneces
					tmp1->lm     :=sb1->b1_lm
					tmp1->locpad :=sb1->b1_locpad
					tmp1->embpad :=sb1->b1_qe
					tmp1->ultcom :=sb1->b1_uprc
				else
					tmp1->neces  +=_nneces
				endif
				
			endif
		endif
	endif
	sg1->(dbskip())
end
return


static function _calcpi(_ccodpro,_nqb,_nquant)
sg1->(dbsetorder(1))
sg1->(dbseek(_cfilsg1+_ccodpro))
while ! sg1->(eof()) .and.;
	sg1->g1_filial==_cfilsg1 .and.;
	sg1->g1_cod==_ccodpro
	sb1->(dbsetorder(1))
	sb1->(dbseek(_cfilsb1+sg1->g1_comp))
	if sb1->b1_tipo == "PI"
		_nregsg1:=sg1->(recno())
		_calcnec(sg1->g1_comp,sb1->b1_qb,(sg1->g1_quant/_nqb)*_nquant,2)
		sg1->(dbgoto(_nregsg1))
	endif
	sg1->(dbskip())
end
return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do grupo           ?","mv_ch3","C",04,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"04","Ate o grupo        ?","mv_ch4","C",04,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"05","Do tipo            ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"06","Ate o tipo         ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"07","Mes de referencia  ?","mv_ch7","C",02,0,0,"G",'pertence("01#02#03#04#05#06#07#08#09#10#11#12")',"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ano de referencia  ?","mv_ch8","C",04,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Quantos meses      ?","mv_ch9","N",02,0,0,"G",'naovazio()',"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
CODIGO DESCRICAO                                  ESTOQUE   COBERTURA   SOLICIT.     PEDIDO     EMPENHO     EXPLOSAO     TOTAL     QUANT. A     AJUSTE      MES      SALDO        LOTE    MERCADO SEGURANCA
DIA        DIAS      COMPRA      COMPRA                    PMP       SAIDAS    COMPRAR     LOTE MIN.             FINAL       MINIMO             DIAS
999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999.999 999999,99 999.999.999 999.999.999 999.999.999 999.999.999 999.999.999 999.999.999 999.999.999 99/9999 999.999.999 999.999.999 XXXXXXX 999999,99

CODIGO DESCRICAO                                ARMAZEM  QUANTIDADE LOTE       VALIDADE S. C.  IT  NECES.  P. C.  IT ENTREGA
999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    99   999.999.999 XXXXXXXXXX 99/99/99 999999 99 99/99/99 999999 99 99/99/99
*/
