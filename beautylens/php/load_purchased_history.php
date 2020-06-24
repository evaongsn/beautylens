<?php
error_reporting(0);
include_once ("dbconnect.php");
$order_id = $_POST['order_id'];


$sql = "SELECT PRODUCTS.id, PRODUCTS.name, PRODUCTS.price, PRODUCTS.quantity, PURCHASEDHIS.cart_quantity FROM PRODUCTS INNER JOIN PURCHASEDHIS ON PURCHASEDHIS.products_id = PRODUCTS.id WHERE  PURCHASEDHIS.order_id = '$order_id'";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["purchasedhistory"] = array();
    while ($row = $result->fetch_assoc())
    {
        $purchasedlist = array();
        $purchasedlist["id"] = $row["id"];
        $purchasedlist["name"] = $row["name"];
        $purchasedlist["price"] = $row["price"];
        $purchasedlist["cart_quantity"] = $row["cart_quantity"];
        array_push($response["purchasedhistory"], $purchasedlist);
    }
    echo json_encode($response);
}
else
{
    echo "Cart Empty";

}
?>
