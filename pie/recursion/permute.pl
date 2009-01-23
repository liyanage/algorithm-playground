#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my @things = qw(a b c d);

permute(@things);


sub permute {
	my (@things) = @_;
	
	my $count = @things;
	my $used = [];
	my $output = [];
	my $level = 0;
	do_permute(\@things, $output, $used, $count, $level);
	
}

sub do_permute {
	my ($things, $output, $used, $count, $level) = @_;

	if ($level == $count) {
		print "@$output\n";
		return;
	}

	foreach my $i (0 .. $count - 1) {
		next if $used->[$i];
		push @$output, $things[$i];
		$used->[$i] = 1;
		do_permute($things, $output, $used, $count, $level + 1);
		$used->[$i] = 0;
		pop @$output;
	}

}
