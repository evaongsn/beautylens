<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$products_id = $_POST['products_id'];
$quantity = $_POST['quantity'];

$sqlupdate = "UPDATE CART SET cart_quantity = '$quantity' WHERE email = '$email' AND products_id = '$products_id'";

if ($conn->query($sqlupdate) === true)
{
    echo "success";
}
else
{
    echo "failed";
}
    
$conn->close();
?>