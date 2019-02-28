/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT224   ³Autor ³ Gardenia Ilany      ³Data ³ 18/01/05     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Custo por OP                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

                                       
#include "topconn.ch"                       
#include "rwmake.ch"

user function VIT224()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="CUSTO POR OP"
cdesc1   :="Este programa ira emitir o relatório de custo por OP"
cdesc2   :=""
cdesc3   :=""
cstring  :="SD4"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT224"
wnrel    :="VIT224"+Alltrim(cusername)
aordem  :={"Descricao"}
m_pag    :=1
li       :=132
alinha   :={}
nlastkey :=0
lcontinua:=.t.
cperg:="PERGVIT224"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

if nlastkey==27
   set filter to
   return
endif

setdefault(areturn,cstring)

nordem:=areturn[8]
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
li    :=132
cbtxt :=space(10)




titulo:="CUSTO POR OP"
cabec1:="Período..: " +dtoc(mv_par09) + " a "+dtoc(mv_par10)  + "                               (Padrao)                            (Real)  "
cabec2:="Produto                                               Qtde  Prc. Unit.       Total         Qtde       Total Variac.(%)"
//Cliente                                        UF     Tit.Aberto        Vl Pago       Vencidos   Não Vencidos  Inad.
//Produto                                               Qtde  Prc. Unit.       Total         Qtde       Total Variac.
//999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999,999.99 9999.999999 9999.999999   999,999.99 9999.999999  999.99
_cfilsb1:=xfilial("SB1")
_cfilsbm:=xfilial("SBM")
_cfilsd4:=xfilial("SD4")
_cfilsd3:=xfilial("SD3")
_cfilsc2:=xfilial("SC2")
_cfilsx5:=xfilial("SX5")
sb1->(dbsetorder(1))
sbm->(dbsetorder(1))
sd4->(dbsetorder(2)) //ALTERADO DE (1) PARA (2) - 10/05/06-ALEX
sd3->(dbsetorder(1))
sc2->(dbsetorder(1))
sx5->(dbsetorder(1))


processa({|| _geratmp()})

setprc(0,0)

setregua(sb1->(lastrec()))
tmp1->(dbgotop())
_ttcstgrupo:=0
_grupo:="     "

while ! tmp1->(eof()) .and.;
      lcontinua
	incregua() 
   if tmp1->tipo <> "PA" .and. tmp1->tipo <> "PI"
		tmp1->(dbskip())
      loop
   endif          
   _grupo:=tmp1->tipgru
	_tcstgrupo:=0
	_tcustpad:=0
	_tcustreal:=0
	_tquantpad:=0
	_tquantreal:=0

	while ! tmp1->(eof()) .and. _grupo==tmp1->tipgru .and. lcontinua
	   _passei:=.f.

//	incproc("Selecionando titulos em geral...")

		_cquery:=" SELECT "
		_cquery+=" D4_QTDEORI QTDEORI,D4_COD COD,D4_OP OP,C2_NUM NUM,C2_ITEM ITEM,C2_SEQUEN SEQUEN,"
		_cquery+=" C2_QUANT QUANT,C2_EMISSAO EMISSAO,C2_DATRF DATRF"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SC2")+" SC2,"
		_cquery+=  retsqlname("SD4")+" SD4"
		_cquery+=" WHERE"
		_cquery+="     SD4.D_E_L_E_T_<>'*'"
		_cquery+=" AND SC2.D_E_L_E_T_<>'*'"
		_cquery+=" AND D4_FILIAL='"+_cfilsd4+"'"
		_cquery+=" AND C2_PRODUTO='"+tmp1->cod+"'"   
		_cquery+=" AND SUBSTR(D4_OP,1,6)=C2_NUM" 
		_cquery+=" AND SUBSTR(D4_OP,7,2)=C2_ITEM" 
		_cquery+=" AND SUBSTR(D4_OP,9,3)=C2_SEQUEN" 
		if mv_par11 = 2
			_cquery +=" AND D4_LOCAL <> '80'"
		endif   
		_cquery+=" AND C2_EMISSAO BETWEEN '"+dtos(mv_par09)+"' AND '"+dtos(mv_par10)+"'"  
		cData := CtoD("  /  /  ")
		If mv_par12 == 1
		  _cquery+=" AND C2_DATRF='"+DtoS(cData)+"'"
		ElseIf mv_par12 == 2
		  _cquery+=" AND C2_DATRF<>'"+DtoS(cData)+"'"
		  _cquery+=" AND C2_DATRF>='"+DtoS(mv_par13)+"'"
		  _cquery+=" AND C2_DATRF<='"+DtoS(mv_par14)+"'"
		EndIf                                           

		// INCLUÍDO PARA ORDENAÇÃO DO ARQUIVO TEMPORÁRIO
		_cquery+=" ORDER BY D4_OP,D4_COD"
  
	 	_cquery:=changequery(_cquery)
		
		tcquery _cquery new alias "TMP2"
		tcsetfield("TMP2","QTDEORI","N",15,2)
		tcsetfield("TMP2","QUANT","N",15,2)
		tcsetfield("TMP2","EMISSAO","D",08)
		tcsetfield("TMP2","DATRF","D",08)
	
		tmp2->(dbgotop())

		while ! tmp2->(eof()) .and.;
	      lcontinua
	      if tmp2->op < substr(mv_par01,1,6) .or. tmp2->op > substr(mv_par02,1,6)
				tmp2->(dbskip())
		      loop
		   endif   
		   _op:=tmp2->op
			if prow()>54 .or. prow()=0
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif              
			@ prow()+2,000 PSAY "ORDEM DE PRODUCAO Nº:  " +tmp2->op + " EMISSAO: "+ dtoc(tmp2->emissao) + "  FECHAMENTO: "+ dtoc(tmp2->datrf) 


			_cquery :=" SELECT "    
			_cquery +=" SUM(D3_QUANT) QUANT, SUM(D3_CUSTO1) CUSTO1"
			_cquery +=" FROM "+retsqlname("SD3")+" SD3"
			_cquery +=" WHERE "
			_cquery +="     SD3.D_E_L_E_T_<>'*'"
			_cquery +=" AND D3_FILIAL='"+_cfilsd3+"'"
			_cquery +=" AND D3_OP='"+_op+"'"   
	   	_cquery +=" AND D3_ESTORNO<>'S'"   
			_cquery +=" AND D3_CF = 'PR0'"
//			if mv_par11 = 2
//				_cquery +=" AND D3_TIPO <> 'MO'"
//			endif   
			tcquery _cquery new alias "TMP4"
			tcsetfield("TMP4","QUANT","N",15,2)
			tcsetfield("TMP4","CUSTO1","N",15,2)
			tmp4->(dbgotop())  
			_quanttmp4:=tmp4->quant
			_custotmp4:=tmp4->custo1
			tmp4->(dbclosearea())

			_quanttmp5:=0
			_custotmp5:=0
			if mv_par11 = 2
				_cquery :=" SELECT "    
				_cquery +=" SUM(D3_QUANT) QUANT, SUM(D3_CUSTO1) CUSTO1"
				_cquery +=" FROM "+retsqlname("SD3")+" SD3"
				_cquery +=" WHERE "
				_cquery +="     SD3.D_E_L_E_T_<>'*'"
				_cquery +=" AND D3_FILIAL='"+_cfilsd3+"'"
				_cquery +=" AND D3_OP='"+_op+"'"   
		   	_cquery +=" AND D3_ESTORNO<>'S'"   
//				_cquery +=" AND D3_CF <> 'PR0'"
				_cquery +=" AND D3_TIPO='MO'"
	  
				tcquery _cquery new alias "TMP5"
				tcsetfield("TMP5","QUANT","N",15,2)
				tcsetfield("TMP5","CUSTO1","N",15,2)
				tmp5->(dbgotop())  
				_quanttmp5:=tmp5->quant
				_custotmp5:=tmp5->custo1
				_custotmp4:=_custotmp4-tmp5->custo1
				tmp5->(dbclosearea())
			endif   

			@ prow()+1,000 PSAY substr(tmp1->cod,1,6)
			@ prow() ,008  PSAY tmp1->descri
			@ prow() ,049  PSAY tmp2->quant picture "@E 999,999.99"
			@ prow() ,059  PSAY _custotmp4/_quanttmp4 picture "@E 9999.999999"
			@ prow() ,071  PSAY (_custotmp4/_quanttmp4)*tmp2->quant picture "@E 99999.999999"
			@ prow() ,086  PSAY _quanttmp4 picture "@E 999,999.99"
			@ prow() ,097  PSAY _custotmp4 picture "@E 99999.999999"
			@ prow() ,111  PSAY (_quanttmp4/tmp2->quant*100)-100 picture "@E 9999.99"
//   		msgstop(_op)
//   		msgstop(_custotmp4)

//			_tquantpad+=tmp2->quant
//    	_tquantreal+=_quanttmp4 
//			_tcustreal+=_custotmp4 

			_tquantpad:=tmp2->quant
	    	_tquantreal:=_quanttmp4 
			_tcustreal:=_custotmp4 
         _tcustpad:=0

	      _advalor:= ((_custotmp4/_quanttmp4)*tmp2->quant)  - _custotmp4


			while ! tmp2->(eof()) .and.;
	   	   lcontinua .and. _op == tmp2->op
			   _codtmp2:=tmp2->cod
			   _quanttmp2:=0
				while ! tmp2->(eof()) .and.;
			      lcontinua .and. _op == tmp2->op .and. _codtmp2== tmp2->cod
				   _quanttmp2+=tmp2->qtdeori
				   tmp2->(dbskip())
				end   
				_cquery :=" SELECT "    
				_cquery +=" D3_QUANT QUANT, D3_CUSTO1 CUSTO1,"
				_cquery +=" D3_CF CF"
				_cquery +=" FROM "+retsqlname("SD3")+" SD3"
				_cquery +=" WHERE "
				_cquery +="     SD3.D_E_L_E_T_<>'*'"
				_cquery +=" AND D3_FILIAL='"+_cfilsd3+"'"
				_cquery +=" AND D3_OP='"+_op+"'"   
				_cquery +=" AND D3_COD='"+_codtmp2+"'"   
		   	_cquery +=" AND D3_ESTORNO<>'S'"   
				_cquery +=" AND D3_CF<>'PR0'"
				if mv_par11 = 2
					_cquery +=" AND D3_TIPO<>'MO'"
				endif   
	  			tcquery _cquery new alias "TMP3"
				tcsetfield("TMP3","CUSTO1","N",15,2)
				tcsetfield("TMP3","QUANT","N",15,2)
				tmp3->(dbgotop())  


				_quanttmp3:=0
				_custo:=0
				_2custo:=0
				_2quanttmp3:=0
				while ! tmp3->(eof()) .and.;
		   	   lcontinua
					if prow()>54 .or. prow()=0
						cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
					endif              
					_codtmp3:=_codtmp2

//999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999,999.99 9999.999999 9999.999999   999,999.99 9999.999999  999.99
					while ! tmp3->(eof()) .and.;
		   		   lcontinua .and. _codtmp3 == _codtmp2

		   		   if tmp3->cf <> 'DE0'
			   		   _quanttmp3+=tmp3->quant
			   		   _custo+= tmp3->custo1
			   		   _2quanttmp3+=tmp3->quant
			   		   _2custo+= tmp3->custo1
			   		 elseif tmp3->cf == 'DE0'
			   		 	_quanttmp3-=tmp3->quant
			   		 	_custo-=tmp3->custo1
			   		 endif	  
					   tmp3->(dbskip())
		   	   end           
		   	   if _custo < 0
		   	   	_custo:=0
		   	   endif	
 	   
					sb1->(dbseek(_cfilsb1+_codtmp2))
					@ prow()+1,000 PSAY substr(_codtmp2,1,6)
					@ prow() ,008  PSAY sb1->b1_desc
					@ prow() ,049  PSAY _quanttmp2 picture "@E 999,999.99"
					if _custo >0 .and. _quanttmp3>0
						@ prow() ,059  PSAY _custo/_quanttmp3 picture "@E 9999.999999"
						@ prow() ,071  PSAY (_custo/_quanttmp3)*_quanttmp2 picture "@E 99999.999999"
	            elseif _2quanttmp3 >0
						@ prow() ,059  PSAY _2custo/_2quanttmp3 picture "@E 9999.999999"
						@ prow() ,071  PSAY (_2custo/_2quanttmp3)*_quanttmp2 picture "@E 99999.999999"
	            endif
					@ prow() ,086  PSAY _quanttmp3 picture "@E 999,999.99"
					@ prow() ,097  PSAY _custo picture "@E 99999.999999"
					@ prow() ,111  PSAY (_quanttmp3/_quanttmp2*100)-100 picture "@E 9999.99"
					if _quanttmp3>0
						_tcustpad+=(_custo/_quanttmp3)*_quanttmp2
					endif	

				end	
				tmp3->(dbclosearea())
			end	

			_cquery :=" SELECT "    
			_cquery +=" D3_QUANT QUANT, D3_CUSTO1 CUSTO1,D3_COD COD,D3_OP OP,D3_TRT TRT,"
			_cquery +=" D3_CF CF,D3_LOTECTL LOTECTL,D3_NUMLOTE NUMLOTE"
			_cquery +=" FROM "
			_cquery +=  retsqlname("SD3")+" SD3"
			_cquery +=" WHERE"
			_cquery +="     SD3.D_E_L_E_T_<>'*'"
			_cquery +=" AND D3_FILIAL='"+_cfilsd3+"'"
			_cquery +=" AND D3_OP='"+_op+"'"   
	   	_cquery +=" AND D3_ESTORNO<>'S'"   
			_cquery +=" AND D3_CF='RE0'"
			_cquery +=" AND D3_TIPO<>'MO'"
			tcquery _cquery new alias "TMP6"
			tcsetfield("TMP6","CUSTO1","N",15,2)
			tcsetfield("TMP6","QUANT","N",15,2)
			tmp6->(dbgotop())  
	      _tcustotmp6:=0
			while ! tmp6->(eof()) .and.;
	   	   lcontinua
				if prow()>54 .or. prow()=0
					cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
				endif              
				sd4->(dbsetorder(1))
				sd4->(dbseek(_cfilsd4+tmp6->cod+tmp6->op,.t.))
	         if tmp6->cod==sd4->d4_cod .and. tmp6->op==sd4->d4_op
					tmp6->(dbskip())
				   loop
	         endif
	         _codtmp6:= tmp6->cod
	         _quanttmp6:=0
	         _custotmp6:=0
				while ! tmp6->(eof()) .and.;
	   		   lcontinua .and. _codtmp6 == tmp6->cod
					_quanttmp6+=tmp6->quant
					_custotmp6+=tmp6->custo1
					tmp6->(dbskip())
				end	          
				sb1->(dbseek(_cfilsb1+_codtmp6))
				@ prow()+1,000 PSAY substr(_codtmp6,1,6)
				@ prow() ,008  PSAY sb1->b1_desc
				@ prow() ,059  PSAY _custotmp6/_quanttmp6 picture "@E 9999.999999"
				@ prow() ,086  PSAY _quanttmp6 picture "@E 999,999.99"
				@ prow() ,097  PSAY _custotmp6 picture "@E 9999.999999"
				@ prow() ,111  PSAY 100 picture "@E 9999.99"
				_tcustotmp6+= _custotmp6

	      end
//	msgstop(_tquantpad)
//	msgstop(_tcustpad)
//	msgstop(_tquantreal)
//	msgstop(_tcustreal)
		if _tquantreal ==0 
			_tquantreal :=1
		endif   
	   if _tquantpad ==0
			_tquantpad :=1
		endif 	
       
		   _cstgrupo:=round(((_tcustreal/_tquantreal)-(_tcustpad/_tquantpad))*_tquantreal,2)
			_tcstgrupo+=_cstgrupo


//      	@ prow()+1,00 PSAY "ACRESC./DECRESC.(RS): " 
//			@ prow(),022  PSAY   _advalor  picture "@E 999,999.99"
		   if !empty(_cstgrupo)
			   @ prow()+1,000 PSAY "PERDA (R$):" // +tabela("V0",_grupo+"    ")
			   @ prow(),022 PSAY _cstgrupo picture "@E 999,999,999.99"
			endif   
			
			
			
			tmp6->(dbclosearea())
	   end
		tmp2->(dbclosearea())
		tmp1->(dbskip())

		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			eject
			lcontinua:=.f.
		endif
	end


   if !empty(_tcstgrupo)
   	sx5->(dbseek(_cfilsx5+"V0"+_grupo))
	   @ prow()+1,000 PSAY "PERDA (R$) "+sx5->x5_descri  //tabela("V0",_grupo+"    ")
	   @ prow(),022 PSAY _tcstgrupo picture "@E 999,999,999.99"
	endif   
   _ttcstgrupo+=_tcstgrupo 
end
if !empty(_ttcstgrupo)
	@ prow()+1,000 PSAY "PERDA GERAL (R$):"
	@ prow(),022 PSAY _ttcstgrupo picture "@E 999,999,999.99"
endif
roda(cbcont,cbtxt)
tmp1->(dbclosearea())

set device to screen

if areturn[5]==1
   set print to
   dbcommitall()
   ourspool(wnrel)
endIf

ms_flush()
return

static function _geratmp()
procregua(1)
incproc("Selecionando produtos...")
_cquery:=" SELECT"
_cquery+=" B1_COD COD,B1_DESC DESCRI,B1_TIPO TIPO,B1_GRUPO GRUPO,BM_TIPGRU TIPGRU"
_cquery+=" FROM "
_cquery+=  retsqlname("SBM")+" SBM,"
_cquery+=  retsqlname("SB1")+" SB1"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SBM.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B1_GRUPO=BM_GRUPO"
_cquery+=" AND B1_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"  
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"  
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"  
_cquery+=" ORDER BY BM_TIPGRU,B1_DESC"










_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"

return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da OP              ?","mv_ch1","C",11,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SC2"})
aadd(_agrpsx1,{cperg,"02","Ate a OP           ?","mv_ch2","C",11,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SC2"})
aadd(_agrpsx1,{cperg,"03","Do produto         ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"04","Ate o produto      ?","mv_ch4","C",15,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"05","Do tipo            ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"06","Ate o tipo         ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"07","Do grupo           ?","mv_ch7","C",04,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"08","Ate o grupo        ?","mv_ch8","C",04,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"09","Da emissao OP      ?","mv_ch9","D",08,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Ate a emissao OP   ?","mv_chA","D",08,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "}) 
aadd(_agrpsx1,{cperg,"11","Mao de Obra        ?","mv_chB","N",01,0,2,"C",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"12","Tipo de Op`s       ?","mv_chC","N",01,0,3,"C",space(60),"mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"13","Do encerramento    ?","mv_chD","D",08,0,0,"G",space(60),"mv_par13"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"14","Ate o encerramento ?","mv_chE","D",08,0,0,"G",space(60),"mv_par14"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
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
                                                        S A I D A S                        E S T O Q U E
Codigo Descricao                                Mes Ant.   No Mes   No Dia    Media  Ent.Mes  Ent.Dia Processo  Empenho    Saldo Pendencia Dias Quarentena          Valor
XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999  9999.999 9999   9999.999 999.999.999,99
*/

