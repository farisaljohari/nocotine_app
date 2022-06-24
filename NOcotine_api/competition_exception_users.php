<?php

if ($_SERVER['REQUEST_METHOD']== 'GET'){
    // Add config file
    require_once 'config.php';

    $tempData = array();
    //sleep(1.5);
    $sql = "SELECT competition.sender_id , competition.receiver_id FROM competition;";
    $result = mysqli_query($conn, $sql);

if (mysqli_num_rows($result) > 0) {
  // output data of each row
    while($row = mysqli_fetch_assoc($result)) {
        $tempData [] = $row;
        }
} else {
    $tempData = array();
}

    http_response_code(200);
    header('Content-Type:application/json');
    echo json_encode($tempData);

mysqli_close($conn);


}else{
    http_response_code(404);
    header('Content-Type:application/json');
    echo '{ "message": "page not found"}';
}