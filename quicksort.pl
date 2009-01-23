#!/usr/bin/perl

use strict;
use warnings;

my @data;
push @data, int(rand(100)) foreach 1 .. 20;

print "@data\n";
@data = quicksort(@data);
print "@data\n";




sub quicksort {
	my (@data) = @_;
	do_quicksort(\@data, 0, @data - 1);
	return @data;
}


sub do_quicksort {
	my ($array, $left, $right) = @_;

	return unless $left < $right;
	warn("do_quicksort: left $left, right $right\n");

	my $p = partition($array, $left, $right);
	warn("do_quicksort: pivot $p: " . join(' ', @{$array}[$left .. $p - 1]) . " ($array->[$p]) " . join(' ', @{$array}[$p + 1 .. $right]) . "\n");
	do_quicksort($array, $left, $p - 1);
	do_quicksort($array, $p + 1, $right);
}


sub partition {
	my ($a, $left, $right) = @_;
	
	my $p = int(rand($right - $left)) + $left;
	my $store = $left;
	
	($a->[$right], $a->[$p]) = ($a->[$p], $a->[$right]);
	
	foreach my $i ($left .. $right - 1) {
		if ($a->[$i] <= $a->[$right]) {
			($a->[$i], $a->[$store]) = ($a->[$store], $a->[$i]);
			$store++;
		}
	}
	($a->[$store], $a->[$right]) = ($a->[$right], $a->[$store]);
	return $store;
}

