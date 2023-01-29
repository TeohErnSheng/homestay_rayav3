<?php
	include_once("dbconnect.php");
	$search  = $_GET["search"];
	$results_per_page = 6;
	$pageno = (int)$_GET['pageno'];
	$page_first_result = ($pageno - 1) * $results_per_page;
	if ($search =="all"){
			$sqlloadproduct = "SELECT * FROM homestay";
	}else{
		$sqlloadproduct = "SELECT * FROM homestay WHERE Name LIKE '%$search%'";
	}
	$result = $conn -> query($sqlloadproduct);
	$number_of_result = $result -> num_rows;
	$number_of_page = ceil($number_of_result/$results_per_page);
	$sqlloadproduct = $sqlloadproduct . " LIMIT $page_first_result , $results_per_page";
	$result = $conn -> query($sqlloadproduct);
	if ($result -> num_rows > 0) {
		$homestayarray["homestay"] = array();
		while ($row = $result -> fetch_assoc()) {
			$hslist = array();
			$hslist['HomestayId'] = $row['HomestayId'];
			$hslist['Name'] = $row['Name'];
			$hslist['username'] = $row['username'];
			$hslist['Address'] = $row['Address'];
			$hslist['contactNumber'] = $row['contactNumber'];
			$hslist['Pax'] = $row['Pax'];
			$hslist['Facilities'] = $row['Facilities'];
			$hslist['Price'] = $row['Price'];
			$hslist['State'] = $row['State'];
			$hslist['Locality'] = $row['Locality'];
			$hslist['Latitude'] = $row['Latitude'];
			$hslist['Longitude'] = $row['Longitude'];
			array_push($homestayarray["homestay"],$hslist);
		}
		$response = array('status' => 'success', 'numofpage'=>"$number_of_page",'numberofresult'=>"$number_of_result",'data' => $homestayarray);
    sendJsonResponse($response);
		}else{
		$response = array('status' => 'failed','numofpage'=>"$number_of_page", 'numberofresult'=>"$number_of_result",'data' => null);
    sendJsonResponse($response);
	}
	
	function sendJsonResponse($sentArray)
	{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
	}
	?>