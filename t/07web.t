#!/usr/bin/perl -w
# $Id: 07web.t 28 2006-05-20 17:45:01Z maletin $
# $URL: svn+ssh://svn.berlios.de/svnroot/repos/cpan-teamspeak/cpan/trunk/t/07web.t $

use strict;
use Teamspeak;
use Test::Simple tests => 1;

my $tsh = Teamspeak->new( type => 'web' );
ok( $tsh->connect( slogin => 'sa', pwd => 'sa' ), 'connect' );
