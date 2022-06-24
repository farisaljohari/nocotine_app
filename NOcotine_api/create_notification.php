<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){
    // Add config file
    require_once 'config.php';
    // Read DATA
    $post_id = $_POST['post_id'];
    $user_id_sender = $_POST['user_id_sender'];
    $user_id_reciever = $_POST['user_id_reciever'];
    $body = mysqli_real_escape_string($conn,  $_POST['body']);
    $icon = mysqli_real_escape_string($conn,  $_POST['icon']);
    $date=  mysqli_real_escape_string($conn,  $_POST['date']);

        //Check is empty
        if(empty($user_id_sender) || empty($user_id_reciever) || empty($body)||empty($icon)||empty($date)){
            http_response_code(401);
            header('Content-Type:application/json');
            echo '{ "message": "empty data"}';
            return;
        }
        // Add config file
        require_once 'config.php';

    // Insert Data
    $sql = "INSERT INTO `notification`(`user_id_sender`, `user_id_reciever`, `post_id`, `body`, `icon`, `date`)
        VALUES ('$user_id_sender','$user_id_reciever','$post_id','$body','$icon','$date')";
        
        
        
        // check query 
        if (mysqli_query($conn, $sql)) {
            // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "created notification successfully"}';
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