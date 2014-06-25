#!/usr/bin/perl

use Modern::Perl 2014;
use autodie;
use experimental 'smartmatch';
$|++;

#Get arguments
my $USAGE = q/USAGE:
perl add_taxonomy.pl <tidy OTU table> <rep set taxonomic assignments> > OTU_table_w_taxonomy.tidy.txt
/;
(my $OTUTable, my $repSetAssignments) = @ARGV or die $USAGE;

#Read in rep set taxonomic assignments
my %taxonomy;
open TAXA, '<', $repSetAssignments or die $USAGE;
say STDERR "Reading taxonomic assignments from $repSetAssignments";
while (<TAXA>) {

  #print STDERR "\r$. OTUs read" unless $. % 1000;
  (my $OTU, my $lineage) = split(/\t/, $_);

  $lineage =~ s/.__//g;
  $lineage =~ s/;\s/\t/g;
  $taxonomy{$OTU} = $lineage;

}
#say STDERR "\r$. OTUs read";
close TAXA;

#Add taxonomy to OTU table
my $OTUIndex;
say STDERR "Adding taxonomy to OTU table $OTUTable";
open TABLE, '<', $OTUTable;
while (<TABLE>) {

  print STDERR "\r$. lines processed" unless $. % 1000;
  chomp;
  my @row = split(/\t/, $_);

  if ($. == 1) {
    ($OTUIndex) = grep { $row[$_] ~~ 'OTU' } 0 .. scalar @row;
    die 'Could not find column named "OTU"' . "\n" unless defined $OTUIndex;
    say $_, "\t", join("\t", qw(Kingdom Phylum Class Order Family Genus Species));
    next;
  }

  my $OTU = $row[$OTUIndex];
  unless (exists $taxonomy{$OTU}) {
    warn "No known taxonomy for OTU $OTU";
  }
  say $_, "\t", $taxonomy{$OTU};

}
say STDERR "\r$. lines processed";
close TABLE;
