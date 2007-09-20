#!/usr/bin/perl -w
# $Id: 03sl.t 28 2006-05-20 17:45:01Z maletin $
# $URL: svn+ssh://svn.berlios.de/svnroot/repos/cpan-teamspeak/cpan/trunk/t/03sl.t $

use strict;
use Teamspeak;
use Test::Simple tests => 1;

my $tsh = Teamspeak->new( type => 'telnet' );
$tsh->connect();
ok( $tsh->sl == 2, 'two servers' );
