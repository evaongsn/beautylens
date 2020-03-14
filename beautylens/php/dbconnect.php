<?php
$servername = "localhost";
$username   = "hackanan_evaongsn";
$password   = "{]D4,F;]YACb";
$dbname     = "hackanan_beautylens";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>