#!/usr/bin/perl
use lib qw(blib/arch blib/lib ../blib/arch ../blib/lib );

use warnings;
use strict;

use NetworkInfo::Discovery;
use NetworkInfo::Discovery::Host;
use NetworkInfo::Discovery::Sniff;
use NetworkInfo::Discovery::Traceroute;

my $d = new NetworkInfo::Discovery ('file' => 'sample.xml', 'autosave' => 1) || warn ("failed to make new obj");

my $s = new NetworkInfo::Discovery::Sniff;


$s->maxcapture(10);
$s->do_it;
$d->add_hosts($s->get_hosts);


my @traced;
foreach my $h ($s->get_hosts) {
    (print "----- already traced to " . $h->ipaddress . "\n" && next ) if (grep { $_ eq $h->ipaddress  } @traced);
    print "Tracing to " . $h->ipaddress . "\n";
    push (@traced, $h->ipaddress); 

    my $t = new NetworkInfo::Discovery::Traceroute (host=>$h->ipaddress);
    $t->do_it;
    $d->add_hosts($t->get_hosts);
    $d->add_hops($t->get_hops);
}

$d->print_graph;
my $discServer = $d->find_host(new NetworkInfo::Discovery::Host("is_discovery_host" => "yes"));

print $discServer->as_string . "\n";

