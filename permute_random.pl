#!/usr/bin/perl

use strict;
use warnings;

# http://www.algoblog.com/2007/06/04/permutation/

my @array = qw(a b c d e);

foreach my $i (1 .. @array - 1) {
	my $j = int(rand($i + 1));
	@array[$i, $j] = @array[$j, $i];
}
print "@array\n";
