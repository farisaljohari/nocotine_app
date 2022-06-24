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
        users.email,
        users.image, 
        posts.post_text,
        posts.post_id, 
        posts.feeling,
        posts.total_comments,
        posts.image_post,  
        COUNT(DISTINCT likes.post_id) AS Total_likes
        FROM users 
        RIGHT JOIN posts ON users.id = posts.user_id 
        LEFT JOIN likes ON posts.post_id = likes.post_id 
        WHERE users.id= ".$user_id."
        GROUP BY posts.post_id";
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