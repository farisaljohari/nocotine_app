<?php

if ($_SERVER['REQUEST_METHOD']== 'POST'){

    $Comment_id=$_POST['comment_id'];

    // Add config file
    require_once 'config.php';

    $tempData = array();
    //sleep(0.5);
    $sql = "SELECT users.id, users.first_name, users.last_name, users.email, users.Token, users.image,comments.comment_text, comments.post_id,
    comments.comment_id
    FROM users RIGHT JOIN comments ON users.id = comments.user_id WHERE 
    comments.comment_id=".$Comment_id." GROUP BY comments.comment_id";
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