def func1(x,y,z) x > 0 ? y : z end
p func1(-100,0,-1)              # => -1

func2 = -> x,y,z { x > 0 ? y : z }
p func2.curry.(-100).(0).(-1)    # => -1
p func2.curry[-100][0][-1]       # => -1

func3 = -> x { ->  y { -> z { x > 0 ? y : z } } }
p func3.(-100).(0).(-1)          # => -1
p func3[-100][0][-1]             # => -1
