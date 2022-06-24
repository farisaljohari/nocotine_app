<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){

    // Read DATA
    
    $Post_id = $_POST['post_id'];
    $User_id = $_POST['user_id'];
        // Add config file
        require_once 'config.php';
    // Insert Data
    $sql = "DELETE FROM `likes` WHERE likes.post_id=".$Post_id." 
    AND likes.user_id=".$User_id."";
    $sql2 = "DELETE FROM `notification` WHERE notification.post_id=".$Post_id."
    AND notification.user_id_sender=".$User_id." 
    AND notification.icon='favorite'";    
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