
<?php

if ($_SERVER['REQUEST_METHOD']== 'POST'){


    // Add config file
    require_once 'config.php';

    $tempData = array();
    //sleep(0.5);
    $sql = "SELECT competition.sender_counter AS counter_sender,users.first_name AS fname_sender, users.last_name AS lname_sender, users.image AS image_sender, competition.receiver_counter AS counter_receiver, u2.first_name AS fname_receiver, u2.last_name AS lname_receiver, u2.image AS image_receiver, competition.end_time, competition.receiver_accept FROM competition INNER JOIN users ON competition.sender_id = users.id LEFT JOIN users u2 ON competition.receiver_id = u2.id";
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