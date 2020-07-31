sub g {
  my $f = shift;
  return $f->( sub { my $y = shift; return g($f)->($y); })
};

print g( sub { my $fib = shift; return sub { my $n = shift; return sub { my $o = shift; return sub { my $p = shift; return $n == 0 ? $o : $fib->($n - 1)->($p)->($o + $p); }; }; }; })->(50)->(0)->(1), "\n";
@r = map { g( sub { my $fib = shift; return sub { my $n = shift; return sub { my $o = shift; return sub { my $p = shift; return $n == 0 ? $o : $fib->($n - 1)->($p)->($o + $p); }; }; }; })->($_)->(0)->(1) } (0..10);
print "@r ", "\n";
@r = map { g( sub { my $fib = shift; return sub { my $n = shift; return sub { my $o = shift; return sub { my $p = shift; return $n == 0 ? $o : $fib->($n - 1)->($p)->($o + $p); }; }; }; })->($_)->(0)->(1) } (0,10,20,30,40,50);
print "@r ", "\n";
