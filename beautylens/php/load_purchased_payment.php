<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

if (isset($email)){
   $sql = "SELECT * FROM PAYMENTS WHERE user_email = '$email'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["payments"] = array();
    while ($row = $result->fetch_assoc())
    {
        $paymentslist = array();
        $paymentslist["orderid"] = $row["order_id"];
        $paymentslist["billid"] = $row["bill_id"];
        $paymentslist["total"] = $row["total"];
        $paymentslist["date"] = $row["date"];
        array_push($response["payments"], $paymentslist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>