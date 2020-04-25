#!/usr/bin/perl
use strict;
use warnings;
my $input = $ARGV[0];
my $output_dir = $ARGV[1];
if(@ARGV < 2){
    print STDERR "ESAUbiSite_main.pl protein.fa output_dir\n";die;
}
$output_dir =~ s/\/$//;
my $aaindex = "src/aaindex/aa";
my $svm_predict = "src/libsvm_320/svm-predict";
my $svm_scale = "src/libsvm_320/svm-scale";
my $svm_scale_range = "src/libsvm_320/svm_scale_range";
if(!-e $aaindex){
    print STDERR "Please build the aaindex program first\n";die;
}
if(!-e $svm_predict){
    print STDERR "Please build the svm-predict program first\n";die;
}
if(!-e $svm_scale){
    print STDERR "Please build the svm-scale program first\n";die;
}
my $html_results = $output_dir."/ESAUbiSite_prediction.html";
if(-e $html_results){
    print STDERR "The results is exist\n";die;
}
my $tmp_dir = $output_dir."/tmp";
my $cmd = "mkdir ".$tmp_dir;
`$cmd`;
print STDERR "Sliding window size is 21\n";
$cmd = "perl src/slide_window.pl 21 ".$input." ".$tmp_dir;
`$cmd`;
my $list = $tmp_dir."/".$input."_list";
my $sliding_seq =  $tmp_dir."/".$input."_seq";
my $sliding_seq_aa = $tmp_dir."/".$input."_aa";
my $sliding_seq_aa_scale = $tmp_dir."/".$input."_scale";
my $svm_predict_output = $tmp_dir."/".$input."_svmpredict";
my $ubi_color_results = $tmp_dir."/".$input."_ubicolor";
$cmd = $aaindex." -A 1 ".$sliding_seq." > ".$sliding_seq_aa;
`$cmd`;
$cmd = $svm_scale." -r ".$svm_scale_range." ".$sliding_seq_aa." > ".$sliding_seq_aa_scale;
`$cmd`;
$cmd = $svm_predict." -b 1 ".$sliding_seq_aa_scale." ESAUbiSite_model ".$svm_predict_output;
`$cmd`;
$cmd = "perl src/color_k.pl ".$list." ".$svm_predict_output." ".$ubi_color_results;
`$cmd`;
$cmd = "php src/generate_html_results.php ".$ubi_color_results." > ".$html_results;
`$cmd`;



