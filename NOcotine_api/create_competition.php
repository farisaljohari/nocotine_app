<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){
    require_once 'config.php';
    // Read DATA
    $sender_id =mysqli_real_escape_string($conn,  $_POST['sender_id']);
    $receiver_id = mysqli_real_escape_string($conn,  $_POST['receiver_id']);
    $duration = mysqli_real_escape_string($conn,  $_POST['duration']);
    $end_time = mysqli_real_escape_string($conn,  $_POST['end_time']);

        //Check is empty
        if(empty($sender_id) || empty($receiver_id) || empty($duration)){
            http_response_code(401);
            header('Content-Type:application/json');
            echo '{ "message": "empty data"}';
            return;
        }

    // Insert Data
    $sql = "INSERT INTO `competition`(`sender_id`, `receiver_id`, `duration`,`end_time`)
        VALUES ('$sender_id','$receiver_id','$duration','$end_time')";
        
        
        
        // check query 
        if (mysqli_query($conn, $sql)) {
            // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "created competition successfully"}';
        } else {
            // print error 
            http_response_code(500);
            header('Content-Type:application/json');
            $error = mysqli_error($conn);
            echo '{ "message": '.$error.'}';
        }


        // close 
        mysqli_close($conn);
}else{
    http_response_code(404);
    header('Content-Type:application/json');
    echo '{ "message": "page not found"}';
}