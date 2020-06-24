<?php
error_reporting(0);
include_once ("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);

$sqlinsert = "INSERT INTO USERS(NAME,EMAIL,PASSWORD,PHONE,CREDIT,QUANTITY) VALUES ('$name','$email','$password','$phone',0,0)";

if ($conn->query($sqlinsert) === true)
{
    sendEmail($email);
    echo "success";
    
}
else
{
    echo "failed";
}

//http://hackanana.com/beautylens/php/register.php?name=Eva%20Ong&email=evaong@gmail.com&phone=0165494710&password=123456

function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Registeration Verification'; 
    $message = 'http://hackanana.com/beautylens/php/verify_regis.php?email='.$useremail; 
    $headers = 'From: noreply@beautylens.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}

?>
