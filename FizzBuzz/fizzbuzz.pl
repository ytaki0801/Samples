fb(X,'FizzBuzz') :- X mod 15 =:= 0, !.
fb(X,'Fizz')     :- X mod  3 =:= 0, !.
fb(X,'Buzz')     :- X mod  5 =:= 0, !.
fb(X,X).
fizzbuzz(N) :- between(1,N,X), fb(X,R), write(R), write(' '), fail.

% ?- fizzbuzz(100).
