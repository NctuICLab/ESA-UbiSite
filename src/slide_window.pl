#! /usr/bin/perl
use strict;
use warnings;

# ./silde_window.pl  win_size  src_file

my $win = $ARGV[0];
my $in = $ARGV[1];
my $out_dir = $ARGV[2];
if (@ARGV < 3){
	print STDERR "perl slide_window.pl window_size inputfile out_dir\n";die;
}
my $half = ($win-1)/2;
my @label;
my @seq;
my $no = 0;
open IN,"<",$in;
while(my $line=<IN>){
	#chomp $line;
	if($line =~ /^>/){
		$no++;
		$label[$no] = $line;
		next;
    }else{
		$line =~ s/ //g;
        $line =~ s/\n//;
        $line =~ s/\r//;
        $seq[$no] .= $line;
    }
}
close IN;

my $list = $out_dir."/".$in."_list";
my $ssss = $out_dir."/".$in."_seq";
open OU,">",$list;
open SE,">",$ssss;

for my $nn (1..$no)
{
	print OU $label[$nn];
	print OU "=".$seq[$nn]."\n";
	#print OU "Peptide\tPosition\n";
	my @seq_filter =();
	my $seq = $seq[$nn];
	my $len = length $seq;
	my @array = split(//,$seq);
	foreach my $ele (@array)
	{
		if($ele =~ m/[QAWSEDCRFVTGYHNMIKLP]/)
		{
				push(@seq_filter,$ele);
		}
	}

	my $seq_clean = join('',@seq_filter);
	#print "$seq_clean\n";
	for my $i (0..$half-1){
		$seq_clean = "_".$seq_clean."_";
	}
	for my $i (0..$len-1){
	    my $center = $i+$half;
	    my $slide_seq = substr $seq_clean, $center, 1;
	    my $terminal = 0;
		#print "$slide_seq\n";
		if($slide_seq eq "K")
		{
			my $B = $center-$half;
			my $E = $center+$half;
			if($B < $half){
				$terminal = 1;
			}
			if($E > $half+$len-1){
				$terminal = 1;
			}
			my $span = $E-$B+1;
			my $slide = substr $seq_clean, $B, $span;
	        my $slide_label = 0;	# modified
		    $slide =~ s/_//g;
			print OU "$slide\t".($i+1)."\n";
			print SE "$slide\t0\n";
			#print $slide."\t".$slide_label."\t".$name."\t".($i+1)."\n";
		}
	}
}
close OU;
close SE;
