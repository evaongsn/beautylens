<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$quantity = $_POST['quantity'];

$sql = "SELECT * FROM USERS WHERE EMAIL = '$email'";    
$quan = 0;
 
$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    while ($row = $result->fetch_assoc())
    {
      $quan = $row["QUANTITY"];
    }
    echo  $quan;
}
else
{
    echo "nodata";
}
?>