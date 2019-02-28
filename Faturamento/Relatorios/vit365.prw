#include "rwmake.ch"            
#include "dialog.ch"
#include "topconn.ch"

/*/{Protheus.doc} vit365
	Impressao de Etiquetas de Volumes - Faturamento 
@author Alex Junio de Miranda
@since 14/06/11
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function vit365()
_cfilsa1:=xfilial("SA1")
_cfilsa2:=xfilial("SA2")
_cfilsa4:=xfilial("SA4")
_cfilsd2:=xfilial("SD2")
_cfilsf2:=xfilial("SF2")

_serie	 :=space(3)
_denota  :=space(9)
_atenota :=space(9)
_nvolume :=0
_cporta  :=""      
_aportas :={"COM2:9600,N,8,2","LPT1","COM1:9600,N,8,2"}

@ 000,000 to 180,450 dialog odlg title "Impressao de Etiquetas Volume - Faturamento"
@ 010,005 say "Serie"
@ 010,050 get _serie size 50,8 
@ 020,005 say "Da Nota Fiscal"
@ 020,050 get _denota size 50,8 f3 "SD2"
@ 030,005 say "Ate a Nota Fiscal"
@ 030,050 get _atenota size 50,8 f3 "SD2"

@ 040,005 say "Porta"
@ 040,050 combobox _cporta items _aportas size 70,8

@ 060,050 bmpbutton type 1 action imprime2()
@ 060,085 bmpbutton type 2 action close(odlg)

activate dialog odlg centered
return

Static Function imprime2()
_lok:= .f.

sf2->(dbsetorder(1))
sf2->(dbseek(_cfilsf2+_denota+_serie,.t.))

while !sf2->(eof()) /*.and. sf2->f2_filial==_cfilsf2*/ .and.; 
sf2->f2_doc >= _denota .and. sf2->f2_doc <= _atenota .and. sf2->f2_serie == _serie //.and. !_lok
Alert(sf2->f2_doc)		
	sd2->(dbsetorder(3))
	sd2->(dbseek(_cfilsd2+sf2->f2_doc+sf2->f2_serie,.t.))

    if sd2->d2_tipo $"DB"
    	sa2->(dbsetorder(1))
    	sa2->(dbseek(_cfilsa2+sf2->f2_cliente+sf2->f2_loja))
    else
    	sa1->(dbsetorder(1))
    	sa1->(dbseek(_cfilsa1+sf2->f2_cliente+sf2->f2_loja))
	endif
	
	dbSelectArea("SA4")
	sa4->(dbsetorder(1))	
	sa4->(dbseek(_cfilsa4+sf2->f2_transp))

	_nvolume :=sf2->f2_volume1   
	       	
	mscbprinter("S600",_cporta,,62,.F.,,,,10240)
	mscbchkstatus(.f.)

	for _i:=1 to _nvolume
//		mscbbegin(1,6,62)
		mscbbegin(1,6)
			mscbsay(010,003,"VITAMEDIC IND. FARMACEUTICA LTDA","N","0","050,028") // T�TULO   
			mscbsay(009,010,"Cliente: "+sd2->d2_cliente,"N","0","050,035") // CODIGO DO CLIENTE/FORNECEDOR
			mscbsay(065,010,"Pedido: "+sd2->d2_pedido,"N","0","050,035") // NUMERO DO PEDIDO 

            if sd2->d2_tipo $"DB"                                                                 
				mscbsay(012,018,sa2->a2_nome,"N","0","050,035") // NOME FORNECEDOR
				mscbsay(009,026,sa2->a2_end,"N","0","050,028") // ENDERECO FORNECEDOR
				mscbsay(010,033,"Cep: "+Trans(sa2->a2_cep,"@R 99999-999")+" "+AllTrim(sa2->a2_mun)+" "+sa2->a2_est,"N","0","050,028") // CEP + CIDADE + ESTADO
			else
				mscbsay(012,018,sa1->a1_nome,"N","0","050,035") // NOME CLIENTE
				mscbsay(009,026,sa1->a1_end,"N","0","050,028") // ENDERECO CLIENTE
				mscbsay(010,033,"Cep: "+Trans(sa1->a1_cep,"@R 99999-999")+" "+AllTrim(sa1->a1_mun)+" "+sa1->a1_est,"N","0","050,028") // CEP + CIDADE + ESTADO
			endif
			
			mscbsay(012,040,"Transportadora: "+sa4->a4_nome,"N","0","050,028") // TRANSPORTADORA
			mscbsay(009,047,"Volume: "+str(_i,4,0)+"/"+str(_nvolume,4,0),"N","0","050,028") // VOLUME
			mscbsay(065,047,"Especie: "+alltrim(sf2->f2_especi1),"N","0","050,028") // ESPECIE DO VOLUME
			mscbsay(010,054,"Nota Fiscal/Serie: "+sf2->f2_doc+"/"+sf2->f2_serie,"N","0","050,028")		
		mscbend()				
	next
	mscbcloseprinter()	
	
	_lok:= .t.

	sf2->(dbskip())
end

if !_lok
	msgstop("Dados inválidos! NF não encontrada!")
endif

close(odlg)
return

