#!/usr/bin/perl

use Modern::Perl 2014;
use autodie;
use File::Slurp qw(read_file);
use experimental 'smartmatch';
$|++;

my $USAGE = qq/CORRECT USAGE:
perl remove_samples_from_OTU_table.pl <sample_list.txt> <OTUTable.txt> > <filtered_OTU_table.txt>
/;
die $USAGE unless @ARGV;

(my $sampleList, my $OTUTable) = @ARGV;

#Read in list of samples to remove
my %sampleList = map {$_ => 1} read_file($sampleList, chomp => 1);

#Remove from OTU table
open IN, '<', $OTUTable;
my $index;
while (<IN>) {

  chomp;
  my @row = split(/\t/, $_);

  #Determine the Sample column from the header
  if ($. == 1) {
    ($index) = grep { $row[$_] ~~ 'Sample' } 0 .. scalar @row;
    die 'Could not find column named "Sample"' . "\n" unless defined $index;
    say $_;
    next;
  }

  next if exists $sampleList{$row[$index]};
  say;
}
close IN;
