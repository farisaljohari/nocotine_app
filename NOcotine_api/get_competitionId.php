
<?php

if ($_SERVER['REQUEST_METHOD']== 'POST'){
    // Add config file
    require_once 'config.php';
    $User_id=$_POST['user_id'];
    $tempData = array();
    //sleep(1.5);
    $sql = "SELECT competition.competition_id FROM competition WHERE
    competition.sender_id=".$User_id." OR competition.receiver_id=".$User_id.";";
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