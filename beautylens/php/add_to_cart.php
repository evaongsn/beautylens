<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$products_id = $_POST['products_id'];
$cart_quantity = $_POST["cart_quantity"];
$quantity = $_POST["quantity"];

$sqlquantity = "SELECT * FROM CART WHERE email = '$email'";


$resultq = $conn->query($sqlquantity);
if ($resultq->num_rows > 0) {
   // $quantity = 0;
    while ($row = $resultq ->fetch_assoc()){
        $quantity = $row["cart_quantity"] + $quantity;
        // echo "cart".$cart_quantity;

    }
}

$sqlsearch = "SELECT * FROM CART WHERE email = '$email' AND products_id= '$products_id'";

$result = $conn->query($sqlsearch);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        $prquantity = $row["cart_quantity"];
    }
    $prquantity = $prquantity + 1;
    $sqlinsert = "UPDATE CART SET cart_quantity = '$prquantity' WHERE products_id = '$products_id' AND email = '$email'";
    
}else{
    $sqlinsert = "INSERT INTO CART(email,products_id,cart_quantity) VALUES ('$email','$products_id','1')";
}

if ($conn->query($sqlinsert) === true)
{
    $quantity = $quantity +1;
   $sqlinsertquantity = "UPDATE USERS SET quantity = '$quantity' WHERE email = '$email' ";
    $carticon - $conn->query($sqlinsertquantity);
    echo "success,".$quantity;
}
else
{
    echo "failed";
}

?>