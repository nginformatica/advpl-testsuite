#include 'protheus.ch'
#include 'testsuite.ch'
#Include 'FWMVCDef.ch'

TestSuite MVC Description 'MVC Examples' Verbose
    Enable Environment '99' '01'
    Feature Create Description 'Create a new specialty'
    Feature Duplicate Description 'Try duplicate a new specialty'
EndTestSuite

Feature Create TestSuite MVC

    Local oModel := FWLoadModel( 'MNTA010' )
    oModel:SetOperation( MODEL_OPERATION_INSERT )
    oModel:Activate()

    ::Expect( oModel:SetValue( 'MNTA010_ST0', 'T0_ESPECIA', '888' ) ):ToBe( .T. )
    ::Expect( oModel:SetValue( 'MNTA010_ST0', 'T0_NOME', 'TESTSUITE DESCRIPTION' ) ):ToBe( .T. )
    ::Expect( oModel:VldData() ):ToBe( .T. )
    ::Expect( oModel:GetErrorMessage() ):ToBe( { 'MNTA010', 'POST', , , , , , , } )

    oModel:CommitData()
    oModel:DeActivate()

Return

Feature Duplicate TestSuite MVC

    Local oModel := FWLoadModel( 'MNTA010' )
    oModel:SetOperation( MODEL_OPERATION_INSERT )
    oModel:Activate()

    ::Expect( oModel:SetValue( 'MNTA010_ST0', 'T0_ESPECIA', '888' ) ):ToBe( .F. )
    ::Expect( oModel:SetValue( 'MNTA010_ST0', 'T0_NOME', 'TESTSUITE DESCRIPTION' ) ):ToBe( .T. )
    ::Expect( oModel:VldData() ):ToBe( .F. )
    ::Expect( oModel:GetErrorMessage() ):Not():ToBe( { 'MNTA010', 'POST', , , , , , , } )

    oModel:DeActivate()

Return

CompileTestSuite MVC