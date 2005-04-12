#!/usr/bin/perl -w
# $Id: 03sl.t 7 2005-01-19 15:54:19Z maletin $
# $URL: svn+ssh://svn.berlios.de/svnroot/repos/cpan-teamspeak/cpan/trunk/t/03sl.t $

use strict;
use Teamspeak;
use Test::Simple tests => 1;

my $n = Teamspeak->new( type => 'telnet' );
$n->connect();
ok( $n->sl == 2, 'two servers' );
