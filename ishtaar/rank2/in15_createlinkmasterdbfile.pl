#!/usr/bin/perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: in15_createlinkmasterdbfile.pl
#Date started : 10/15/03
#create linkmaster DB file from linkmetadata text file.


use strict;
use DB_File;


my $fullname;
my $file;
my ($id,$temp,$page_url,$link_text,$page_type,$title,%hash);
my @sub_list;

my $i = 0;
my ($key);
system('rm linkmasterdbfile.txt');
my $linkfilename = 'linkmasterdbfile.txt';
tie (%hash, 'DB_File', $linkfilename, O_CREAT|O_RDWR, 0644, $DB_BTREE) || die $!;

my ($filename) = "linkmetadata.txt";


open (F,"$filename");
while (<F>)
{
$i++;
chomp;
($id,$temp,$page_url,$link_text,$page_type,$title) = split(/\t/,$_);
$hash{$id} = "$page_url\t$link_text\t$title\t$page_type";
}

close (F);
untie %hash;
print "$i links processed\n";
exit 1;
