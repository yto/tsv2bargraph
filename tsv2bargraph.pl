#!/usr/bin/env perl
# -*- coding: utf-8 -*-
use strict;
use warnings;
use List::Util qw(max sum);
use Getopt::Long;

my $key_str = 1;
my $width = 50;
my $diff_mode;
my $stack_mode; # 積み上げ棒グラフ
my $graph_type = ""; # default: single, "g": grouped, "s": stacked
my @chs = ();
my $de = "\t";
GetOptions(
    "key=s" => \$key_str,
    "width=s" => \$width,
    "diff" => \$diff_mode,
    "type=s" => \$graph_type,
    "char=s" => \@chs,
    "delim=s" => \$de,
    );

@chs = ("-", "+", ".", "|") if not @chs;
my @keys = map {$_-1} split(",", $key_str);

my @lines = map {chomp; [split($de, $_)]} <>;
my $max = max(map {my $t = $_; map {$t->[$_]||0} @keys} @lines);
$max = max(map {my $t = $_; sum(map {$t->[$_]||0} @keys)} @lines) if $graph_type eq "s";

foreach my $lr (@lines) {
    if (@keys == 1) {
	### bar graph: 普通の棒グラフ (数値が一つの場合)
	my $len = int(($lr->[$keys[0]]) / $max * $width);
	print join($de, @$lr, ($chs[0] x $len))."\n";
    } elsif ($graph_type eq 's' and @keys >= 2) {
	### stacked bar graph : 積み上げ棒グラフ
	my $bar = "";
	for (my $i = 0; $i < @keys; $i++) {
	    my $len = int(($lr->[$keys[$i]]||0) / $max * $width + 0.5);
	    $bar .= $chs[$i] x $len;
	}
	print join($de, @$lr, $bar)."\n";
    } elsif (@keys >= 2) {
	### grouped bar graph: 集合棒グラフ
	for (my $i = 0; $i < @keys; $i++) {
	    my $len = int(($lr->[$keys[$i]]||0) / $max * $width);
	    my @cs = map {$_ == $keys[$i] ? $lr->[$_]."*" : $lr->[$_]} 0..$#$lr;
	    print join($de, @cs, ($chs[$i%@chs] x $len))."\n";
	}
    } else {
	die;
    }
}
