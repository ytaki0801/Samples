#include <Python.h>

PyObject* carr(PyObject* self, PyObject* args)
{
  PyObject *arr_a, *arr_b;
  int size_a, size_b;
  if (!PyArg_ParseTuple(args, "O!O!ii", &PyList_Type, &arr_a, &PyList_Type, &arr_b, &size_a, &size_b)) return NULL;

  int res = 0;
  for(int i=0; i < size_a; i++){
    for(int j=0; j < size_b; j++){
      res = res
        +PyLong_AsLong(PyList_GetItem(arr_a,i))
        +PyLong_AsLong(PyList_GetItem(arr_b,j));
    }
  }

  return Py_BuildValue("i", res);
}

static PyMethodDef carrMethods[] = {
  {"carr", carr, METH_VARARGS, "arr C version"},
  {NULL,   NULL, 0,            NULL}
};

static struct PyModuleDef carrModule = {
  PyModuleDef_HEAD_INIT, "carr", NULL, -1, carrMethods
};

PyMODINIT_FUNC PyInit_carr(void) {
  return PyModule_Create(&carrModule);
}

