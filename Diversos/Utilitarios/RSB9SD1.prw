#INCLUDE "SIGAWIN.CH"
#INCLUDE "RWMAKE.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RSB9SD1  ³ Autor ³                        ³ Data ³         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Lista o produto trazendo o valor do SB9 e do SD1           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function RSB9SD1()

nordem   :=""
tamanho  :="G"
limite   :=220
titulo   :="CUSTO SB9 X SD1"
cdesc1   :=""
cdesc2   :=""
cdesc3   :=""
cstring  :="SB9"
areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog :="RB9XD1"
wnrel    :="RB9XD1"
alinha   :={}
nlastkey :=0
lcontinua:=.t.
nlin  :=80
cabec1:=""
cabec2:=""
M_pag := 1
cperg:="RB9XD1"

pergunte(cperg,.f.)

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

setprc(0,0)

dbSelectArea("SD1")  //ITENS NF ENTRADA
dbSetorder(7) //d1_filial+d1_cod+d1_local+dtos(d1_dtdigit)+d1_numseq

dbSelectArea("SF4") //TIPOS DE ENTRADA E SAIDA
dbSetorder(1) //f4_filial+f4_nforig+f8_serorig+f8_fornece+f8_loja

dbSelectArea("SF8") //AMARRACAO NF ORIG X NF IMP/FRE
dbSetorder(2) //f8_filial+f8_nforig+f8_serorig+f8_fornece+f8_loja

dbSelectArea("SB9")  //SALDOS INICIAIS
cFiltro :="B9_FILIAL=='"+xFilial("SB9")+"'.AND. DTOS(B9_DATA)=='"+DTOS(MV_PAR01)+"'
cChave:="B9_FILIAL+B9_COD+B9_LOCAL"
cArqIndxB9:=CriaTrab(NIL,.F.)

IndRegua("SB9",cArqIndxB9,cChave,,cFiltro,"Filtrando registros...")

nIndice	:=	Retindex("SB9")
#IFNDEF TOP
	dbSetIndex(cArqIndxB9+OrdBagExt())
#ENDIF

sb9->(DbSetOrder(nIndice+1))
sb9->(DbGoTop())

//setregua(sb9->(lastrec()))

While !sb9->(Eof())
	
	//incregua()
	
	_nQuant := 0
	_nTotal := 0
	_nImpostos := 0
	_nVlFret := 0
	_nValDesp := 0
	_nVicmret := 0
	_nCustD1  := 0
	_nVlpis:=0
	_nVlcof:=0
	_cDocsf8 := " "
	_dInimov := mv_par01
	_dDtDigit:= ctod("  /  /  ")
	_lsd1:=.t.
	_ccodsb9:=sb9->b9_cod
	
	If sb9->b9_qini==0
		sb9->(dbskip())
		loop
	Endif
	
	While !sb9->(eof()) .and. sb9->b9_cod==_ccodsb9
		
		If sb9->b9_qini==0
			sb9->(dbskip())
			loop
		Endif
		
		sd1->(dbgotop())
		If sd1->(dbseek(xfilial("SD1")+sb9->b9_cod)) .and. _lsd1 //+sb9->b9_local+dtos(_dInimov)
			While !sd1->(eof()) .and. sd1->d1_cod == sb9->b9_cod //sd1->d1_cod+sd1->d1_local == sb9->b9_cod+sb9->b9_local
				If sd1->d1_tipo#"N" .or. sd1->d1_dtdigit>mv_par01
					sd1->(dbskip())
					loop
				Endif
				
				If _dDtDigit<sd1->d1_dtdigit
					sf4->(dbseek(xfilial("SF4")+sd1->d1_tes))
					do case
						case sf4->f4_piscof = '1'
							_nVlpis:=sd1->d1_total * 0.0165
						case sf4->f4_piscof = '2'
							_nVlcof:=sd1->d1_total * 0.076
						case sf4->f4_piscof = '3'
							_nVlpis:=sd1->d1_total * 0.0165
							_nVlcof:=sd1->d1_total * 0.076							
					Endcase
					_nQuant:=sd1->d1_quant
					_nTotal:=sd1->d1_total
					if sd1->d1_valimp1 == 0 .and. sd1->d1_valimp2 == 0 .and. sd1->d1_valimp3 == 0 .and.  sd1->d1_valimp4 == 0 .and.;
						sd1->d1_valimp5 == 0 .and. sd1->d1_valimp6 == 0
						
						_nImpostos:=sd1->d1_valipi + sd1->d1_valicm + sd1->d1_valdesc + _nVlpis + _nVlcof
						
					Else
						
						_nImpostos:=sd1->d1_valipi + sd1->d1_valicm + sd1->d1_valdesc + sd1->d1_valimp1 + sd1->d1_valimp2 + sd1->d1_valimp3
						_nImpostos:=_nImpostos+sd1->d1_valimp4 + sd1->d1_valimp5 + sd1->d1_valimp6
						
					Endif
					
					_nVlIPI:=sd1->d1_valipi
					_nVlICM:=sd1->d1_valicm
					_nVDesc:=sd1->d1_valdesc
					_nVICMret:=sd1->d1_icmsret
					_nValdesp:=sd1->d1_despesa
					_cDocsf8:=sd1->d1_doc+sd1->d1_serie+sd1->d1_fornece+sd1->d1_loja
					_dDtDigit:=sd1->d1_dtdigit
					_lsd1:=.f.
				Endif
				
				sd1->(dbskip())
			End
			
			_nordsd1:=sd1->(indexord())
			_nregsd1:=sd1->(recno())
			
			If sf8->(dbseek(xfilial("SF8")+_cDocsf8))
				
				sd1->(dbsetorder(1)) //d1_filial+d1_doc+d1_serie+d1_fornece+d1_loja
				sd1->(dbgotop())
				sd1->(dbseek(xfilial("SD1")+sf8->f8_nfdifre+sf8->f8_sedifre+sf8->f8_transp+sf8->f8_lojtran))
				
				_nVlFret:=sd1->d1_total - sd1->d1_valicm
				
			Endif
			
			_nCustD1:=(_nTotal-_nImpostos-_nVlfret-_nValDesp + _nVicmret) / _nQuant
			
			sd1->(dbsetorder(_nordsd1))
			sd1->(dbgoto(_nregsd1))
		Else
			_dInimov:=_dInimov-1
		Endif
		
		if nlin>53
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
			nlin:=8
			@ nlin,000 PSAY "Codigo         Qtd_SB9    Tot_SB9      Custo_SB9         Qtd_SD1     Tot_SD1   Impostos      Frete     Desp Icm_Retido    Custo_SD1         Diferença  Al  Data"
			nlin:=nlin+1
			@ nlin,000 PSAY replicate("-",limite)
			nlin:=nlin+1
		endif
		
		@ nlin,000 PSAY substr(sb9->b9_cod,1,6)
//		@ nlin,008 PSAY sb9->b9_qini  picture "@E 999,999,999.99"
//		@ nlin,023 PSAY sb9->b9_vini1 picture "@E 999,999.99"
//		@ nlin,034 PSAY sb9->b9_vini1/sb9->b9_qini picture "@E 999,999.999999"
//		@ nlin,050 PSAY _nQuant picture "@E 999,999,999.99"
//		@ nlin,066 PSAY _nTotal picture "@E 999,999.99"
		@ nlin,078 PSAY _nImpostos picture "@E 99,999.99"
		@ nlin,089 PSAY _nVlFret picture "@E 99,999.99"
		@ nlin,099 PSAY _nValDesp picture "@E 9,999.99"
		@ nlin,109 PSAY _nVicmret picture "@E 99,999.99"
		@ nlin,119 PSAY _nCustD1  picture "@E 99,999.999999"
//		@ nlin,134 PSAY (_nCustD1*sb9->b9_qini)-sb9->b9_vini1 picture "@E 9,999,999.999999"
//		@ nlin,151 PSAY SB9->B9_LOCAL
		@ nlin,154 PSAY _dDtDigit
		
		nlin+=1
		
		SB9->(DbSkip())
	End
End

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endIf

ms_flush()

return()
