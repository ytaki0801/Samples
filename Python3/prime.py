def prime(x):
    i = 2
    while i < x / 2 + 1:
        if x % i == 0:
            return(False)
        i = i + 1
    return(True)

x = int(input("x = ? "))
for i in range(1,x):
    if prime(i+1):
        print(i+1, end=" ")
print()
