#!/usr/bin/env perl

use Modern::Perl 2014;
use autodie;
use File::Slurp qw(read_file);
use experimental 'smartmatch';
$|++;

my $USAGE = qq/CORRECT USAGE:
... | perl remove_OTUs_from_OTU_table.pl OTU_list.txt | ...
/;
die $USAGE unless @ARGV == 1;

(my $OTUList) = @ARGV;

#Read in list of OTUs to remove
my %OTUList = map {$_ => 1} read_file($OTUList, chomp => 1);

#Remove from OTU table
my $index;
my $removed = 0;
say STDERR "Removing OTUs listed in ", $OTUList, "...";
while (<STDIN>) {

  chomp;
  my @row = split(/\t/, $_);

  #Determine the OTU column from the header
  if ($. == 1) {
    ($index) = grep { $row[$_] ~~ 'OTU' } 0 .. scalar @row;
    die 'Could not find column named "OTU"' . "\n" unless defined $index;
    say $_;
    next;
  }

  if (exists $OTUList{$row[$index]}) {
    ++$removed;
    next;
  };
  say;
}
say STDERR $removed, " rows removed from OTU table";
