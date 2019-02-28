#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 19/02/02
#INCLUDE "TOPCONN.CH"

User Function vit030()        // incluido pelo assistente de conversao do AP6 IDE em 19/02/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,WNREL,NORDEM,TAMANHO,LIMITE")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,CCANCEL,NTIPO")
SetPrvt("M_PAG,LI,CFILSA1,CFILSC5,CFILSD2,CFILSZ3")
SetPrvt("CQUERY,CABEC1,CABEC2,NTOTAL,LIMPCAMP,NVDESCFI")
SetPrvt("NVALLIQ,NVALOR,")

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VIT030   ³ Autor ³ Gardenia Ilany        ³ Data ³ 19/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Acompanhamento de Campanhas Comerciais        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/



// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/02/02 ==> #INCLUDE "TOPCONN.CH"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CbTxt  := ""
CbCont := ""
wnrel  := ""
nOrdem := ""
tamanho:= "M"
limite := 132
titulo := "RELATORIO DE ACOMPANHAMENTO DE CAMPANHAS COMERCIAIS"
cDesc1 := "Este programa ira emitir o relatorio de acompanhamento de campanhas comerciais"
cDesc2 := ""
cDesc3 := ""

cString:="SD2"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="VIT030"
aLinha  := { }
nLastKey := 0


cperg    :="PERGVIT030"
_pergsx1()
pergunte(cperg,.f.)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametro                         ³
//³ mv_par01              Da data                               ³
//³ mv_par02              Ate a data                            ³
//³ mv_par03              Do cliente                            ³
//³ mv_par04              Ate a loja                            ³
//³ mv_par05              Do cliente                            ³
//³ mv_par06              Ate a loja                            ³
//³ mv_par07              Do vendedor                           ³
//³ mv_par08              Sintetico/Analitico(S/N)             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cCancel := "***** CANCELADO PELO OPERADOR *****"
wnrel:="VIT030"+Alltrim(cusername)
wnrel:=SetPrint(cString,wnrel,cperg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,,,.T.)

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)
ntipo:=if(areturn[4]==1,15,18)
If nLastKey == 27
    Set Filter To
    Return
Endif

RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP6 IDE em 19/02/02 ==> RptStatus({|| Execute(RptDetail) })
Return NIL

//*******************************************
//Funcao RptDetail - Impressao do Relatorio
//*******************************************

// Substituido pelo assistente de conversao do AP6 IDE em 19/02/02 ==> Function RptDetail
Static Function RptDetail()

cbcont := 0
m_pag  := 1
li     := 80
cbtxt  := space(10)

cfilsa1:=xfilial("SA1")
cfilsa3:=xfilial("SA3")
cfilsc5:=xfilial("SC5")
cfilsc6:=xfilial("SC6")
cfilsd2:=xfilial("SD2")
cfilsz3:=xfilial("SZ3")
sa1->(dbsetorder(1))
sa3->(dbsetorder(1))
sc5->(dbsetorder(1))
sc6->(dbsetorder(2))
sd2->(dbsetorder(3))
sz3->(dbsetorder(1))


cquery:=       " SELECT D2_SERIE SERIE,D2_DOC DOC,D2_EMISSAO EMISSAO,D2_TOTAL TOTAL ,D2_PEDIDO PEDIDO,D2_CLIENTE CLIENTE,D2_LOJA LOJA,D2_COD COD "
cquery:=cquery+" FROM "+retsqlname("SD2")+" SD2"
cquery:=cquery+" WHERE SD2.D_E_L_E_T_<>'*'"
cquery:=cquery+" AND D2_FILIAL='"+xfilial("SD2")+"'"
//cquery:=cquery+" AND D2_CLIENTE='"+sz3->z3_cliente+"'"
//cquery:=cquery+" AND D2_LOJA='"+sz3->z3_loja+"'"
cquery:=cquery+" AND D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
cquery:=cquery+" ORDER BY D2_CLIENTE,D2_DOC,D2_SERIE"
cquery:=changequery(cquery)
tcquery cquery new alias "TMP"
tcsetfield("TMP","EMISSAO","D")
tcsetfield("TMP","TOTAL","N",15,2)


cabec1      :="Nota Fiscal  Emissao    Valor da Fatura         Promocoes           Indice           A Pagar"                    
cabec2      :=""

ntotal:=0
limpcamp:=.t.
setprc(0,0)
setregua(sf2->(lastrec()))
dbselectarea("TMP")
tmp->(dbgotop())
sa3->(dbseek(cfilsa3+mv_par07))
@ prow()+1,000 PSAY "Vendedor: "+mv_par07 +' - ' + sa3->a3_nome 

while ! tmp->(eof())
   _cliente := tmp->cliente
   _loja :=tmp->loja
   _emissao :=tmp->emissao
	sz3->(dbseek(cfilsz3+mv_par07+_cliente))
//	if !found() .or.( sz3->z3_tipo =="I") .or. (sz3->z3_inicial<mv_par01 .or. sz3->z3_final>mv_par02)
//	if ( sz3->z3_tipo =="I") .or. (sz3->z3_incial < mv_par01 .or. sz3->z3_final > mv_par02)
	if ( sz3->z3_tipo =="I") .or. (sz3->z3_incial > emissao .or. sz3->z3_final < emissao)
		tmp->(dbskip())
		loop
   endif
   if sz3->z3_vend <> mv_par07  .or. sz3->z3_cliente <> _cliente
		tmp->(dbskip())
		loop
   endif
	limpcamp:=.t.
	_ntotal1 :=0
	_promocao1 :=0

	while ! tmp->(eof()) .and. _cliente == tmp->cliente    
		_nota :=tmp->doc
		_serie:=tmp->serie
		_emissao:=tmp->emissao
		_ntotal :=0
		_promocao :=0
		while ! tmp->(eof()) .and. _cliente == tmp->cliente .and. _nota == tmp->doc;
		   .and. _serie == tmp->serie
			if prow()==1.or.prow()>58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
			endif
			if limpcamp
//				@ prow()+1,000 PSAY replicate("-",limite)
				sa1->(dbseek(cfilsa1+tmp->cliente+tmp->loja))
//				@ prow()+1,000 PSAY ""
				@ prow()+1,000 PSAY "Cliente: "+tmp->cliente+"/"+tmp->loja+"-"+sa1->a1_nome
				@ prow()+1,000 PSAY "Inicio: "+dtoc(sz3->z3_incial)
				@ prow(),025   PSAY "Fim: "+dtoc(sz3->z3_final)
				@ prow(),040   PSAY "Valor: "+transform(sz3->z3_valor,"@E 999,999,999,999.99")
				@ prow(),067   PSAY "Desconto: "+transform(sz3->z3_descont,"@E 99.99")+"%"
				@ prow(),092   PSAY "Prazo Medio: "+transform(sz3->z3_cond,"999")
				@ prow(),114 PSAY "% Premiacao: "+transform(sz3->z3_brinde,"@E 99.99")+"%"
				limpcamp:=.f.
			endif                                  
			

//			incregua()
			sd2->(dbseek(cfilsd2+tmp->doc+tmp->serie+_cliente+_loja))
			sc6->(dbseek(cfilsc6+tmp->cod+sd2->d2_pedido))      
			if sc6->c6_promoc =='P' .or. sc6->c6_promoc=='M'  
				_promocao += tmp->total
				_promocao1 += tmp->total
			endif	
			_ntotal+=tmp->total
			_ntotal1+=tmp->total
			tmp->(dbskip())
		end	

  		@ prow()+1,000 PSAY _nota +"-"+_serie
		@ prow(),013   PSAY _emissao
		@ prow(),026   PSAY _ntotal picture "@E 999,999,999.99"
		@ prow(),044   PSAY _promocao picture "@E 999,999,999.99"
		@ prow(),061   PSAY _ntotal-_promocao picture "@E 999,999,999.99"
		@ prow(),079   PSAY (_ntotal-_promocao)*(sz3->z3_brinde/100) picture "@E 999,999,999.99"
	end	                
	@ prow()+1,000   PSAY 'TOTAIS ==>'
	@ prow(),026   PSAY _ntotal1 picture "@E 999,999,999.99"
	@ prow(),044   PSAY _promocao1 picture "@E 999,999,999.99"
	@ prow(),061   PSAY _ntotal1-_promocao1 picture "@E 999,999,999.99"
	@ prow(),079   PSAY (_ntotal1-_promocao1)*(sz3->z3_brinde/100) picture "@E 999,999,999.99"
end
roda(cbcont,cbtxt)

Set Device To Screen
tmp->(dbclosearea())

If ( aReturn[5]==1 )
	Set Print to
	dbCommitall()
	ourspool(wnrel)
EndIf

MS_Flush()

Return

/*
Campanha: 999999 Cliente: 999999/99-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx Inicio: 99/99/99 Fim: 99/99/99
Valor mensal: 999.999.999.999,99 Valor total: 999.999.999.999,99 Desconto: 99,99% Prazo medio: 999 % brindes: 99,99
Nota Fiscal Emissao     Valor da Fatura   Icms Subst.Trib. % Desc.Fin.    Valor Desc.Fin.      Valor Liquido
xxx 999999  99/99/99 999.999.999.999,99 999.999.999.999,99    99,99    999.999.999.999,99 999.999.999.999,99
Valor total da campanha: 999.999.999.999,99 Total das notas fiscais: 999.999.999.999,99 Diferenca: 999.999.999.999,99
*/




static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do cliente         ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"04","Da loja            ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Ate o cliente      ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"06","Ate a loja         ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Do vendedor        ?","mv_ch7","C",06,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Sintetico/Analitico?","mv_ch8","C",01,0,0,"C",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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




















