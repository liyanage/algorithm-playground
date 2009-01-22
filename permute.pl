#!/usr/bin/perl

use strict;
use warnings;

print sort map {"@$_\n"} permute(@ARGV);

sub permute {
	my (@elements) = @_;
	return () unless @elements;
	my $first = shift @elements;
	return [$first], map {[$first, @$_], [@$_]} permute(@elements);
}

