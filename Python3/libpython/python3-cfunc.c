#define PY_SSIZE_T_CLEAN
#include <Python.h>

static PyObject* cfib_func(PyObject* self, PyObject* args)
{
  int n;
  if (!PyArg_ParseTuple(args, "i", &n)) return NULL;

  int f1 = 0, f2 = 1, t;
  for (; n > 0; n--) { t = f1; f1 = f2; f2 = t + f2; }
  return Py_BuildValue("i", f1);
}

static PyMethodDef cfibMethods[] = {
  {"cfib", cfib_func, METH_VARARGS, "fib C version"},
  {NULL,   NULL, 0,            NULL}
};

static PyModuleDef cfibModule = {
  PyModuleDef_HEAD_INIT, "cfib", NULL, -1, cfibMethods,
  NULL, NULL, NULL, NULL
};

static PyObject* PyInit_cfib(void) {
  return PyModule_Create(&cfibModule);
}

#define APPINITPY ".appinit.py"

int main(int argc, char *argv[])
{
  if (PyImport_AppendInittab("cfib", &PyInit_cfib) == -1) {
    printf("module init error\n"); exit(1);
  }

  Py_SetProgramName((wchar_t *)argv[0]);
  Py_Initialize();

  char filename[256];
  sprintf(filename, "%s%s%s", getenv("HOME"), "/", APPINITPY);
  FILE *ifile = _Py_fopen_obj(Py_BuildValue("s", filename), "r+");
  if (ifile == NULL)  { printf("file open error\n"); exit(1); }
  PyRun_SimpleFileEx(ifile, filename, 1);

  PyObject* mmod = PyImport_AddModule("__main__");

  PyObject *mcfib = PyImport_ImportModule("cfib");
  if (!mcfib) { printf("module import error\n"); exit(1); }
  PyObject_SetAttrString(mmod, "cfib", mcfib);
  Py_DECREF(mcfib);

  PyObject *proc = PyObject_GetAttrString(mmod, "cfib_itr");
  if (proc == NULL) { printf("func attr error\n"); exit(1);; }

  PyObject *args = PyTuple_New(1);
  PyTuple_SetItem(args, 0, PyLong_FromLong(10));
  PyObject *eRet = PyObject_CallObject(proc, args);
  Py_DECREF(proc);
  Py_DECREF(args);
  if (eRet == NULL) { PyErr_Print(); printf("exec error\n"); exit(1); }

  for (int i = 0; i < (int)PyList_Size(eRet); i++)
    printf("%ld ", PyLong_AsLong(PyList_GetItem(eRet, i)));
  printf("\n");
  Py_DECREF(eRet);

  Py_XDECREF(mmod);

  Py_FinalizeEx();

  return (0);
}
