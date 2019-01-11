#include 'protheus.ch'
#include 'testsuite.ch'

#define SUITEID Expect

Test Suite 'The test suite to test the test suite itself!' Verbose
    Define Before
        If File( '\love.txt' )
            FErase( '\love.txt' )
        EndIf
        If ExistDir( '\problems' )
            DirRemove( '\problems' )
        EndIf
        Return

    Define Feature Files 'Tests with files should be working'
        Local nHandle

        nHandle := FCreate( '\love.txt' )
        FWrite( nHandle, 'I love you <3' )
        FClose( nHandle )

        Expect nHandle to not have type 'C'
        Expect nHandle to have type 'N'
        Expect nHandle to not be 0
        Expect '\hate.txt' to not be a file
        Expect '\love.txt' to be a file
        Expect '\love.txt' to not be a file with contents 'I hate you :@'
        Expect '\love.txt' to be a file with contents 'I love you <3+'
        Return

    Define Feature Folders 'Tests with folders should be :top:'
        MakeDir( '\problems' )
        Expect '\problems' to be a folder
        Expect '\happiness' to not be a folder
        Return

End Test Suite

#undef SUITEID