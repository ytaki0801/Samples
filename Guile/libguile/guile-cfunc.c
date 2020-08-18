#include <stdio.h>
#include <libguile.h>

#define APPINITSCM ".appinit.scm"

SCM cfib(SCM var)
{
  int f1 = 0, f2 = 1, t;
  for (int n = scm_to_int(var); n > 0; n--) {
    t = f1; f1 = f2; f2 = t + f2;
  }
  return (scm_from_int(f1));
}

int main(int argc, char **argv)
{
  scm_init_guile();

  scm_c_define_gsubr("cfib", 1, 0, 0, cfib);

  char appinitfile[128];
  sprintf(appinitfile, "%s%s%s", getenv("HOME"), "/", APPINITSCM);
  scm_c_primitive_load(appinitfile);
 
  SCM proc = scm_variable_ref(scm_c_lookup("cfib-itr"));
  SCM eRet = scm_call_1(proc, scm_from_int(10));

  printf("%s\n", scm_to_latin1_string(eRet));
 
  return (0);
}
