#!/usr/bin/perl -w
# $Id: 04sql.t 7 2005-01-19 15:54:19Z maletin $
# $URL: svn://svn.berlios.de/cpan-teamspeak/cpan/trunk/t/04sql.t $

use strict;
use Teamspeak;
use Test::Simple tests => 1;

my $n = Teamspeak->new(
  type => 'sql',
  host => 'localhost',
  db   => 'teamspeak'
);
$n->connect( 'teamspeak', 'teamspeak' );
ok( defined $n->sl, 'sql sl' );
