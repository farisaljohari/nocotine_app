<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){

    // Read DATA
    $post_id = $_POST['post_id'];
    $Comment_id = $_POST['comment_id'];
        // Add config file
        require_once 'config.php';

    // Insert Data
    $sql = "DELETE FROM `comments` WHERE comments.comment_id =".$Comment_id."";
        
    $sql2 = "DELETE FROM `admin_notification` WHERE admin_notification.comment_id=".$Comment_id."";
    $sql3 = "DELETE FROM `comments_report` WHERE comments_report.comment_id	 =".$Comment_id."";  
        // check query 
        if (mysqli_query($conn, $sql)) {
            if(mysqli_query($conn, $sql2)){
                if(mysqli_query($conn, $sql3)){
                    require_once("get_total_comments.php");
                    updateTotalComments($post_id,$conn);
                    http_response_code(200);
                    header('Content-Type:application/json');
                    echo '{ "message": "Delete Comment successfully"}';
                }
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