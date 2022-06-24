<?php

if ($_SERVER['REQUEST_METHOD']== 'GET'){


    // Add config file
    require_once 'config.php';

    $tempData = array();
    $sql = "SELECT users.id,
    users.email,
    CONCAT(users.first_name, ' ', users.last_name) AS Name,
    users.image FROM users WHERE users.type='user'";
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





