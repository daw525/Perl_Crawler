#!/usr/bin/perl
use strict;
use warnings;
use Net::HTTP;

my @links = getLinks("www.dawilson.co.uk");

getLinks($links[2]);

sub getLinks {
	my ($url) = @_;
	my $page;
	my $s = Net::HTTP->new(Host=>$url) || die $@;
	$s->write_request(GET=>"/",'User-Agent'=>"Mozilla/5.0");
	my($code,$mess,%h)=$s->read_response_headers;
	while(1) {
		my $buf;
		my $n=$s->read_entity_body($buf,1024);
		die "read failed: $!" unless defined $n;
		last unless $n;
		$page = $page.$buf;
	}
	open (FILE, ">>./links.txt") || die "File open error";
	my @links=$page=~/<a href=\"(.*?)\"/g;
	foreach my $link (@links) {
		if (!($link=~/^http/)) {
			$link = $url."/".$link;
		}
		print FILE $link."\n";
	}
	close FILE;
	return @links;
}
