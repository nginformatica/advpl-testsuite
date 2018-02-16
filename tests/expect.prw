#include 'protheus.ch'
#include 'testsuite.ch'

TestSuite Expect Description 'The test suite to test the test suite itself!' Verbose
    Enable Environment 'T3' 'S SC 01'
    Enable Before
    Feature Files Description 'Tests with files should be working'
    Feature Folders Description 'Tests with folders should be :top:'
EndTestSuite

Before TestSuite Expect
    If File( '\love.txt' )
        FErase( '\love.txt' )
    EndIf
    If ExistDir( '\problems' )
        DirRemove( '\problems' )
    EndIf
    Return

Feature Files TestSuite Expect
    Local nHandle

    nHandle := FCreate( '\love.txt' )
    FWrite( nHandle, 'I love you <3' )
    FClose( nHandle )

    ::Expect( nHandle ):Not():ToHaveType( 'C' )
    ::Expect( nHandle ):ToHaveType( 'N' )
    ::Expect( nHandle ):Not():ToBe( 0 )
    ::Expect( '\hate.txt' ):Not():ToBeAfile()
    ::Expect( '\love.txt' ):ToBeAFile()
    ::Expect( '\love.txt' ):Not():ToBeAFileWithContents( 'I hate you :@' )
    ::Expect( '\love.txt' ):ToBeAFileWithContents( 'I love you <3' )
    Return

Feature Folders TestSuite Expect
    MakeDir( '\problems' )
    ::Expect( '\problems' ):ToBeAFolder()
    ::Expect( '\happiness' ):Not():ToBeAFolder()
    Return

CompileTestSuite Expect