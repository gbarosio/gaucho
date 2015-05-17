#!/usr/bin/perl
# Copyright Guido Barosio, gbarosio@gmail.com
# Distributed as a part of Gaucho, yet another perl MVC framework.
# 2014

package BaseController;

require Exporter;
@ISA = qw/Exporter/;

@EXPORT = qw/Index/;

sub Index {
	return $0;
}
1;
