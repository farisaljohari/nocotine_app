<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){

    // Read DATA
    
    $User_id = $_POST['user_id'];
    $New_value_visble_sheet= 1;
    $Num_of_packets= $_POST['num_packets'];
    $Price_of_packets= $_POST['price_packets'];
    $Number_of_cigarette = 0;
    $Cost_of_cigarette = 0.0;
    $Save_health = 0.0;
        // Add config file
        require_once 'config.php';

    // Insert Data
    $sql = "UPDATE users
    SET users.visable_sheet = ".$New_value_visble_sheet.",
    users.price_of_packets = ".$Price_of_packets.",
    users.number_of_packets = ".$Num_of_packets."
    WHERE users.id = ".$User_id."";
    $sql2 = "INSERT INTO `smoking_counter`(`user_id`, `number_of_cigarette`, `cost_of_cigarette`, `save_health`)
        VALUES ('".$User_id."','".$Number_of_cigarette."','".$Cost_of_cigarette."','".$Save_health."')";
        
        
        // check query 
        if (mysqli_query($conn, $sql)) {
           if(mysqli_query($conn, $sql2)){
                // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "information update successfully"}';
           }
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