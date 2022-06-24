
<?php


if ($_SERVER['REQUEST_METHOD']== 'POST'){
    // Add config file
    require_once 'config.php';
    // Read DATA
    
    $Email= $_POST['email'];
    //Check Email Exisit?
    //sleep(0.5);
    
    
    require_once("send_email.php");
    sendTo($Email, "Account Suspended", "We’re sorry to inform you that your NOcotine account has been suspended due to content that violated our policies.");
 
        mysqli_close($conn);
}else{
    http_response_code(404);
    header('Content-Type:application/json');
    echo '{ "message": "page not found"}';
}