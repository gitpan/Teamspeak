#!/usr/bin/perl -w
# $Id: 02connect.t 3 2005-01-12 14:14:56Z maletin $
# $URL: svn+ssh://svn.berlios.de/svnroot/repos/cpan-teamspeak/cpan/trunk/t/02connect.t $

use strict;
use Teamspeak;
use Test::Simple tests => 1;

my $n = Teamspeak->new( type => 'telnet' );
ok( $n->connect(), 'connect' );
