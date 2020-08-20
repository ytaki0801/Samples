#include <stdio.h>
#include <libguile.h>

SCM cfib(SCM args)
{
  int n  = scm_to_int(scm_list_ref(args, scm_from_int(0)));
  int f1 = scm_to_int(scm_list_ref(args, scm_from_int(1)));
  int f2 = scm_to_int(scm_list_ref(args, scm_from_int(2)));

  int t; for (; n > 0; n--) { t = f1; f1 = f2; f2 = t + f2; }

  SCM ret = scm_list_3(scm_from_int(f1),
                       scm_from_latin1_string("clib"),
                       scm_from_latin1_string("result"));
  return (ret);
}

int main(int argc, char **argv)
{
  scm_init_guile();

  scm_c_define_gsubr("cfib", 1, 0, 0, cfib);

  scm_c_eval_string("(display (cfib '(10 0 1))) (newline)");
 
  return (0);
}
