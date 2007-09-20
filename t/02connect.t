#!/usr/bin/perl -w
# $Id: 02connect.t 28 2006-05-20 17:45:01Z maletin $
# $URL: svn+ssh://svn.berlios.de/svnroot/repos/cpan-teamspeak/cpan/trunk/t/02connect.t $

use strict;
use Teamspeak;
use Test::Simple tests => 1;

my $tsh = Teamspeak->new( type => 'telnet' );
ok( $tsh->connect(), 'connect' );
