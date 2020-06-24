<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_GET['email'];
$phone = $_GET['phone'];
$amount = $_GET['amount'];
$orderid = $_GET['orderid'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
 
$signed= hash_hmac('sha256', $signing, 'S-NmPfZVWqrAeD6H6YhTT7yw');
if ($signed === $data['x_signature']) {

    if ($paidstatus == "Success"){ //payment success
        
        $sqlcart = "SELECT products_id,cart_quantity FROM CART WHERE email = '$email'";
        $cartresult = $conn->query($sqlcart);
        if ($cartresult->num_rows > 0)
        {
        while ($row = $cartresult->fetch_assoc())
        {
            $products_id = $row["products_id"];
            $cq = $row["cart_quantity"]; //cart qty
            $sqlinsertpurchasedhistory = "INSERT INTO PURCHASEDHIS(email,order_id,bill_id,products_id,cart_quantity) VALUES ('$email','$orderid','$receiptid','$products_id','$cq')";
            $conn->query($sqlinsertpurchasedhistory);
            
            $selectproduct = "SELECT * FROM PRODUCTS WHERE id = '$products_id'";
            $productresult = $conn->query($selectproduct);
             if ($productresult->num_rows > 0){
                  while ($rowp = $productresult->fetch_assoc()){
                    $prquantity = $rowp["quantity"];
                    $prevsold = $rowp["sold"];
                    $newquantity = $prquantity - $cq; //quantity in store - quantity ordered by user
                    $newsold = $prevsold + $cq;
                    $sqlupdatequantity = "UPDATE PRODUCTS SET quantity = '$newquantity', sold = '$newsold' WHERE id = '$products_id'";
                    $conn->query($sqlupdatequantity);
                  }
             }
        }
        
       $sqldeletecart = "DELETE FROM CART WHERE email = '$email'";
       $sqlinsert = "INSERT INTO PAYMENTS(order_id,bill_id,user_email,total) VALUES ('$orderid','$receiptid','$email','$amount')";
       $sqlupdatequantity = "UPDATE USERS SET QUANTITY = '0' WHERE EMAIL = '$email'";
       
       $conn->query($sqldeletecart);
       $conn->query($sqlinsert);
       $conn->query($sqlupdatequantity);
    }
        echo '<br><br><body><div><h2><br><br><center>Receipt</center></h1><table border=1 width=80% align=center><tr><td>Order ID</td><td>'.$orderid.'</td></tr><tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td><td>'.$email. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr><tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr><tr><td>Date </td><td>'.date("d/m/Y").'</td></tr><tr><td>Time </td><td>'.date("h:i a").'</td></tr></table><br><p><center>Press back button to return to BeautyLens</center></p></div></body>';
        //echo $sqlinsertcarthistory;
    } 
        else 
    {
    echo 'Payment Failed!';
    }
}

?>