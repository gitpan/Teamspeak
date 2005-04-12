#!/usr/bin/perl -w
# $Id: 07web.t 17 2005-03-18 12:42:28Z maletin $
# $URL: svn+ssh://svn.berlios.de/svnroot/repos/cpan-teamspeak/cpan/trunk/t/07web.t $

use strict;
use Teamspeak;
use Test::Simple tests => 1;

my $n = Teamspeak->new( type => 'web' );
ok( $n->connect( slogin => 'sa', pwd => 'sa' ), 'connect' );
