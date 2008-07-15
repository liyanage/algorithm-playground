#!/usr/bin/perl
#
# Merge sort
#

use strict;
use warnings;

use POSIX;
use Data::Dumper;
use Carp;


my @test = qw(1 2 200 150 10 2);

my @sorted = mergesort(@test);

print(Data::Dumper->Dump([\@sorted]));




sub mergesort {
	my (@list) = @_;

	my $n = @list;
	return @list if ($n < 2);

	return merge(
		[mergesort(@list[0 .. floor($n / 2) - 1])],
		[mergesort(@list[floor($n / 2) .. $n - 1])]
	);
}




sub merge {
	my ($a, $b) = @_;

	my @out;
	while (@$a and @$b) {
		push @out, $a->[0] < $b->[0] ? shift @$a : shift @$b;
	}
	
	return @out, @$a, @$b;
}
