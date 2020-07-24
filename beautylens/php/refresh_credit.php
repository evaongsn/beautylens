<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$credit = $_POST['credit'];

$sql = "SELECT * FROM USERS WHERE EMAIL = '$email'";    
$cr = 0;
 
$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    while ($row = $result->fetch_assoc())
    {
      $credit = $row["CREDIT"];
    }
    echo  $credit;
}
else
{
    echo "nodata";
}
?>