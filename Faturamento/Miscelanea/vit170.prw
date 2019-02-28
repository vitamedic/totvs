/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT170   ³ Autor ³ Heraildo C. de Freitas³ Data ³11/12/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Leitura de Arquivo Texto do Pocket para Geracao de Pedido  ³±±
±±³          ³ de Venda                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function vit170()
_cperg:="PERGVIT170"
_pergsx1()
if pergunte(_cperg,.t.) .and.;
	msgyesno("Confirma a recepcao dos arquivos?")
	processa({|| _grava()})
	msginfo("Recepcao finalizada!")
endif
return


static function _grava()
_cdir:=alltrim(mv_par01)
if right(_cdir,1)<>"\"
	_cdir+="\"
endif

_cfilsb1:=xfilial("SB1")
sb1->(dbsetorder(1))

_afiles:=directory(_cdir+"*.ped")

procregua(len(_afiles))

for _ni:=1 to len(_afiles)
	_carq   :=_cdir+_afiles[_ni,1]
	_ceol   :=chr(13)+chr(10)
	_nhdl   :=fopen(_carq,68)
	
	incproc("Processando arquivo "+_carq)
	
	if _nhdl==-1
		msgstop("Erro na abertura do arquivo "+_carq)
	else
		_ntamfile:=fseek(_nhdl,0,2)
		fseek(_nhdl,0,0)
		_ntamlin :=209+len(_ceol) // tamanho da primeira linha
		_cbuffer :=space(_ntamlin)
		_nbtlidos:=fread(_nhdl,@_cbuffer,_ntamlin) // leitura da primeira linha do arquivo texto
		
		_acabpv :={}
		_aitempv:={}
		_aitem  :={}
		_nopc   :=3  //3- inclusao  5- exclusao
		
		//		_cnumped:=getsxenum("SC5","C5_NUM")
		//      RollBAckSx8()
		lmshelpauto:=.t.
		lmserroauto:=.f.
		
		_cpocket:=substr(_cbuffer,2,10)
		_ccliente:=substr(_cbuffer,12,6)
		_clojacli:=substr(_cbuffer,18,2)
		_ctabela :=substr(_cbuffer,20,3)
		_ccondpag:=substr(_cbuffer,23,3)
		_ndescit :=val(substr(_cbuffer,26,5))/100
		_cpromoc :=substr(_cbuffer,31,1)
		_cgeragnr:=substr(_cbuffer,32,1)
		_ctransp :=substr(_cbuffer,33,6)
		_ncomis1 :=val(substr(_cbuffer,39,5))/100
		_cmenped :=substr(_cbuffer,44,100)
		_cmennota:=substr(_cbuffer,144,60)
		_cvend1  :=substr(_cbuffer,204,6)
		
		// cabecalho
		_acabpv:={}
		//		aadd(_acabpv,{"C5_NUM"    ,_cnumped ,Nil})
		aadd(_acabpv,{"C5_TIPO"   ,"N"      ,nil})
		aadd(_acabpv,{"C5_CLIENTE",_ccliente,nil})
		aadd(_acabpv,{"C5_LOJACLI",_clojacli,nil})
		//c5_tipocli--preenchido por gatilho
		aadd(_acabpv,{"C5_TABELA" ,_ctabela ,nil})
		aadd(_acabpv,{"C5_CONDPAG",_ccondpag,nil})
		aadd(_acabpv,{"C5_GERAGNR",_cgeragnr,nil})
		aadd(_acabpv,{"C5_DESCIT" ,_ndescit ,nil})
		aadd(_acabpv,{"C5_PROMOC" ,_cpromoc ,nil})
		aadd(_acabpv,{"C5_VEND1"  ,_cvend1  ,nil})
		aadd(_acabpv,{"C5_COMIS1" ,_ncomis1 ,nil})
		aadd(_acabpv,{"C5_MENPED" ,_cmenped ,nil})
		aadd(_acabpv,{"C5_MENNOTA",_cmennota,nil})
		aadd(_acabpv,{"C5_TRANSP" ,_ctransp ,nil})
		aadd(_acabpv,{"C5_EMISSAO",ddatabase,nil})
		aadd(_acabpv,{"C5_POCKET" ,_cpocket ,nil})
		
		//Itens
		_ntamlin :=52+len(_ceol) // tamanho da linha dos itens
		_cbuffer :=space(_ntamlin)
		_nbtlidos:=fread(_nhdl,@_cbuffer,_ntamlin)
		_citem   :="01"
		while _nbtlidos>=_ntamlin
			_cproduto:=substr(_cbuffer,2,6)+space(9)
			sb1->(dbseek(_cfilsb1+_cproduto))
			_cdescpro:=substr(sb1->b1_desc,1,30)
			_nqtdven :=val(substr(_cbuffer,8,9))/100
			_nprcven :=round(val(substr(_cbuffer,17,18))/1000000,2)
			_nvalor  :=val(substr(_cbuffer,35,12))/100
			_ndescont:=val(substr(_cbuffer,47,5))/100
			_cpromoc :=substr(_cbuffer,52,1)
			
			_aitempv:={}
			//			aadd(_aitempv,{"C6_NUM"    ,_cnumped ,Nil})
			aadd(_aitempv,{"C6_ITEM"   ,_citem   ,nil})
			aadd(_aitempv,{"C6_PRODUTO",_cproduto,nil})
			aadd(_aitempv,{"C6_QTDVEN" ,_nqtdven ,nil})
			aadd(_aitempv,{"C6_DESCRI" ,_cdescpro,nil})
			//			aadd(_aitempv,{"C6_PRCVEN" ,_nprcven ,nil})
			//			aadd(_aitempv,{"C6_VALOR"  ,_nvalor  ,nil})
			aadd(_aitempv,{"C6_DESCONT",_ndescont,nil})
			aadd(_aitempv,{"C6_PROMOC" ,_cpromoc ,nil})
			
			aadd(_aitem,_aitempv)
			_citem:=soma1(_citem,2)
			_nbtlidos:=fread(_nhdl,@_cbuffer,_ntamlin)
		end
		//MATA410(_aCabpv,_aItem,_nopc)
		
		msexecauto({|x,y,z| mata410(x,y,z)},_acabpv,_aitem,_nopc)
		
		if lmserroauto
			mostraerro()
		else
			_cnumped:=sc5->c5_num
			
			frename(_carq,"\pocket\pedidos\lidos\"+_afiles[_ni,1])
			
			_carq:=_cvend1+"."+substr(_cpocket,3,8)+"."+strzero(val(_cnumped),7,0)+".ret"
			_nhandle:=fcreate(_carq,0)
			frename(_carq,"\pocket\retornos\"+_carq)
			if _nhandle<0
				msginfo("Erro na criacao do arquivo "+_carq)
			endif
			fwrite(_nhandle,_cvend1)
			fwrite(_nhandle,_cpocket)
			fwrite(_nhandle,_cnumped)
			fwrite(_nhandle,"PEDIDO IMPLANTADO                                 ")
			fwrite(_nhandle,chr(13)+chr(10))                   // MUDANCA DE LINHA
			fclose(_nhdl)
			fclose(_nhandle)
			
			//		frename(_carq,_cdir+"lidos\"+_afiles[_ni,1])
		endif
	endif
next
sysrefresh()
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Diretorio          ?","mv_ch1","C",40,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
