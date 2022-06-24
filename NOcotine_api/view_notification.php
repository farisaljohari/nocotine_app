<?php

if ($_SERVER['REQUEST_METHOD']== 'GET'){

    $user_id=$_GET['User_id'];

    // Add config file
    require_once 'config.php';

    $tempData = array();
    //sleep(0.5);
    $sql = "SELECT
                users.id,
                users.first_name,
                users.last_name,
                users.image,
                users.Token,
                notification.notification_id,
                notification.user_id_sender,
                notification.post_id,
                notification.body, 
                notification.icon, 
                notification.date 
                FROM users 
                RIGHT JOIN notification ON users.id = notification.user_id_sender
                WHERE notification.user_id_reciever= ".$user_id."
                GROUP BY notification.notification_id";
    $result = mysqli_query($conn, $sql);

if (mysqli_num_rows($result) > 0) {
  // output data of each row
    while($row = mysqli_fetch_assoc($result)) {
        $tempData [] = $row;
        }
} else {
    $tempData = array();
}

    http_response_code(200);
    header('Content-Type:application/json');
    echo json_encode($tempData);

mysqli_close($conn);


}else{
    http_response_code(404);
    header('Content-Type:application/json');
    echo '{ "message": "page not found"}';
}