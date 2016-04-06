#!/usr/bin/perl

package Config;
use YAML::XS 'LoadFile';
use strict;

require Exporter;
my @ISA = qw(Exporter);
my @EXPORT = qw(log base_url conf);
my $config = LoadFile('../../app/config/config.cfg');

print $config->{projectName}."\n";
print $config->{version}."\n";
print $config->{base_url}."\n";
print $config->{log_path}."\n";

sub log {
	return $config->{log_path};
}

sub base_url {
	return $config->{base_url};
}

sub conf {
	my @conf = ($config->{projectName},$config->{version} );

	return \@conf;
}
