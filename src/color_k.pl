#! /usr/bin/perl

$list = $ARGV[0];
$out = $ARGV[1];
$result = $ARGV[2];
if(@ARGV < 3){
	print STDERR "perl color_k.pl fasta_list svmpredict_results output\n";die;
}
open LI, $list;
open OU, $out;
open RE, ">$result";
$i=0;
$j=0;
$now_pos = 0;
$count = 0;
$each_count = 0;
@sample =();
while(<LI>){
	if(/^>/){
		next;
	}
	if(/^=/){
		$seq[$j] = $_;
		$j++;
		next;
	}
	@l = split;
	$pep[$i] = $l[0];
	$pos[$i] = $l[1];
	if($pos[$i] > $now_pos)
	{
		$now_pos = $pos[$i];
		$sample[$count] = $each_count;
		$each_count++;
		#print "sample[$count] = $sample[$count]\n";
	}
	else
	{
		$count++;
		$each_count = 0;	
		$now_pos = $pos[$i];
		$sample[$count] = $each_count;
		$each_count++;	
		#print "sample[$count] = $sample[$count]\n";	
	}
	$i++;
}
#print "sample[0] = $sample[0]\n";
#print "sample[1] = $sample[1]\n";
$i=0;
while(<OU>){
	@l = split;
	#print "$l[0] $l[2]\n";
	if($l[0] eq "labels"){next;}
	else
	{
		$lab[$i] = $l[0];
        	$pob[$i] = $l[2];
        	$i++;
	}
}
#print "i=$i j=$j\n";
#die;
#print "\n============\n";
$no_ubi = 0;
for $m (0..$j-1){#No. of sample
	$seq[$m] =~ s/K/k/g;
	$length = length $seq[$m];
	$tmp_seq="";
	for($p=1; $p+70<$length; $p=$p+70){
		$sub = substr($seq[$m], $p, 70);
		$tmp_seq = $tmp_seq.$sub."<br>";
	}
	$sub = substr($seq[$m], $p);
	$seq[$m] = "=".$tmp_seq.$sub."<br>";
	for $n (0..$sample[$m]){#No. of cut sample
		if($lab[$no_ubi]==1){
			#$seq[$m] =~ s/k/<u><b><font color=#bb00bb>K<\/Font><\/b><\/u>/; 
			$seq[$m] =~ s/k/<u title="Position: $pos[$no_ubi];  Ubiquitylation: Y;  Score: $pob[$no_ubi]"><font color=#ff00ff>K<\/Font><\/u>/; 
			#print "$pos[$n] $pob[$n]\n";
			#print "$seq[$m]\n";
		}
		if($lab[$no_ubi]==0){
			#$seq[$m] =~ s/k/<u><b>K<\/b><\/u>/;	
			$seq[$m] =~ s/k/<u title="Position: $pos[$no_ubi];  Ubiquitylation: N;  Score: $pob[$no_ubi]"><font color=#bbbbbb>K<\/Font><\/u>/;
			#print "$pos[$n] $pob[$n]\n";
			#print "$seq[$m]\n";
		}
		$no_ubi++;
	}
	#print "\n==================\n";
}
seek LI,0,0;

$i=0;
$j=0;
while(<LI>){
	if(/^>/){
		print RE $_;
		next;
	}
	if(/^=/){
		#print "$seq[$j]\n";
		print RE $seq[$j]."\n";
		$j++;
		next;
	}
	#print "$pos[$i] $pep[$i] $lab[$i] $pob[$i]\n";
	print RE $pos[$i]."\t".$pep[$i]."\t".$lab[$i]."\t".$pob[$i]."\n";
	$i++;
}
close RE;
close OU;
close LI;
