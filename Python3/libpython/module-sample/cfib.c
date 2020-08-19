#include <Python.h>

PyObject* cfib(PyObject* self, PyObject* args)
{
  int n;
  if (!PyArg_ParseTuple(args, "i", &n)) return NULL;

  int f1 = 0, f2 = 1, t;
  for (; n > 0; n--) { t = f1; f1 = f2; f2 = t + f2; }
  return Py_BuildValue("i", f1);
}

static PyMethodDef cfibMethods[] = {
  {"cfib", cfib, METH_VARARGS, "fib C version"},
  {NULL,   NULL, 0,            NULL}
};

static struct PyModuleDef cfibModule = {
  PyModuleDef_HEAD_INIT, "cfib", NULL, -1, cfibMethods
};

PyMODINIT_FUNC PyInit_cfib(void) {
  return PyModule_Create(&cfibModule);
}

