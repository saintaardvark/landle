#!/usr/bin/perl -w

# perl_template.pl:  A Small but Useful(tm) utility to foo the right bar.
#
# Copyright (C) 2014 Hugh Brown
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.
#
# $Id$
# $URL$

use strict;
use Getopt::Std;
# use Net::GitHub::V3;
use LWP::Simple;
use JSON::XS;
use File::Path qw(mkpath);
my %option;
my $p_option;
my $verbose = 0;
my $testing_only = 0;

sub usage {
	print <<USAGE;

$0: A Small but Useful(tm) utility to foo the right bar. Useful for
debugging web servers.

Usage:

-p [arg] Provide an argument.
-v	Be verbose.
-n	Testing only: show, do not do. Implies -v.
-h	This helpful message.
USAGE
	exit 1;
}

sub complain_and_die {
	my $error = shift;
	print STDERR "$error\n\n";
	&usage;
}

sub debug {
	if ($verbose > 0) {
		my $log = shift;
		print "$log\n";
	}
}

getopts('vnhp:', \%option);

if ($option{h}) {
	&usage;
}

if ($option{v}) {
	$verbose = 1;
}

if ($option{n}) {
	$testing_only = 1;
	$verbose = 1;
}
if (defined $option{p}) {
	$p_option = $option{p};
}

my @targets = qw(forks
		 mirrors
		 private
		 public
		 starred
		 watched);

foreach my $i (@targets) {
  mkpath("repos/$i");
}
  print "Target: $i\n";
  print "URL: https://api.github.com/users/saintaardvark/$i\n";
  my $reply = get("https://api.github.com/users/saintaardvark/$i");
  # print "FIXME: \$reply = |$reply|\n";
  my $data = decode_json $reply;
    foreach my $project (@$data) {
    printf("%s\n\tFork: %s\n\tURL:%s\n", $project->{"name"}, $project->{"fork"}, $project->{"clone_url"});
  }
}
