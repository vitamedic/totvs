/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT024   ³ Autor ³ Gardenia Ilany        ³ Data ³ 07/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao de Duplicatas                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function vit024()
tamanho := "P" 
limite  := 80
titulo  := "EMISSAO DE DUPLICATAS"
cDesc1  := "Este programa irá emitir as Duplicatas conforme"
cDesc2  := "parametros especificados."
cDesc3  := ""
cString := "SE1"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
cPerg   :="MTR750"
nLastKey := 0
li := 0
//+---------------------------------------------+
//¦ Variaveis utilizadas para parametros	      ¦
//¦ mv_par01		// Duplicata de		         ¦
//¦ mv_par02		// Duplicata ate	            ¦
//¦ mv_par03		// Serie                		¦
//+---------------------------------------------+
//+--------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                           ¦
//+--------------------------------------------------------------+
pergunte("MTR750",.F.)

//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT.                       ¦
//+--------------------------------------------------------------+
wnrel:="VIT024"+Alltrim(cusername)

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,)

If LastKey() == 27 .Or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .Or. nLastKey == 27
   Return
Endif

rptstatus({|| rptdetail()})
return

static function rptdetail()
_cfilsa1:=xfilial("SA1")
_cfilsa6:=xfilial("SA6")
_cfilse1:=xfilial("SE1")
_cfilsc5:=xfilial("SC5")
_cfilsd2:=xfilial("SD2")
_i:=0
sa1->(dbsetorder(1))
sa6->(dbsetorder(1))
se1->(dbsetorder(1))
sc5->(dbsetorder(1))
sd2->(dbsetorder(9))

setprc(0,0)

setregua((val(mv_par02)-val(mv_par01))+1)

ntipo:=Iif(areturn[4]==1,15,18)

se1->(dbseek(_cfilse1+mv_par03+mv_par01,.t.))
while ! se1->(eof()) .and.;
		se1->e1_filial==_cfilse1 .and.;
		se1->e1_prefixo==mv_par03 .and.;
		se1->e1_num<=mv_par02
	incregua()
	 if se1->e1_tipo == "JP "
			se1->(dbskip())
			loop
	 endif			 	
	_reg:=recno()
	_i++                     
	_cliente :=se1->e1_cliente
	_prffat :=se1->e1_prefixo
	_fatura :=se1->e1_num                                               
	_parcela:=se1->e1_parcela
	_loja :=se1->e1_loja
	
	se1->(dbsetorder(10))
	se1->(dbseek(_cfilse1+_cliente+_loja+_prffat+_fatura,.t.))
	_nota:=se1->e1_num   
	sd2->(dbseek(_cfilsd2+_cliente+_nota+"2  ",.t.))
	_pedido :=sd2->d2_pedido
	sc5->(dbseek(_cfilsc5+_pedido,.t.))
	_tppagto := sc5->c5_tppagto
	se1->(dbsetorder(1))
	se1->(dbseek(_cfilse1+_prffat+_fatura+_parcela,.t.))
	go _reg
	
	@ prow(),000 PSAY CHR(15)
	@ prow()+1,050 PSAY "VITAMEDIC - Ind. Farmaceutica Ltda"
	@ prow()+1,050 PSAY "Rua VPR 01-Qd.024 - Modulo 01 Daia - Anapolis - GO"
	@ prow()+1,050 PSAY "CEP 75133-600               Cx. Postal 66"
	@ prow()+1,050 PSAY "Fone: 0-XX-62-3902-6100     Fax:0-XX-62-3902-6199"
	@ prow()+2,050 PSAY "Natureza da Operacao:6.71 - VENDA DE PRODUTOS"
	@ prow()+2,050 PSAY "Data da Emissao da Nota:" +DTOC(SE1->E1_EMISSAO)
	@ prow()+2,000 PSAY "Duplicata:" +SE1->E1_NUM +"-"+SE1->E1_PARCELA
	_notas:=u_vit144(se1->e1_num)
	@ prow()+1,000 PSAY _notas              
	if _tppagto == "2"
		@ prow()+1,000 PSAY "CARTEIRA"
	else
		@ prow()+1,000 PSAY "BANCO"
	endif	
	If se1->e1_emissao==se1->e1_vencto
		@ prow()  ,035 PSAY "Dt.Venc.: A VISTA" 
	Else
		@ prow(), 035 PSAY "Dt.Venc.:"+DTOC(SE1->E1_VENCTO)
	EndIf
	@ prow(),060 PSAY "Valor: "
	@ prow(),069 PSAY SE1->E1_VALOR  Picture "@E 999,999.99"
	sa1->(dbseek(_cfilsa1+se1->e1_cliente+se1->e1_loja))
	sa6->(dbseek(_cfilsa6+se1->e1_portado))
  	@ prow()+2,000 PSAY  CHR(18)+"Nome Firma:" +SA1->A1_NOME  		
	@ prow()  ,060 PSAY  "Vend.:"+SE1->E1_VEND1
	@ prow()+1,000 PSAY  "End.:"+Subs(SA1->A1_END,1,50) 
	@ prow()  ,060 PSAY  "Cep:"
	@ prow()  ,065 PSAY  SA1->A1_CEP    Picture "@R 99999-999" 
	@ prow()+1,000 PSAY  "Municipio:" + SA1->A1_MUN +" - "+SA1->A1_EST
	@ prow()  ,060 PSAY  "Fone:" + alltrim(sa1->a1_ddd)+" "+alltrim(SA1->A1_TEL)
   @ prow()+2,000 PSAY  "End.de Pgto.:"+SA1->A1_ENDCOB 
   @ prow()+1,000 PSAY  "Bairro: "+sa1->a1_bairroc  
	@ prow()  ,060 PSAY  "Cep:"
	@ prow()  ,065 PSAY  SA1->A1_CEPC    Picture "@R 99999-999" 
	@ prow()+1,000 PSAY  "Municipio:" + SA1->A1_MUNC +" - "+SA1->A1_ESTC
   @ prow()+2,000 PSAY  "CNPJ/CPF:"
   @ prow()  ,010 PSAY  SA1->A1_CGC   Picture "@R 99.999.999/9999-99"   
   @ prow()+1,000 PSAY  "Insc. Est: "+  SA1->A1_INSCR                                                              
   @ prow()+1,000 PSAY "Valor por extenso:"
	@ prow()+1,022 PSAY TRIM(SUBS(EXTENSO(SE1->E1_VALOR),1,54))+REPLICATE("*",54-LEN(TRIM(SUBS(EXTENSO(SE1->E1_VALOR),1,54))))
	@ prow()+1,022 PSAY TRIM(SUBS(EXTENSO(SE1->E1_VALOR),55,54))+REPLICATE("*",54-LEN(TRIM(SUBS(EXTENSO(SE1->E1_VALOR),55,54))))
	@ prow()+1,022 PSAY TRIM(SUBS(EXTENSO(SE1->E1_VALOR),100,54))+REPLICATE("*",54-LEN(TRIM(SUBS(EXTENSO(SE1->E1_VALOR),100,54))))
	@ prow()+2,000 PSAY "Data: _____/_____/_____             Assinatura:________________________"

	se1->(dbskip())

	if (_i==2) .and.;
		!se1->(eof()) .and.;
		(se1->e1_filial==_cfilse1) .and.;
		(se1->e1_prefixo==mv_par03) .and.;
		(se1->e1_num<=mv_par02)
		_i:=0
		@ 066,000 PSAY " "

	 	setprc(0,0)
	else
		@ prow()+1,000 PSAY " "
	endif  

end
/*if _i<2
	@ 066,000 PSAY " "
	setprc(0,0)                                	
endif*/

Set Device to Screen

setpgeject(.f.)

If aReturn[5] == 1
   Set Printer To 
   dbCommitAll()
   ourspool(wnrel)
Endif

ms_flush()
return