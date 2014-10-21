# $Id$
# $URL$

package Teamspeak::Telnet::Channel;
my @ISA = qw( Teamspeak::Channel );

my @_parameters = (
    'id',    'name',     'topic',    'parent',
    'flags', 'maxusers', 'password', 'order'
);

sub parameter {
    return @_telnet_ch_parameters;
}

sub new {
    my ( $class, %arg ) = @_;
    bless {
        id       => $arg{id},
        parent   => $arg{parent},
        order    => $arg{order},
        maxusers => $arg{maxusers},
        name     => $arg{name},
        flags    => $arg{flags},
        password => $arg{password},
        topic    => $arg{topic},
        },
        ref($class) || $class;
}    # new

sub id {
    my $self = shift;
    return $self->{id};
}

sub codec {
    my $self = shift;
    return $self->{codec};
}

sub parent {
    my $self = shift;
    return $self->{parent};
}

sub order {
    my $self = shift;
    return $self->{order};
}

sub maxusers {
    my $self = shift;
    return $self->{maxusers};
}

sub name {
    my $self = shift;
    return $self->{name};
}

sub flags {
    my $self = shift;
    return $self->{flags};
}

sub password {
    my $self = shift;
    return $self->{password};
}

sub topic {
    my $self = shift;
    return $self->{topic};
}    # topic

1;

=head A

=cut
