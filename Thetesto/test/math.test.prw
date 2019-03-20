#include 'protheus.ch'
#include 'thetesto.ch'

TestSuite Math Description "mathematical operations"
    TestCase SumAssociativity Description "(+) is associative" TimeOut 50
    TestCase SumCommutativity Description "(+) is commutative"
    Skip TestCase SumBijectivity Description "(+) is bijective over (-)"
EndTestSuite

TestCase SumAssociativity TestSuite Math
    Local cOne := FluentExpr():New(1)
    cOne:ToBe( 2 )
EndTestCase

TestCase SumCommutativity TestSuite Math
EndTestCase

TestCase SumBijectivity TestSuite Math
EndTestCase
