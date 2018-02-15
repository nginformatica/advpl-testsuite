#include 'protheus.ch'
#include 'fileio.ch'

// ANSI/VT-100 sequences for console formatting
#define ANSI_BOLD Chr( 27 ) + '[1m'
#define ANSI_LIGHT_RED Chr( 27 ) + '[91m'
#define ANSI_LIGHT_GREEN Chr( 27 ) + '[92m'
#define ANSI_LIGHT_YELLOW Chr( 27 ) + '[93m'
#define ANSI_CYAN Chr( 27 ) + '[36m'
#define ANSI_LIGHT_GRAY Chr( 27 ) + '[37m'
#define ANSI_LIGHT_MAGENTA Chr( 27 ) + '[95m'
#define ANSI_END Chr( 27 ) + '[0m'

Static Function Now()
	Return ANSI_BOLD + '[' + DToC( Date() ) + ' ' + Time() + ']' + ANSI_END

Static Function FormatString( cInput, aValues )
	Local nIndex
	Local cResult := cInput

	Default aValues := {}
	For nIndex := 1 To Len( aValues )
		cResult := StrTran( cResult, '{' + AllTrim( Str( nIndex ) ) + '}', cValToChar( aValues[ nIndex ] ) )
	Next
	Return cResult

/**
 * @class Logger
 * @author Marcelo Camargo
 * @since 02/2018
 **/
Class Logger
	Data Context As Character
	Data Handler As Number

	Method New() Constructor
	Method Start()
	Method LogToFile( cKind, cText )
	Method Log( cMessage, aValues )
	Method Info( cMessage, aValues )
	Method Error( cMessage, aValues )
	Method Warn( cMessage, aValues )
	Method Success( cMessage, aValues )
EndClass

Method New( cContext ) Class Logger
	::Context := cContext
	Return ::Start()

Method Start() Class Logger
	Local cSep := If( isSrvUnix(), '/', '\' )
	Local cOutDir := CurDir() + cSep + 'logs'
	Local cOutFile := cOutDir + cSep + ::Context + '.log'

	If !ExistDir( cOutDir )
		MakeDir( cOutDir )
	EndIf

	If File( cOutFile )
		::Handler := FOpen( cOutFile, FO_WRITE + FO_SHARED, Nil, .F. )
	Else
		::Handler := FCreate( cOutFile, Nil, Nil, .F. )
	EndIf
	Return Self

Method LogToFile( cKind, cText ) Class Logger
	Local cLine := DToC( Date() ) + ' ' + Time() + ' | '
	cLine += Padr( '[' + cKind + ']', 11, ' ' ) + ' | '
	cLine += cText + Chr( 13 ) + Chr( 10 )
	FSeek( ::Handler, 0, FS_END )
	FWrite( ::Handler, cLine, Len( cLine ) )
	Return Self

Method Log( cMessage, aValues ) Class Logger
	Local cText := FormatString( cMessage, aValues )
	ConOut( Now() + ' [LOG]     ' + ANSI_LIGHT_GRAY + cText + ANSI_END )
	Return ::LogToFile( 'LOG', cText )

Method Info( cMessage, aValues ) Class Logger
	Local cText := FormatString( cMessage, aValues )
	ConOut( Now() + ' [INFO]    ' + ANSI_CYAN + cText + ANSI_END )
	Return ::LogToFile( 'INFO', cText )

Method Error( cMessage, aValues ) Class Logger
	Local cText := FormatString( cMessage, aValues )
	ConOut( Now() + ' [ERROR]   ' + ANSI_LIGHT_RED + cText + ANSI_END )
	Return ::LogToFile( 'ERROR', cText )

Method Warn( cMessage, aValues ) Class Logger
	Local cText := FormatString( cMessage, aValues )
	ConOut( Now() + ' [WARN]    ' + ANSI_LIGHT_YELLOW + cText + ANSI_END )
	Return ::LogToFile( 'WARN', cText )

Method Success( cMessage, aValues ) Class Logger
	Local cText := FormatString( cMessage, aValues )
	ConOut( Now() + ' [SUCCESS] ' + ANSI_LIGHT_GREEN + cText + ANSI_END )
	Return ::LogToFile( 'SUCCESS', cText )