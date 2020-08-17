#include <stdio.h>
#include <gauche.h>

#define APPINITSCM "~/.appinit.scm"
#define S_NAME     "(cadr (assq 'name    *my-profile*))"
#define S_TWITTER  "(cadr (assq 'twitter *my-profile*))"

const char* getScmString(ScmObj *obj)
{
  ScmObj sStr, oPort = Scm_MakeOutputStringPort(TRUE);
  Scm_Printf(SCM_PORT(oPort), "%S", obj);
  sStr = Scm_GetOutputString(SCM_PORT(oPort), 0);
  return Scm_GetStringConst(SCM_STRING(sStr));
}

int main(int argc, char **argv)
{
  GC_INIT(); 
  Scm_Init(GAUCHE_SIGNATURE);

  ScmLoadPacket lRet;
  if(Scm_Load(APPINITSCM, 0, &lRet) < 0) {
    printf("There is no %s.\n", APPINITSCM);
    return (1);
  }

  ScmEvalPacket eRet;

  if (Scm_EvalCString(S_NAME, SCM_NIL, &eRet))
    printf("Name: %s\n", getScmString((ScmObj *)eRet.results[0]));
  if (Scm_EvalCString(S_TWITTER, SCM_NIL, &eRet))
    printf("Twitter: %s\n", getScmString((ScmObj *)eRet.results[0]));

  Scm_Exit(0); 

  return(0);
}
