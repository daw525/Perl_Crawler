#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;

my @links = getLinks("http://www.bbc.co.uk");

foreach my $link (@links) {
	getLinks($link);
}

sub getLinks {
	my ($url) = @_;
	my $page = get($url) || die "Bad URL ";
	open (FILE, ">>./links.txt") || die "File open error";
	my @links=$page=~/<a href=\"(.*?)\"/g;
	foreach my $link (@links) {
		if ((!($link=~/^http/))||($link=~/^\//)) {
			$link = $url.$link;
		}
		print FILE $link."\n";
		print $link."\n";
	}
	close FILE;
	return @links;
}
