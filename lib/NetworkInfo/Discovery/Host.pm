package NetworkInfo::Discovery::Host;

use strict;
use warnings;

=head1 NAME

NetworkInfo::Discovery::Host - holds all the data we know about a host

=head1 SYNOPSIS

  use NetworkInfo::Discovery::Host;

  my $host = new NetworkInfo::Discovery::Host('ipaddress'=> '192.168.1.3',
				      'mac'=> '11:11:11:11:11:11',
				      'dnsname' => 'someotherhost' ) 
		    || warn ("failed to make host");

=head1 DESCRIPTION

C<NetworkInfo::Discovery::Host> has all the information we could ever want to 
know about a host.

=over 4

=item dnsname
    
this it the name that DNS knows this host by.

=item ipaddress

this is the software address of the host (a.k.a its IP address)

=item mac

this is the hardware Media Access Control address (MAC address) of the host

=item open_ports

these are ports that we know this host to be listening on

=back


=head1 METHODS

=item new 

returns a new Host object, and takes the arguments shown in this example:

    $obj = NetworkInfo::Discovery::Host->new( [dnsname	=> $text,]
				[ipaddress	=> $ipaddress_text,]
				[mac		=> $mac_text,]
				[open_ports	=> $array_numbers,] );

=cut

sub new {
    my $proto = shift;
    my %args = @_;

    my $class = ref($proto) || $proto;

    my $self  = {};
    bless ($self, $class);

    # for all args, see if we can load them
    foreach my $attr (keys %args) {
	if ($self->can($attr) ) {
	    $self->$attr( $args{$attr} );
	} else {
	    print "error calling NetworkInfo::Discovery::Host-> $attr (  $args{$attr} ) : no method $attr \n";
	}
    }

    return $self;
}

=pod

=item is_discovery_host ([yes|no])

get set what we think the os type is (Linux, Solaris...)

=cut
sub is_discovery_host {
    my $self = shift;

    $self->{'is_discovery_host'} = shift if (@_);
    return $self->{'is_discovery_host'};
}

=pod

=item os_type ([$string])

get set what we think the os type is (Linux, Solaris...)

=cut
sub os_type {
    my $self = shift;

    $self->{'os_type'} = join(',',@_) if (@_);
    return $self->{'os_type'};
}

=pod

=item dnsname ([$name])

get set this dns name

=cut
sub dnsname {
    my $self = shift;

    $self->{'dnsname'} = join(',',@_) if (@_);
    return $self->{'dnsname'};
}

=pod

=item ipaddress ([$name])

get set this ip address in the form "111.222.333.444"

=cut
sub ipaddress {
    my $self = shift;

    $self->{'ipaddress'} = join(',',@_) if (@_);
    return $self->{'ipaddress'};
}

=pod

=item mac ([$mac])

get set this mac address in the form "aa:bb:bb:dd:ee:ff"

=cut
sub mac {
    my $self = shift;

    $self->{'mac'} = join(',',@_) if (@_);
    return $self->{'mac'};
}

=pod

=item does_udp ([yes|no])

=cut
sub does_udp {
    my $self = shift;

    $self->{'does_udp'} = join(',',@_) if (@_);
    return $self->{'does_udp'};
}
=pod

=item does_tcp ([yes|no])

=cut
sub does_tcp {
    my $self = shift;

    $self->{'does_tcp'} = join(',',@_) if (@_);
    return $self->{'does_tcp'};
}
=pod

=item does_arp ([yes|no])

=cut
sub does_arp {
    my $self = shift;

    $self->{'does_arp'} = join(',',@_) if (@_);
    return $self->{'does_arp'};
}
=pod

=item does_ethernet ([yes|no])

=cut
sub does_ethernet {
    my $self = shift;

    $self->{'does_ethernet'} = join(',',@_) if (@_);
    return $self->{'does_ethernet'};
}

=pod

=item open_ports ([@ports])

get/set the open listening ports for this host

=cut
sub open_ports {
    my $self = shift;
    my @ports = @_;

    if (@ports) {
	$self->{'open_ports'} = join(',',@ports);
    } 
    return $self->{'open_ports'};
}

=pod

=item id 

returns the "hopefully" unique address for this host.  this is a real design flaw
that needs to be worked out.  the id right now is either just the ip address or
"ipaddress+macaddress" if we know the mac address.

=cut
sub id {
    my $self = shift;

    return $self->ipaddress unless ($self->mac) ;
    return ($self->ipaddress . "+" . $self->mac);
}

=pod

=item get_attributes

returns a hash of attributes about this host.  it is currently
used only by the C<NetworkInfo::Discovery> module to store our graph info.

=cut
sub get_attributes {
    my $self = shift;

    my %attrs;
    foreach my $a (keys %$self) {
	$attrs{$a} = $self->{$a} if ($self->{$a});
    }
     
    return %attrs;
}

=pod

=item as_string

returns the host in a string representation.

=cut
sub as_string {
    my $self = shift;
    my $str;
    
    $str .= $self->id() . ": ";

    my %attrs = $self->get_attributes;;
    foreach my $a (keys %attrs) {
	$str .= "$a => $attrs{$a}, ";
    }
     
    return $str;
}
  
=head1 AUTHOR

Tom Scanlan <tscanlan@openreach.com>

=head1 SEE ALSO

L<NetworkInfo::Discovery::Host>

L<NetworkInfo::Discovery::Detect>

L<NetworkInfo::Discovery::Sniff>

L<NetworkInfo::Discovery::Traceroute>

=head1 BUGS

Please send any bugs to Tom Scanlan <tscanlan@they.gotdns.org>

=cut


1;
