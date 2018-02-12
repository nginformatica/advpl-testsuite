/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2018 NG Informática - TOTVS Software Partner
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include 'protheus.ch'

#define ANSI_CLEAR_SCREEN Chr( 27 ) + '[2J'
#define ANSI_MOVE_CURSOR_TO_HOME Chr( 27 ) + '[H'
#define ANSI_BEL Chr( 7 )
#define ANSI_SET_TITLE Chr( 27 ) + ']2;'
#define ANSI_YELLOW Chr( 27 ) + '[93m'
#define ANSI_RED Chr( 27 ) + '[91m'
#define ANSI_RESET Chr( 27 ) + '[0m'
#define ANSI_SAVE Chr( 27 ) + '7'
#define ANSI_RESTORE Chr( 27 ) + '8'
#define ANSI_YELLOW Chr( 27 ) + '[93m'

Class TestSuite
	Data aErrors As Array
    Data cName As Character
    Data cDescription As Character
    Data oTester As Object
    Data oLogger As Object
    Method New( cName, cDescription ) Constructor
    Method GetFeatures()
    Method Run( oTester )
    Method ReportError( cFeature, cDescription, nStartedAt, oError )
    Method ReportEnd( cFeature, cDescription, nStartedAt )
    Method FormatStack( cStack )
    Method Expect( xExpr )
EndClass

Method New( cName, cDescription ) Class TestSuite
	::aErrors := {}
    ::cName := cName
    ::cDescription := cDescription
    Return Self

Method FormatStack( cStack ) Class TestSuite
    Local cResult := ''
    Local aStack := StrTokArr2( cStack, Chr( 10 ), .T. )
    Local nIndex := 1

    For nIndex := 1 To Len( aStack )
        If nIndex == 1
            cResult += aStack[ nIndex ] + CRLF
        Else
            cResult += Space( 30 ) + StrTran( aStack[ nIndex ], 'Called', ANSI_YELLOW + 'Called' + ANSI_RED ) + CRLF
        EndIf
    Next

    Return StrTran( cResult, 'THREAD ERROR', ANSI_YELLOW + 'THREAD ERROR' + ANSI_RED )

Method GetFeatures() Class TestSuite
    Local aMethods := ClassMethArr( ::oTester )
    Local aFeatures := {}
    Local nIndex
    For nIndex := 1 To Len( aMethods )
        If SubStr( aMethods[ nIndex, 1 ], 1, 5 ) == 'FEAT_'
            aAdd( aFeatures, Right( aMethods[ nIndex, 1 ], Len( aMethods[ nIndex, 1 ] ) - 5 ) )
        EndIf
    Next
    Return aFeatures

Method ReportError( cFeature, cDescription, nStartedAt, oError ) Class TestSuite
	aAdd( ::aErrors, { cFeature, oError:Description } )
    ::oLogger:Error( '[{1}] {2} ({3}s)', { cFeature, cDescription, Seconds() - nStartedAt } )
    ::oLogger:Error( '-------> ' + oError:Description )
    ::oLogger:Error( ::FormatStack( oError:ErrorStack ) )
	Return Self

Method ReportEnd( cFeature, cDescription, nStartedAt ) Class TestSuite
	If aScan( ::aErrors, { |aError| aError[ 1 ] == cFeature } ) == 0
        ::oLogger:Success( '[{1}] {2} ({3}s)', { cFeature, cDescription, Seconds() - nStartedAt } )
	EndIf
	Return Self

Method Run( oTester ) Class TestSuite
    Local oLogger
    Local aFeatures
	Local cTitle
	Local cClearScreen
    Local nIndex
    Local cFeatDesc
    Local nStartedAt
    Local oLastError
    Local aArea
    Local nTime := Seconds()

    ::oTester := oTester
    aFeatures := ::GetFeatures()

    cTitle := ANSI_SET_TITLE + '[' + ::cName + '] AdvPL Test Suite' + ANSI_BEL
    cClearScreen := ANSI_CLEAR_SCREEN + ANSI_MOVE_CURSOR_TO_HOME

    ConOut( cTitle )
    ConOut( cClearScreen )

    ::oLogger := Logger():New( ::cName )
    ::oLogger:Info( '[{1}] AdvPL Test Suite v0.1', { ::cName } )
    ::oLogger:Log( '> {1}, {2} feature(s)' + ANSI_SAVE, { ::cDescription, Len( aFeatures ) } )

    RpcSetEnv( oTester:cDescription_Company, oTester:cDescription_Branch )
    ConOut( ANSI_RESTORE )
    ::oLogger:Log( '> Running on {1} {2} {3}({4}s)', ;
    	{ oTester:cDescription_Company, oTester:cDescription_Branch, ANSI_YELLOW, Seconds() - nTime } )

	oLastError := ErrorBlock()
    Private oThis := Self

    aArea := GetArea()
    Begin Transaction
        For nIndex := 1 To Len( aFeatures )
            nStartedAt := Seconds()
            cFeatDesc := &( 'oThis:oTester:cDescription_Feat' + aFeatures[ nIndex ] )
            ErrorBlock( { |oError| Self:ReportError( aFeatures[ nIndex ], cFeatDesc, nStartedAt, oError ) } )
            Begin Sequence
                &( 'oThis:oTester:Feat_' + aFeatures[ nIndex ] + '()' )
            End Sequence
            Self:ReportEnd( aFeatures[ nIndex ], cFeatDesc, nStartedAt )
        Next

        DisarmTransaction()
        Break
    End Transaction
    RestArea( aArea )

    ErrorBlock( oLastError )
    ::oLogger:Info( 'Ran {1} tests, {2} failed. Took {3}s', { Len( aFeatures ), Len( ::aErrors ), Seconds() - nTime } )
    Return Self

Method Expect( xExpr ) Class TestSuite
    Local cType := ValType( xExpr )
    Return FluentExpr():New( xExpr )

Class FluentExpr
    Data xValue
    Method New( xValue ) Constructor
    Method ToHaveType( cType )
    Method ToBe( xOther )
    Method ToThrowError()
EndClass

Method New( xValue ) Class FluentExpr
    ::xValue := xValue
    Return Self

Method ToHaveType( cType ) Class FluentExpr
    Local cMyType := ValType( ::xValue )
    If cMyType != cType
        UserException( 'Expected ' + cMyType + ' to be of type ' + cType )
    EndIf
    Return Self

Method ToBe( xOther ) Class FluentExpr
    If !(::xValue == xOther)
        UserException( 'Expected ' + cValToChar( ::xValue ) + ' to be ' + cValToChar( xOther ) )
    EndIf
    Return Self

Method ToThrowError() Class FluentExpr
    Local oError
    Local bError := ErrorBlock( { |oExc| oError := oExc } )

    Begin Sequence
        Eval( ::xValue )
    End Sequence

    ErrorBlock( bError )

    If oError == Nil
        UserException( 'Expected ' + GetCBSource( ::xValue ) + ' to throw error' )
    EndIf
    Return Self
