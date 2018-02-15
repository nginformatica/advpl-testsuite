#include 'protheus.ch'
#include 'testsuite.ch'

TestSuite Expect Description 'The test suite to test the test suite itself!' Verbose
    Environment 'T3' 'S SC 01'
    // Feature CodeBlocks Description 'Tests with exceptions and code blocks'
    Feature Files Description 'Tests with files should be working'
    Feature Folders Description 'Tests with folders should be :top:'
EndTestSuite

// Feature CodeBlocks TestSuite Expect
//     Local bCorrect := { || 1 + 1 }
//     Local bWrong := { |xWhat| xWhat + '...' }

//     ::Expect( bCorrect ):Not():ToThrowError()
//     ::Expect( bWrong ):ToThrowError()
//     Return

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

Feature Folders TestSuite Expect
    If ExistDir( '\problems' )
        DirRemove( '\problems' )
    EndIf

    MakeDir( '\problems' )
    ::Expect( '\problems' ):ToBeAFolder()
    ::Expect( '\happiness' ):Not():ToBeAFolder()
    Return

CompileTestSuite Expect