#!/usr/bin/perl -w
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 00_load.t'
#########################
## no critic (UselessNoCritic MagicNumbers)

use strict;
use warnings;

our $VERSION = "1.000";

use Test::More tests => 7;
for my $module (qw(Wiki::TiddlyWiki::Classic::Saver::Package)) {
    use_ok($module) || BAIL_OUT("Cannot even use $module");
}
my $released = Wiki::TiddlyWiki::Classic::Saver::Package->release_time;
like($released, qr{^[0-9]+\z}, "release_time is a number");
is(Wiki::TiddlyWiki::Classic::Saver::Package->release_time, $released,
   "Still the same release time");
is(Wiki::TiddlyWiki::Classic::Saver::Package::released("Wiki::TiddlyWiki::Classic::Saver::Package", "1.000"),
   "1.000", "Module released");
eval { Wiki::TiddlyWiki::Classic::Saver::Package::released("Mumble", "1.000") };
like($@, qr{^Could not find a history for package 'Mumble' at },
     "Expected module not found");
eval { Wiki::TiddlyWiki::Classic::Saver::Package::released("Wiki::TiddlyWiki::Classic::Saver/Package", "9999") };
like($@,
     qr{^No known version '9999' of package 'Wiki::TiddlyWiki::Classic::Saver/Package' at },
     "Expected version not found");
# The fact that this makes cond coverage 100% must be a Devel::Cover bug
eval { Wiki::TiddlyWiki::Classic::Saver::Package::released("OogieBoogie", "1.000") };
like($@,
     qr{^Could not find a history for package 'OogieBoogie' at },
     "No history for unknown modules");
