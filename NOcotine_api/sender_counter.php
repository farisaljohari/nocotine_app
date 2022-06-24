<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){
    // Add config file
    require_once 'config.php';
    // Read DATA
    $sender_id = $_POST['sender_id'];
        // Add config file
        require_once 'config.php';

    // Insert Data
    $sql = "UPDATE competition
    SET competition.sender_counter = competition.sender_counter + 1
    WHERE competition.sender_id=".$sender_id."";
        
        
        
        // check query 
        if (mysqli_query($conn, $sql)) {
            // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "update sender counter successfully"}';
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