<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){
    $json = file_get_contents('php://input');
    // Converts it into a PHP object
    $data = json_decode($json);
    $Email = $data->Email;
    $Password = $data->Password;
    // Read DATA
    // $Email = $_POST['email'];
    // $Password = $_POST['password'];

        //Check is empty
        if(empty($Email) || empty($Password)){
            http_response_code(401);
            header('Content-Type:application/json');
            echo '{ "message": "empty data"}';
            return;
        }
        // Add config file
        require_once 'config.php';
        //ecrept password
        $Password=md5($Password);

    // Select Data
    $sql_login = "SELECT * FROM `users` WHERE email='$Email' AND password='$Password'";
    $results_login = mysqli_query($conn, $sql_login);    
        if (mysqli_num_rows($results_login) == 1) {
            while($row = mysqli_fetch_assoc($results_login)) {
                $templet = array(
                "id"=>"".$row['id']."",
                "first_name"=>"".$row['first_name']."",
                "last_name"=>"".$row['last_name']."",
                "email"=>"".$row['email']."",
                "verified"=>"".$row['verified']."",
                "type"=>"".$row['type']."",
                "gender"=>"".$row['gender']."",
                "Age"=>"".$row['Age']."",
                "bio"=>"".$row['bio']."",
                "image"=>"".$row['image']."",
                "visable_sheet"=>"".$row['visable_sheet']."",
                "number_of_packets"=>"".$row['number_of_packets']."",
                "price_of_packets"=>"".$row['price_of_packets']."",
            );
            
            http_response_code(200);
            header('Content-Type:application/json');
            echo json_encode($templet);
            }
            
        }else {
            // print error 
            http_response_code(401);
            header('Content-Type:application/json');
            $error = mysqli_error($conn)."Email or Password not found1";
            echo '{ "message": '.$error.'}';
        }
        
        

        // close 
        mysqli_close($conn);
}else{
    http_response_code(404);
    header('Content-Type:application/json');
    echo '{ "message": "page not found"}';
}