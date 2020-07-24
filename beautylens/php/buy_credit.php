<?php
error_reporting(0);
//include_once("dbconnect.php");

$email = $_GET['email']; //email
$phone = $_GET['phone']; 
$name = $_GET['name']; 
$amount = $_GET['amount']; 
$current_credit = $_GET['current_credit'];

$newcr = $amount +  $current_credit;

$api_key = '769dae75-1614-451a-a2a2-3523e4c2b0f4';
$collection_id = '0wp6hsii';
$host = 'https://billplz-staging.herokuapp.com/api/v3/bills';


$data = array(
          'collection_id' => $collection_id,
          'email' => $email,
          'phone' => $phone,
          'name' => $name,
          'amount' => $amount * 100, // RM20
		  'description' => 'Payment for store credit ',
          'callback_url' => "http://hackanana.com/beautylens/return_url",
          'redirect_url' => "http://hackanana.com/beautylens/php/buy_credit_update.php?email=$email&phone=$phone&amount=$amount&newcr=$newcr" 
);


$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);

//echo "<pre>".print_r($bill, true)."</pre>";
header("Location: {$bill['url']}");
?>