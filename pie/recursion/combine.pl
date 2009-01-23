#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my @things = qw(w x y z);

print map {join('', @$_) . "\n"} combine(@things);


sub combine {
	my (@things) = @_;
	my ($first, @rest) = @things;

	my @result = [$first];
	return @result unless @rest;
	
	foreach my $combination (combine(@rest)) {
		push @result, [$first, @$combination];
		push @result, $combination;
	}
	
	return @result;
	
}


