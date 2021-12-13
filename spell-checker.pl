#!/usr/bin/env perl
use strict;
use warnings;
use autodie;
use List::Util qw(min);
use List::Util qw(max);

my $nargs= $#ARGV +1;

open DICT, './dictionary.txt';

my %WORDS;

while(<DICT>){
    chomp;
    $WORDS{$_}=$_;
}
my @keys=keys %WORDS;
#print($WORDS{"sunday"});
my $line=0;

open INPUT, $ARGV[0];
open OUTPUT, ">",$ARGV[1];

while(<INPUT>){
    chomp;
    $line++;
    print("line number: $line\n");
    my @word= split(/[^A-Za-z]+/,$_);
    my @non_word= split(/[A-Za-z]+/,$_);
    my @new_word;
    my @suggestions;
    my $s_no=0;
    my $i=0;
    foreach my $index (0..$#word){
        my $w=$word[$index];
        $s_no=0;
        @suggestions=();
        #print "$w";
        if($WORDS{lc $w}){
            $new_word[$i]=$w;
            $i=$i+1;
            #print 1;
        }
        elsif($WORDS{$w}){
            $new_word[$i]=$w;
            $i=$i+1;
            #print 2;
        }
        else{
            if($w eq uc($w)){
                #print(3);
                $new_word[$i]=$w;
                $i=$i+1;
            }

            else{
                #print(4);
                my $error_line="";
                
                foreach my $x (0.. ($index)){
                    if($_!~/^[A-Za-z]/){
                        $error_line = $error_line.$word[$x].$non_word[$x];
                    }
                    else{
                        $error_line = $error_line.$non_word[$x].$word[$x];
                    }
                }

                print("$error_line\n");
                foreach my $y (0.. (length($error_line)-2)){
                    print(" ");
                }
                print("^\n");
                
                foreach my $key (@keys){
                    
                    if(distance($w, $WORDS{$key})<=1){
                        $suggestions[$s_no]=$WORDS{$key};
                        print("wrong word: $w, suggestion no : $s_no $WORDS{$key}","\n");
                        $s_no++;
                    }
                }

                if(length($w)>=2){
                    my $start = 0;
                foreach my $i (0..(length($w)-2)){
                    my $j = substr($w,0,$start).substr($w,$start+1,1).substr($w,$start,1).substr($w,$start+2,length($w)-2-$start);
                    $start++;
                    if($WORDS{$j}){
                        $suggestions[$s_no]=$WORDS{$j};
                        print("wrong word: $w, suggestion no : $s_no $WORDS{$j}","\n");
                        $s_no++;
                    }
                }
                }
                if($s_no>0){
                print "Enter the suggestion number: you want to replace -1 to keep same:";
                chomp(my $num = <STDIN>);
                if($num<0){
                    $new_word[$i]=$w;
                    $i=$i+1;
                }
                else{
                    $new_word[$i]=$suggestions[$num];
                    $i=$i+1;
                }

                print("you chose: $new_word[$i-1]\n");}
                else{
                    print("We could not find the given word in the dictionary that matches given word: Do you want to ignore the word?(y/n) ");
                    chomp(my $answer = <STDIN>);
                    if($answer eq "y"){
                        $new_word[$i]=$w;
                        $i=$i+1;
                    }
                    else{
                        print("Enter the replacement: ");
                        chomp($answer = <STDIN>);
                        $new_word[$i]=$w;
                        $i=$i+1;
                    }
                }
            }
            
        }

    }

    my $len1=$#new_word;
    my $len2=$#non_word;
    my $final_line="";
    foreach my $j (0..max($len1,$len2)){
        if($_!~/^[A-Za-z]/){
        $final_line = $final_line.$new_word[$j].$non_word[$j];
        }
        else{
            $final_line = $final_line.$non_word[$j].$new_word[$j];
        }
    }
    print("$final_line\n");
    print(OUTPUT "$final_line\n");
   
}

close OUTPUT;

#levishetien distance algorithm
#to find out difference between strings
sub distance{
    my ($word1, $word2)=@_;
    
    my @ar1=split(//,$word1);
    my @ar2=split(//,$word2);

    my @d;

    $d[$_][0] = $_ foreach (0 .. @ar1);
    $d[0][$_] = $_ foreach (0 .. @ar2);

    foreach my $i (1..@ar1){
        foreach my $j (1..@ar2){
            my $cost = ($ar1[$i-1] eq $ar2[$j-1])? 0: 1;
            $d[$i][$j]=min($d[$i-1][$j-1]+$cost, $d[$i-1][$j]+1,$d[$i][$j-1]+1 );
        }
    }
    $d[@ar1][@ar2];
}