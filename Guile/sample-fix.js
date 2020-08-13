function fix(f) { return f(function(x) { return fix(f)(x); }); };

display(fix(function(fib) { function(f1) { function(f2) { function(n) { n == 0 ? f1 : fib(f2)(f1+f2)(n-1); }; }; }; })(0)(1)(40));
newline();
// => 102334155
display(map(fix(function(fib) { function(f1) { function(f2) { function(n) { n == 0 ? f1 : fib(f2)(f1+f2)(n-1); }; }; }; })(0)(1), iota(11)));
// => (0 1 1 2 3 5 8 13 21 34 55)
display(map(fix(function(fib) { function(f1) { function(f2) { function(n) { n == 0 ? f1 : fib(f2)(f1+f2)(n-1); }; }; }; })(0)(1), iota(6,0,10)));
// => (0 55 6765 832040 102334155 12586269025)
