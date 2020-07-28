{-
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
