<?php

// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){
    // Add config file
    require_once 'config.php';
    // Read DATA
    $book_name = mysqli_real_escape_string($conn,  $_POST['book_name']);
    $pdf_name_file = mysqli_real_escape_string($conn,  $_POST['pdf_name_file']);
    $book_poster = mysqli_real_escape_string($conn,  $_POST['book_poster']);

        
        // Add config file
        require_once 'config.php';

    // Insert Data
    $sql = "INSERT INTO `books`(`book_name`, `pdf_name_file`, `book_poster`)
        VALUES ('$book_name','$pdf_name_file','$book_poster')";
        
        
        
        // check query 
        if (mysqli_query($conn, $sql)) {
            require_once("get_total_comments.php");
            updateTotalComments($post_id,$conn);
            // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "add book successfully"}';
        } else {
            // print error 
            http_response_code(500);
            header('Content-Type:application/json');
            $error = mysqli_error($conn);
            echo '{ "message": '.$error.'}';
        }


        // close 
        mysqli_close($conn);
}else{
    http_response_code(404);
    header('Content-Type:application/json');
    echo '{ "message": "page not found"}';
}