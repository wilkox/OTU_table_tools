#!/usr/bin/perl

use Modern::Perl 2014;
use autodie;
use File::Slurp qw(read_file);
use experimental 'smartmatch';
$|++;

my $USAGE = qq/CORRECT USAGE:
... | perl remove_samples_from_OTU_table.pl OTU_list.txt | ...
/;
die $USAGE unless @ARGV == 1;

(my $sampleList) = @ARGV;

#Read in list of samples to remove
my %sampleList = map {$_ => 1} read_file($sampleList, chomp => 1);

#Remove from OTU table
my $index;
my $removed = 0;
say STDERR "Removing samples listed in ", $sampleList, "...";
while (<STDIN>) {

  chomp;
  my @row = split(/\t/, $_);

  #Determine the Sample column from the header
  if ($. == 1) {
    ($index) = grep { $row[$_] ~~ 'Sample' } 0 .. scalar @row;
    die 'Could not find column named "Sample"' . "\n" unless defined $index;
    say $_;
    next;
  }

  if (exists $sampleList{$row[$index]}) {
    ++$removed;
    next;
  };
  say;
}
say STDERR $removed, " rows removed from OTU table";
