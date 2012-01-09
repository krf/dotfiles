#!/usr/bin/perl
use strict;
use feature qw( switch );
use Getopt::Euclid;
use List::MoreUtils qw( any );

my %authors;
my $total;
my $files;

my %aliases = split /[,=]/, $ARGV{'-a'};
my @exclude = split(',', $ARGV{'-e'});

sub alias {
   my $alias = shift;
   exists $aliases{$alias} ? $aliases{$alias} : $alias;
}
sub exclude {
   my $file = shift;
   any { $file =~ /^$_/ } @exclude;
}

my @blame_args = ();
given(1) {
   when($ARGV{'-w'}) {
      push @blame_args, '-w'; continue;
   }
   when($ARGV{'-C'}) {
      push @blame_args, '-C'; continue;
   }
}

foreach my $file (`git ls-tree --name-only -r $ARGV{'<rev>'}`) {
   next if exclude $file;
   chomp($file);
   print STDERR "Processing $file\n";
   foreach my $line (`git blame @blame_args $ARGV{'<rev>'} -- "$file"`) {
      chomp($line);
      if (substr($line, 0, 1) eq "^") {
         ++$authors{"*initial checkin"};
      } else {
         $line =~ s[^.*?\((.*?)\s*\d{4}-\d{2}-\d{2}.*][$1];
         ++$authors{alias $line};
      }
      ++$total;
   }
}

print "Total lines: $total\n";
foreach my $author (sort { $authors{$b} <=> $authors{$a} } keys %authors) {
   printf "%12u  %5.2f%%  %s\n",
          $authors{$author},
          $authors{$author} * 100 / $total,
          $author;
}

exit(0);

__END__

=head1 NAME

git-blame-stats - script witch uses git blame to work out who owns how much

=head1 DESCRIPTION

Modified script by Jan Engelhardt which uses the git blame command to work out who owns how much.

Original version: http://dev.medozas.de/gitweb.cgi?p=hxtools;a=blob;f=libexec/git-blame-stats;hb=HEAD
Where I found this script: http://use.perl.org/~acme/journal/39082?from=rss

=head1 OPTIONS

=over

=item <rev>

Revision (default: HEAD).

=for Euclid:
  rev.default: 'HEAD'

=item -e <files>

Exclude the given files. Multiple files may be given separated by commas.

=for Euclid:
  files.type: string
  files.type.error: --files must be given a comma-separated list of files names

=item -a <aliases>

Set aliases of author names as key=value pairs. (e.g. -a John=JohnDoe) Multiple aliases may be given separated by commas.

=for Euclid:
  aliases.type: string, aliases =~ /\A([^=]+=[^=]+)(,[^=]+=[^=]+)*\Z/
  aliases.type.error: --aliases must be given a comma-separated of key=value pairs

=item -w

Ignore whitespace, see: 'git help blame' for details.

=item -C

Detect lines copied from other files, see: 'git help blame' for details.

=back

