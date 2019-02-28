/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT366    ³ Autor ³ Alex Júnio de Miranda³ Data ³ 14/06/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao de Etiquetas de Identificação de Amostra         ³±±
±±³          ³ de Lote Piloto para Análise.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"

user function vit366()
_produto :=space(40)
_lote    :=space(10)
_dtfab   :=ctod("  /  /  ")
_dtval   :=ctod("  /  /  ")
_nvolume :=0
_cporta  :=""     
_aportas :={"COM2:9600,N,8,2","LPT1","COM1:9600,N,8,2"}

@ 000,000 to 200,450 dialog odlg title "Impressao de Etiquetas Identificao Amostra Piloto"
@ 010,005 say "Produto"
@ 010,050 get _produto size 50,8 
@ 020,005 say "Lote"
@ 020,050 get _lote size 50,8
@ 030,005 say "Dt. Fabr.:"
@ 030,050 get _dtfab 
@ 040,005 say "Dt. Val.:"
@ 040,050 get _dtval 
@ 050,005 say "N. Etiquetas:"
@ 050,050 get _nvolume picture "@E 999"

@ 060,005 say "Porta"
@ 060,050 combobox _cporta items _aportas size 70,8

@ 080,050 bmpbutton type 1 action _impetiq()
@ 080,085 bmpbutton type 2 action close(odlg)

activate dialog odlg centered
return

Static Function _impetiq()

mscbprinter("S600",_cporta,,62,.F.,,,,10240)      

mscbchkstatus(.f.)

mscbbegin(_nvolume,6)
	mscbsay(010,005,"VITAMEDIC IND. FARMACEUTICA LTDA","N","0","060,040")  
	mscbsay(010,020,"Produto: "+_produto,"N","0","060,040") 
	mscbsay(010,027,"Lote: "+_lote,"N","0","060,040") 
	mscbsay(010,034,"Dt. Fabricacao: "+substr(dtoc(_dtfab),4,5),"N","0","050,028") 
	mscbsay(010,041,"Dt. Validade: "+substr(dtoc(_dtval),4,5),"N","0","050,028") 
mscbend()		
mscbcloseprinter()		

close(odlg)
return

