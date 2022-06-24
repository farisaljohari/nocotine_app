<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){
    // Add config file
    require_once 'config.php';
    // Read DATA
    $post_id = $_POST['post_id'];
    $user_id = $_POST['user_id'];
    $comment_text = mysqli_real_escape_string($conn,  $_POST['comment_text']);

        //Check is empty
        if(empty($user_id) || empty($comment_text)){
            http_response_code(401);
            header('Content-Type:application/json');
            echo '{ "message": "empty data"}';
            return;
        }
        // Add config file
        require_once 'config.php';

    // Insert Data
    $sql = "INSERT INTO `comments`(`post_id`, `user_id`, `comment_text`)
        VALUES ('$post_id','$user_id','$comment_text')";
        
        
        
        // check query 
        if (mysqli_query($conn, $sql)) {
            require_once("get_total_comments.php");
            updateTotalComments($post_id,$conn);
            // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "created comment successfully"}';
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