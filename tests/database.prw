#include 'protheus.ch'
#include 'testsuite.ch'

TestSuite DataBase Description 'Database restoration and transaction tests' Verbose
    Enable Environment 'T3' 'S SC 01'
    Data cFile As Character
    Feature CreateTable Description 'We can create a new table'
    Feature DeleteTable Description 'We can delete a table'
EndTestSuite

Feature CreateTable TestSuite DataBase
    Local aStruct := { ;
        { 'CODE', 'N', 3, 0 }, ;
        { 'LANGUAGE', 'C', 20, 0 }, ;
        { 'PARADIGM', 'C', 20, 0 }, ;
        { 'DESCRIPT', 'C', 100, 0 } ;
    }

    ::cFile := '\programming.dbf'
    dbCreate( ::cFile, aStruct )
    ::Expect( ::cFile ):ToBeAFile()
    dbUseArea( .F., Nil, ::cFile, 'LNG' )
    Return

Feature DeleteTable TestSuite DataBase
	LNG->( dbCloseArea() )
	::Expect( Select( 'LNG' ) ):ToBe( 0 )
	::Expect( ::cFile ):ToBeAFile()
	FErase( ::cFile )
	Return

CompileTestSuite DataBase