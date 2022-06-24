<?php

// check Request Type 
if ($_SERVER['REQUEST_METHOD']== 'POST'){

    // Read DATA
    
    $User_id_sender = $_POST['User_id_sender'];
    $User_id_receiver = $_POST['User_id_receiver'];
        // Add config file
        require_once 'config.php';

    // Insert Data
    $sql = "DELETE FROM `competition` WHERE competition.sender_id = ".$User_id_sender." AND competition.receiver_id = ".$User_id_receiver."";
    $sql2 = "DELETE FROM `notification` WHERE notification.user_id_reciever=".$User_id_receiver." AND notification.user_id_sender=".$User_id_sender." AND notification.icon='competition'";    
        
        
        // check query 
        if (mysqli_query($conn, $sql)) {
            // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "Delete Like successfully"}';
            if (mysqli_query($conn, $sql2)){
                // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "Delete notification successfully"}';
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