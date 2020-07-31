package main
import "fmt"

type INT int // int, uint, int64 or uint64 for factorial
type IR func(IR) func(INT) INT

func main() {
    // Z combinator
    var Z = func(f func(func(INT) INT) func(INT) INT) func(INT) INT {
        return func(g func(IR) func(INT) INT) func(INT) INT {
            return g(g)
                }(func(g IR) func(INT) INT {
                    return f(func(x INT) INT {
                        return (g(g))(x)
                    })
                })
        }
    var rz = Z(func(f func(INT) INT) func(INT) INT { return func(n INT) INT { if n == 0 { return 1 } else { return n * f(n-1) } } })(5)
    fmt.Println(rz)
}
