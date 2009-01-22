
use strict;
use warnings;

use Data::Dumper;

my @result = sort map {"@$_"} permute(qw(D L S V));
warn(Data::Dumper->Dump([\@result]));

sub permute {
	my (@elements) = @_;
	return () unless @elements;
	my $first = shift @elements;
	return [$first], map {[$first, @$_], [@$_]} permute(@elements);
}


