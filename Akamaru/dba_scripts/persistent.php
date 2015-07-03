<?php  
$host="10.11.6.116";  
$username="connect";  
$password="connect";  
$db_name="test";  

for ($i=1;$i<10;$i++) {

print "Connect #:".$i;
print "\n";
$con=mysql_pconnect("$host", "$username", "$password")or die("cannot connect");
mysql_select_db("$db_name");


}
?>
