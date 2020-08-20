#define PY_SSIZE_T_CLEAN
#include <Python.h>

/* Python用関数の定義 */
PyObject* cfib(PyObject* self, PyObject* args)
{
  int n;
  if (!PyArg_ParseTuple(args, "i", &n)) return NULL;

  int f1 = 0, f2 = 1, t;
  for (; n > 0; n--) { t = f1; f1 = f2; f2 = t + f2; }
  return Py_BuildValue("i", f1);
}

/* モジュール用メソッド一覧の定義 */
static PyMethodDef cfibMethods[] = {
  {"cfib", cfib, METH_VARARGS, "fib C version"},
  {NULL,   NULL, 0,            NULL}
};

/* モジュールの定義 */
static struct PyModuleDef cfibModule = {
  PyModuleDef_HEAD_INIT, "cfib", NULL, -1, cfibMethods
};

/* モジュール初期化の定義 */
PyMODINIT_FUNC PyInit_cfib(void) {
  return PyModule_Create(&cfibModule);
}

/* ユーザ設定ファイルを模したファイル */
#define APPINITPY ".appinit.py"

int main(int argc, char *argv[])
{
  /* 定義した関数をPythonから利用できるようにする設定その1 */
  if (PyImport_AppendInittab("cfib", &PyInit_cfib) == -1) {
    printf("module init error\n"); exit(1);
  }

  /* Python処理系の初期化 */
  Py_Initialize();

  /* ホームディレクトリにあるAPPINITPYの読み込み */
  char filename[256];
  sprintf(filename, "%s%s%s", getenv("HOME"), "/", APPINITPY);
  FILE *ifile = _Py_fopen_obj(Py_BuildValue("s", filename), "r+");
  if (ifile == NULL)  { printf("file open error\n"); exit(1); }
  PyRun_SimpleFileEx(ifile, filename, 1);

  /* トップレベルの実行環境モジュールを取得 */
  PyObject* mmod = PyImport_AddModule("__main__");

  /* 定義した関数をPythonから利用できるようにする設定その2 */
  PyObject *mcfib = PyImport_ImportModule("cfib");
  if (!mcfib) { printf("module import error\n"); exit(1); }
  PyObject_SetAttrString(mmod, "cfib", mcfib);
  Py_DECREF(mcfib);

  /* 実行するPythonの関数定義の指定 */
  PyObject *proc = PyObject_GetAttrString(mmod, "cfib_itr");
  if (proc == NULL) { printf("func attr error\n"); exit(1);; }

  /* Pythonの関数を整数の引数で実行し，実行結果をPythonオブジェクトで取得 */
  PyObject *args = PyTuple_New(1);
  PyTuple_SetItem(args, 0, PyLong_FromLong(10));
  PyObject *eRet = PyObject_CallObject(proc, args);
  Py_DECREF(proc);
  Py_DECREF(args);
  if (eRet == NULL) { PyErr_Print(); printf("exec error\n"); exit(1); }

  /* 戻り値をリスト構造とみなして参照し，各要素を表示 */
  for (int i = 0; i < (int)PyList_Size(eRet); i++)
    printf("%ld ", PyLong_AsLong(PyList_GetItem(eRet, i)));
  printf("\n");
  Py_DECREF(eRet);

  Py_XDECREF(mmod);

  Py_FinalizeEx();

  return (0);
}
