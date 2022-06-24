
<?php


if ($_SERVER['REQUEST_METHOD']== 'POST'){
    // Add config file
    require_once 'config.php';
    // Read DATA
    
    $Email= $_POST['email'];
    $string="abcdefghijklmnpkirstuvxyzABCDEFGHIJKLMNPQIRSTUVXYZ0123456789!@#$%^&*()_";
    $generate_pass=substr(str_shuffle($string),0,8);
    $Password = $generate_pass;
    $Conf_password = $generate_pass;
    //Check Email Exisit?
    //sleep(0.5);
    $sql = "SELECT *
    FROM users
    WHERE users.email='$Email'";
    $result = mysqli_query($conn, $sql);

    if (mysqli_num_rows($result) > 0) {
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
    require_once("send_email.php");
    sendTo($Email, "Reset Password", "New Password: $Password");
    $Password=md5($Password);
    // Insert Data
    $sql = "UPDATE users
    SET users.password = '$Password'
    WHERE users.email = '$Email'";
        
        
        
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


    } else {
         http_response_code(401);
        header('Content-Type:application/json');
        echo '{ "message": "Email Not Found"}';
        return;
    }
    
    
    
  
        // close 
        mysqli_close($conn);
}else{
    http_response_code(404);
    header('Content-Type:application/json');
    echo '{ "message": "page not found"}';
}