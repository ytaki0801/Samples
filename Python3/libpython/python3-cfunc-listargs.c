#define PY_SSIZE_T_CLEAN
#include <Python.h>

PyObject* cfib(PyObject* self, PyObject* args)
{
  PyObject *listargs;
  if (!PyArg_ParseTuple(args, "O!", &PyList_Type, &listargs)) return NULL;
  int n  = PyLong_AsLong(PyList_GetItem(listargs, 0));
  int f1 = PyLong_AsLong(PyList_GetItem(listargs, 1));
  int f2 = PyLong_AsLong(PyList_GetItem(listargs, 2));

  int t; for (; n > 0; n--) { t = f1; f1 = f2; f2 = t + f2; }

  PyObject *retPy = PyList_New(3);
  PyList_SET_ITEM(retPy, 0, PyLong_FromLong(f1));
  PyList_SET_ITEM(retPy, 1, PyUnicode_FromString("clib"));
  PyList_SET_ITEM(retPy, 2, PyUnicode_FromString("result"));

  return Py_BuildValue("O", retPy);
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

int main(int argc, char *argv[])
{
  if (PyImport_AppendInittab("cfib", &PyInit_cfib) == -1) {
    printf("module init error\n"); exit(1);
  }

  Py_Initialize();

  PyObject* mmod = PyImport_AddModule("__main__");

  PyObject *mcfib = PyImport_ImportModule("cfib");
  if (!mcfib) { printf("module import error\n"); exit(1); }
  PyObject_SetAttrString(mmod, "cfib", mcfib);
  Py_DECREF(mcfib);

  PyRun_SimpleString("print(cfib.cfib([10,0,1]))");

  Py_XDECREF(mmod);

  Py_FinalizeEx();

  return (0);
}
