<?php  
$host="10.11.6.116";  
$username="connect";  
$password="connect";  
$db_name="test";  
$con=mysql_pconnect("$host", "$username", "$password")or die("cannot connect"); 
mysql_select_db("$db_name")or die("cannot select DB"); 

$result = mysql_query("SELECT BENCHMARK(100000000,ENCODE('hello','goodbye'))"); 
?>
