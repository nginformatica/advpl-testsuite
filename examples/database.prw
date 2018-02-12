#include 'protheus.ch'
#include 'testsuite.ch'

TestSuite CentroDeCusto Description 'Testes de gravacao de centro de custo'
    Environment 'T3' 'S SC 01'
    Data nRegistros As Numeric
    Feature Gravacao Description 'Grava centro de custo na CTT'
    Feature Leitura Description 'Le os dados gravados na CTT'
EndTestSuite

Feature Gravacao TestSuite CentroDeCusto
    Local cAliasQry := GetNextAlias()
    BeginSql Alias cAliasQry
        Column QUANTIDADE As Numeric(14, 2)
        SELECT COUNT(*) AS QUANTIDADE FROM %table:CTT%
    EndSql
    ::nRegistros := ( cAliasQry )->QUANTIDADE
    ( cAliasQry )->( dbCloseArea() )
    ::Expect( ::nRegistros ):ToBe( 2 ) // Começa com 2 registros

    dbSelectArea( 'CTT' )
    RecLock( 'CTT', .T. )
    CTT->CTT_FILIAL := xFilial( 'CTT' )
    CTT->CTT_CUSTO  := 'POMBAL'
    CTT->CTT_DESC01 := 'ONDE OS POMBOS HABITAM'
    MsUnlock()
    BeginSql Alias cAliasQry
        Column QUANTIDADE As Numeric(14, 2)
        SELECT COUNT(*) AS QUANTIDADE FROM %table:CTT%
    EndSql
    ::nRegistros := ( cAliasQry )->QUANTIDADE
    ( cAliasQry )->( dbCloseArea() )
    ::Expect( ::nRegistros ):ToBe( 3 ) // Termina com 3 registros
    Return

Feature Leitura TestSuite CentroDeCusto
    dbSelectArea( 'CTT' )
    dbSeek( xFilial( 'CTT' ) + 'POMBAL' )
    ::Expect( CTT->CTT_DESC01 ):ToHaveType( 'C' )
    ::Expect( AllTrim( CTT->CTT_DESC01 ) ):ToBe( 'ONDE OS POMBOS HABITAM' )
    Return

CompileTestSuite CentroDeCusto
