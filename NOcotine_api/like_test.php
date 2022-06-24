<?php

if ($_SERVER['REQUEST_METHOD']== 'POST'){

    $User_ID=$_POST['user_id'];
    $Post_ID=$_POST['post_id'];

    // Add config file
    require_once 'config.php';

    $tempData = array();
    //sleep(0.5);
    $sql = "SELECT 
    likes.visable_like
    FROM posts
    LEFT JOIN likes ON posts.post_id = likes.post_id
    WHERE likes.user_id=".$User_ID." AND likes.post_id=".$Post_ID."
    GROUP BY posts.post_id";
    $result = mysqli_query($conn, $sql);
    if (mysqli_num_rows($result) > 0) {
            // output data of each row
            while($row = mysqli_fetch_assoc($result)) {
                $tempData  = $row['visable_like'];
                }
        } else {
            $tempData = "false";
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