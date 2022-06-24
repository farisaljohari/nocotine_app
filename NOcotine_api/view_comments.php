<?php

if ($_SERVER['REQUEST_METHOD']== 'GET'){

    $post_idd=$_GET['post_id'];

    // Add config file
    require_once 'config.php';

    $tempData = array();
    //sleep(0.5);
    $sql = "SELECT users.id, users.first_name, users.last_name, users.email, users.image,comments.comment_id, comments.comment_text, posts.post_id FROM posts RIGHT JOIN comments ON posts.post_id = comments.post_id LEFT JOIN users ON comments.user_id = users.id WHERE posts.post_id=".$post_idd." GROUP BY comments.comment_id;";
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