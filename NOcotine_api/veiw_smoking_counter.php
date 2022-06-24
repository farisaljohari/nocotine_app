<?php

if ($_SERVER['REQUEST_METHOD']== 'POST'){

    $User_id=$_POST['user_id'];

    // Add config file
    require_once 'config.php';

    $tempData = array();
    //sleep(0.5);
    $sql = "SELECT 
    smoking_counter.user_id,
    smoking_counter.number_of_cigarette,
    smoking_counter.cost_of_cigarette,
    smoking_counter.save_health
    FROM smoking_counter
    WHERE smoking_counter.user_id=".$User_id."";
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