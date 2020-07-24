<?php
error_reporting(0);
include_once("dbconnect.php");
$id = $_POST['id'];
     $sqldelete = "DELETE FROM PRODUCTS WHERE id = '$id'";
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>