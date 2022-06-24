<?php

if ($_SERVER['REQUEST_METHOD']== 'POST'){

    $Post_id=$_POST['post_id'];

    // Add config file
    require_once 'config.php';

    $tempData = array();
    //sleep(0.5);
    $sql = "SELECT 
    COUNT(comments.post_id) AS Total_comments
    FROM posts
    LEFT JOIN comments ON posts.post_id = comments.post_id
    WHERE posts.post_id=".$Post_id."
    GROUP BY posts.post_id";
    $result = mysqli_query($conn, $sql);

if (mysqli_num_rows($result) > 0) {
  // output data of each row
    while($row = mysqli_fetch_assoc($result)) {
        $tempData  = $row['Total_comments'];
        }
} else {
    $tempData = "0";
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