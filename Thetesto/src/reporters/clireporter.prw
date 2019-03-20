#include 'protheus.ch'

#xtranslate ? [ <explist,...> ] => ConOut( <explist> )

#define CRLF (Chr( 13 ) + Chr( 10 ))

#define ESC Chr( 27 )
#define ANSI_CLEAR_SCREEN  (ESC + 'c')
#define ANSI_BOLD          (ESC + '[1m')
#define ANSI_UNDERLINE     (ESC + '[4m')
#define ANSI_BG_RED        (ESC + '[41m')
#define ANSI_BG_GREEN      (ESC + '[42m')
#define ANSI_BG_YELLOW     (ESC + '[43m')
#define ANSI_BG_CYAN       (ESC + '[46m')
#define ANSI_BG_LIGHT_BLUE (ESC + '[104m')
#define ANSI_BG_WHITE      (ESC + '[47m')
#define ANSI_FG_LIGHT_BLUE (ESC + '[94m')
#define ANSI_FG_BLACK      (ESC + '[30m')
#define ANSI_FG_RED        (ESC + '[31m')
#define ANSI_FG_GREEN      (ESC + '[32m')
#define ANSI_FG_CYAN       (ESC + '[36m')
#define ANSI_FG_GRAY       (ESC + '[90m')
#define ANSI_FG_WHITE      (ESC + '[97m')
#define ANSI_RESET         (ESC + '[0m')

#define FAIL ("    " + ANSI_BG_RED + ANSI_FG_WHITE + " FAIL " + ANSI_RESET)
#define PASS ("    " + ANSI_BG_GREEN + ANSI_FG_WHITE + " PASS " + ANSI_RESET)
#define SKIP ("    " + ANSI_BG_CYAN + ANSI_FG_WHITE + " SKIP " + ANSI_RESET)

#define ELLAPSED( nEllapsed ) " " + ANSI_FG_RED + "(" + cValToChar( nEllapsed ) + "ms)"

Class CliReporter From LongNameClass
    Data nTimer

    Data Colors As Logical

    Method New() Constructor
    Method WillRun( oCase )
    Method WillRunSuite( oSuite )
    Method WillStart( aSuites )
    Method DidFail( oCase, oError )
    Method DidPass( oCase )
    Method DidRunSuite()
    Method DidSkip( oCase )
    Method DidStop()
EndClass

Method New( lColors ) Class CliReporter
    Default lColors  := .T.

    ::Colors := lColors
Return Self

Method WillRun( oCase ) Class CliReporter
    ::nTimer := Seconds()
Return

Method WillRunSuite( oSuite ) Class CliReporter
    ? Space( 2 ) + oSuite:Description
Return

Method WillStart( aSuites ) Class CliReporter
    ? ANSI_CLEAR_SCREEN
Return

Method DidFail( oCase, oError ) Class CliReporter
    ? FAIL + " " + oCase:Description + ANSI_RESET
    ? CRLF + Space( 6 ) + ANSI_FG_RED + oError:Description + ANSI_RESET + CRLF
    ? FormatStack( oError:ErrorStack )
Return

Method DidPass( oCase ) Class CliReporter
    Local nEllapsed := (Seconds() - ::nTimer) * 1000

    ? PASS + " " +  oCase:Description + ELLAPSED( nEllapsed ) + ANSI_RESET
Return

Method DidSkip( oCase ) Class CliReporter
    ? SKIP + " " + oCase:Description + ANSI_RESET
Return

Method DidRunSuite() Class CliReporter
    ? ""
Return

Method DidStop() Class CliReporter
    ? Replicate( Chr( 13 ) + Chr( 10 ), 10 )

/**
 * Formats the stack of an error.
 *
 * @param {Character} cStack - the stack string
 * @returns {Character} the colorized and formatted stack
 */
Static Function FormatStack( cStack )
    Local aLines  := StrTokArr( cStack, CRLF )
    Local cResult := ""
    Local nLine
    Local cLine
    Local nOpen
    Local cFile
    Local cSource

    For nLine := 1 To Len( aLines )
        cLine := aLines[ nLine ]
        If nLine == 1
            cLine := StrTran( cLine, "THREAD ERROR", ANSI_FG_RED + "THREAD ERROR" + ANSI_RESET )
        ElseIf cLine = "Called from"
            If '.TEST.PRW)' $ cLine .And. Empty( cFile )
                nOpen := At( '(', cLine )
                cFile := SubStr( cLine, nOpen + 1, At( '.TEST.PRW)', cLine ) - nOpen + 8  )
            EndIf
            cLine := FormatLine( cLine )
        EndIf

        cResult += Space( 6 ) + cLine + CRLF
    Next

    If !Empty( cFile )
        // cSource := ExtractSource( cFile )
    EndIf

Return cResult

Static Function FormatLine( cLine )
    Local cResult := ""
    Local nOpen
    Local nClose
    Local cMethod
    Local cFile
    Local cDateTime
    Local cLineNumber

    nOpen       := At( '(', cLine )
    nClose      := At( ')', cLine )
    cMethod     := SubStr( cLine, 13, nOpen - 13 )
    cFile       := SubStr( cLine, nOpen + 1, nClose - nOpen - 1 )
    cDateTime   := SubStr( cLine, nClose + 2, 16 )
    cLineNumber := SubStr( cLine, RAt( ':', cLine ) + 2 )

    cResult := ANSI_FG_GRAY + "at " + ANSI_RESET
    cResult += ANSI_FG_LIGHT_BLUE + cMethod + " " + ANSI_RESET
    cResult += "(" + ANSI_UNDERLINE + ANSI_FG_CYAN + cFile + ANSI_RESET + ":"
    cResult += ANSI_FG_CYAN + cLineNumber + ANSI_RESET + ") "
    cResult += ANSI_FG_GRAY + cDateTime + ANSI_RESET
Return cResult

/**
 * Tries to extract the real source code to show it.
 * The original path is retrieved directly from RPO.
 * @param {Character} cProgram - file name to open
 */
Static Function ExtractSource( cProgram )
    Local xByteCode
    Local nFrom
    Local nTo
    Local cChunk
    Local aSeparators := {}
    Local nNul := 0

    xByteCode := GetApoRes( cProgram )
    nFrom := At( cProgram, xByteCode )
    nTo := At( "%" + cProgram + "%", xByteCode, nFrom + 1 )
    cChunk := SubStr( xByteCode, nFrom, nTo - nFrom )

    Do While .T.
        nNul := At( Chr( 0 ), cChunk, nNul + 1 )

        If nNul == 0
            Exit
        EndIf

        Aadd( aSeparators, nNul )
    EndDo

    ConOut(1)
Return
