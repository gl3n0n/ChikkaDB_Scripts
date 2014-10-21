<?php

//connect to the database 
$connect = mysql_connect("localhost","root","\$CRIPT\$"); 
mysql_select_db("oist_log",$connect); //select the table 
// 

if ($_FILES[csv][size] > 0) { 

$strTableOverallInstall = 'oist_android_overall_installs_'.date("YmdHis");

$strCreateTable = "CREATE TABLE `".$strTableOverallInstall."` (
  `datein` date NOT NULL DEFAULT '0000-00-00',
  `active_device_installs` int(9) DEFAULT NULL,
  `daily_device_installs` int(9) DEFAULT NULL,
  `active_user_installs` int(9) DEFAULT NULL,
  `total_user_installs` int(9) DEFAULT NULL,
  `daily_user_installs` int(9) DEFAULT NULL,
  PRIMARY KEY (`datein`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1";
#mysql_query($strCreateTable);

#
	$result = mysql_query($strCreateTable);
   if (!$result) {
   die('Invalid query: ' . mysql_error());
}
    //get the csv file
    $new_name = $_FILES[csv][tmp_name];
    chmod("$new_name",0777);
    $new_file = $new_name;    

    //load csv file database
    $strSQL = "LOAD DATA INFILE '".$new_file."' REPLACE INTO TABLE ".$strTableOverallInstall." FIELDS TERMINATED BY '\,' IGNORE 5 LINES";
   // print $strSQL;
    $result = mysql_query($strSQL);
    if (!$result) {
    die('Invalid query: ' . mysql_error());
}


    //load csv file database
    $strSQL = "LOAD DATA INFILE '".$new_file."' REPLACE INTO TABLE oist_stat.oist_android_overall_installs FIELDS TERMINATED BY '\,' IGNORE 5 LINES";
   // print $strSQL;
    $result = mysql_query($strSQL);
    if (!$result) {
    die('Invalid query: ' . mysql_error());
}

$strSQLUpdateInstall = "UPDATE oist_stat.oist_client_breakdown a INNER JOIN ".$strTableOverallInstall." b ON (a.datein=b.datein) SET a.install=b.daily_device_installs";

$result = mysql_query($strSQLUpdateInstall);
    if (!$result) {
    die('Invalid query: ' . mysql_error());
}
    //redirect 
    header('Location: csv_import_overall_install.php?success=1'); die; 

} 

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml"> 
<head> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> 
<title>Import a CSV File for OIST Android Overall Install</title> 
</head> 

<body> 
	<div><p><strong>Import CSV Overall Install</strong></p></div>
		<div>
			<strong>Filename:</strong> <strong><span style="color:#ff0000;">com.oist.android_overall_installs.csv</span></strong></div>
		<div>
			&nbsp;</div>
<?php if (!empty($_GET[success])) { echo "<b>Your file has been imported.</b><br><br>"; } //generic success notice ?> 

<form action="" method="post" enctype="multipart/form-data" name="form1" id="form1"> 
  Choose your file: <br /> 
  <input name="csv" type="file" id="csv" /> 
  <input type="submit" name="Submit" value="Submit" /> 
</form> 
		<div>
			&nbsp;</div>
		<div>
			&nbsp;</div>
		<div>
			<a href="index.php">Home</a> |&nbsp;<a href="csv_import_overall_install.php">Import CSV Overall Install</a>&nbsp;|&nbsp;<a href="csv_import_country_install.php">Import CSV Country Install</a></div>
</body> 
</html> 
