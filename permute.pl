#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

#print sort map {"@$_\n"} bitstring2(@ARGV);

#bitstring2(1 .. 20);

# mliyanage
sub permute {
	my (@elements) = @_;
	return () unless @elements;
	my $first = shift @elements;
	return [$first], map {[$first, @$_], [@$_]} permute(@elements);
}

warn(Data::Dumper->Dump([permute(qw(a b c))]));

