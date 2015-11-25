#!/usr/bin/perl

use warnings;
use lib "/home/dba_scripts/oist_stat/Lib";
use common;
use myconstants;
use DB;

use Spreadsheet::WriteExcel;
use MIME::Lite;

my $current_date = "";
my $current_day = "";

$current_date = $ARGV[0];
$current_day = $ARGV[1];
$txt_month = $ARGV[2];

my $excel_file = "/home/dba_scripts/oist_stat/PowerApp_Usage_Report_".$current_date.".xls";
print $excel_file;

my $dbh_hi10 = DB::DBconnect(myconstants::HI10_DB,myconstants::HI10_HOST,myconstants::HI10_USER,myconstants::HI10_PASSWORD);
my @mainRst;
my @rowRst;

# START: Create Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);

# formats
#  Add and define a format
$format = $workbook->add_format(bg_color => 'silver'); # Add a format
$format->set_bold();
$format->set_font('Calibri');
$format->set_size('9');
$format->set_color('black');
$format->set_align('center');
$format->set_border(2);

$format1 = $workbook->add_format(); # Add a format
$format1->set_font('Calibri');
$format1->set_size('9');
$format1->set_color('black');
$format1->set_align('right');
$format1->set_border(1);
$format1->set_num_format('###,###,###,##0');

$format1p = $workbook->add_format(); # Add a format
$format1p->set_font('Calibri');
$format1p->set_size('9');
$format1p->set_color('black');
$format1p->set_align('right');
$format1p->set_border(1);
$format1p->set_num_format('###,###,###,##0.00');


$format2 = $workbook->add_format(bg_color => 'cyan'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('11');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(2);

$format21R = $workbook->add_format(bg_color => 'silver'); # Add a format
$format21R->set_bold();
$format21R->set_font('Calibri');
$format21R->set_size('11');
$format21R->set_color('black');
$format21R->set_align('center');
$format21R->set_border(2);


# START: Worksheet
$worksheet[0] = $workbook->add_worksheet("Summary");
$worksheet[1] = $workbook->add_worksheet("Volume");
$worksheet[2] = $workbook->add_worksheet("Users");
$worksheet[3] = $workbook->add_worksheet("Buys");

   # START: Worksheet Summary / Volume / Users (1st,2nd,3rd)
   # $strMain  = "call sp_generate_month_days('".$current_date."-01')"; -- runs on generate hi10 report
   # $sth_main = $dbh_hi10->prepare($strMain);                                                                                                  
   # $sth_main->execute();
   # print "SQL: $strMain\n";
   $strMain  = "select service, upper(replace(service, 'Service', '')) service_desc, 
                       if (length(replace(service, 'Service', ''))<=5, 6, length(replace(service, 'Service', '')))+2  service_len 
                from powerapp_plan_services_mapping a
                where exists (select 1 from usage_per_plan b where a.service=b.service and left(b.datein,7) = '".$current_date."')
                and   exists (select 1 from unique_subs c where a.service=c.service and left(c.datein,7) = '".$current_date."')
                order by 1,2";
   $sth_main = $dbh_hi10->prepare($strMain);                                                                                                  
   $sth_main->execute();
   $nColCtr=0;
   while (@mainRst = $sth_main->fetchrow()) {
      $row = 2;
      $i=0;
      # Print Column Header
      print "Summary: @mainRst[0], @mainRst[1], @mainRst[2]\n";
      if ($nColCtr == 0) {
         $worksheet[0]->set_column($nColCtr+1, $nColCtr+1, 14);
         $worksheet[1]->set_column($nColCtr+1, $nColCtr+1, 14);
         $worksheet[2]->set_column($nColCtr+1, $nColCtr+1, 14);
         $worksheet[0]->write($row, $nColCtr,   'Date',      $format21R);
         $worksheet[1]->write($row, $nColCtr,   'Date',      $format21R);
         $worksheet[2]->write($row, $nColCtr,   'Date',      $format21R);
         $worksheet[0]->write($row, $nColCtr+1, @mainRst[1], $format21R);
         $worksheet[1]->write($row, $nColCtr+1, @mainRst[1], $format21R);
         $worksheet[2]->write($row, $nColCtr+1, @mainRst[1], $format21R);
      } else {
         $worksheet[0]->set_column($nColCtr,$nColCtr,@mainRst[2]);
         $worksheet[1]->set_column($nColCtr,$nColCtr,@mainRst[2]);
         $worksheet[2]->set_column($nColCtr,$nColCtr,@mainRst[2]);
         $worksheet[0]->write($row, $nColCtr, @mainRst[1], $format21R);
         $worksheet[1]->write($row, $nColCtr, @mainRst[1], $format21R);
         $worksheet[2]->write($row, $nColCtr, @mainRst[1], $format21R);
      }
      # Print Usage per Plan
      $strSQL  = "select DATE_FORMAT(x.tx_date,'%m/%d/%Y'), y.avg_download, y.total, y.uniq 
                  from   tmp_month_days x left outer join (
                         select a.datein datein,
                                round(((a.download+a.upload)/1000000)/b.count,2) avg_download, 
                                round((a.download+a.upload)/1000000,2) total,
                                b.count uniq
                         from   usage_per_plan a, 
                                unique_subs b
                         where  a.datein  = b.datein 
                         and    a.service = b.service 
                         and    b.type='RX'
                         and    a.service = '".@mainRst[0]."'
                         and    left(a.datein,7) = '".$current_date."') y
                  on     (x.tx_date=y.datein)
                  where  left(x.tx_date,7) = '".$current_date."'
                  order  by x.tx_date";
      # print "SQL: $strSQL\n";
      $sth_sql = $dbh_hi10->prepare($strSQL);                                                                                                  
      $sth_sql->execute();
      while (@rowRst = $sth_sql->fetchrow()) {
         $i++;
         if ($nColCtr == 0) {
            $worksheet[0]->write($row+$i, $nColCtr,   @rowRst[0], $format1);
            $worksheet[1]->write($row+$i, $nColCtr,   @rowRst[0], $format1);
            $worksheet[2]->write($row+$i, $nColCtr,   @rowRst[0], $format1);
            $worksheet[0]->write($row+$i, $nColCtr+1, @rowRst[1], $format1p);
            $worksheet[1]->write($row+$i, $nColCtr+1, @rowRst[2], $format1p);
            $worksheet[2]->write($row+$i, $nColCtr+1, @rowRst[3], $format1);
         } else {
            $worksheet[0]->write($row+$i, $nColCtr, @rowRst[1], $format1p);
            $worksheet[1]->write($row+$i, $nColCtr, @rowRst[2], $format1p);
            $worksheet[2]->write($row+$i, $nColCtr, @rowRst[3], $format1);
         }
      }
   
      # Increment Column Counter
      if ($nColCtr == 0) {
         $nColCtr++;
      }
      $nColCtr++;
   }
   $worksheet[0]->merge_range(1,1,1,$nColCtr-1, 'Average Usage per Plan (mb)', $format2);
   $worksheet[1]->merge_range(1,1,1,$nColCtr-1, 'Total Usage per Plan (mb)', $format2);
   $worksheet[2]->merge_range(1,1,1,$nColCtr-1, 'Unique Users per Plan', $format2);
   # END: Worksheet Summary



   # START: Worksheet Buys (4th)
   # $strMain  = "select if(service='ClashofclansService', 'UnlimitedService', service) service, 
   $strMain  = "select service, upper(replace(service, 'Service', '')) service_desc, 
                       if (length(replace(service, 'Service', ''))<=5, 6, length(replace(service, 'Service', '')))+2  service_len
                from powerapp_plan_services_mapping a
                where exists (select 1 from usage_per_plan b where a.service=b.service and left(b.datein,7) = '".$current_date."')
                and   exists (select 1 from unique_subs c where a.service=c.service and left(c.datein,7) = '".$current_date."')
                order by 2";
   $sth_main = $dbh_hi10->prepare($strMain);                                                                                                  
   $sth_main->execute();
   $nColCtr=0;
   while (@mainRst = $sth_main->fetchrow()) {
      $row = 2;
      $i=0;
      # Print Column Header
      # print "Buys: @mainRst[0], @mainRst[1], @mainRst[2]\n";
      if ($nColCtr == 0) {
         $worksheet[3]->set_column($nColCtr+1,$nColCtr+1,@mainRst[2]);
         $worksheet[3]->write($row, $nColCtr,   'Date',      $format21R);
         $worksheet[3]->write($row, $nColCtr+1, @mainRst[1], $format21R);
      } else {
         $worksheet[3]->set_column($nColCtr,$nColCtr,@mainRst[2]);
         $worksheet[3]->write($row, $nColCtr, @mainRst[1], $format21R);
      }
      # Print Usage per Plan
      $strSQL  = "select DATE_FORMAT(x.tx_date,'%m/%d/%Y'), y.no_buys 
                  from   tmp_month_days x left outer join (
                         select a.tran_dt datein, a.hits_tot no_buys 
                         from   powerapp_brand_expiry_dailyrep a, powerapp_plan_services_mapping b 
                         where  a.tran_dt >= concat('".$current_date."', '-01') 
                         and    a.plan=b.plan
                         and    b.service = '".@mainRst[0]."'
                         and    left(a.tran_dt,7) = '".$current_date."'
                         group  by 1 ) y
                  on     (x.tx_date=y.datein)
                  where  left(x.tx_date,7) = '".$current_date."'
                  order  by x.tx_date";
      # print "SQL: $strSQL\n";
      $sth_sql = $dbh_hi10->prepare($strSQL);                                                                                                  
      $sth_sql->execute();
      while (@rowRst = $sth_sql->fetchrow()) {
         $i++;
         if ($nColCtr == 0) {
            $worksheet[3]->write($row+$i, $nColCtr,   @rowRst[0], $format1);
            $worksheet[3]->write($row+$i, $nColCtr+1, @rowRst[1], $format1);
         } else {
            $worksheet[3]->write($row+$i, $nColCtr, @rowRst[1], $format1);
         }
      }
   
      # Increment Column Counter
      if ($nColCtr == 0) {
         $nColCtr++;
      }
      $nColCtr++;
   }
   $worksheet[3]->merge_range(1,1,1,$nColCtr-1, 'Total Buys per Plan', $format2);
   # END: Worksheet Buys


# END: Worksheet

$workbook->close();
 binmode STDOUT;
# END: Create Excel workbook

$from = "powerapp_stats\@chikka.com";
$to = "victor\@chikka.com,ps.java\@chikka.com,jomai\@chikka.com,ra\@chikka.com,ian\@chikka.com,jldespanol\@voyagerinnovation.com";
$cc = "dbadmins\@chikka.com";
#$to = "glenon\@chikka.com";
#$cc = "glenon\@chikka.com";
$Subject = "PowerApp Usage Report, ".$current_day;

# Part using which the attachment is sent to an email #
$msg = MIME::Lite->new(
        From     => $from,
        To       => $to,
                Cc      => $cc,
        Subject  => $Subject,
        Type     => 'File/xls',
        Path     => $excel_file
);

    $msg->attach(
        Type => 'text/html',
        Data => qq{
            <body>
                <p>
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">PowerApp Usage Report for the Month of $txt_month.</span></span></p>
                <p>
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">Please refer to the attachment.</span></span></p>
                <p>
                        &nbsp;</p>
                <div>
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">Regards,</span></span></div>
                <div>
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">CHIKKA DBA TEAM</span></span></div>
                <p>
                        &nbsp;</p>
                <p>
                        <br />
                        &nbsp;</p>
            </body>
        },
    );

print "Mail Sent\n";
$msg->send; # send via default




