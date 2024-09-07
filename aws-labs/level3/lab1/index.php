<?php
$dbname = "datacenter_db";
$dbuser = "datacenter_admin";
$dbpass = "password";
$dbhost = "datacenter-rds.cxw4w26qs85m.us-east-1.rds.amazonaws.com";

$link = mysqli_connect($dbhost, $dbuser, $dbpass) or die("Unable to Connect to '$dbhost'");
mysqli_select_db($link, $dbname) or die("Could not open the db '$dbname'");

$test_query = "SHOW TABLES FROM $dbname";
$result = mysqli_query($link, $test_query);

$tblCnt = 0;
while($tbl = mysqli_fetch_array($result)) {
  $tblCnt++;
}

if (!$tblCnt) {
  echo "Connected successfully<br />\n";
} else {
  echo "Connected successfully<br />\n";
}
?>