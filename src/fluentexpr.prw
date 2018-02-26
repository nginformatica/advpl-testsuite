#include 'protheus.ch'
#include 'testsuite.ch'

#xcommand Throw <cMsg> With <aValues> ;
    => ;
    __MSG__ := Format( <cMsg>, <aValues> ) ;;
    aAdd( aTestReport, { .F., __MSG__ } ) ;;
    UserException( __MSG__ ) ;;
    Return Self

#xcommand Passed <cMsg> With <aValues> ;
    => ;
    __MSG__ := Format( <cMsg>, <aValues> ) ;;
    aAdd( aTestReport, { .T., __MSG__ } ) ;;
    Return Self

Static Function Format( cString, aValues )
    Local cResult := cString
    Local nIndex
    For nIndex := 1 To Len( aValues )
        cResult := StrTran( cResult, '{' + AllTrim( Str( nIndex ) ) + '}', ToString( aValues[ nIndex ] ) )
    Next
    Return cResult

Static Function ToString( xValue )
    Local cType := ValType( xValue )
    If cType == "A"
        Return '{ ' + ArrTokStr( xValue, ', ') + ' }'
    ElseIf cType == "B"
        Return GetCBSource( xValue )
    ElseIf cType == "O"
        Return ArrTokStr( ClassMethArr( xValue, .T. ), ' | ' )
    EndIf
    Return cValToChar( xValue )

Class FluentExpr
    Data xValue
    Data lNot
    Method New( xValue ) Constructor
    Method Not()

    Method ToBe( xOther )
    Method ToBeAFile()
    Method ToBeAFileWithContents( cContent )
    Method ToBeAFolder()
    Method ToHaveType( cType )
    Method ToThrowError()
EndClass

Method New( xValue ) Class FluentExpr
    ::xValue := xValue
    ::lNot := .F.
    Return Self

Method Not() Class FluentExpr
    ::lNot := .T.
    Return Self

Method ToBe( xOther ) Class FluentExpr
    Local cValue := ToString( ::xValue )
    Local cOther := ToString( xOther )
    If ::lNot
        If cValue == cOther
            Throw 'Expected {1} to not be {2}' With { cValue, cOther }
        EndIf

        Passed 'Expected {1} to not be {2}' With { cValue, cOther }
    Else
        If !(cValue == cOther)
            Throw 'Expected {1} to be {2}' With { cValue, cOther }
        EndIf

        Passed 'Expected {1} to be {2}' With { cValue, cOther }
    EndIf
    Return Self

Method ToBeAFile() Class FluentExpr
    Local lIsFile := File( ::xValue )

    If ::lNot
        If lIsFile
            Throw 'Expected {1} to not be a file' with { ::xValue }
        EndIf
        Passed 'Expected {1} to not be a file' With { ::xValue }
    Else
        If !lIsFile
            Throw 'Expected {1} to be a file' with { ::xValue }
        EndIf
        Passed 'Expected {1} to be a file' With { ::xValue }
    EndIf
    Return Self

Method ToBeAFileWithContents( cContent ) Class FluentExpr
    Local lIsFile := File( ::xValue )

    If ::lNot
        If lIsFile .And. ReadFileContents( ::xValue ) == cContent
            Throw 'Expected {1} to not be a file with contents "{2}"' with { ::xValue, cContent }
        EndIf
        Passed 'Expected {1} to not be a file with contents "{2}"' With { ::xValue, cContent }
    Else
        If !lIsFile .Or. !(ReadFileContents( ::xValue ) == cContent)
            Throw 'Expected {1} to be a file with contents "{2}"' with { ::xValue, cContent }
        EndIf
        Passed 'Expected {1} to be a file with contents "{2}"' With { ::xValue, cContent }
    EndIf
    Return Self


Method ToBeAFolder() Class FluentExpr
    Local lIsFolder := ExistDir( ::xValue )

    If ::lNot
        If lIsFolder
            Throw 'Expected {1} to not be a folder' with { ::xValue }
        EndIf
        Passed 'Expected {1} to not be a folder' With { ::xValue }
    Else
        If !lIsFolder
            Throw 'Expected {1} to be a folder' with { ::xValue }
        EndIf
        Passed 'Expected {1} to be a folder' With { ::xValue }
    EndIf
    Return Self

Method ToHaveType( cType ) Class FluentExpr
    Local cMyType := ValType( ::xValue )

    If ::lNot
        If cMyType == cType
            Throw 'Expected {1} to not have type {2}, but it does' With { ::xValue, cType }
        EndIf
        Passed 'Expected {1} to not have type {2} (it is a {3})' With { ::xValue, cType, cMyType }
    Else
        If !(cMyType == cType)
            Throw 'Expected {1} to have type {2}, but it has type {3}' With { ::xValue, cType, cMyType }
        EndIf
        Passed 'Expected {1} to have type {2}' With { ::xValue, cType }
    EndIf
    Return Self

Method ToThrowError() Class FluentExpr
    Local oError
    Local bError := ErrorBlock( { |oExc| oError := oExc } )
    Local cSource := GetCBSource( ::xValue )

    Begin Sequence
        Eval( ::xValue )
    End Sequence

    ErrorBlock( bError )

    If oError == Nil
        aAdd( aTestReport, { .F., 'Expected {1} to throw an error', { cSource } } )
        UserException( 'Expected ' + cSource + ' to throw error' )
        Return Self
    EndIf
    aAdd( aTestReport, { .T., 'Expected {1} to throw an error', { cSource } } )
    Return Self