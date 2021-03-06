#!/usr/bin/perl

use warnings;
use lib "/home/dba_scripts/oist_stat/Lib";
use common;
use netcast_rep_constants;
use DB;
use Spreadsheet::WriteExcel;
#use MIME::Lite;
use Email::MIME;

$tdate = $ARGV[0];
$vnum = $ARGV[1];
#$txt_month = $argv[2];
#$vday=substr($tdate,8);


#my $excel_file = "/home/dba_scripts/oist_stat/netcast_migration_report_company_".$tdate.".xls";
my $excel_file = "/home/netcast_migration/stats/netcast_migration_report_company_".$tdate."_".$vnum.".xls";
print $excel_file;

my $smartBro = DB::DBconnect(netcast_rep_constants::netcast_DB,netcast_rep_constants::netcast_HOST,netcast_rep_constants::netcast_USER,netcast_rep_constants::netcast_PASSWORD);

# create a new excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);
my $sth_rt;
my @rowrst;

#  add and define a format

$format_values11 = $workbook->add_format(fg_color => 9,bold=>0,font=>'calibri',size=>11,color=>'black',align=>'right',valign=>'vcenter',border=>1,);

$format2 = $workbook->add_format(fg_color => 9,bold=>0,font=>'calibri',size=>11,color=>'black',align=>'left',valign=>'vcenter',border=>1,num_format => '#');
$format3 = $workbook->add_format(fg_color => 'white',bold=>1,font=>'calibri',size=>12,color=>'black',align=>'center',valign=>'vcenter',border=>2,);
$format4 = $workbook->add_format(fg_color => 'white',bold=>1,font=>'calibri',size=>14,color=>'black',align=>'center',valign=>'vcenter',border=>2,);

#add worksheets
my $tab1 = $workbook->add_worksheet("contacts_users_group");
my $tab2 = $workbook->add_worksheet("v3listofcontactspergroup");
my $tab3 = $workbook->add_worksheet("v4listofcontactspergroup");
my $tab4 = $workbook->add_worksheet("migratedgroupscontactssummary");
my $tab5 = $workbook->add_worksheet("V3 Validation Report");
 my $tab6 = $workbook->add_worksheet("Unsupported MSISDN");
# set columns and rows
$tab1->set_column('a:u',15);
$tab2->set_column('a:b',25);
$tab2->set_column('c:c',15);
$tab2->set_column('d:g',35);
$tab2->set_column('h:k',10);
$tab2->set_column('j:j',25);


$tab3->set_column('a:b',25);
$tab3->set_column('c:c',15);
$tab3->set_column('d:g',35);
$tab3->set_column('h:k',10);
$tab3->set_column('j:j',25);


$tab4->set_column('a:h',35);
$tab5->set_column('a:h',35);

#$tab5->set_column('a:b',25);
#$tab5->set_column('c:c',15);
#$tab5->set_column('d:g',35);
#$tab5->set_column('h:k',10);
#$tab5->set_column('j:j',25);

#$tab6->set_column('a:h',35);

##tab 1
#$tab1->write('a3','Date',$format_date);
#$tab1->merge_range('b3:d3','Countries',$format2);

$tab1->write('a1',"V3_user_id",$format3);
$tab1->write('b1',"V4_user_id",$format4);
$tab1->write('c1',"Owner/user",$format3);
$tab1->write('d1',"Role",$format3);
$tab1->write('e1',"Status",$format4);
$tab1->write('f1',"V3 Total Contacts",$format3);
$tab1->write('g1',"Active Contacts",$format4);
$tab1->write('h1',"Contacts w/ msisdn",$format3);
$tab1->write('i1',"Deactivated Contacts",$format4);
$tab1->write('j1',"Invalid Msisdn Length",$format3);
$tab1->write('k1',"Unsupported Carrier",$format4);
$tab1->write('l1',"Contacts w/o msisdn",$format3);
$tab1->write('m1',"Duplicate Msisdn",$format4);
$tab1->write('n1',"Contacts Transferred To Admin",$format3);
$tab1->write('o1',"Total Migrated",$format4);
$tab1->write('p1',"V3 Total Groups",$format3);
$tab1->write('q1',"Active Group",$format4);
$tab1->write('r1',"Deactivated Group",$format3);
$tab1->write('s1',"Group Transferred To Admin",$format3);
$tab1->write('t1',"Split Groups",$format3);
$tab1->write('u1',"Total Migrated Groups",$format3);


my $row=0;
my $i=0;
my $col=0;
$strgetstat="SELECT * FROM vw_reps;";
       
$sth_rt = $smartBro->prepare($strgetstat);
$sth_rt->execute();
while (my @rowRst = $sth_rt->fetchrow()) {
   $i++;
   for ( $f=0; $f <= 20; $f++) {
      $tab1->write($row+$i, $col+$f,    $rowRst[$f], ($i % 2 ==0)? $format_values11 : $format_values11);
   }
}

## tab2
$tab2->write('a1',"GROUP NAME",$format3);
$tab2->write('b1',"V3 CONTACT OWNER",$format4);
$tab2->write('c1',"MOBILE NAME",$format3);
$tab2->write('d1',"LAST NAME",$format3);
$tab2->write('e1',"FIRST NAME",$format4);
$tab2->write('f1',"MIDDLE NAME",$format3);
$tab2->write('g1',"EMAIL",$format4);
$tab2->write('h1',"AGE",$format3);
$tab2->write('i1',"GENDER",$format4);
$tab2->write('j1',"ADDRESS",$format3);
$tab2->write('k1',"Birthday",$format4);


$row=0;
$i=0;
$col=0;
$strgetstat="SELECT c.name,
                    e.name,
                    concat('639',d.msisdn) as msisdn,
                    a.alias as last_name,
                    a.name as first_name,
                    a.alias as middle_name,
                    a.email as email, 
                    if(a.age='0',' ',a.age) as age,
                    a.gender as gender,
                    a.address as address,
                    if(a.birthday='0000-00-00',' ',a.birthday) as birthday
             FROM  netcast3_db.group_tb c 
             LEFT OUTER JOIN netcast3_db.contacts_group_tb b on (c.id = b.group_id and b.status_flag in(1,0))
             LEFT OUTER JOIN netcast3_db.contacts_tb2 a  ON (a.id = b.contact_id and  a.status_flag = 1)
             LEFT OUTER join  netcast3_db.msisdn_tb d ON (a.msisdn_id=d.id)
             left OUTER join netcast3_db.users_tb e ON (a.user_id = e.id) 
             WHERE c.company_id= ".$tdate."
             AND   c.status_flag = 1 
             group by d.id, c.id
             order by 1, 2,c.name, d.msisdn";

$sth_rt = $smartBro->prepare($strgetstat);
$sth_rt->execute();
while (my @rowRst = $sth_rt->fetchrow()) {
   $i++;
   for ( $f=0; $f <= 10; $f++) {
      $tab2->write($row+$i, $col+$f,    $rowRst[$f], ($i % 2 ==0)? $format2 : $format2);
}
                                                                                                                                                                                              }

#tab3
$tab3->write('a1',"GROUP NAME",$format3);
$tab3->write('b1',"V3 USERNAME",$format4);
$tab3->write('c1',"MOBILE NUMBER",$format3);
$tab3->write('d1',"LAST NAME",$format3);
$tab3->write('e1',"FIRST NAME",$format4);
$tab3->write('f1',"MIDDLE NAME",$format3);
$tab3->write('g1',"EMAIL",$format4);
$tab3->write('h1',"AGE",$format3);
$tab3->write('i1',"GENDER",$format4);
$tab3->write('j1',"ADDRESS",$format3);
$tab3->write('k1',"BIRTHDAY",$format4);


$row=0;
$i=0;
$col=0;

$strgetstat="SELECT b.group_name as group_name,
                    c.name as contact_owner,
                    d.msisdn as mobile_number,
                    d.last_name as last_name,
                    d.first_name as first_name,
                    d.middle_name as middle_name,
                    d.email as email,
                    if(d.info1='0',' ',d.info1) as age,
                    d.info2 as gender,
                    d.info3 as address,
                    if(d.info4='0000-00-00',' ',d.info4) as birthday
             FROM netcast_db_migrate.groups b 
             LEFT JOIN netcast_db_migrate.groups_contacts a on a.group_id=b.group_id
             LEFT JOIN netcast_db_migrate.users c on a.new_user_id=c.user_id
             LEFT JOIN netcast_db_migrate.contacts d on a.contact_id=d.contact_id";

$sth_rt = $smartBro->prepare($strgetstat);
$sth_rt->execute();
while (my @rowRst = $sth_rt->fetchrow()){
   $i++;
   for ( $f=0; $f <= 10; $f++) {
      $tab3->write($row+$i, $col+$f,    $rowRst[$f], ($i % 2 ==0)? $format2 : $format2);
   }
}

#tab4
$tab4->write('a1',"Company_id",$format3);
$tab4->write('b1',"V3 GroupName",$format4);
$tab4->write('c1',"V3 GroupOwner",$format3);
$tab4->write('d1',"V3 TotalContacts",$format3);
$tab4->write('e1',"V4 GroupCreated",$format4);
$tab4->write('f1',"V4 GroupAssigned",$format3);
$tab4->write('g1',"V4 GroupTotalContacts",$format4);
#$tab4->write('h1',"V4 Duplicate/s",$format4);


$row=0;
$i=0;
$col=0;

$strgetstat="select v3.v3_company_id,
                    v3.v3_group_name,
                    v3.v3_user,
                    v3.v3_total_contacts,
                    v4.v4_group_name,
                    v4.v4_contact_owner,
                    v4.v4_total_contacts
                    -- dup.duplicates
             from (
                   select x.v3_company_id, 
                          x.v3_group_name,
                          x.v3_user,
                          x.id v3_gid,
                          count(msisdn) as v3_total_contacts
                   from (
                          SELECT e.company_id v3_company_id,
                                 c.name v3_group_name,
                                 c.user_id,
                                 c.id,
                                 e.name as v3_user, 
                                 concat('639',d.msisdn) as msisdn
                          FROM   netcast3_db.group_tb c
                          LEFT JOIN netcast3_db.contacts_group_tb b ON (c.id = b.group_id and b.status_flag =1) 
                          LEFT JOIN netcast3_db.contacts_tb2 a ON (a.id = b.contact_id and a.status_flag = 1) 
                          LEFT JOIN netcast3_db.msisdn_tb d ON (a.msisdn_id = d.id)
                          LEFT JOIN netcast3_db.users_tb e ON (e.id = c.user_id)
                          WHERE c.status_flag = 1
                          GROUP by d.id, c.id  order by 1, c.name
                        ) x 
                   group by x.user_id, x.v3_group_name
                  ) v3
             inner join ( select c.group_name as v4_group_name,
                                 c.user_id as v4_user_id ,
                                 b.contact_id as v4_contact_id,
                                 c.old_group_id as v4_group_id,
                                 c.date_created AS v4_date_created,
                                 d.name as v4_contact_owner,
                                 c.group_id as group_id,
                                 count(b.msisdn) as v4_total_contacts
                          from netcast_db_migrate.groups c
                          left join  netcast_db_migrate.groups_contacts a on a.group_id=c.group_id
                          left join netcast_db_migrate.contacts b on a.contact_id=b.contact_id
                          left join netcast_db_migrate.users d on a.new_user_id=d.user_id
                          group by 1,2,4
                        ) v4 on (v3.v3_gid=v4.v4_group_id)";

$sth_rt = $smartBro->prepare($strgetstat);
$sth_rt->execute();
while (my @rowRst = $sth_rt->fetchrow()) {
   $i++;
   for ( $f=0; $f <= 6; $f++) {
      $tab4->write($row+$i, $col+$f,    $rowRst[$f], ($i % 2 ==0)? $format2 : $format2);
   }
}



#tab5
$tab5->write('a1',"Group Name",       $format4);
$tab5->write('b1',"Group ID",         $format3);
$tab5->write('c1',"Group Owner",      $format3);
$tab5->write('d1',"MSISDN",           $format3);
$tab5->write('e1',"Contact Owner ID", $format3);
$tab5->write('f1',"Group Member",     $format3);


$row=0;
$i=0;
$col=0;

$strgetstat="SELECT if (a.user_id <> c.user_id, concat(c.name,'_',a.user_id), concat(c.name) ) as Group_Name, 
                    c.id as group_id, 
                    concat(e.name,'_',e.id) as group_owner_name, 
                    -- nilagay ko lang ito para makita ko kung ano yung user name and id niya
                    concat('639',d.msisdn) as msisdn, 
                    a.user_id as contact_owner_id, 
                    b.status_flag as group_member 
             FROM  netcast3_db.group_tb c 
                   left outer join netcast3_db.contacts_group_tb b on (c.id = b.group_id and b.status_flag in (1,0))
                   left outer join netcast3_db.contacts_tb a on (a.id = b.contact_id and a.status_flag = 1)
                   left outer join netcast3_db.msisdn_tb d on (a.msisdn_id = d.id )
                   left outer join netcast3_db.users_tb e on (c.user_id = e.id)
             WHERE c.company_id = ".$tdate." 
             AND   c.status_flag = 1 
             group by d.id, c.id order by 1, c.name, d.msisdn";

$sth_rt = $smartBro->prepare($strgetstat);
$sth_rt->execute();
while (my @rowRst = $sth_rt->fetchrow()) {
   $i++;
   for ( $f=0; $f <= 5; $f++) {
      $tab5->write($row+$i, $col+$f, $rowRst[$f], ($i % 2 ==0)? $format2 : $format2);
   }
}





#tab6 unsupported msisdn
$tab6->write('a1',"GROUP NAME",$format3);
$tab6->write('b1',"V3 USERNAME",$format4);
$tab6->write('c1',"MOBILE NAME",$format3);
$tab6->write('d1',"LAST NAME",$format3);
$tab6->write('e1',"FIRST NAME",$format4);
$tab6->write('f1',"MIDDLE NAME",$format3);
$tab6->write('g1',"EMAIL",$format4);
$tab6->write('h1',"AGE",$format3);
$tab6->write('i1',"GENDER",$format4);
$tab6->write('j1',"ADDRESS",$format3);
$tab6->write('k1',"Birthday",$format4);


$row=0;
$i=0;
$col=0;

$strgetstat="select 
                grp.name group_name,
                usr.name v3user,
                phn.msisdn,
                cntct.alias as last_name,
                cntct.name as first_name,
                cntct.alias as middle_name,
                cntct.email,
                cntct.age,
                cntct.gender,
                cntct.address,
                cntct.birthday
            from
                netcast3_db.contacts_tb cntct, 
                netcast3_db.contacts_group_tb s,  
                netcast3_db.group_tb grp, 
                tmp_msisdn_v3 phn,
                netcast3_db.users_tb usr
           where s.contact_id = cntct.id and 
                 s.group_id = grp.id and 
                 cntct.msisdn_id=phn.id and 
                 phn.brand is null and 
                 grp.user_id=usr.id;";


$sth_rt = $smartBro->prepare($strgetstat);
$sth_rt->execute();
while (my @rowRst = $sth_rt->fetchrow()) {
   $i++;
   for ( $f=0; $f <= 10; $f++) {
      $tab6->write($row+$i, $col+$f,    $rowRst[$f], ($i % 2 ==0)? $format2 : $format2);
   }
}



$workbook->close();
binmode STDOUT;

#my $filesize = -s $excel_file;



$from = "Netcast DBA\@chikka.com";
$to = "jojo\@chikka.com,afaylona\@chikka.com,mllduran\@chikka.com,jocamat\@chikka.com,pegadraneda\@chikka.com,qc\@chikka.com,pdev-tech\@chikka.com";
#$cc = "jojo\@chikka.com";
#$cc = "afaylona\@chikka.com,mllduran\@chikka.com,jocamat\@chikka.com,pegadraneda\@chikka.com,qc\@chikka.com ";
$Subject = "Netcast Migration Report : Netcast Company -  ".$tdate." - ".$vnum;

  # Part using which the attachment is sent to an email #
my $message = Email::MIME->create(
  header_str => [
    From    => $from,
    To      => $to,
    Subject => $Subject,
  ],
  attributes => {
    encoding => 'quoted-printable',
    charset  => 'ISO-8859-1',
  },
  body_str => "Company $tdate Migrated Successfully.\n\nReport file is now available in our FTP server.\n\nFilename is netcast_migration_report_company_".$tdate."_".$vnum.".xls.\n\n\n\n\nRegards,\n\nCHIKKA DBA TEAM ",
);

# send the message
 use Email::Sender::Simple qw(sendmail);
 sendmail($message);








#$msg = MIME::Lite->new(
#        From     => $from,
#        To       => $to,
#	Cc      => $cc,
#        Subject  => $Subject,
#        Type     => 'File/xls');
     #   Path     => $excel_file
                      #  )  ;

#$msg->attach(
#        Type => 'text/html',
#        Data => qq{
#            <body>
#      		<p>
#			<span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">  Company $tdate Migrated Successfully.</span></span></p>
#		<p>
#			<span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">Report file is now available in our FTP server.</span></span></p>
#		<p>
#                
#                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">Filename is netcast_migration_report_company_$tdate _ $vnum.xls.</span></span></p>
#                <p>

#
#			&nbsp;</p>
#		<div>
#			<span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">Regards,</span></span></div>
#		<div>
#			<span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">CHIKKA DBA TEAM</span></span></div>
#		<p>
#			&nbsp;</p>
#		<p>
#			<br />
#			&nbsp;</p>
#            </body>
#        },
#    );
	
print "Mail Sent\n";
#$msg->send; # send via default


#######

