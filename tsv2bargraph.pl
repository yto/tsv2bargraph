#!/usr/bin/env perl
# -*- coding: utf-8 -*-
use strict;
use warnings;
use List::Util qw(max);
use Getopt::Long;

my $key_str = 1;
my $width = 50;
my $diff_mode;
my @chs = ("-", "+", ".", "|");
my $de = "\t";
GetOptions(
    "key=s" => \$key_str,
    "width=s" => \$width,
    "diff" => \$diff_mode,
    "char=s" => \@chs,
    "delim=s" => \$de,
    );

my @keys = map {$_-1} split(",", $key_str);

my @lines = map {chomp; [split($de, $_)]} <>;
my $max = max(map {my $t = $_; map {$t->[$_]||0} @keys} @lines);

foreach my $lr (@lines) {
    if ($diff_mode and @keys == 2) { # diff mode : 2つの数値をマージして比較
	my @lens = map {int(($lr->[$keys[$_]]||0) / $max * $width)} (0, 1);
	my $i = $lens[0] <= $lens[1] ? 0 : 1;
	my $bar = ($chs[$i] x $lens[$i]).($chs[$i-1] x abs($lens[0]-$lens[1]));
	print join("\t", @$lr, $bar)."\n";
    } elsif (@keys >= 2) { # 2つ以上の数値を複数行で表示
	for (my $i = 0; $i < @keys; $i++) {
	    my $len = int(($lr->[$keys[$i]]||0) / $max * $width);
	    my @cs = @$lr;
	    $cs[$keys[$i]] .= "*";
	    print join("\t", @cs, ($chs[$i%@chs] x $len))."\n";
	}
    } elsif (@keys == 1) { # 数値が一つの場合
	my $len = int(($lr->[$keys[0]]) / $max * $width);
	print join("\t", @$lr, ($chs[0] x $len))."\n";
    } else {
	die;
    }
}
