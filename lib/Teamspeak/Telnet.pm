# $Id: Telnet.pm 23 2005-04-17 02:18:27Z maletin $
# $URL: svn+ssh://svn.berlios.de/svnroot/repos/cpan-teamspeak/cpan/trunk/lib/Teamspeak/Telnet.pm $

package Teamspeak::Telnet;

use 5.004;
use strict;
use Carp;
use vars qw( $VERSION );
$VERSION = '0.3';
my @ISA = qw( Teamspeak );

## Module import.
use Net::Telnet;

sub connect {
  my $self = shift;
  my $t = Net::Telnet->new( Timeout => $self->{timeout},
      errmode => [ \&my_die, $self, 'Telnet Timeout' ] );
  if( ! $t ) {
    $self->my_die( "can't create Telnet-Instance" );
    return undef;
  }
  $t->open( Host => $self->{host}, Port => $self->{port} )
    or do {
      $self->my_die( "Telnet open $t->errmsg" );
      return undef;
    };
  $t->waitfor('/\[TS\]$/');
  $self->{sock}   = $t;
}    # connect

sub new {
  my ( $class, %arg ) = @_;
  bless {
    host    => $arg{host}    || 'localhost',
    port    => $arg{port}    || 51234,
    timeout => $arg{timeout} || 4,
    },
    ref($class) || $class;
}    # new

# Server List:
sub sl {
  my $self = shift;
  $self->{sock}->print('sl');
  my($answer) = $self->{sock}->waitfor('/OK$/');
  return grep( /^\d+$/, split( /\n/, $answer ) );
}

# Select Server:
sub sel {
  my ( $self, $server_id ) = @_;
  $self->{sock}->print("sel $server_id");
  my($answer) = $self->{sock}->waitfor('/OK$/');
  return 1;
}    # sel

# Superadmin LOGIN:
sub slogin {
  my ( $self, $login, $pwd ) = @_;
  $self->{sock}->print("slogin $login $pwd");
  $self->{sock}->waitfor('/OK$/');
  $self->{slogin} = $login;
  return 1;
}    # slogin

# normal LOGIN:
sub login {
  my ( $self, $login, $pwd ) = @_;
  $self->{sock}->print("login $login $pwd");
  $self->{sock}->waitfor('/OK$/');
  $self->{login} = $login;
  return 1;
}    # login

# Database userlist:
sub dbuserlist {
  my $self   = shift;
  my @result = ();
  if( ! $self->logged_in ) {
    $self->my_die( "command needs login" );
    return undef;
  }
  $self->{sock}->print('dbuserlist');
  my($answer, $match) = $self->{sock}->waitfor('/(OK|ERROR,.*)$/');
  return @result if( $match =~ /no data/ );
  my @lines = split( /\n/, $answer );
  shift @lines; # First Line is empty
  my $fields = shift @lines;
  return unless $fields;
  my @fields = split( /\t/, $fields );
  foreach my $line (@lines) {
    my @r = split( /\t/, $line );
    my %args = map {
      $r[$_] =~ s/^"(.*)"$/$1/;
      $r[$_] =~ s/^(\d\d)-(\d\d)-(\d{4})/$3-$2-$1/;
      $fields[$_] => $r[$_] } 0..@r-1;
    push( @result, { %args } );
  }
  return @result;
}    # dbuserlist

# Database userdelete:
sub delete_user {
  my ( $self, $user_id ) = @_;
  $self->{sock}->print("dbuserdel $user_id");
  $self->{sock}->waitfor('/OK$/');
  return 1;
}    # delete_user

# Database useradd:
sub add_user {
  my ( $self, %args ) = @_;
  $args{admin} = 0 if $args{admin} != 1;
  $self->{sock}->print("dbuseradd $args{user} $args{pwd} $args{pwd} $args{admin}");
  $self->{sock}->waitfor('/OK$/');
  return 1;
}    # add_user

# Channel List:
sub cl {
  my $self = shift;
  $self->{sock}->print('cl');
  my($answer, $match) = $self->{sock}->waitfor('/(OK|ERROR.*)$/');
  if( ! defined $match or $match =~ /ERROR/ ) {
    $self->my_die( $match );
    return undef;
  }
  my @lines = split( /\n/, $answer );
  shift @lines; # First Line is empty
  my $fields = shift @lines;
  my @fields = split( /\t/, $fields );
  my @result = ();
  foreach my $line (@lines) {
    my @r = split( /\t/, $line );
    my %args = map {
      $r[$_] =~ s/^"(.*)"$/$1/;
      $r[$_] =~ s/^(\d\d)-(\d\d)-(\d{4})/$3-$2-$1/;
      $fields[$_] => $r[$_] } 0..@r-1;
    push( @result, { %args } );
  }
  return @result;
}    # cl

# Player List:
sub pl {
  my $self = shift;
  $self->{sock}->print('pl');
  my($answer, $match) = $self->{sock}->waitfor('/(OK|ERROR.*)$/');
  if( ! defined $match or $match =~ /ERROR/ ) {
    $self->my_die( $match );
    return undef;
  }
  my @lines = split( /\n/, $answer );
  shift @lines; # First Line is empty
  my $fields = shift @lines;
  my @fields = split( /\t/, $fields );
  my @result = ();
  foreach my $line (@lines) {
    my @r = split( /\t/, $line );
    my %args = map {
      $r[$_] =~ s/^"(.*)"$/$1/;
      $r[$_] =~ s/^(\d\d)-(\d\d)-(\d{4})/$3-$2-$1/;
      $fields[$_] => $r[$_] } 0..@r-1;
    push( @result, { %args } );
  }
  return @result;
}    # pl

# Disconnect:
sub disconnect {
  my $self = shift;
  $self->{sock}->print('quit');
  delete $self->{sock};
}

sub my_die {
  my($self, @msg) = @_;
  $self->{err} = 1;
  @msg = ( 'unknown error' ) if( ! @msg );
  $self->{errmsg} = "@msg";
  carp "my_die @msg";
}

sub logged_in {
  my $self = shift;
  return 2 if( defined $self->{slogin} );
  return 1 if( defined $self->{login} );
  return 0;
}

1;
