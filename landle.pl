#!/usr/bin/perl -w

# landle: A Small but Useful(tm) utility to maintain clones of github
# repos.
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
use Config::Simple;
use LWP::Simple;
use JSON::XS;
use File::Basename qw(dirname);
use File::HomeDir qw(home);
use File::Path qw(make_path);
use Cwd qw(abs_path);
my %option;
my $p_option;
my $verbose = 0;
my $offline = 0;
my $testing_only = 0;
my $data;
my $project;
my $user;

my $cfg = new Config::Simple(home() . "/.landlerc");
# FIXME: For testing
my $root = abs_path("./repos");
my @subdirs = ("forks", "mirrors", "private", "public", "starred", "watching");
my @targets = qw(forks
		 mirrors
		 private
		 public
		 starred
		 watched);

sub usage {
	print <<USAGE;

$0: A Small but Useful(tm) utility to maintain clones of your github repos.

Usage:

-u      Github username.  Required.
-d	Work on already-downloaded test data only.
-v	Be verbose.
-n	Testing only: show, do not do.
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

sub setup_root {
	# FIXME: eval / check for errors
	debug("Setting up directories...");
	foreach my $i (@subdirs) {
		next if -d "${root}/$i";
		make_path("${root}/$i", { verbose => 1,
					  mode    => 0755 });
	}
	debug("Done.");
}

sub clone_or_update {
	my $project = shift;
	my $target_dir = shift;
	chdir("${root}/${target_dir}");
	my $repo_dir = $project->{"name"};
	if (-d $repo_dir) {
		debug("Assuming already cloned and need to update.");
		# FIXME: Would git fetch be better?
		debug("cd $repo_dir && git pull origin master");
		return if $testing_only;
		chdir("$repo_dir");
		system("git pull origin master");
	} else {
		debug("Assuming need to clone.");
		my $clone = sprintf("git clone %s", $project->{"clone_url"});
		debug($clone);
		return if $testing_only;
		system($clone);
	}
}

getopts('dvnhu:', \%option);

if ($option{h}) {
	&usage;
}

if ($option{v}) {
	$verbose = 1;
}

if ($option{n}) {
	$testing_only = 1;
}
if (defined $option{d}) {
	$offline = 1;
}
if ($option{u}) {
	$user = $option{u};
}


setup_root;

# Arghh:  repos and starred are different.
# FIXME: This handling of the original directory is stupid.
my $orig;
my @urls = ("https://api.github.com/users/$user/repos",
	    "https://api.github.com/users/$user/starred" );

if ($offline == 1) {
	local $/;
	open(my $fh, '<', 'user.repos.json');
	$orig = dirname(abs_path('user.repos.json'));
	my $json_text = <$fh>;
	$data = decode_json($json_text);
} else {
	# FIXME: Is the repos URL what I want?  Put it in config, or var up above.
	debug("URL: https://api.github.com/users/$user/repos\n");
	# FIXME: no network option
	my $reply = get("https://api.github.com/users/$user/repos");
	# debug("\$reply = |$reply|");
	$data = decode_json($reply);
}

# users.repos will give us forks, private and public.
# FIXME: Testing option
foreach $project (@$data) {
	# debug("Name: " . $project->{"name"});
	# debug("\tFork?: " . $project->{"fork"});
	# debug("\tClone URL: " . $project->{"clone_url"});
	if ($project->{"fork"} == 1) {
		clone_or_update($project, "forks");
	} elsif ($project->{"private"} == 1) {
		clone_or_update($project, "private");
	} else {
		clone_or_update($project, "public");
	}
}

# And now starred.
# FIXME: Combine these two using the @urls above.
if ($offline == 1) {
	chdir($orig);
	system("pwd");
	local $/;
	open(my $fh, '<', 'user.starred.json') or die("Can't open: $!");
	my $json_text = <$fh>;
	$data = decode_json($json_text);
} else {
	# FIXME: Is the repos URL what I want?  Put it in config, or var up above.
	debug("URL: https://api.github.com/users/$user/starred");
	# FIXME: no network option
	my $reply = get("https://api.github.com/users/$user/starred");
	# debug("\$reply = |$reply|");
	$data = decode_json($reply);
}

foreach $project (@$data) {
	clone_or_update($project, "starred");
}
