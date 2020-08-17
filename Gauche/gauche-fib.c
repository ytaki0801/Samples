#include <stdio.h>
#include <gauche.h>

#define FIB "(let ((n (read))) (map (lambda (x) (let f ((i x) (f1 0) (f2 1)) (if (= i 0) f1 (f (- i 1) f2 (+ f1 f2))))) n))"

int main(int argc, char **argv)
{
  GC_INIT(); 
  Scm_Init(GAUCHE_SIGNATURE);

  ScmEvalPacket eRet;
  if (Scm_EvalCString(FIB, SCM_NIL, &eRet) < 0) {
    printf("Error in S expression\n"); return (1);
  }
  Scm_Printf(SCM_CUROUT, "%S\n", eRet.results[0]);

  Scm_Exit(0); 

  return(0);
}
