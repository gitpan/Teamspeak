#!/usr/bin/perl -w
# $Id: 01version.t,v 1.1 2006/05/20 16:51:21 moertzen Exp $
# $URL: svn+ssh://svn.berlios.de/svnroot/repos/cpan-teamspeak/cpan/trunk/t/01version.t $

use strict;
use Teamspeak;
use Test::Simple tests => 1;

ok( $Teamspeak::VERSION > 0, 'version is positive' );
