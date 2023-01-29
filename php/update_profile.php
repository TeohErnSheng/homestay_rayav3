<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
if (isset($_POST['image'])) {
    $encoded_string = $_POST['image'];
    $userId = $_POST['userId'];
    $decoded_string = base64_decode($encoded_string);
    $path = '../assets/images/profiles/'.$userId.'.png';
    $is_written = file_put_contents($path, $decoded_string);
    if ($is_written){
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    }else{
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
    die();
}

if (isset($_POST['email'])) {
	$oldEmail = $_POST['oldEmail'];
    $email = $_POST['email'];
    $username = $_POST['username'];
    $sqlupdate = "UPDATE user SET email ='$email' WHERE username =
'$username'";
    databaseUpdate($sqlupdate);
    die();
}
if (isset($_POST['passkey'])) {
    $passkey = sha1($_POST['passkey']);
    $username = $_POST['username'];
    $sqlupdate = "UPDATE user SET passkey ='$passkey' WHERE
username = '$username'";
    databaseUpdate($sqlupdate);
    die();
}
if (isset($_POST['name'])) {
$username = $_POST['username'];
$name = $_POST['name'];
    $sqlupdate = "UPDATE user SET username ='$username' WHERE username =
'$name'";
$sqlupdate2 = "UPDATE homestay SET username ='$username' WHERE username =
'$name'";
    databaseUpdate2($sqlupdate,$sqlupdate2);
    die();
}
function databaseUpdate($sql){
    include_once("dbconnect.php");
    if ($conn -> query($sql) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

function databaseUpdate2($sql,$sql2){
    include_once("dbconnect.php");
    if ($conn -> query($sql) === TRUE && $conn -> query($sql2) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>