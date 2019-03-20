#include 'protheus.ch'

User Function Satanas()
  Local i
  for i := a() to b() step c()
    ConOut("body")
   next
Return

stat func a()
 ConOut("from")
 retu 1
stat func b()
 ConOut("to")
 retu 5
stat func c()
 ConOut("step")
 retu 1
