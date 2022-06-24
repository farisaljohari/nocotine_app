<?php

// check Request Type 
if ($_SERVER['REQUEST_METHOD']== 'POST'){

    // Read DATA
    
    $User_id = $_POST['user_id'];
        // Add config file
        require_once 'config.php';

    // Insert Data
   // Insert Data
    $sql1 = "DELETE FROM `users` WHERE users.id=".$User_id."";
    $sql2 = "DELETE FROM `posts` WHERE posts.user_id=".$User_id."";
    $sql3 = "DELETE FROM `notification` WHERE notification.user_id_sender=".$User_id." OR notification.user_id_reciever=".$User_id."";   
    $sql4 = "DELETE FROM `likes` WHERE likes.user_id=".$User_id."";    
    $sql5 = "DELETE FROM `comments` WHERE comments.user_id=".$User_id."";     
    $sql6 = "DELETE FROM `competition` WHERE competition.sender_id = ".$User_id." OR competition.receiver_id = ".$User_id."";
    $sql7 = "DELETE FROM `feedback` WHERE feedback.user_id=".$User_id."";  
    $sql8 = "DELETE FROM `smoking_counter` WHERE smoking_counter.user_id=".$User_id."";  
        
        // check query 
        if (mysqli_query($conn, $sql1)) {
            if(mysqli_query($conn, $sql2)){
                if(mysqli_query($conn, $sql3)){
                    if(mysqli_query($conn, $sql4)){
                        if(mysqli_query($conn, $sql5)){
                            if(mysqli_query($conn, $sql6)){
                                if(mysqli_query($conn, $sql7)){
                                    if(mysqli_query($conn, $sql8)){
                                        http_response_code(200);
                                        header('Content-Type:application/json');
                                        echo '{ "message": "Delete SQL1,2,3,4,5,6,7,8 successfully"}';
                                    }
                                }
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