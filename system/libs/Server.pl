#!/usr/bin/perl
# Based on: http://www.wellho.net/resources/ex.php4?item=p402/miniserver.pl
# modifyied by Guido Barosio, gbarosio@gmail.com
# 2014, gaucho, yet another perl framework

use strict;
use Socket;
use IO::Socket;

# Simple web server in Perl
# Serves out .html files, echos form data


# Setup and create socket

my $port = shift;
my $home = shift;
my $counter = 0;

defined($port) or die "Usage: $0 portno home\n";
defined($home) or die "Usage $0 portno home\n";

my $DOCUMENT_ROOT = $home;

my $server = new IO::Socket::INET(
					Proto => 'tcp',
                                	LocalPort => $port,
                                  	Listen => 100000,
                                  	ReuseAddr => 1);
$server or die "Unable to create server socket: $!" ;

# Await requests and handle them as they arrive

while (my $client = $server->accept()) {
    $counter++;
    $client->autoflush(1);
    my %request = ();
    my %data;

    {

#-------- Read Request ---------------

        local $/ = Socket::CRLF;
        while (<$client>) {
            chomp; # Main http request
            if (/\s*(\w+)\s*([^\s]+)\s*HTTP\/(\d.\d)/) {
                $request{METHOD} = uc $1;
                $request{URL} = $2;
                $request{HTTP_VERSION} = $3;
            } # Standard headers
            elsif (/:/) {
                (my $type, my $val) = split /:/, $_, 2;
                $type =~ s/^\s+//;
                foreach ($type, $val) {
                        s/^\s+//;
                        s/\s+$//;
                }
                $request{lc $type} = $val;
            } # POST data
            elsif (/^$/) {
                read($client, $request{CONTENT}, $request{'content-length'})
                    if defined $request{'content-length'};
                last;
            }
        }
    }

#-------- SORT OUT METHOD  ---------------

    if ($request{METHOD} eq 'GET') {
        if ($request{URL} =~ /(.*)\?(.*)/) {
                $request{URL} = $1;
                $request{CONTENT} = $2;
                %data = parse_form($request{CONTENT});
        } else {
                %data = ();
        }
        $data{"_method"} = "GET";
    } elsif ($request{METHOD} eq 'POST') {
                %data = parse_form($request{CONTENT});
                $data{"_method"} = "POST";
    } else {
        $data{"_method"} = "ERROR";
    }

#------- Serve file ----------------------

        my $localfile = $DOCUMENT_ROOT.$request{URL};

# Send Response
        if (open(FILE, "<$localfile")) {
            print $client "HTTP/1.0 200 OK", Socket::CRLF;
            print $client "Content-type: text/html", Socket::CRLF;
            print $client Socket::CRLF;
            my $buffer;
            while (read(FILE, $buffer, 4096)) {
                print $client $buffer;
            }
            $data{"_status"} = "200";
        }
        else {
            print $client "HTTP/1.0 404 Not Found", Socket::CRLF;
            print $client "Concent-type: text/html", Socket::CRLF;
            print $client "<html><body>404 Not Found</body></html>";
            $data{"_status"} = "404";
        }
        close(FILE);

# Log Request
        print ($DOCUMENT_ROOT.$request{URL},"\n");
        foreach (keys(%data)) {
                print ( " $_ = $data{$_}\n"); }

# ----------- Close Connection and loop ------------------
    print $counter."\n";
    close $client;
}

sub parse_form {
    my $data = $_[0];
    my %data;
    foreach (split /&/, $data) {
        my ($key, $val) = split /=/;
        $val =~ s/\+/ /g;
        $val =~ s/%(..)/chr(hex($1))/eg;
        $data{$key} = $val;}
    return %data; 
}


