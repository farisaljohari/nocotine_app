<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){
    // Add config file
    require_once 'config.php';
    // Read DATA
    $User_id = $_POST['user_id'];
    $Post_text = mysqli_real_escape_string($conn,  $_POST['post_text']);
    $Feeling = $_POST['feeling'];
    $Image_Post=$_POST['image_name'];
    $total_comments = "0";

        //Check is empty
        if(empty($User_id) || empty($Post_text)){
            http_response_code(401);
            header('Content-Type:application/json');
            echo '{ "message": "empty data"}';
            return;
        }
        // Add config file
        require_once 'config.php';

    // Insert Data
    $sql = "INSERT INTO `posts`(`user_id`, `post_text`, `feeling`, `image_post`, `total_comments`)
        VALUES ('$User_id','$Post_text','$Feeling','$Image_Post','$total_comments')";
        
        
        
        // check query 
        if (mysqli_query($conn, $sql)) {
            // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "created Post successfully"}';
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