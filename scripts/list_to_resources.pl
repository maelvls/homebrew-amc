#!/usr/bin/env perl
#
# Before running this script, run:
#   cpan i MetaCPAN::Client
#
# Lines must be of form (spaces and the comma are ignored):
#  ```
#      XML::Writer
#      Locale::Language
#      IO::Socket::SSL
#        Net::SSLeay
#        Mozilla::CA
#      Authen::SASL
#        Digest::HMAC_MD5
#  ```

use MetaCPAN::Client;
my $mcpan  = MetaCPAN::Client->new();
my %already_seen = ();
foreach my $line ( <STDIN> ) {
    chomp($line);
    $line =~ s/^\s*([A-Za-z:_0-9]*)\s*$/\1/;
    my $package = $mcpan->package($line);
    if (! exists($already_seen{$line})) {
        $already_seen{$line} = 1;
        my $url = "https://cpan.metacpan.org/authors/id/".$package->file();
        chomp(my $sha256 = `curl -sSL $url | sha256sum | cut -d' ' -f1`);
        print "resource \"$line\" do\n";
        print "  url \"".$url."\"\n";
        print "  sha256 \"".$sha256."\"\n";
        print "end\n";
    }
}
