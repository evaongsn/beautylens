<?php
error_reporting(0);
include_once ("dbconnect.php");
$id = $_POST['id'];
$name  = ($_POST['name']);
$quantity  = $_POST['quantity'];
$price  = $_POST['price'];
$type  = $_POST['type'];
$size  = $_POST['size'];
$expiration_time  = $_POST['expiration_time'];
$power  = $_POST['power'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);

$path = '../product_images/'.$id.'.jpg';

$sqlupdate = "UPDATE PRODUCTS SET name = '$name', price = '$price', quantity = '$quantity', type = '$type' WHERE id = '$id'";


if ($conn->query($sqlupdate) === true)

{echo "success";
    // if (file_put_contents($path, $decoded_string)){
    //     echo 'success';
    // }else{
    //     echo 'sucess';
    // }
}
else
{
    echo "failed";
}    



?>