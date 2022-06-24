<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){
    // Add config file
    require_once 'config.php';
    // Read DATA
    $user_id = $_POST['user_id'];
    $rate = $_POST['rate'];
    $feedback_comment = mysqli_real_escape_string($conn,  $_POST['feedback_comment']);
    $date = $_POST['date'];
    
        // Add config file
        require_once 'config.php';

    // Insert Data
    $sql = "INSERT INTO `feedback`( `user_id`, `rate`, `feedback_comment`, `date`) 
    VALUES ('".$user_id."','".$rate."','".$feedback_comment."','".$date."')";
        
        
        
        // check query 
        if (mysqli_query($conn, $sql)) {
            // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "created feedback successfully"}';
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