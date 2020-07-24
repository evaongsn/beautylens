<?php
error_reporting(0);
include_once ("dbconnect.php");
$pid = $_POST['pid'];
$pname  = ($_POST['pname']);
$quantity  = $_POST['quantity'];
$price  = $_POST['price'];
$type  = $_POST['type'];
$size  = $_POST['size'];
$expiration_time  = $_POST['expiration_time'];
$power  = $_POST['power'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$sold = '0';
$path = '../product_images/'.$pid.'.jpg';

$sqlinsert = "INSERT INTO PRODUCTS(id, name, price, quantity, sold, power, size, expiration_time, type) VALUES ('$pid' ,'$pname', '$price',  '$quantity', '$sold', '$power', '$size', '$expiration_time', '$type')";

if ($conn->query($sqlinsert) === true)
{
    if (file_put_contents($path, $decoded_string)){
        echo 'success';
    }else{
        echo 'failed';
    }
}
else
{
    echo "failed";
}    
//}


?>