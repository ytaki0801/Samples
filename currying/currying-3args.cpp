#include <iostream>
using namespace std;

int func1(int x, int y, int z) { if (x > 0) return y; else return z; }

auto func2(int x) {
  return [x] (int y) {
    return [x,y] (int z) {
      if (x > 0) return y; else return z;
    };
  };
}

int main(void)
{
  cout << func1(-100,0,-1)   << endl;    // => -1
  cout << func2(-100)(0)(-1) << endl;    // => -1
  return (0);
}

