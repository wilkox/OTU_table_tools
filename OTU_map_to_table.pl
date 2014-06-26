#!/usr/bin/perl

use Modern::Perl 2013;
use autodie;
$|++;

my $USAGE = q/USAGE:
perl OTU_map_to_table.pl final_otu_map_mc2.txt > OTU_table.tidy.txt
/;

my $map = shift or die $USAGE;

my %count;

say STDERR "Reading OTU map file $map";

open MAP, "<", $map;
while (<MAP>) {

  chomp;
  print STDERR "\r$. OTUs read" unless $. % 100;
  
  my @row = split(/\t/, $_);
  my $OTU = shift(@row);

  foreach (@row) {
    (my $sample) = parse_read($_);
    $count{$sample}{$OTU}++;
  }
  
}
say STDERR "\r$. OTUs read";
close MAP;

#Write output table
say STDERR "Producing tidy OTU table...";
say "Sample\tOTU\tCount";
foreach my $sample (sort(keys(%count))) {
  foreach my $OTU (sort(keys(%{$count{$sample}}))) {
    say "$sample\t$OTU\t$count{$sample}{$OTU}";
  }
}
say STDERR "Done";

sub parse_read {

  my $read = shift;

  if ($read =~ /^([^\|]+)\|/) {
    return $1;
  } else {
    die "Could not parse sample name from $read";
  }
}
