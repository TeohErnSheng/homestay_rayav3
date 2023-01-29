<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);
$sqllogin = "SELECT * FROM user WHERE email = '$email' AND
passkey = '$password'";
$result = $conn -> query($sqllogin);
if ($result -> num_rows > 0) {
while ($row = $result -> fetch_assoc()) {
        $userlist = array();
		$userlist['userId'] = $row['userId'];
        $userlist['name'] = $row['username'];
        $userlist['email'] = $row['email'];
        $userlist['password'] = $row['passkey'];
        $response = array('status' => 'success', 'data' => $userlist);
        sendJsonResponse($response);
   }
}
else{
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);

}
$conn -> close();

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>