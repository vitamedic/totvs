#include "rwmake.ch"       
#include "topconn.ch"

User Function VIT207()
//SetPrvt("_CFILSA4,_CFILSD2,_CFILSF2,_CFILSA1")
SetPrvt("_CARQ,_LCONTINUA,_NHANDLE,")
Private _cperg := "PERGVIT207"

_pergsx1()

pergunte(_cPerg,.t.)


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT207  ³Autor ³ Gardenia Ilany         ³Data ³ 27/07/04   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Geracao do Arquivo para Transmissao - Receita              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
 
	if msgbox("Confirma geracao do(s) arquivo(s) ?","Atencao","YESNO")
		processa({|| _geraarq()})
		msginfo("Arquivo(s) gerado(s) com sucesso!")
		sysrefresh()
	endif
return


Static function _geraarq()
_cfilsa1:=xfilial("SA1")
_cfilsa2:=xfilial("SA2")
_cfilsf3:=xfilial("SF3")
_cfilsb1:=xfilial("SB1")
_cfilsd2:=xfilial("SD2")
_cfilsf2:=xfilial("SF2")
_cfilsf1:=xfilial("SF1")
_cfilsd1:=xfilial("SD1")
_cfilse4:=xfilial("SE4")

sa1->(dbsetorder(1))
sa2->(dbsetorder(1))
sf3->(dbsetorder(1))
sb1->(dbsetorder(1))
sd2->(dbsetorder(3))
sf2->(dbsetorder(3))
sd1->(dbsetorder(1))
se4->(dbsetorder(1))


processa({|| _querys()})

tmp1->(dbgotop())
_carq:=alltrim(mv_par04)+".TXT"
_nhandle:=fcreate(_carq,0)
//frename(_carq,"\pocket\origem\"+_carq)
if _nhandle<0
	msginfo("Erro na criacao do arquivo "+_carq)
	_lcontinua:=.f.
endif
while ! tmp1->(eof())
//	if tmp1->cfo$ "599  /531  /631  /695  /593  /693  /799  /699  "
//		tmp1->(dbskip())                     
//		loop
//   endif
//   if mv_par03 ==1
//		if ! tmp1->cfo$ "111  /112  /113  /114  /141  /142  /143  /144  /151  /152  /153  /154  /155  /161  /162  /163  /164  /165  /171  /172  /173  /174  /191  /197  /211  /212  /213  /214  /241  /242  /243  /244  /251  /252  /253  /254  /255  /261  /262  /263  /264  /265  /271  /272  /273  /274  /291  /297  "
//			tmp1->(dbskip())                     
//			loop
//	   endif
//	endif   
	if mv_par03 == 1 .and. tmp1->cfo > "5000 "
		tmp1->(dbskip())                     
		loop
	elseif mv_par03 == 2 .and. tmp1->cfo < "5000 "	
		tmp1->(dbskip())                     
		loop
	endif	
	_cliefor:=tmp1->cliefor
	_loja :=tmp1->loja
	_passou:=.f.
	if tmp1->cfo > "5000 "
//		msgstop(tmp1->cfo)
		sa1->(dbseek(_cfilsa1+_cliefor+_loja))             
 		_cgc:=sa1->a1_cgc		
 		set softseek on
		sf2->(dbseek(_cfilsf2+tmp1->nfiscal+tmp1->serie))             
		set softseek off
      _codcond:=sf2->f2_cond
		se4->(dbseek(_cfilse4+_codcond))             
 		_cond:=se4->e4_cond
 		if substr(_cond,1,1)=="0"
 			_tipocond:="1"
 		else
 			_tipocond:="2"
 		endif		
		sd2->(dbseek(_cfilsd2+tmp1->nfiscal+tmp1->serie))             
		set softseek off
		_total:=0
//msgstop(tmp1->nfiscal)
//msgstop(tmp1->serie)
//msgstop(sd2->d2_doc)
		while ! sd2->(eof()) .and. tmp1->nfiscal==sd2->d2_doc .and. tmp1->serie == sd2->d2_serie
			_passou:=.t.
			if _total < sd2->d2_total	
				_total:= sd2->d2_total
				_produto:=sd2->d2_cod
			endif	
			sd2->(dbskip())                     
      end
	elseif 	tmp1->cfo < "5000 "
		sa2->(dbseek(_cfilsa2+_cliefor+_loja))             
 		_cgc:=sa2->a2_cgc		
 		set softseek on
		sf1->(dbseek(_cfilsf1+tmp1->nfiscal+tmp1->serie))             
		set softseek off
      _codcond:=sf2->f2_cond
		se4->(dbseek(_cfilse4+_codcond))             
 		_cond:=se4->e4_cond
 		if substr(_cond,1,1)=="0"
 			_tipocond:="1"
 		else
 			_tipocond:="2"
 		endif		
 		set softseek on
		sd1->(dbseek(_cfilsd1+tmp1->nfiscal+tmp1->serie))             
		set softseek off
		_total:=0
		while ! sd1->(eof()) .and. tmp1->nfiscal==sd1->d1_doc .and. tmp1->serie == sd1->d1_serie
			_passou:=.t.
			if _total < sd1->d1_total	
				_total:= sd1->d1_total
				_produto:=sd1->d1_cod 
			endif	
			sd1->(dbskip())                     
      end
	endif	
	if _passou
		sb1->(dbseek(_cfilsb1+_produto))             
		fwrite(_nhandle,_cgc)          	
		fwrite(_nhandle,tmp1->serie+"  ")              
		fwrite(_nhandle,tmp1->nfiscal)             
	   _dia:=strzero(day(tmp1->entrada),2,0)
	   _mes:=strzero(month(tmp1->entrada),2,0)
	   _ano:=strzero(year(tmp1->entrada),4,0)
		fwrite(_nhandle,_dia+_mes+_ano)           
		fwrite(_nhandle,strzero(round(tmp1->valcont*100,0),17)) 
		fwrite(_nhandle,_tipocond)           
		fwrite(_nhandle,sb1->b1_desc+"     ")           
		fwrite(_nhandle,substr(tmp1->cfo,1,4))           
		fwrite(_nhandle,chr(13)+chr(10))                   // MUDANCA DE LINHA
   else
   	if tmp1->cfo=="111  " .or. tmp1->cfo=="211  "
   		_descpro:="INSUMOS PARA INDUSTRIALIZAÇÃO "
		elseif tmp1->cfo=="113  "   		
   		_descpro:="INDUSTRIALIZAÇÃO              "
		elseif tmp1->cfo=="142  "   		
   		_descpro:="ENERGIA ELETRICA              "
		elseif tmp1->cfo=="152  "   		
   		_descpro:="TELEFONE                      "
		elseif tmp1->cfo=="162  " .or.tmp1->cfo=="262  "
   		_descpro:="FRETE SOBRE VENDA             "
		elseif tmp1->cfo=="191  " .or.tmp1->cfo=="291  "   		
   		_descpro:="ATIVO IMOBILIZADO             "
		elseif tmp1->cfo=="197  " .or. tmp1->cfo=="297  " 
   		_descpro:="MATERIAL DE CONSUMO           "
   	else 	
   		_descpro:="PRODUTO NAO ENCONTRADO        "
   	endif	
//		sb1->(dbseek(_cfilsb1+_produto))             

		fwrite(_nhandle,_cgc)          	
		fwrite(_nhandle,tmp1->serie+"  ")              
		fwrite(_nhandle,tmp1->nfiscal)             
	   _dia:=strzero(day(tmp1->entrada),2,0)
	   _mes:=strzero(month(tmp1->entrada),2,0)
	   _ano:=strzero(year(tmp1->entrada),4,0)
		fwrite(_nhandle,_dia+_mes+_ano)           
		fwrite(_nhandle,strzero(round(tmp1->valcont*100,0),17)) 
		fwrite(_nhandle,_tipocond)           
		fwrite(_nhandle,_descpro+space(15))           
		fwrite(_nhandle,substr(tmp1->cfo,1,4))           
		fwrite(_nhandle,chr(13)+chr(10))                   // MUDANCA DE LINHA
	endif	
	tmp1->(dbskip())
	if  tmp1->(eof())
		fclose(_nhandle)
	endif	
end               
tmp1->(dbclosearea())
return
        	

      

static function _querys()
_cquery:=" SELECT"
_cquery+=" F3_ENTRADA ENTRADA, F3_ESPECIE ESPECIE,F3_NFISCAL NFISCAL,F3_SERIE SERIE,F3_CFO CFO ,"
_cquery+=" F3_CLIEFOR CLIEFOR,F3_LOJA LOJA,F3_VALCONT VALCONT"
_cquery+=" FROM "
_cquery+=  retsqlname("SF3")+" SF3"
_cquery+=" WHERE"
_cquery+="     SF3.D_E_L_E_T_<>'*'"
_cquery+=" AND F3_FILIAL='"+_cfilsf3+"'"
_cquery+=" AND F3_ENTRADA BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" ORDER BY F3_CFO,F3_ENTRADA"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","ENTRADA","D")
tcsetfield("TMP1","VALCONT","N",15,2)
return




static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Da Data Nota       ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"03","Do tipo (E/S/A)    ?","mv_ch3","N",01,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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



