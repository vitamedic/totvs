#include "rwmake.ch"
#include "topconn.ch"

/*/{Protheus.doc} vit005
Validacao da Quantidade Liberada do Pedido de Venda para Retornar o Estoque Disponivel para Faturamento
@author Heraildo C. de Freitas
@since 08/01/2002
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function vit005()
_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsb8:=xfilial("SB8")
_cfilsbf:=xfilial("SBF")
_cfilsc6:=xfilial("SC6")
_cfilsc9:=xfilial("SC9")
_cfilsf4:=xfilial("SF4")
sb1->(dbsetorder(1))
sc6->(dbsetorder(1))
sf4->(dbsetorder(1))

_npitem   :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_ITEM"})
_npproduto:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_PRODUTO"})
_nplocal  :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_LOCAL"})
_nptes    :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_TES"})
_npqtdlib :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_QTDLIB"})
_npsldalib:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_SLDALIB"})
_nqtdemp  :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_QTDEMP"})

for _i:=1 to len(acols)
    if _npsldalib==0
        _nsldalib:=0
        _lzera:=.f.
    else
        _nsldalib:=acols[_i,_npsldalib]
        _lzera:=.t.
    endif
    if _nsldalib==0 .and.;
        _lzera
        acols[_i,_npqtdlib]:=0
    else
        if _i==n
            _nqtdlib:=m->c6_qtdlib
        else
            _nqtdlib:=acols[_i,_npqtdlib]
        endif
        _ctes:=acols[_i,_nptes]
        sf4->(dbseek(_cfilsf4+_ctes))
        if _nqtdlib>0 .and.;
            sf4->f4_estoque=="S"
            _citem   :=acols[_i,_npitem]
            _cproduto:=acols[_i,_npproduto]
            _clocal  :=acols[_i,_nplocal]
            
            _cquery:=" SELECT"
            _cquery+=" SUM(C9_QTDLIB) QTDLIB"
            _cquery+=" FROM "
            _cquery+=  retsqlname("SC9")+" SC9"
            _cquery+=" WHERE"
            _cquery+="     SC9.D_E_L_E_T_<>'*'"
            _cquery+=" AND C9_FILIAL='"+_cfilsc9+"'"
            _cquery+=" AND C9_PRODUTO='"+_cproduto+"'"
            _cquery+=" AND C9_LOCAL='"+_clocal+"'"
            _cquery+=" AND C9_BLCRED BETWEEN '01' AND '09'"
        
            _cquery:=changequery(_cquery)
            
            MemoWrite("/sql/vit005tmp1.sql",_cquery)        
            tcquery _cquery new alias "TMP1"
            tcsetfield("TMP1","QTDLIB","N",9,2)
        
            sb1->(dbseek(_cfilsb1+_cproduto))
            if sb1->b1_localiz=="S"
                _cquery:=          " SELECT SUM(BF_QUANT-BF_EMPENHO) AS SALDO"
                _cquery:=_cquery+" FROM "+retsqlname("SBF")
                _cquery:=_cquery+" WHERE BF_FILIAL='"+xfilial("SBF")+"'"
                _cquery:=_cquery+" AND D_E_L_E_T_<>'*'"
                _cquery:=_cquery+" AND BF_PRODUTO='"+_cproduto+"'"
                _cquery:=_cquery+" AND BF_LOCAL='"+_clocal+"'"
            
                _cquery:=changequery(_cquery)

            elseif (sb1->b1_rastro=="L" .and. sb1->b1_localiz=="N")
                _cquery:=" SELECT"
                _cquery+=" SUM(B8_SALDO-B8_EMPENHO) SALDO"
                _cquery+=" FROM "
                _cquery+=  retsqlname("SB8")+" SB8"
                _cquery+=" WHERE"
                _cquery+="     SB8.D_E_L_E_T_<>'*'"
                _cquery+=" AND B8_FILIAL='"+_cfilsb8+"'"
                _cquery+=" AND B8_PRODUTO='"+_cproduto+"'"
                _cquery+=" AND B8_LOCAL='"+_clocal+"'"
                _cquery+=" AND B8_SALDO>0"
            
                _cquery:=changequery(_cquery)
            else
                _cquery:=" SELECT"
                _cquery+=" SUM(B2_QATU-B2_QEMP-B2_RESERVA) AS SALDO"
                _cquery+=" FROM "
                _cquery+=  retsqlname("SB2")+" SB2"
                _cquery+=" WHERE"
                _cquery+="     D_E_L_E_T_<>'*'"
                _cquery+=" AND B2_FILIAL='"+_cfilsb2+"'"
                _cquery+=" AND B2_COD='"+_cproduto+"'"
                _cquery+=" AND B2_LOCAL='"+_clocal+"'"
            
                _cquery:=changequery(_cquery)
            endif
            MemoWrite("/sql/vit005tmp2.sql",_cquery)
            tcquery _cquery new alias "TMP2"
            tcsetfield("TMP2","SALDO","N",15,5)
    
            sc6->(dbseek(_cfilsc6+m->c5_num+_citem))
            _ndispo:=tmp2->saldo-tmp1->qtdlib
            if _ndispo<=0
                if _i==n
                    m->c6_qtdlib:=0
                else
                    acols[_i,_npqtdlib]:=0
                endif
            elseif _nqtdlib>_ndispo
                if _ndispo>=sc6->c6_qtdven-sc6->c6_qtdent
                    if _i==n
                        m->c6_qtdlib:=sc6->c6_qtdven-sc6->c6_qtdent
                    else
                        acols[_i,_npqtdlib]:=sc6->c6_qtdven-sc6->c6_qtdent
                    endif
                else
                    if _i==n
                        m->c6_qtdlib:=_ndispo
                    else
                        acols[_i,_npqtdlib]:=_ndispo
                    endif
                endif
            endif
            tmp1->(dbclosearea())
            tmp2->(dbclosearea())
        endif
    endif
next
return(.t.)