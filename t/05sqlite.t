#!/usr/bin/perl -w
# $Id: 05sqlite.t 7 2005-01-19 15:54:19Z maletin $
# $URL: svn://svn.berlios.de/cpan-teamspeak/cpan/trunk/t/05sqlite.t $

use strict;
use Teamspeak;
use Test::Simple tests => 1;

my $n = Teamspeak->new(
  type => 'sql',
  file => 't/server.dbs'
);
$n->connect( '', '' );
ok( defined $n->sl, 'sqlite sl' );
