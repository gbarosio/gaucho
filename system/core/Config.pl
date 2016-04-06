#!/usr/bin/perl
use YAML::XS 'LoadFile';
use Data::Dumper;
use strict;

my $config = LoadFile('../../app/config/config.cfg');

print $config->{projectName}."\n";
print $config->{version}."\n";
print $config->{base_url}."\n";
print $config->{log_path}."\n";
