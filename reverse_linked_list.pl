use warnings;
use strict;

use Data::Dumper;


my $index = 1;
my $head = {value => $index++};
$head = {value => $index++, next => $head};
$head = {value => $index++, next => $head};
$head = {value => $index++, next => $head};
$head = {value => $index++, next => $head};
$head = {value => $index++, next => $head};

warn(Data::Dumper->Dump([$head]));
#warn(Data::Dumper->Dump([reverse_list($head)]));
warn(Data::Dumper->Dump([reverse_list_recursive($head)]));


sub reverse_list {
	my $head = shift;
	
	my $current = $head;
	my $previous;
	my $next;
	
	while ($current) {
		$next = $current->{next};
		$current->{next} = $previous;
		$previous = $current;
		$current = $next;
	}
	return $previous;

}



sub reverse_list_recursive {
	my ($current, $previous) = @_;
	my $next = $current->{next};
	$current->{next} = $previous;
	return $next ? reverse_list_recursive($next, $current) : $current;
}








