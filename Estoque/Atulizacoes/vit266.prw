/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT266   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 13/09/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Liberacao para Atualizacao de Estrutura                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
#include "rwmake.ch"
#include "topconn.ch"

user function vit266()
_cfilszg:=xfilial("SZG")

ccadastro:="Liberação para atualização de estrutura"

arotina  :={}
aadd(arotina,{"Pesquisar" ,'AXPESQUI'                                    ,0,1})
aadd(arotina,{"Visualizar",'AXVISUAL'                                    ,0,2})
aadd(arotina,{"Incluir"   ,'AXINCLUI("SZG",,,,,,"U_VIT266IN()")'         ,0,3})
aadd(arotina,{"Alterar"   ,'U_VIT266AL()'                                ,0,4})
aadd(arotina,{"Excluir"   ,'U_VIT266DE1()'                                ,0,5})
aadd(arotina,{"enCerrar"  ,'U_VIT266EN1()'                                ,0,6})
aadd(arotina,{"enc. Todos",'U_VIT266ET1()'                                ,0,7})
aadd(arotina,{"imPrimir"  ,'execblock("VIT266IP",.f.,.f.)'               ,0,8})
aadd(arotina,{"imp.esTrut",'execblock("VIT266PR",.f.,.f.)'               ,0,9})


szg->(dbsetfilter({|| zg_filial==_cfilszg .and. empty(zg_dataenc)},"zg_filial==_cfilszg .and. empty(zg_dataenc)"))

szg->(dbgotop())
mbrowse(006,001,022,075,"SZG")

szg->(dbclearfil())
return()

// VALIDA A INCLUSÃO
user function vit266in()
_lok:=.t.

_cfilsb1:=xfilial("SB1")

sb1->(dbsetorder(1))
sb1->(dbseek(_cfilsb1+m->zg_cod))

sb1->(reclock("SB1",.f.))
sb1->b1_altestr:="S"
sb1->b1_valestr:=m->zg_valestr
sb1->(msunlock())

return(_lok)

// VALIDA A ALTERAÇÃO
user function vit266al()
_cproduto:=szg->zg_cod

_nopcao:=axaltera("SZG",recno(),4)

if _nopcao==1
	_cfilsb1:=xfilial("SB1")
	
	sb1->(dbsetorder(1))
	sb1->(dbseek(_cfilsb1+_cproduto))
	
	sb1->(reclock("SB1",.f.))
	sb1->b1_altestr:="S"
	sb1->b1_valestr:=szg->zg_valestr
	sb1->(msunlock())
	
	szg->(reclock("SZG",.f.))
	szg->zg_usualt :=cusername
	szg->zg_dataalt:=ddatabase
	szg->(msunlock())
endif
return()

// VALIDA A EXCLUSÃO
user function vit266de1()
_cproduto:=szg->zg_cod

_nopcao:=axdeleta("SZG",recno(),5)

if _nopcao==2
	_lok:=.t.
	
	_cfilsb1:=xfilial("SB1")
	
	sb1->(dbsetorder(1))
	sb1->(dbseek(_cfilsb1+_cproduto))
	
	sb1->(reclock("SB1",.f.))
	sb1->b1_altestr:="N"
	sb1->b1_valestr:=ctod("  /  /  ")
	sb1->(msunlock())
endif
return()

// ENCERRA LIBERAÇÃO
user function vit266en1()
if MSGYESNO("Confirma o encerramento da alteração da estrutura?")
	
	_cfilsb1:=xfilial("SB1")
	
	sb1->(dbsetorder(1))
	sb1->(dbseek(_cfilsb1+szg->zg_cod))
	
	sb1->(reclock("SB1",.f.))
	sb1->b1_altestr:="N"
	sb1->b1_valestr:=ctod("  /  /  ")
	sb1->(msunlock())
	
	szg->(reclock("SZG",.f.))
	szg->zg_usuenc :=cusername
	szg->zg_dataenc:=ddatabase
	szg->(msunlock())
	
	sysrefresh()
endif
return()

// ENCERRA LIBERAÇÃO DE TODOS OS PRODUTOS
user function vit266et1()
if MSGYESNO("Confirma o encerramento da alteração de todas as estruturas?")
	
	_cfilsb1:=xfilial("SB1")
	
	szg->(dbsetorder(1))
	szg->(dbseek(_cfilszg))
	while ! szg->(eof()) .and.;
		szg->zg_filial==_cfilszg
		
		if empty(szg->zg_dataenc)
			sb1->(dbsetorder(1))
			sb1->(dbseek(_cfilsb1+szg->zg_cod))
			
			sb1->(reclock("SB1",.f.))
			sb1->b1_altestr:="N"
			sb1->b1_valestr:=ctod("  /  /  ")
			sb1->(msunlock())
			
			szg->(reclock("SZG",.f.))
			szg->zg_usuenc :=cusername
			szg->zg_dataenc:=ddatabase
			szg->(msunlock())
		endif
		szg->(dbskip())
	end
	sysrefresh()
endif
return()



//Imprimir lista de atualização de estrutura
user function vit266ip()

nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="LIBERACAO DA ATUALIZACAO DE ESTRUTURA"
cdesc1   :="Este programa ira emitir os produtos liberados para "
cdesc2   :="atualizacao da estrutura"
cdesc3   :=""
cstring  :="SZG"
areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog :="VIT266"
wnrel    :="VIT266"
alinha   :={}
nlastkey :=0
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


rptstatus({|| rptdetail()})

return

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

cabec1:="Codigo Descricao                                      Validade OBS"
cabec2:=""

setprc(0,0)

setregua(SZG->(lastrec()))
SZG->(DBGOTOP())
while ! SZG->(eof())  .and.  lcontinua
	incregua()
	sb1->(dbseek(xFilial("SB1")+SZG->ZG_COD))
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	@ prow()+1,000 PSAY left(SZG->ZG_cod,6)+" "+left(SZG->ZG_desc,40)
	@ prow(),054   PSAY SZG->ZG_valestr
	@ prow(),064   PSAY IF(SB1->B1_ALTESTR <>'S',"Nao confirmada","")
	If !Empty(szg->zg_obs)
		_cObs   := Alltrim(szg->zg_obs)
		_nCont  := len(_cObs)
		_nQuebra:= 45
		While  _nCont > 0
			_nQuebra:= 45
			_nQuebra:= at(" ",_cObs,_nQuebra)
			if _nQuebra == 0
				_nQuebra:= len(_cObs)
			Endif
			@ prow()+1,007   PSAY substr(_cObs,1,_nQuebra)
			_cObs := substr(_cObs,_nQuebra+1, len(_cObs))
			_nCont:= len(_cObs)
		End
	Endif
	SZG->(dbskip())
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		lcontinua:=.f.
	endif
end

if prow()>0 .and.;
	lcontinua
	roda(cbcont,cbtxt)
endif

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endIf

ms_flush()
return

*/
user function vit266pr()
//Imprimir Estrutura
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="IMPRESSAO DE ESTRUTURAS "
cdesc1   :="Este programa ira emitir a estrutura dos produtos liberados para "
cdesc2   :="atualizacao da estrutura"
cdesc3   :=""
cstring  :="SZG"
areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog :="VIT266"
wnrel    :="VIT266"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
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


rptstatus({|| rptdetail2()})

return

static function rptdetail2()


cbcont := 0
m_pag  := 1
li     := 132
cbtxt  := space(10)

_cfilsb1:=xfilial("SB1")
_cfilsg1:=xfilial("SG1")
sb1->(dbsetorder(1))
sg1->(dbsetorder(1))

processa({|| _querys()})
tmp1->(dbgotop())
while ! tmp1->(eof())
	if empty(tmp1->zg_dataenc)
		_produto:=tmp1->produto
		mfirst:=.t.
		mfirst2:=.t.
		sb1->(dbseek(_cfilsb1+tmp1->produto))
		_desc:=sb1->b1_desc
		_prvalid:=sb1->b1_prvalid
		_um:=sb1->b1_um
		_apres:= sb1->b1_apres
		//	_le:=sb1->b1_le
		_le:=sb1->b1_qb
		cab266()
		while ! tmp1->(eof()) .and. _produto == tmp1->produto
			_tipo:=tmp1->tipo
			if _tipo =='MP' .or. _tipo=='PI'
				@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------|"
				@ prow()+1,000 PSAY "|                                        MATERIA  PRIMA                                       |"
				@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------|"
				@ prow()+1,000 PSAY "| Codigo| Materia Prima                                     |              Qtde Padrao  | UM  |"
				@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------|"
			elseif _tipo =='EE'
				@ prow()+3,000 PSAY "|---------------------------------------------------------------------------------------------|"
				@ prow()+1,000 PSAY "|                                   MATERIAL DE EMBALAGEM ESSENCIAL                           |"
				@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------|"
				@ prow()+1,000 PSAY "| Codigo| Material                                          |              Qtde Padrao  | UM  |"
				@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------|"
			elseif _tipo =='EN'
				@ prow()+3,000 PSAY "|---------------------------------------------------------------------------------------------|"
				@ prow()+1,000 PSAY "|                                 MATERIAL DE EMBALAGEM NAO ESSENCIAL                         |"
				@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------|"
				@ prow()+1,000 PSAY "| Codigo| Materia Prima                                     |              Qtde Padrao  | UM  |"
				@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------|"
			endif
			while ! tmp1->(eof()) .and. _tipo == tmp1->tipo
				_qtde :=0
				_comp:=tmp1->comp
				_desccomp :=tmp1->descri
				_umcomp := tmp1->um
				while ! tmp1->(eof()) .and. _comp == tmp1->comp
					_qtde += tmp1->quant //* _le
					tmp1->(dbskip())
				end
				if _tipo =='MP' .or. _tipo=='PI'
					@ prow()+1,000 PSAY "|"
					@ prow(),001 PSAY left(_comp,6)
					@ prow(),008 PSAY "|"
					@ prow(),010 PSAY _desccomp
					@ prow(),060 PSAY "|"
					@ prow(),070 PSAY _qtde  picture "@E 999,999,999.999999"
					@ prow(),088 PSAY "|"
					@ prow(),090 PSAY _umcomp
					@ prow(),094 PSAY "|"
					//				@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------|"
					
				elseif _tipo =='EE'
					@ prow()+1,000 PSAY "|"
					@ prow(),001 PSAY left(_comp,6)
					@ prow(),008 PSAY "|"
					@ prow(),010 PSAY _desccomp
					@ prow(),060 PSAY "|"
					@ prow(),070 PSAY _qtde  picture "@E 999,999,999.999999"
					@ prow(),088 PSAY "|"
					@ prow(),090 PSAY _umcomp
					@ prow(),094 PSAY "|"
					
				elseif _tipo =='EN'
					@ prow()+1,000 PSAY "|"
					@ prow(),001 PSAY left(_comp,6)
					@ prow(),008 PSAY "|"
					@ prow(),010 PSAY _desccomp
					@ prow(),060 PSAY "|"
					@ prow(),070 PSAY _qtde  picture "@E 999,999,999.999999"
					@ prow(),088 PSAY "|"
					@ prow(),090 PSAY _umcomp
					@ prow(),094 PSAY "|"
					
				endif
			end
			@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------|"
		end
		@ prow()+3,000 PSAY "|---------------------------------------------------------------------------------------------|"
		@ prow()+1,000 PSAY "|ELABORADO POR       | REVISADO POR         |	       APROVADO POR |(GARANTIA DA QUALIDADE   |"
		@ prow()+1,000 PSAY "|--------------------|----------------------|-----------------------|-------------------------|"
		@ prow()+1,000 PSAY "|Nome:               |Nome:                 |Nome:                  |Nome:                    |"
		@ prow()+1,000 PSAY "|Data:____/____/____ |Data:____/____/____   |Data:____/____/____    |Data____/____/____       |"
		@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------|"
		if !eof()
			@  000,000 PSAY " "
		endif
	else		
		tmp1->(dbskip())	
	endif
	//	eject
end
tmp1->(dbclosearea())
Set Device To Screen
if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endIf

ms_flush()
return



static function _querys()
_cquery:=" SELECT"
_cquery+=" ZG_COD COD,"
_cquery+=" B1_DESC DESCRI,B1_TIPO TIPO,B1_UM UM,B1_LOCPAD LOCPAD,B1_GRUPO GRUPO,"
_cquery+=" G1_COD PRODUTO, G1_COMP COMP,G1_QUANT QUANT,ZG_DATAENC"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SG1")+" SG1,"
_cquery+=  retsqlname("SZG")+" SZG"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SG1.D_E_L_E_T_<>'*'"
_cquery+=" AND SZG.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND G1_FILIAL='"+_cfilsg1+"'"
_cquery+=" AND ZG_COD =G1_COD"
_cquery+=" AND B1_COD =G1_COMP"

_cquery+=" ORDER BY  G1_COD,B1_LOCPAD,B1_TIPO,B1_DESC"


_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","QUANT"  ,"N",15,7)
return


Static function cab266()
if mfirst
	setprc(0,0)
	mpag:=1
	mfirst:=.f.
else
	mpag:=mpag+1
endif
@ 000,000 PSAY avalimp(133)
@ 000,000 PSAY chr(18)
@ prow()+1,000 PSAY "Vitapan Industria Farmaceutica Ltda."
@ prow()  ,070 PSAY "Pag.: "+strzero(mpag,3,0)
@ prow()+1,000 PSAY "Produto: "+chr(15)+chr(14)+left(tmp1->produto,6)+"-"+_desc+chr(20)+chr(18)
@ prow()+1,000 PSAY "D.Qumica: "
@ prow(),  064 PSAY "Lote no. 000000"
@ prow()+1,000 PSAY "Apresent:"+substr(_apres,1,50)
//   @ prow()  ,062 PSAY "Emissao: "+dtoc(database())
@ prow()+1,000 PSAY "Revisao:           Data Revisao:   /   /"
@ prow()  ,062 PSAY "Validade: "+strzero((_prvalid/365)*12,2,0)
@ prow()  ,075 PSAY "meses"
@ prow()+1,000 PSAY "                               FORMULA PADRAO "
@ prow()  ,057 PSAY "Qtde.Teorica:"
@ prow()  ,070 PSAY _le picture "@E 999,999"
@ prow()  ,077 PSAY _um
@ prow()+1,000 PSAY replicate("_",79)
@ prow()+1,000 PSAY chr(15)
return

