<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){
    // Add config file
    require_once 'config.php';
    // Read DATA
    
    $First_Name = mysqli_real_escape_string($conn, $_POST['first_name']);
    $Last_Name = mysqli_real_escape_string($conn, $_POST['last_name']);
    $User_id = $_POST['user_id'];
        // Add config file
        require_once 'config.php';

    // Insert Data
    $sql = "UPDATE users
    SET users.first_name = '".$First_Name."',
    users.last_name = '".$Last_Name."'
    WHERE users.id = ".$User_id."";
        
        
        
        // check query 
        if (mysqli_query($conn, $sql)) {
            // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "update Name successfully"}';
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