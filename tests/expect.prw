#include 'protheus.ch'
#include 'testsuite.ch'

TestSuite Expect Description 'The test suite to test the test suite itself!' Verbose
    Environment 'T3' 'S SC 01'
    Feature Files Description 'Tests with files should be working'
EndTestSuite

Feature Files TestSuite Expect
    Local nHandle

    If File( '\love.txt' )
        FErase( '\love.txt' )
    EndIf

    nHandle := FCreate( '\love.txt' )
    FWrite( nHandle, 'I love you <3' )
    FClose( nHandle )

    ::Expect( nHandle ):Not():ToHaveType( 'C' )
    ::Expect( nHandle ):ToHaveType( 'N' )
    ::Expect( nHandle ):Not():ToBe( 0 )
    ::Expect( '\hate.txt' ):Not():ToBeAfile()
    ::Expect( '\love.txt' ):ToBeAFile()
    Return

CompileTestSuite Expect