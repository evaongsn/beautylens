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
   $sql = "SELECT * FROM PRODUCTS WHERE NAME LIKE  '%$name%'";
}


$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["products"] = array();
    while ($row = $result->fetch_assoc())
    {
        $productlist = array();
        $productlist["id"] = $row["id"];
        $productlist["name"] = $row["name"];
        $productlist["price"] = $row["price"];
        $productlist["quantity"] = $row["quantity"];
        $productlist["power"] = $row["power"];
        $productlist["size"] = $row["size"];
        $productlist["expiration_time"] = $row["expiration_time"];
        $productlist["type"] = $row["type"];
        
        array_push($response["products"], $productlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>