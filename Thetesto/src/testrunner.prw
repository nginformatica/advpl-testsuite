#include 'msobject.ch'
#include 'apwebsrv.ch'

WsStruct SuiteModel
    WsData ClassName As String
    WsData Name As String
    WsData File As String
    WsData Description As String Optional
    WsData TestCases As Array Of Object
EndWsStruct

WsStruct CaseModel
    WsData Name As String
    WsData Description As String Optional
    WsData Skip As Logical
    WsData Only As Logical
    WsData TimeOut As Integer Optional
EndWsStruct

Class TestRunner From LongNameClass
    Data Colors  As Logical
    Data Verbose As Logical

    Method New( cSuite )
    Method GetAllTestSuites()
    Method Run()
EndClass

Method New() Class TestRunner
    ::Colors  := .T.
    ::Verbose := .F.
Return Self

Method Run() Class TestRunner
    Local oReporter := CliReporter():New()
    Local aSuites   := ::GetAllTestSuites()
    Local nSuite
    Local oSuite
    Local nCase
    Local oCase
    Local bError
    Local oError

    oReporter:WillStart( aSuites )

    For nSuite := 1 To Len( aSuites )
        oSuite := aSuites[ nSuite ]
        Private oInstance := WsClassNew( oSuite:ClassName )
        oReporter:WillRunSuite( oSuite )
        For nCase := 1 To Len( oSuite:TestCases )
            oCase := oSuite:TestCases[ nCase ]
            oReporter:WillRun( oCase )
            bError := ErrorBlock( { |oMyError| oError := oMyError } )
            Begin Sequence
                oError := Nil
                If oCase:Skip
                    oReporter:DidSkip( oCase )
                Else
                    &( "oInstance:TestCase_" + oCase:Name + "()" )
                    If !Empty( oError )
                        Break( oError )
                    EndIf
                    oReporter:DidPass( oCase )
                EndIf
            Recover
                oReporter:DidFail( oCase, oError )
            End Sequence
            ErrorBlock( bError )
        Next
        FreeObj( oInstance )
        oReporter:DidRunSuite()
    Next

    oReporter:DidStop()
Return

Method GetAllTestSuites() Class TestRunner
    Local aTestFiles := GetSrcArray( "*.TEST.PRW" )
    Local aSuites    := {}
    Local cSuite
    Local cCase
    Local aClass
    Local oSuite
    Local oCase
    Local nIndex
    Local nMethod
    Local cMode

    For nIndex := 1 To Len( aTestFiles )
        cSuite := Left( aTestFiles[ nIndex ], Len( aTestFiles[ nIndex ] ) - 9 )
        cClass := "THETESTO_" + cSuite
        aClass := WsDescData( cClass, .T. )

        If Empty( aClass )
            Loop
        EndIf

        oSuite := WsClassNew( "SuiteModel" )
        oSuite:ClassName   := cClass
        oSuite:Name        := FindProp( aClass, "NAME", "" )
        oSuite:File        := aTestFiles[ nIndex ]
        oSuite:Description := FindProp( aClass, "_", "" )
        oSuite:TestCases   := {}

        For nMethod := 1 To Len( aClass )
            If Left( aClass[ nMethod, 1 ], 28 ) = "DESCRIPTION_TESTCASE_MARKER_"
                cCase := Right( aClass[ nMethod, 1 ], Len( aClass[ nMethod, 1 ] ) - 28 )
                oCase := WsClassNew( "CaseModel" )
                cMode := FindProp( aClass, "TESTCASE_" + cCase + "_MODE", "" )
                oCase:Name        := FindProp( aClass, "TESTCASE_" + cCase + "_NAME", "" )
                oCase:Description := FindProp( aClass, "TESTCASE_" + cCase, "" )
                oCase:Skip        := cMode == "SKIP"
                oCase:Only        := cMode == "ONLY"
                oCase:TimeOut     := Val( FindProp( aClass, "TESTCASE_" + cCase + "_TIMEOUT", "0" ) )
                AAdd( oSuite:TestCases, oCase )
            EndIf
        Next
        AAdd( aSuites, oSuite )
    Next
Return aSuites

Static Function FindProp( aDesc, cProp, xDefault )
    Local nIndex
    Local xResult

    nIndex := AScan( aDesc, { |aSub| aSub[ 1 ] == "DESCRIPTION_" + Upper( cProp ) } )
    If nIndex > 0
        xResult := aDesc[ nIndex, 3 ]
    EndIf

    Default xResult := xDefault
Return xResult

User Function Fusca()
    Local aArr := { 1, 2, 3 }
    ADel( aArr, 12 )
Return
