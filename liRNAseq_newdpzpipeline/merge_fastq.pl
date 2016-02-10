#!/usr/bin/perl
use warnings;
use strict;
use IO::Uncompress::Bunzip2 qw(bunzip2 $Bunzip2Error) ;

# Merge together two FastQ files
# Now accepts .bz2 compressed files as inputs
# Usage is merge_fastq.pl [read1 file] [read2 file] [outfile]

my ($in1,$in2,$out) = @ARGV;

die "Usage is merge_fastq.pl [read1 file] [read2 file] [outfile]\n" unless ($out);

my $IN1; my $IN2;
if ( $in1 =~ /\.bz2$/i ) {
     $IN1 = new IO::Uncompress::Bunzip2 $in1 
	 or die "IO::Uncompress::Bunzip2 failed: $Bunzip2Error\n";
} else { open ($IN1,$in1) or die "Can't open $in1: $!"; }

if ( $in2 =~ /\.bz2$/i ) {
    $IN2 = new IO::Uncompress::Bunzip2 $in2
	or die "IO::Uncompress::Bunzip2 failed: $Bunzip2Error\n";
} else { open ($IN2,$in2) or die "Can't open $in2: $!"; }

open (OUT,'>',$out) or die "Can't write to $out: $!";

my $count;
while (1) {
    ++$count;
    my $line1 = <$IN1>;
    my $line2 = <$IN2>;

    last unless (defined $line1 and defined $line2);

    if ($count % 2) {
	print OUT $line1;
    }
    else {
	chomp $line1;
	print OUT $line1,$line2;
    }

}
