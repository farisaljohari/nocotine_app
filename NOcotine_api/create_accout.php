<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){
    require_once 'config.php';
    // Read DATA
    $First_name =mysqli_real_escape_string($conn,  $_POST['fname']);
    $Last_name = mysqli_real_escape_string($conn,  $_POST['lname']);
    $Email = mysqli_real_escape_string($conn,  $_POST['email']);
    $Password = mysqli_real_escape_string($conn,  $_POST['password']);
    $Conf_password = mysqli_real_escape_string($conn,  $_POST['conf_password']);
    $Gender = mysqli_real_escape_string($conn,  $_POST['gender']);
    $Age = mysqli_real_escape_string($conn,  $_POST['Age']);
    $Bio = "";
    $Image = "user.png";
    $Visable_Sheet = 0;
    $Type="user";
    $Verified=0;
    $Verification_code = 'qwertzuiopasdfghjklyxcvbnmQWERTZUIOPASDFGHJKLYXCVBNM0123456789!$/()*';
	$Verification_code = str_shuffle($Verification_code);
	$Verification_code = substr($Verification_code, 0, 10);
        //Check is empty
        if(empty($First_name) || empty($Last_name) || empty($Email) || empty($Password) || empty($Conf_password) || empty($Gender)){
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
    $sql = "INSERT INTO `users`(`first_name`, `last_name`, `email`, `verified`, `verification_code`, `type`, `password`, `gender`, `Age`, `bio`, `image`,`visable_sheet`) VALUES ('$First_name','$Last_name','$Email','$Verified','$Verification_code','$Type','$Password','$Gender','$Age','$Bio','$Image','$Visable_Sheet')";
        
        // check query 
        if (mysqli_query($conn, $sql)) {
             require_once("send_email.php");
            sendTo($Email, "Email Verification", 
            "
                    Click on this link to verify your email:<br><br>
                    
                    <a href='https://nocotine.ofitjo.com/NOcotine_api/verify_email.php?email=$Email&verification_code=$Verification_code'>Click Here</a>
                ");
            // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "created user successfully"}';
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


