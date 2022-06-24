<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){
    // Add config file
    require_once 'config.php';
    // Read DATA
    $post_id = $_POST['post_id'];
    $comment_id = $_POST['comment_id'];
    $body = mysqli_real_escape_string($conn,  $_POST['body']);
    $type=  mysqli_real_escape_string($conn,  $_POST['type']);

       
        // Add config file
        require_once 'config.php';

    // Insert Data
    $sql = "INSERT INTO `admin_notification`( `post_id`,`comment_id`, `body`, `type`) 
    VALUES ('$post_id','$comment_id','$body','$type')";
        
        
        
        // check query 
        if (mysqli_query($conn, $sql)) {
            // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "created admin notification successfully"}';
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