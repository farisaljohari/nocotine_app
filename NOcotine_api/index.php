<?php

if ($_SERVER['REQUEST_METHOD']== 'GET'){

    $data = array("message"=> "Welcome ^_*");
    http_response_code(200);
    header('Content-Type:application/json');
    echo json_encode($data);
}

