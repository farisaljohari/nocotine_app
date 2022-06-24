<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){

    // Read DATA
    
    $Post_id = $_POST['post_id'];
    $Comment_id = $_POST['comment_id'];
    $User_report_id = $_POST['User_report_id'];
    // Add config file
    require_once 'config.php';

    // Insert Data
    $sql = "INSERT INTO `comments_report`(`post_id`, `comment_id`, `user_report_id`) 
    VALUES ('$Post_id','$Comment_id','$User_report_id')";
        
        
        
        // check query 
        if (mysqli_query($conn, $sql)) {
            // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "Report Comment successfully"}';
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