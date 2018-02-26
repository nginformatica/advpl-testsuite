#ifndef _TESTSUITE_CH
#define _TESTSUITE_CH

#xcommand TestSuite <cName> ;
    [ <description: Description> <cDesc> ] ;
    [ <verbose: Verbose> ] ;
    => ;
    Static __NAME__ := <(cName)> ;;
    Static __DESC__ := <cDesc> ;;
    Static __VERBOSE__ := <.verbose.> ;;
    _ObjNewClass( TestSuite_<cName>, LongNameClass ) ;;
    _ObjClassMethod( New, ( cName, cDescription ), ) ;;
    _ObjClassMethod( Expect, ( xExpr ), ) ;;
    _ObjClassData( cDescription, String, , <cDesc> ) ;;
    _ObjClassData( cName, String, , <(cName)> ) ;;
    _ObjClassData( oParent, String, ,  )

#xcommand EndTestSuite => _ObjEndClass()

#xcommand Feature <cFeat> ;
    [ <description: Description> <cDesc> ] ;
    => ;
    _ObjClassMethod( Feat_<cFeat>, , ) ;;
    _ObjClassData( cDescription_Feat<cFeat>, String, , <cDesc> )

#xcommand Enable Before ;
    => ;
    _ObjClassMethod( Before, , )

#xcommand Before TestSuite <cSuite> ;
    => ;
    Function ___TestSuite_<cSuite>____Before()

#xcommand Enable Environment <cCompany> <cBranch> ;
    => ;
    _ObjClassData( cDescription_Company, String, , <cCompany> ) ;;
    _ObjClassData( cDescription_Branch, String, , <cBranch> )

#xcommand Feature <cFeat> ;
    TestSuite <cSuite> ;
    => ;
    Function ___TestSuite_<cSuite>____Feat_<cFeat>()

#xcommand CompileTestSuite <cSuite> ;
    => ;
    Function ___TestSuite_<cSuite>____New( cName, cDescription ) ;;
        Self:oParent := TestSuite():New( cName, cDescription ) ;;
        Return Self ;;
    Function ___TestSuite_<cSuite>____Expect( xExpr ) ;;
        Return FluentExpr():New( xExpr ) ;;
    Function U_<cSuite> ;;
        Local oTester := TestSuite_<cSuite>():New( __NAME__, __DESC__ ) ;;
        oTester:oParent:lVerbose := __VERBOSE__ ;;
        oTester:oParent:Run( oTester ) ;;
        Return 0

#include 'fileio.ch'

Static Function ReadFileContents( cFileName )
    Local nHandler := FOpen( cFileName, FO_READWRITE + FO_SHARED )
    Local nSize    := 0
    Local xBuffer  := ''

    If -1 == nHandler
        Return Nil
    EndIf

    nSize := FSeek( nHandler, 0, FS_END )
    FSeek( nHandler, 0 )
    FRead( nHandler, xBuffer, nSize )
    FClose( nHandler )
    Return xBuffer

#endif // _TESTSUITE_CH