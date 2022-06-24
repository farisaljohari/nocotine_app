<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){

    // Read DATA
    
    $Post_id = $_POST['post_id'];
    $User_id = $_POST['user_id'];
    $Visable_like = "true";
        // Add config file
        require_once 'config.php';

    // Insert Data
    $sql = "INSERT INTO `likes`(`post_id`, `user_id`, `visable_like`)
        VALUES ('$Post_id','$User_id','$Visable_like')";
        
        
        
        // check query 
        if (mysqli_query($conn, $sql)) {
            // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "Likes Post successfully"}';
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