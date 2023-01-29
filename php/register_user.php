<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$name = $_POST['username'];
$email = $_POST['email'];
$password = sha1($_POST['passkey']);
$sqlinsert = "INSERT INTO user (username,email,passkey) VALUES('$name','$email','$password')";
if ($conn -> query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
           sendJsonResponse($response);
    }else{
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    }
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>