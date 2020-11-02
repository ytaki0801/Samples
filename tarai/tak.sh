#!/bin/sh

stackpush () {
  eval STACK$STACKNUM=$1
  STACKNUM=$((STACKNUM+1))
}

stackpop ()
{
  STACKNUM=$((STACKNUM-1))
  eval STACKPOPR="\$STACK$STACKNUM"
}

tak () {
  if [ $1 -le $2 ]; then
    TAKR=$3
  else
    x=$1
    y=$2
    z=$3
    x1=$((x-1))
    y1=$((y-1))
    z1=$((z-1))
    stackpush $z1
    stackpush $y1
    tak $x1 $2 $3
    r1=$TAKR
    stackpop && y1=$STACKPOPR
    stackpush $r1
    tak $y1 $3 $1
    r2=$TAKR
    stackpop && r1=$STACKPOPR
    stackpop && z1=$STACKPOPR
    stackpush $r1
    stackpush $r2
    tak $z1 $1 $2
    r3=$TAKR
    stackpop && r2=$STACKPOPR
    stackpop && r1=$STACKPOPR
    tak $r1 $r2 $r3
  fi
}

STACKNUM=0

tak 10 5 0
printf "$TAKR\n"

