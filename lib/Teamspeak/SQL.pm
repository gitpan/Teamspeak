# $Id: SQL.pm 28 2006-05-20 17:45:01Z maletin $
# $URL: svn+ssh://svn.berlios.de/svnroot/repos/cpan-teamspeak/cpan/trunk/lib/Teamspeak/SQL.pm $

package Teamspeak::SQL;

use 5.004;
use strict;
use DBI;
use vars qw( $VERSION );
$VERSION = '0.4';
my @ISA = qw( Teamspeak );

sub connect {
  my ( $self, $user, $pwd ) = @_;
  my $dsn;
  if ( $self->{d_file} ) {
    $dsn = "dbi:SQLite2:dbname=$self->{d_file}";
    $user = $pwd = '';
  } else {
    $dsn = "dbi:mysql:database=$self->{d_db}";
    $dsn .= ";hostname=$self->{d_host};port=$self->{d_port}";
  }
  my $m = DBI->connect( $dsn, $user, $pwd );
  $self->{db} = $m;
}    # connect

sub new {
  my ( $class, %arg ) = @_;
  my $s;
  if ( $arg{file} ) {
    $s = { d_file => $arg{file} };
  } else {
    $s = {
      d_host => $arg{host} || 'localhost',
      d_port => $arg{port} || 3306,
      d_db   => $arg{db}   || 'teamspeak',
    };
  }
  bless $s, ref($class) || $class;
}    # new

sub get_channel {
  my $self = shift;
  $self->{channel} = {};    # Forget old values.
  my $s    = 'select * from ts2_channels';
  my $all  = $self->{db}->selectall_hashref( $s, 'i_channel_id' );
  foreach my $c ( keys %$all ) {
    $all->{$c}{tsh} = $self;    # a channel belongs to a Teamspeak-Handle.
    $self->{channel}{$c} = bless( $all->{$c}, 'Teamspeak::Channel' );
  }
  return keys %{$self->{channel}};
}    # get_channel

sub sl {
  my $self = shift;
  my $s    = 'select * from ts2_servers';
  return $self->{db}->selectall_hashref( $s, 'i_server_id' );
}    # sl

package Teamspeak::Channel;

my @_parameter = (
  's_channel_description',  'dt_channel_created',
  's_channel_name',         'i_channel_parent_id',
  'i_channel_codec',        'b_channel_flag_hierarchical',
  's_channel_topic',        'i_channel_order',
  's_channel_password',     'b_channel_flag_moderated',
  'b_channel_flag_default', 'i_channel_maxusers',
  'i_channel_server_id'
);

sub store {
  my $self = shift;
  my $sql  =
      "update ts2_channels set "
    . join( ', ', map { "$_ = ?" } @_parameter )
    . " where i_channel_id = ?";
  my $rows_affected =
    $self->{dbh}
    ->do( $sql, {}, map( { $self->{$_} } @_parameter ), $self->{i_channel_id} );
  if ( $rows_affected == 1 or $rows_affected == 0 ) {
    return 1;    # Even unmodified Channels report sucess.
  } else {
    $self->{err}    = 1;
    $self->{errstr} = "$rows_affected Channels modified.";
    return 0;    # should never happen, because i_channel_id is primary key.
  }
}    # Teamspeak::Channel::store

sub parameter {
  my $self = shift;
  return map { $_ =~ m/.+_channel_(.*)/; $1 } @_parameter;
}    # Teamspeak:Channel::parameter

1;
