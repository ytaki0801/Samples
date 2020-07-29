{-
-- Using ghci
-- \x -> x
Prelude> (\x -> x) 10
10
Prelude> (\y -> y) 10
10
Prelude> (\x -> \y -> x + y) 10 20
30
Prelude> (\z -> \y -> z + y) 10 20
30
Prelude> (\y -> \y -> y + y) 10 20
40
Prelude> (\f -> \x -> (f x) * 2) (\y -> y + 1) 10
22
Prelude> (\x -> (x + 1) * 2) 10
22
Prelude> inc y = y + 1
Prelude> (\f -> \x -> (f x) * 2) inc 10
22
Prelude> inc_ret = \y -> y + 1
Prelude> inc = inc_ret
Prelude> fnc_ret f = \x -> (f x) * 2
Prelude> fnc = fnc_ret inc
Prelude> fnc 10
22
-}

-- Using runghc
main = do

-- Church booleans
let gt a b = if a > b then \x -> \y -> x else \x -> \y -> y
print(gt 20 10 True False)    -- => True
print(gt 10 20 True False)    -- => False
let a = 10
let b = 20
print(gt a b "a>b" "a<=b")    -- => "a<=b"
let a = 20
let b = 10
print(gt a b "a>b" "a<=b")    -- => "a>b"

-- Church numerals
let zero  f = \x -> x
let one   f = \x -> f x
let two   f = \x -> f (f x)
let three f = \x -> f (f (f x))
let four  f = \x -> f (f (f (f x)))
let toINT ch = ch (\x -> x + 1) 0
print(toINT zero)     -- => 0
print(toINT one)      -- => 1
print(toINT two)      -- => 2
print(toINT three)    -- => 3
print(toINT four)     -- => 4
let chINC ch = \f -> \x -> f (ch f x)
print(toINT (chINC two))      -- => 3
print(toINT (chINC one))      -- => 2
print(toINT (chINC three))    -- => 4
let chADD ch = \ch1 -> ch1 chINC ch
print(toINT (chADD one three))    -- => 1 + 3 = 4
print(toINT (chADD four zero))    -- => 4 + 0 = 4
print(toINT (chADD three two))    -- => 3 + 2 = 5
let chDEC ch = \f -> \x -> ch (\g -> \h -> h (g f)) (\u -> x) (\u -> u)
print(toINT (chDEC three))    -- => 2
print(toINT (chDEC one))      -- => 0
print(toINT (chDEC four))     -- => 3
let chSUB ch = \ch1 -> ch1 chDEC ch
print(toINT (chSUB three one))    -- => 3 - 1 = 2
print(toINT (chSUB four one))     -- => 4 - 1 = 3
-- "Occurs check: cannot construct the infinite type:" for "two", "three" and "four"
-- print(toINT (chSUB four two))   
-- print(toINT (chSUB four three))
-- print(toINT (chSUB four four))
let chMUL ch = \ch1 -> \f -> ch1 (ch f)
print(toINT (chMUL two three))     -- => 2 * 3 = 6
print(toINT (chMUL four three))    -- => 4 * 3 = 12
let chPOW ch = \ch1 -> ch1 ch
print(toINT (chPOW two three))    -- => 2^3 = 8
print(toINT (chPOW two four))     -- => 2^4 = 16
print(toINT (chPOW one four))     -- => 1^4 = 1

-- fixed point combinator
let g f = f (g f)
print(g (\fact -> \n -> if n == 0 then 1 else n * fact (n-1)) 5)
-- => 120
print(g (\fib -> \x -> \f1 -> \f2 -> if x == 0 then f1 else fib (x-1) f2 (f1+f2)) 40 0 1)
-- => 102334155
