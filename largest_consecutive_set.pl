#!/usr/bin/perl

use strict;
use warnings;

#my @array = (-10, 2, 3, -2, 0, 5, -15);
my @array = qw(3 2 8 9 -25 5 8 4 4 -3 5 3 -10);


my $current_sum = 0;
my $best_sum = 0;
my $best_start = 0;
my $best_end = 0;
my $current_start = 0;
my $current_end = -1;
my $length = @array;


my $i = 0;
while ($i < $length) {
	my $value = $array[$i];
	$current_sum += $value;
	if ($current_sum < 0) {
#		$current_start++;
		$current_start = $i + 1;
		$current_sum = 0;
	} else {
		if ($current_sum > $best_sum) {
			$best_start = $current_start;
			$best_end = $i;
			$best_sum = $current_sum;
		}
	}
	$i++;
}


my @best = @array[$best_start .. $best_end];
my $sum = 0;
$sum += $_ foreach @best;
print "@best / $sum\n";


