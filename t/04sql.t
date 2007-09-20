#!/usr/bin/perl -w
# $Id: 04sql.t 28 2006-05-20 17:45:01Z maletin $
# $URL: svn+ssh://svn.berlios.de/svnroot/repos/cpan-teamspeak/cpan/trunk/t/04sql.t $

use strict;
use Teamspeak;
use Test::Simple tests => 1;

my $tsh = Teamspeak->new(
  type => 'sql',
  host => 'localhost',
  db   => 'teamspeak'
);
$tsh->connect( 'teamspeak', 'teamspeak' );
ok( defined $tsh->sl, 'sql sl' );
