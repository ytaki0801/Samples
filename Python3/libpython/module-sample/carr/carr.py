# -*-encode: utf-8-*-
import time
from carr import carr

if __name__ == "__main__":
    start_t = time.time()

    arr_a = [i for i in range(1000)]
    arr_b = [i for i in range(1000)]

    res = carr(arr_a, arr_b, len(arr_a), len(arr_b))
    print(res)

    all_time = time.time() - start_t
    print("Execution time:{0} [sec]".format(all_time))

