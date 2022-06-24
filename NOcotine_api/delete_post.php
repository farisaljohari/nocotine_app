<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){

    // Read DATA
    
    $Post_id = $_POST['post_id'];
        // Add config file
        require_once 'config.php';

    // Insert Data
    $sql1 = "DELETE FROM `posts` WHERE posts.post_id=".$Post_id."";
    $sql2 = "DELETE FROM `notification` WHERE notification.post_id=".$Post_id."";   
    $sql3 = "DELETE FROM `likes` WHERE likes.post_id=".$Post_id."";    
    $sql4 = "DELETE FROM `comments` WHERE comments.post_id=".$Post_id."";     
    $sql5 = "DELETE FROM `admin_notification` WHERE admin_notification.post_id	 =".$Post_id."";      
    $sql6 = "DELETE FROM `posts_report` WHERE posts_report.	post_id	 =".$Post_id."";  
        // check query 
        if (mysqli_query($conn, $sql1)) {
            if(mysqli_query($conn, $sql2)){
                if(mysqli_query($conn, $sql3)){
                    if(mysqli_query($conn, $sql4)){
                       if(mysqli_query($conn, $sql5)){
                            if(mysqli_query($conn, $sql6)){
                                 http_response_code(200);
                                header('Content-Type:application/json');
                                echo '{ "message": "Delete SQL1,2,3,4 successfully"}';
                            }
                       }
                    }
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