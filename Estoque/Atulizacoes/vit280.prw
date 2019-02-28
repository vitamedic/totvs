/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT280   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 01/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Manutencao nas Fichas de Descarte                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
#include "protheus.ch"
#include "rwmake.ch"

user function vit280()
private _cfilszi
private _cfilszj
private _cfilszk

_cfilszi:=xfilial("SZI")
_cfilszj:=xfilial("SZJ")
_cfilszk:=xfilial("SZK")

arotina:={}
aadd(arotina,{"Pesquisar" ,"AXPESQUI" ,0,1})
aadd(arotina,{"Visualizar","U_VIT280A",0,2})
aadd(arotina,{"Incluir"   ,"U_VIT280A",0,3})
aadd(arotina,{"Alterar"   ,"U_VIT280A",0,4})
aadd(arotina,{"Excluir"   ,"U_VIT280A",0,5})
aadd(arotina,{"Imprimir"  ,"U_VIT282" ,0,6})

ccadastro:="Ficha de descarte"

set key VK_F4 to U_VIT280L()

szj->(dbsetorder(1))
szj->(dbseek(_cfilszj))

mbrowse(06,01,22,75,"SZJ",,"!ZJ_IMPRES")

set key VK_F4 to
return()

user function vit280a(_calias,_nreg,_nopc,_lconsulta)
if _nopc==4 .and.;
	szj->zj_impres=="S"
	
	msginfo("Ficha ja impressa! Alteracao nao permitida!")
elseif _nopc==5 .and.;
	szj->zj_impres=="S"
	
	msginfo("Ficha ja impressa! Exclusao nao permitida!")
else
	private aheader:={}
	private acols  :={}
	private atela  :={}
	private agets  :={}
	
	acampos :={"ZK_NUMERO"}
	nusado  :=0
	aobjects:={}
	_nopca  :=0
	
	sx3->(dbsetorder(1))
	sx3->(dbseek("SZK"))
	while ! sx3->(eof()) .and.;
		sx3->x3_arquivo=="SZK"
		
		if ascan(acampos,alltrim(sx3->x3_campo))==0 .and.;
			x3uso(sx3->x3_usado) .and.;
			cnivel>=sx3->x3_nivel
			
			aadd(aheader,{alltrim(x3titulo()),sx3->x3_campo,sx3->x3_picture,sx3->x3_tamanho,sx3->x3_decimal,sx3->x3_valid,sx3->x3_usado,sx3->x3_tipo,sx3->x3_arquivo,sx3->x3_context})
			nusado++
		endif
		
		sx3->(dbskip())
	end
	
	if inclui
		regtomemory("SZJ",.t.,.f.)
	else
		regtomemory("SZJ",.f.,.f.)
	endif
	
	if ! inclui
		szk->(dbsetorder(1))
		szk->(dbseek(szj->zj_filial+szj->zj_numero))
		while ! szk->(eof()) .and.;
			szk->zk_filial==szj->zj_filial .and.;
			szk->zk_numero==szj->zj_numero
			
			aadd(acols,array(nusado+1))
			
			for _ni:=1 to nusado
				if aheader[_ni,10]<>"V"
					acols[len(acols),_ni]:=szk->(fieldget(fieldpos(aheader[_ni,2])))
				else
					acols[len(acols),_ni]:=criavar(aheader[_ni,2],.t.)
				endif
			next
			acols[len(acols),nusado+1]:=.f.
			
			szk->(dbskip())
		end
	endif
	
	if empty(acols)
		aadd(acols,array(nusado+1))
		
		for _ni:=1 to nusado
			if alltrim(aheader[_ni,2])=="ZK_ITEM"
				acols[len(acols),_ni]:=strzero(1,len(szk->zk_item))
			else
				acols[len(acols),_ni]:=criavar(aheader[_ni,2],.t.)
			endif
		next
		acols[len(acols),nusado+1]:=.f.
	endif
	
	asize:=msadvsize()
	aadd(aobjects,{100,100,.t.,.t.})
	aadd(aobjects,{200,200,.t.,.t.})
	ainfo  :={asize[1],asize[2],asize[3],asize[4],5,5}
	aposobj:=msobjsize(ainfo,aobjects,.t.)
	
	define msdialog odlg title ccadastro from asize[7],0 to asize[6],aSize[5] of omainwnd pixel
	enchoice("SZJ",_nreg,_nopc,,,,,aposobj[1],,3,,,,,,.t.)
	ogetd:=msgetdados():new(aposobj[2,1],aposobj[2,2],aposobj[2,3],aposobj[2,4],_nopc,"ALLWAYSTRUE()","ALLWAYSTRUE()","+ZK_ITEM",.t.,,1,,9999)
	private ogetdad:=ogetd
	activate msdialog odlg on init enchoicebar(odlg,{||_nopca:= 1,if(ogetd:tudook(),if(! obrigatorio(agets,atela),_nopca:=0,odlg:end()),_nopca:=0)},{||odlg:end()})
	
	if _nopca==1 .and.;
		_nopc<>2
		
		begin transaction
		
		if _nopc==3 // INCLUIR
			reclock("SZJ",.t.)
			szj->zj_filial:=_cfilszj
		else // ALTERAR OU EXCLUIR
			reclock("SZJ",.f.)
		endif
		if _nopc==5 // EXCLUIR
			szj->(dbdelete())
		else // INCLUIR OU ALTERAR
			for _ni:=1 to szj->(fcount())
				_ccampo:=upper(alltrim(szj->(fieldname(_ni))))
				if _ccampo<>"ZJ_FILIAL"
					_cvar  :="M->"+_ccampo
					if valtype(&_cvar)<>"U"
						szj->(fieldput(_ni,&_cvar))
					endif
				endif
			next
		endif
		msunlock()
		
		if _nopc==5 // EXCLUIR
			szk->(dbsetorder(1))
			szk->(dbseek(_cfilszk+m->zj_numero))
			while ! szk->(eof()) .and.;
				szk->zk_filial==_cfilszk .and.;
				szk->zk_numero==m->zj_numero
				
				reclock("SZK",.f.)
				szk->(dbdelete())
				msunlock()
				
				szk->(dbskip())
			end
		else
			_citem :=strzero(1,len(szk->zk_item))
			_npitem:=ascan(aheader,{|x| upper(alltrim(x[2]))=="ZK_ITEM"})
			
			for _nj:=1 to len(acols)
				if ! acols[_nj,nusado+1]
					if _nopc==3 // INCLUIR
						reclock("SZK",.t.)
						szk->zk_filial:=_cfilszk
						szk->zk_numero:=m->zj_numero
					else // ALTERAR
						_citem:=acols[_nj,_npitem]
						szk->(dbsetorder(1))
						if szk->(dbseek(_cfilszk+m->zj_numero+_citem))
							reclock("SZK",.f.)
						else
							reclock("SZK",.t.)
							szk->zk_filial:=_cfilszk
							szk->zk_numero:=m->zj_numero
						endif
					endif
					
					for _ni:=1 to szk->(fcount())
						_ccampo:=upper(alltrim(szk->(fieldname(_ni))))
						_np    :=ascan(aheader,{|x| upper(alltrim(x[2]))==_ccampo})
						if _np>0
							szk->(fieldput(_ni,acols[_nj,_np]))
						endif
					next
					szk->zk_item:=_citem
					_citem:=soma1(_citem)
					msunlock()
				elseif _nopc==4 // ALTERAR
					_citem:=acols[_nj,_npitem]
					szk->(dbsetorder(1))
					if szk->(dbseek(_cfilszk+m->zj_numero+_citem))
						reclock("SZK",.f.)
						szk->(dbdelete())
						msunlock()
					endif
				endif
			next
		endif
		
		if __lsx8
			confirmsx8()
		endif
		evaltrigger()
		
		end transaction
	endif
	
	if __lsx8
		rollbacksxe()
	endif
	msunlockall()
	freeusedcode()
endif
return()

user function vit280b()
_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsb8:=xfilial("SB8")

_lok:=.t.

_cvar:=upper(alltrim(readvar()))

_npproduto:=ascan(aheader,{|x| upper(alltrim(x[2]))=="ZK_PRODUTO"})
_npdescpro:=ascan(aheader,{|x| upper(alltrim(x[2]))=="ZK_DESCPRO"})
_npum     :=ascan(aheader,{|x| upper(alltrim(x[2]))=="ZK_UM"})
_npquant  :=ascan(aheader,{|x| upper(alltrim(x[2]))=="ZK_QUANT"})
_nplocal  :=ascan(aheader,{|x| upper(alltrim(x[2]))=="ZK_LOCAL"})
_nplotectl:=ascan(aheader,{|x| upper(alltrim(x[2]))=="ZK_LOTECTL"})
_npdtvalid:=ascan(aheader,{|x| upper(alltrim(x[2]))=="ZK_DTVALID"})
_npcusto  :=ascan(aheader,{|x| upper(alltrim(x[2]))=="ZK_CUSTO"})
_nptipo   :=ascan(aheader,{|x| upper(alltrim(x[2]))=="ZK_TIPO"})
_npgrupo  :=ascan(aheader,{|x| upper(alltrim(x[2]))=="ZK_GRUPO"})
_nppeso   :=ascan(aheader,{|x| upper(alltrim(x[2]))=="ZK_PESO"})

if _cvar=="M->ZK_PRODUTO"
	_cproduto:=m->zk_produto
	sb1->(dbsetorder(1))
	if sb1->(dbseek(_cfilsb1+_cproduto))
		acols[n,_npdescpro]:=sb1->b1_desc
		acols[n,_npum]     :=sb1->b1_um
		acols[n,_nplocal]  :=sb1->b1_locpad
		acols[n,_nptipo]   :=sb1->b1_tipo
		acols[n,_npgrupo]  :=sb1->b1_grupo
		_clocal            :=sb1->b1_locpad
	else
		_lok:=.f.
		msginfo("Produto nao cadastrado!")
	endif
else
	_cproduto:=acols[n,_npproduto]
	sb1->(dbsetorder(1))
	sb1->(dbseek(_cfilsb1+_cproduto))
endif

if _cvar=="M->ZK_QUANT"
	_nquant  :=m->zk_quant
	if _nquant<=0
		_lok:=.f.
		msginfo("Quantidade invalida!")
	endif
else
	_nquant  :=acols[n,_npquant]
endif

if _cvar=="M->ZK_LOCAL"
	_clocal:=m->zk_local
	sb2->(dbsetorder(1))
	if ! sb2->(dbseek(_cfilsb2+_cproduto+_clocal))
		_lok:=.f.
		msginfo("Produto inexistente na tabela de saldos!")
	endif
else
	_clocal:=acols[n,_nplocal]
	sb2->(dbsetorder(1))
	sb2->(dbseek(_cfilsb2+_cproduto+_clocal))
endif

if _cvar=="M->ZK_LOTECTL"
	_clotectl:=m->zk_lotectl
	sb8->(dbsetorder(3))
	if sb8->(dbseek(_cfilsb8+_cproduto+_clocal+_clotectl))
		acols[n,_npdtvalid]:=sb8->b8_dtvalid
	else
		_lok:=.f.
		msginfo("Lote inexistente!")
	endif
endif

if _lok
	if sb1->b1_tipo$"PA/PL"
		acols[n,_nppeso]:=round(_nquant*sb1->b1_peso,3)
	elseif sb1->b1_tipo=="MP"
		acols[n,_nppeso]:=round(_nquant/1000,3)
	else
		acols[n,_nppeso]:=0
	endif
	
	acols[n,_npcusto]:=round(_nquant*sb2->b2_cm1,2)
endif
return(_lok)

user function vit280l()
private nposprod
private nposlocal
private nposlotctl
private nposdvalid

_cvar:=upper(alltrim(readvar()))
if _cvar=="M->ZK_LOTECTL
	nposprod  :=ascan(aheader,{|x| upper(alltrim(x[2]))=="ZK_PRODUTO"})
	nposlocal :=ascan(aheader,{|x| upper(alltrim(x[2]))=="ZK_LOCAL"})
	nposlotctl:=ascan(aheader,{|x| upper(alltrim(x[2]))=="ZK_LOTECTL"})
	nposdvalid:=ascan(aheader,{|x| upper(alltrim(x[2]))=="ZK_DTVALID"})
	
	_cproduto:=acols[n,nposprod]
	_clocal  :=acols[n,nposlocal]
	f4lote(,,,"VIT280",_cproduto,_clocal)
endif
return()
