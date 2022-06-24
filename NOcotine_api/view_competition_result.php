
<?php

if ($_SERVER['REQUEST_METHOD']== 'POST'){


    // Add config file
    require_once 'config.php';

    $tempData = array();
    //sleep(0.5);
    $sql = "SELECT competition_result . * ,users.first_name AS fname_win,
            users.last_name AS lname_win,
            users.image AS image_win,
            u2.first_name AS fname_lose,
            u2.last_name AS lname_lose,
            u2.image AS image_lose
            FROM competition_result  
            INNER JOIN users ON competition_result.winner_user_id = users.id 
            LEFT JOIN users u2 ON competition_result.loser_user_id = u2.id ";
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