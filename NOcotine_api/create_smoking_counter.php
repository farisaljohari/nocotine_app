<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){

    // Read DATA
    $User_id = $_POST['user_id'];
    $Number_of_cigarette = 0;
    $Cost_of_cigarette = 0.0;
    $Save_health = 0.0;

        
        // Add config file
        require_once 'config.php';

    // Insert Data
    $sql = "INSERT INTO `smoking_counter`(`user_id`, `number_of_cigarette`, `cost_of_cigarette`, `save_health`)
        VALUES ('".$User_id."','".$Number_of_cigarette."','".$Cost_of_cigarette."','".$Save_health."')";

        
        
        // check query 
        if (mysqli_query($conn, $sql)) {
            // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "created Smoking Counter successfully"}';
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