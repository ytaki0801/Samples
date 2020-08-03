<?php

// for PHP 7.3
function fix73($f) {
    return $f(function($x) use ($f) { return fix73($f)($x); });
};
echo fix73(
       function($g) {
         return function($f1) use ($g) {
           return function($f2) use ($f1,$g) {
             return function($n) use ($f2,$f1,$g) {
               return $n == 0 ? $f1 : $g($f2)($f1+$f2)($n-1);
             };
           };
         };
       }
     )(0)(1)(40) . PHP_EOL;
// => 102334155
foreach(array_map(
  fix73(
    function($g) {
      return function($f1) use ($g) {
        return function($f2) use ($f1,$g) {
          return function($n) use ($f2,$f1,$g) {
            return $n == 0 ? $f1 : $g($f2)($f1+$f2)($n-1);
          };
        };
      };
    }
  )(0)(1), range(0,10)) as $v) { print($v); echo ' '; } echo "\n";
// => 0 1 1 2 3 5 8 13 21 34 55
foreach(array_map(
  fix73(
    function($g) {
      return function($f1) use ($g) {
        return function($f2) use ($f1,$g) {
          return function($n) use ($f2,$f1,$g) {
            return $n == 0 ? $f1 : $g($f2)($f1+$f2)($n-1);
          };
        };
      };
    }
  )(0)(1), range(0,50,10)) as $v) { print($v); echo ' '; } echo "\n";
// => 0 55 6765 832040 102334155 12586269025

// for PHP 7.4
function fix74($f) { return $f( fn($x) => fix74($f)($x)); }
echo fix74(fn($g) => fn($f1) => fn($f2) => fn($n) => $n == 0 ? $f1 : $g($f2)($f1+$f2)($n-1))(0)(1)(40) . PHP_EOL;
// => 102334155
foreach(array_map(fix74(fn($g) => fn($f1) => fn($f2) => fn($n) => $n == 0 ? $f1 : $g($f2)($f1+$f2)($n-1))(0)(1), range(0,10)) as $v) { print($v); echo ' '; } echo "\n";
// => 0 1 1 2 3 5 8 13 21 34 55
foreach(array_map(fix74(fn($g) => fn($f1) => fn($f2) => fn($n) => $n == 0 ? $f1 : $g($f2)($f1+$f2)($n-1))(0)(1), range(0,50,10)) as $v) { print($v); echo ' '; } echo "\n";
// => 0 55 6765 832040 102334155 12586269025
