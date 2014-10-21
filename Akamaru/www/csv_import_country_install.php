<?php

//connect to the database 
$connect = mysql_connect("localhost","root","\$CRIPT\$"); 
mysql_select_db("oist_log",$connect); //select the table 
// 

if ($_FILES[csv][size] > 0) { 

$strTableCountryInstall = 'oist_android_country_installs_'.date("YmdHis");

$strCreateTable = "CREATE TABLE `".$strTableCountryInstall."` (
  `datein` date NOT NULL DEFAULT '0000-00-00',
  `country` varchar(40) DEFAULT '',
  `active_device_installs` int(9) DEFAULT NULL,
  `daily_device_installs` int(9) DEFAULT NULL,
  `active_user_installs` int(9) DEFAULT NULL,
  `total_user_installs` int(9) DEFAULT NULL,
  `daily_user_installs` int(9) DEFAULT NULL,
  PRIMARY KEY (`datein`,`country`)
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
    $strSQL = "LOAD DATA INFILE '".$new_file."' REPLACE INTO TABLE ".$strTableCountryInstall." FIELDS TERMINATED BY '\,' IGNORE 5 LINES";
   // print $strSQL;
    $result = mysql_query($strSQL);
    if (!$result) {
    die('Invalid query: ' . mysql_error());
}
    //load csv file database
    $strSQL = "LOAD DATA INFILE '".$new_file."' REPLACE INTO TABLE oist_stat.oist_android_country_installs FIELDS TERMINATED BY '\,' IGNORE 5 LINES";
   // print $strSQL;
    $result = mysql_query($strSQL);
    if (!$result) {
    die('Invalid query: ' . mysql_error());
}

$strSQLUpdateCountry = "UPDATE ".$strTableCountryInstall." SET country=(CASE country WHEN 'PH' THEN 'PHILIPPINES' WHEN 'US' THEN 'UNITED STATES' WHEN 'AE' THEN 'UNITED ARAB EMIRATES' WHEN 'CN' THEN 'CHINA' WHEN 'GB' THEN 'UNITED KINGDOM' WHEN 'SA' THEN 'SAUDI ARABIA' WHEN 'JP' THEN 'JAPAN' WHEN 'SG' THEN 'SINGAPORE' WHEN 'MY' THEN 'MALAYSIA' WHEN 'CA' THEN 'CANADA' WHEN 'AU' THEN 'AUSTRALIA' WHEN 'QA' THEN 'QATAR' WHEN 'KR' THEN 'SOUTH KOREA' WHEN 'HK' THEN 'HONG KONG' ELSE country END)";

$result = mysql_query($strSQLUpdateCountry);
    if (!$result) {
    die('Invalid query: ' . mysql_error());
}

 $strSQLUpdateCountryInstall = "UPDATE oist_stat.oist_countries_breakdown a INNER JOIN ".$strTableCountryInstall." b ON (a.datein=b.datein) AND (a.country=b.country) SET a.android_install=b.daily_device_installs";

$result = mysql_query($strSQLUpdateCountryInstall);
    if (!$result) {
    die('Invalid query: ' . mysql_error());
}
    //redirect 
    header('Location: csv_import_country_install.php?success=1'); die; 

} 

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml"> 
<head> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> 
<title>Import a CSV File for OIST Android Country Install</title> 
</head> 

<body> 
	<div><p><strong>Import CSV Country Install</strong></p></div>
		<div>
			<strong>Filename:</strong> <strong><span style="color:#ff0000;">com.oist.android_country_installs.csv</span></strong></div>
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
