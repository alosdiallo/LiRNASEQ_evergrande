#!/usr/bin/perl
use warnings;
use strict;
use List::MoreUtils qw(any);

# Moves barcode to sequence name
# New sequence header line format is: @[header string]:[barcode]:::[unique molecular barcode N4]
# Barcode 1 = 1-8                                                                                                                                          # W1 = 22nt starting from 9,10,11,12 - removed
# UMI = 4 nucleotides starting from 9-12
# Usage is add_umi_to_id.pl [header string] [inputfile] [outfile] [BC start] [BC length] [UMI start] [UMI length]
# Requires fastq file, 4 lines per record, no header lines

my ($hdrStr,$in,$out, $BCstart,$BClen, $UMIstart,$UMIlen) = @ARGV;

die "Usage is move_bc_to_SeqName.pl [header string] [inputfile] [outfile] [BC start position (1 based)] [BC length] [UMI start] [UMI length]  \n" unless ($out);

open (IN,$in) or die "Can't open $in: $!";
open (OUT,'>',$out) or die "Can't write to $out: $!";

my $count; # number reads

while (1) {
    my $header = <IN>;
    last unless (defined $header);
    my $seqStr = <IN>;
    my $spc = <IN>;
    my $QStr = <IN>;
    ++$count;

    my $bc1 = substr($seqStr, $BCstart-1,$BClen);
    my $bcMol = substr($seqStr, $UMIstart-1,$UMIlen);
    my $bc = $bc1 .": :". $bcMol;
    my $bcSample = $bc1 .":" ;

    print OUT "@",$hdrStr,":",$bcSample,":",$count,":",$bcMol,"\n"; # Header
    print OUT $seqStr;
    print OUT $spc;
    print OUT $QStr;
    
} # end of while loop for reading input

print STDOUT "Total of ",$count," sequences\n";