sub fix {
  my $f = shift;
  return $f->( sub { my $x = shift; return fix($f)->($x); })
};

print fix( sub { my $fib = shift; return sub { my $o = shift; return sub { my $p = shift; return sub { my $n = shift; return $n == 0 ? $o : $fib->($p)->($o + $p)->($n - 1); }; }; }; })->(0)->(1)->(40), "\n";
# => 102334155
@r = map { fix( sub { my $fib = shift; return sub { my $o = shift; return sub { my $p = shift; return sub { my $n = shift; return $n == 0 ? $o : $fib->($p)->($o + $p)->($n - 1); }; }; }; })->(0)->(1)->($_) } (0..10);
print "@r ", "\n";    # => 0 1 1 2 3 5 8 13 21 34 55
@r = map { fix( sub { my $fib = shift; return sub { my $o = shift; return sub { my $p = shift; return sub { my $n = shift; return $n == 0 ? $o : $fib->($p)->($o + $p)->($n - 1); }; }; }; })->(0)->(1)->($_) } (0,10,20,30,40,50);
print "@r ", "\n";    # => 0 55 6765 832040 102334155 12586269025
