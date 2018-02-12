#xcommand TestSuite <cName> ;
    [ <description: Description> <cDesc> ] ;
    [ <verbose: Verbose> ] ;
    => ;
    Static __NAME__ := <(cName)> ;;
    Static __DESC__ := <cDesc> ;;
    Static __VERBOSE__ := <.verbose.> ;;
    _ObjNewClass( TestSuite_<cName>, TestSuite ) ;;
    _ObjClassMethod( New, ( cName, cDescription ), ) ;;
    _ObjClassData( cDescription, String, , <cDesc> ) ;;
    _ObjClassData( cName, String, , <(cName)> )

#xcommand EndTestSuite => _ObjEndClass()

#xcommand Feature <cFeat> ;
    [ <description: Description> <cDesc> ] ;
    => ;
    _ObjClassMethod( Feat_<cFeat>, , ) ;;
    _ObjClassData( cDescription_Feat<cFeat>, String, , <cDesc> )

#xcommand Environment <cCompany> <cBranch> ;
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
        _Super:New( cName, cDescription ) ;;
        Return Self ;;
    Function U_<cSuite> ;;
        Local oTester := TestSuite_<cSuite>():New( __NAME__, __DESC__ ) ;;
        oTester:lVerbose := __VERBOSE__ ;;
        oTester:Run( oTester ) ;;
        Return 0
