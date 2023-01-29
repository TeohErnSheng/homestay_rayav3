<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$username = $_POST['Username'];
$name = $_POST['Name'];
$address = $_POST['Address'];
$pax = $_POST['Pax'];
$facility = $_POST['Facilities'];
$contactNumber =  $_POST['contactNumber'];
$price = $_POST['Price'];
$state = $_POST['State'];
$local = $_POST['Locality'];
$lat = $_POST['Latitude'];
$lon = $_POST['Longitude'];
$image = $_POST['image'];
$image2 = $_POST['image2'];
$image3 = $_POST['image3'];
$sqlinsert = "INSERT INTO homestay(Name,username,Address,Pax,Facilities,contactNumber,Price,State,Locality,Latitude,Longitude)
VALUES('$name','$username','$address','$pax','$facility','$contactNumber','$price','$state','$local','$lat','$lon')";
if ($conn -> query($sqlinsert) === TRUE) {
    $decoded_string = base64_decode($image);
	$decoded_string2 = base64_decode($image2);
	$decoded_string3 = base64_decode($image3);
    $filename = mysqli_insert_id($conn);
    $path = '../assets/images/'.$filename.'.png';
    file_put_contents($path, $decoded_string);
	$path2 = '../assets/images/'.$filename.'2.png';
	$path3 = '../assets/images/'.$filename.'3.png';
	file_put_contents($path2, $decoded_string2);
	file_put_contents($path3, $decoded_string3);
	$response = array('status' => 'success', 'data' => null);
	sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>