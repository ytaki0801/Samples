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

void init_cfib() {
  scm_c_define_gsubr("cfib", 1, 0, 0, cfib);
}
