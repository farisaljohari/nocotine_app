<?php
function updateTotalComments($post_id,$conn)
{

    // Add config file
    require_once 'config.php';

    $tempData = array();
    $tempData2 = array();
    //sleep(0.5);
    $sql = "SELECT 
    COUNT(comments.post_id) AS Total_comments
    FROM posts
    LEFT JOIN comments ON posts.post_id = comments.post_id
    WHERE posts.post_id='$post_id'
    GROUP BY posts.post_id";
    $result = mysqli_query($conn, $sql);
if (mysqli_query($conn, $sql)) {
  if (mysqli_num_rows($result) > 0) {
  // output data of each row
    while($row = mysqli_fetch_assoc($result)) {
        $tempData  = $row["Total_comments"];
        echo $tempData;
        }
} else {
    $tempData = array();
}

    // http_response_code(200);
    // header('Content-Type:application/json');
    // //echo json_encode($tempData);
    // echo $tempData;
    $sql2="UPDATE posts
    SET total_comments = '$tempData'
    WHERE posts.post_id = '$post_id'";
    if (mysqli_query($conn, $sql2)) {
} else {
  echo "Error updating record: " . mysqli_error($conn);
}
} else {
  echo "Error updating record1: " . mysqli_error($conn);
}


    
mysqli_close($conn);

   
}