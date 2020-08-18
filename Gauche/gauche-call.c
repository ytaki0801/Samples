#include <stdio.h>
#include <gauche.h>

#define APPINITSCM "~/.appinit.scm"

int main(int argc, char **argv)
{
  GC_INIT(); 
  Scm_Init(GAUCHE_SIGNATURE);

  ScmLoadPacket lRet;
  if (Scm_Load(APPINITSCM, 0, &lRet) < 0) {
    printf("There is no %s.\n", APPINITSCM);
    return (1);
  }

  int x = 40;
  if (argc == 2) x = atoi(argv[1]);

  ScmEvalPacket eRet;
  static ScmObj proc = SCM_UNDEFINED;
  SCM_BIND_PROC(proc, "fib", Scm_UserModule());
  ScmObj args = SCM_LIST3(SCM_MAKE_INT(x),SCM_MAKE_INT(0),SCM_MAKE_INT(1));
  if (Scm_Apply(proc, args, &eRet) < 0) {    // (apply fib '(40 0 1))
    printf("Error in S expression\n");
    return (1);
  }
  printf("fib(%d) = %ld\n", x, SCM_INT_VALUE(eRet.results[0]));

  Scm_Exit(0); 

  return(0);
}
