<?php

// check Request Type 
if ($_SERVER['REQUEST_METHOD']== 'POST'){

    // Read DATA
    
    $User_id = $_POST['user_id'];
        // Add config file
        require_once 'config.php';

    // Insert Data
    $sql = "DELETE FROM `competition` WHERE competition.sender_id = ".$User_id." OR competition.receiver_id = ".$User_id."";

        
        
        // check query 
        if (mysqli_query($conn, $sql)) {
            // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "Delete competition successfully"}';
        
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