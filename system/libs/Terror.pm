#!/usr/bin/perl
# Copyright Guido Barosio, gbarosio@gmail.com
# Distributed as a part of Gaucho, yet another perl MVC framework.
# 2014

# Terror.pm, useful error handling

package Terror;

require Exporter;
@ISA = qw/Exporter/;
@EXPORT = qw/Terror Wrong/;

use Carp qw(cluck confess);

sub Terror {
	cluck "Cluck: Terror\n";
}

sub Wrong {
	confess "Confess: Wrong\n";
}
1;
