<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){
    require_once 'config.php';
    // Read DATA
    $competition_id = $_POST['competition_id'];
    $winner_user_id = $_POST['winner_user_id'];
    $loser_user_id = $_POST['loser_user_id'];
    
    // Insert Data
    $sql = "INSERT INTO `competition_result`(`competition_id`, `winner_user_id`, `loser_user_id`)
        VALUES ('$competition_id','$winner_user_id ','$loser_user_id')";
        
        
        
        // check query 
        if (mysqli_query($conn, $sql)) {
            // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "insert competition result successfully"}';
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