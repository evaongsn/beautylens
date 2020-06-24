<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$products_id = $_POST['products_id'];
     $sqldelete = "DELETE FROM CART WHERE email = '$email' AND prodcuts_id = '$products_id'";
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>