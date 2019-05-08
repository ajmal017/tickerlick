#!d:\perl\bin\perl
#------------------------------------------------------------------------
#Author : Thomas Thaliath 
#Program File: rep_site_cat_total.pl
#Date started : 10/29/03
#Last Modified : 10/30/03
#desc :  A report to sum the total category count by site
use strict;
use DB_File;
use DBI;  

my ($dbh,$site_rank,%url,$c,$page_rank,$query2,$key,%hash,%hash1,$d,$e,$f,$query3,$val,$cid,$query1,$site_id,$cat,$site_hash,$site_desc,%site_hash);  


$dbh = open_dbi();


$query3= $dbh->prepare ('select site_id,site_url,site_rank from site_master ') || die $query3->errstr;
$query3->execute();
while(($site_id,$site_desc,$site_rank)= $query3->fetchrow_array())
{
    
   
   $site_hash{$site_id} = $site_rank;
   $url{$site_id} = $site_desc;
}

$query3->finish;

my ($i) = 0;

$query2 = $dbh->prepare ( 'select site_id,sum(link_cat_rank) from link_cat_rank group by site_id ' ) || die $query2->errstr;

$query2->execute();
while(($c,$d)= $query2->fetchrow_array())
{
   
   #$page_rank = log(1+$site_hash{$a})*(log(1+$c)+log(1+$d));
   #$page_rank = sprintf("%d.4f",$page_rank);
   $hash{$c} = $d;
   
}

foreach $key(sort {$hash{$b} <=> $hash{$a}} keys (%hash) )
{
    $i++;
    print "$i\t$url{$key}\t$hash{$key}\t$site_hash{$key}\n";
}
$query2->finish;

$dbh->disconnect();

print "total rows: $i\n";
exit 1;

sub open_dbi
{
   # Declare and initialize variables
   my $host = 'localhost';
   my $db = 'ishtaar';
   my $db_user = 'thaliath';
   my $db_password = '69dimple';

   # Connect to the requested server

   my $dbh = DBI->connect("dbi:mysql:$db:$host", "$db_user", "$db_password") 
      or err_trap("Cannot connect to the database");
   return $dbh;
}#end: open_dbi

#==================== [ err_trap ] ==================== 
sub err_trap 
{
   my $error_message = shift(@_);
   die "$error_message\n  
      ERROR: $DBI::err ($DBI::errstr)\n";
}#end: err_trap

