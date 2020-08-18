#include <stdio.h>
#include <libguile.h>

#define APPINITSCM ".appinit.scm"

int main(int argc, char **argv)
{
  scm_init_guile();

  char appinitfile[128];
  sprintf(appinitfile, "%s%s%s", getenv("HOME"), "/", APPINITSCM);
  scm_c_primitive_load(appinitfile);
 
  SCM proc = scm_variable_ref(scm_c_lookup("fib"));
  SCM eRet = scm_call_3(proc, scm_from_int(40), scm_from_int(0), scm_from_int(1));

  printf("%d\n", scm_to_int(eRet));
 
  return (0);
}
