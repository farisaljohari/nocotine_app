<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){

    // Read DATA
    
    $User_id = $_POST['user_id'];
    $Number_of_cigarette= $_POST['number_of_cigarette'];
    $Cost_of_cigarette= $_POST['cost_of_cigarette'];
    $Save_health= $_POST['save_health'];
    
        // Add config file
        require_once 'config.php';

    // Insert Data
    $sql = "UPDATE smoking_counter
    SET smoking_counter.number_of_cigarette='$Number_of_cigarette',
    smoking_counter.cost_of_cigarette='$Cost_of_cigarette',
    smoking_counter.save_health='$Save_health'
    WHERE smoking_counter.user_id = '$User_id'";
        
        
        
        // check query 
        if (mysqli_query($conn, $sql)) {
            // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "Update Smoking Counter successfully"}';
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