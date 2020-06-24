<?php
error_reporting(0);
include_once ("dbconnect.php");
$type = $_POST['type'];
$name = $_POST['name'];

if (isset($type)){
    if ($type == "Recent"){
        $sql = "SELECT * FROM PRODUCTS ORDER BY DATE DESC lIMIT 20";    
    }else{
        $sql = "SELECT * FROM PRODUCTS WHERE type = '$type'";    
    }
}else{
    $sql = "SELECT * FROM PRODUCTS ORDER BY DATE DESC lIMIT 20";    
}
if (isset($name)){
  $sql = "SELECT * FROM PRODUCTS WHERE name LIKE  '%$name%'";
}
// if (isset($type)){
//      if ($type == "Recent"){
//     $sql = "SELECT * FROM PRODUCTS";  
//     }else{
//   $sql = "SELECT * FROM PRODUCTS WHERE type = '$type'";}
// }else{
//     $sql = "SELECT * FROM PRODUCTS";  
// }


$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["products"] = array();
    while ($row = $result->fetch_assoc())
    {
        $productslist = array();
        $productslist["id"] = $row["id"];
        $productslist["name"] = $row["name"];
        $productslist["price"] = $row["price"];
        $productslist["quantity"] = $row["quantity"];
        $productslist["power"] = $row["power"];
        $productslist["size"] = $row["size"];
        $productslist["expiration_time"] = $row["expiration_time"];
        $productslist["type"] = $row["type"];
        $productslist["sold"] = $row["sold"];
        array_push($response["products"], $productslist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>