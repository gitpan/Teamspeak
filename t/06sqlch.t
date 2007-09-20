#!/usr/bin/perl -w
# $Id: 06sqlch.t 28 2006-05-20 17:45:01Z maletin $
# $URL: svn+ssh://svn.berlios.de/svnroot/repos/cpan-teamspeak/cpan/trunk/t/06sqlch.t $

use strict;
use Teamspeak;
use Test::Simple tests => 2;

my $tsh = Teamspeak->new(
  type => 'sql',
  host => 'localhost',
  db   => 'teamspeak'
);
$tsh->connect( 'teamspeak', 'teamspeak' );
my $c = $tsh->get_channel;
ok( $c->[0]->parameter > 5, 'sql get_channel parameter' );
ok( $c->[0]->store, 'sql channel store' );
