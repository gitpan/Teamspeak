#!/usr/bin/perl -w
# $Id: 06sqlch.t 17 2005-03-18 12:42:28Z maletin $
# $URL: svn+ssh://svn.berlios.de/svnroot/repos/cpan-teamspeak/cpan/trunk/t/06sqlch.t $

use strict;
use Teamspeak;
use Test::Simple tests => 2;

my $n = Teamspeak->new(
  type => 'sql',
  host => 'localhost',
  db   => 'teamspeak'
);
$n->connect( 'teamspeak', 'teamspeak' );
my $c = $n->get_channel;
ok( $c->[0]->parameter > 5, 'sql get_channel parameter' );
ok( $c->[0]->store, 'sql channel store' );
