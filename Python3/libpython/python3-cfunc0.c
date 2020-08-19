#define PY_SSIZE_T_CLEAN
#include <Python.h>

#define APPINITPY "appinit"

int main(int argc, char *argv[])
{
  Py_SetProgramName((wchar_t *)argv[0]);
  Py_Initialize();

  PyObject *msys = PyImport_ImportModule("sys");
  PyObject *mpath = PyObject_GetAttrString(msys, "path");
  PyList_Append(mpath, PyUnicode_FromString(getenv("HOME")));
  Py_DECREF(msys);
  Py_DECREF(mpath);

  PyObject *iname = PyUnicode_FromString(APPINITPY);
  PyObject *imod  = PyImport_Import(iname);
  Py_DECREF(iname);
  if (imod == NULL) { printf("file error\n"); exit(1); }

  PyObject *proc = PyObject_GetAttrString(imod, "fib_itr");
  Py_DECREF(imod);
  if (proc == NULL) { printf("func error\n"); exit(1);; }

  PyObject *args = PyTuple_New(1);
  PyTuple_SetItem(args, 0, PyLong_FromLong(10));
  PyObject *eRet = PyObject_CallObject(proc, args);
  Py_DECREF(proc);
  Py_DECREF(args);
  if (eRet == NULL) { printf("exec error\n"); exit(1); }

  for (int i = 0; i < (int)PyList_Size(eRet); i++)
    printf("%ld ", PyLong_AsLong(PyList_GetItem(eRet, i)));
  printf("\n");
  Py_DECREF(eRet);

  Py_FinalizeEx();

  return (0);
}
