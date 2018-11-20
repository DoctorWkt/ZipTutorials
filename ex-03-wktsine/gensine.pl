#!/usr/bin/perl
use strict;
use warnings;
my $oldval=-1;
foreach my $i (0 .. 7*65535) {
  my $angle = 2 * 3.14 * $i / 65536;
  #my $sinval= int(4 + 4 * sin($angle));
  my $sinval= int(4 + 3.7 * sin($angle));
  #print("$sinval\n");
  #if (($i & 0xff)==0) {
  if (1) {
    #printf("0x%04x ", $i);
    if ($sinval==0) {
      print("X.......\n");
    } elsif ($sinval== 1) {
      print(".X......\n");
    } elsif ($sinval== 2) {
      print("..X.....\n");
    } elsif ($sinval== 3) {
      print("...X....\n");
    } elsif ($sinval== 4) {
      print("....X...\n");
    } elsif ($sinval== 5) {
      print(".....X..\n");
    } elsif ($sinval== 6) {
      print("......X.\n");
    } elsif ($sinval== 7) {
      print(".......X\n");
    }
    print("foo $i $sinval\n") if ($oldval != $sinval);
    $oldval = $sinval;
  }
}
