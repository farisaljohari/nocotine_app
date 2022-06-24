<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){
    // Add config file
    require_once 'config.php';
    // Read DATA
    $Password = mysqli_real_escape_string($conn, $_POST['password']);
    $Conf_password = mysqli_real_escape_string($conn, $_POST['conf_password']);
    $User_id = $_POST['user_id'];
    //Check is empty
    if(empty($Password) || empty($Conf_password)){
        http_response_code(401);
        header('Content-Type:application/json');
        echo '{ "message": "empty data"}';
        return;
    }
    // Add config file
    require_once 'config.php';

    //Check Cofirm Password
    if($Password!=$Conf_password){
        http_response_code(401);
        header('Content-Type:application/json');
        echo '{ "message": "Password does not match"}';
        return;
    }
    $Password=md5($Password);
    // Insert Data
    $sql = "UPDATE users
    SET users.password = '".$Password."'
    WHERE users.id = ".$User_id."";
        
        
        
        // check query 
        if (mysqli_query($conn, $sql)) {
            // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "update password successfully"}';
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