<?php

error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

// if (isset($email)){
//   $sql = "SELECT PRODUCT.ID, PRODUCT.NAME, PRODUCT.PRICE, PRODUCT.QUANTITY, PRODUCT.WEIGHT, CART.CQUANTITY FROM PRODUCT INNER JOIN CART ON CART.PRODID = PRODUCT.ID WHERE CART.EMAIL = '$email'";
// }

if (isset($email)){
$sql = "SELECT p.id, p.name, p.price, p.power, p.quantity, p.size, p.type, c.cart_quantity, p.price*c.cart_quantity FROM PRODUCTS AS p INNER JOIN CART AS c ON c.products_id = p.id WHERE c.email = '$email'";
}

$result = $conn->query($sql);
if ($result->num_rows > 0)
{
    $response["cart"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cartlist = array();
        $cartlist["id"] = $row["id"];
        $cartlist["name"] = $row["name"];
        $cartlist["price"] = $row["price"];
        $cartlist["power"] = $row["power"];
        $cartlist["quantity"] = $row["quantity"];
        $cartlist["cart_quantity"] = $row["cart_quantity"];
        $cartlist["size"] = $row["size"];
        $cartlist["type"] = $row["type"];
        $cartlist["cart_price"] = $row["p.price*c.cart_quantity"];
        array_push($response["cart"], $cartlist);
    }
    echo json_encode($response);
}
else
{
    echo "Cart Empty";
}
?>