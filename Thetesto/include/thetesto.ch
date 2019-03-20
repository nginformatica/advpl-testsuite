#xtranslate _TESTCASE( <cCase> ) => TESTCASE_<cCase>
#xtranslate _TESTCASE_DESCRIPTION( <cCase> ) => DESCRIPTION_TESTCASE_<cCase>

#xcommand TESTSUITE <cSuite> ;
    [ DESCRIPTION <cDesc> ] => ;
    _ObjNewClass( THETESTO_<cSuite>, LONGNAMECLASS ) ;;
    _ObjClassData( DESCRIPTION_NAME, String, , <(cSuite)> ) ;;
    _ObjClassData( DESCRIPTION__, String, , <cDesc> )

#xcommand ENDTESTSUITE => ;
    _ObjEndClass()

#xcommand END TESTSUITE => ;
    ENDTESTSUITE

#xcommand SKIP TESTCASE <cCase> <*rest*> => TESTCASE <cCase> SKIP <rest>
#xcommand ONLY TESTCASE <cCase> <*rest*> => TESTCASE <cCase> ONLY <rest>

#xcommand TESTCASE <cCase>     ;
    [ DESCRIPTION <cDesc> ]    ;
    [ <mode: SKIP, ONLY>  ]    ;
    [ TIMEOUT <nTimeOut>  ] => ;
    _ObjClassMethod( _TESTCASE( <cCase> ), , ) ;;
    _ObjClassData( _TESTCASE_DESCRIPTION( MARKER_<cCase> ), String, , <(cCase)> ) ;;
    _ObjClassData( _TESTCASE_DESCRIPTION( <cCase>_NAME ), String, , <(cCase)> ) ;;
    _ObjClassData( _TESTCASE_DESCRIPTION( <cCase> ), String, , <(cDesc)> ) ;;
    _ObjClassData( _TESTCASE_DESCRIPTION( <cCase>_MODE ), String, , <(mode)> ) ;;
    _ObjClassData( _TESTCASE_DESCRIPTION( <cCase>_TIMEOUT ), Integer, , <(nTimeOut)> )

#xcommand TESTCASE <cCase> TESTSUITE <cSuite> => ;
    Function ___THETESTO_<cSuite>____TESTCASE_<cCase>()

#xcommand ENDTESTCASE => ;
    Return

#xcommand END TESTCASE => ;
    ENDTESTCASE
