#!/usr/bin/perl -w
use JSON;
use Data::Dumper;
use Cwd;
use File::Basename;
use strict;

my $baseDir = dirname(__FILE__);
my $cwd = getcwd;
my $json = JSON->new->allow_nonref;

my @testcases=`cat $baseDir/testcase`;

for my $tcase (@testcases) {
	chomp $tcase;
	if ($tcase eq "") {
		next;
	}
	&calcMaxTTps($tcase);
}
print "Finished";
sub calcMaxTTps($) {
	my $dir = shift;
	my @files=`find $cwd/$dir -name simp*.log`;

	if(@files < 1) {
		print "find no files\n";
		return;
	}
	
	my @save=();
	for my $file (@files) {
		chomp $file;
		push @save, &parseFile($file);
	}
	
	my @maxLenSave=();
	my $maxIdx=0;
	
	for (my $idx=0; $idx< @save; $idx++) {
		my $tmp = $save[$idx];
		my $len = @$tmp;
		my $maxLen=@maxLenSave;
	
		if($len > $maxLen) {
			@maxLenSave = @$tmp; # here need to convert to array
			$maxIdx = $idx;
		}
	}
	# delete maxLenSave element
	splice(@save, $maxIdx, 1);
	
	my $maxTTps = -1;
	for my $select (@maxLenSave) {
	    # {"time":1345461180 ,"avgTps":1452 ,"count":50000 ,"duration":34414 ,"fail":0 ,"tTps":1416 ,"tCount":391 ,"tDuration":276 ,"tFail":0}
		my $time = $select->{time};
		my $avgTps = $select->{avgTps};
		my $count = $select->{count};
		my $duration = $select->{duration};
		my $fail = $select->{fail};
		my $tTps = $select->{tTps};
		my $tCount = $select->{tCount};
		my $tDuration = $select->{tDuration};
		my $tFail = $select->{tFail};
	
		my $countTTps = $tTps;
		for my $otherFile (@save) {
			my $matchIdx = 0;
			for my $cmpLine (@$otherFile) {
				if ($time > $cmpLine->{time}) {
					$matchIdx ++;
				} else {
					# check if time is earlier current file.
					if ($matchIdx <= 0 && abs($time - $cmpLine->{time}) > 5) {
						$matchIdx = -1;
					}
					last;
				}
			}
			my $otherCount = @$otherFile;
			if($matchIdx >= $otherCount || $matchIdx < 0) {
				last;
			}
			my $curLine = @$otherFile[$matchIdx];
			$countTTps += $curLine->{tTps};
		}
		if ($countTTps > $maxTTps) {
			$maxTTps = $countTTps;
		}
	}
	
	print $maxTTps . "\n";
}
sub parseFile($) {
	my $f = shift;
	open(FILE, $f)||die "fail to open file.";
	my @lines=();
	while(<FILE>) {
		my $line = "$_";
		if ($line =~ /time/) {
			# change string to date
			my $time = substr($line, 6, 25);
			my $secs = `date -d $time +%s`;
	
			$secs = substr($secs, 0, 10);
			$line =~ s/$time/$secs/g;
	
			# formate line
			chomp $line;
			$line =~ s/:/\":/g;
			$line =~ s/,/,\"/g;
			$line =~ s/{/{\"/g;
			$line =~ s/N\/A/0/g;

			my $obj = $json->decode($line);
			push @lines ,$obj;
		}
	}
	close(FILE);
	return \@lines;
}
