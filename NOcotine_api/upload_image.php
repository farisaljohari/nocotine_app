<?php
require_once 'config.php';
// check Request Type
if ($_SERVER['REQUEST_METHOD']== 'POST'){

    // Read DATA
    
    $User_id = $_POST['user_id'];
    $Image=$_POST['image'];
    $Image_name=$_POST['imageName'];

    $random1 = substr(number_format(time() * rand(),0,'',''),0,10); 
    $target_dir = "images/";
    $target_file = $target_dir . $random1 . basename($Image_name);
    $uploadOk = 1;
    $imageFileType = strtolower(pathinfo($target_file,PATHINFO_EXTENSION));

    // // Check if image file is a actual image or fake image
    
    // $check = getimagesize($_FILES['image']["tmp_name"]);
    // if($check !== false) {
    //     echo "File is an image - " . $check["mime"] . ".";
    //     $uploadOk = 1;
    // } else {
    //     echo "File is not an image.";
    //     $uploadOk = 0;
    // }
    

    // // Check if file already exists
    // if (file_exists($target_file)) {
    // echo "Sorry, file already exists.";
    // $uploadOk = 0;
    // }

    // // Check file size
    // if ($_FILES['image']["size"] > 500000) {
    // echo "Sorry, your file is too large.";
    // $uploadOk = 0;
    // }

    // // Allow certain file formats
    // if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg"
    // && $imageFileType != "gif" ) {
    // echo "Sorry, only JPG, JPEG, PNG & GIF files are allowed.";
    // $uploadOk = 0;
    // }

    // Check if $uploadOk is set to 0 by an error
    if ($uploadOk == 0) {
    echo "Sorry, your file was not uploaded.";
    // if everything is ok, try to upload file
    } else {
    if (move_uploaded_file($Image, $target_file)) {
        echo "The file ". htmlspecialchars( basename( $Image_name)). " has been uploaded.";
                // Add config file
                require_once 'config.php';

                // Insert Data
                $sql = "UPDATE users
                SET users.image = '".$Image_name."'
                WHERE users.id = ".$User_id."";
                    
                    
                    
                    // check query 
                    if (mysqli_query($conn, $sql)) {
                        // print successfully 
                        http_response_code(200);
                        header('Content-Type:application/json');
                        echo '{ "message": "Update image successfully"}';
                    } else {
                        // print error 
                        http_response_code(500);
                        header('Content-Type:application/json');
                        $error = mysqli_error($conn);
                        echo '{ "message": '.$error.'}';
                    }
                     // close 
        mysqli_close($conn);
    } else {
        
        // print error 
        http_response_code(500);
        header('Content-Type:application/json');
        $error = mysqli_error($conn);
        echo '{ "message": '.$error.'}';
        echo "$Image";
        echo "Sorry, there was an error uploading your file.";
        echo "$Image_name";
    }
    }
//////////////////////////////////////////////////////////////////////////////////////




}else{
    http_response_code(404);
    header('Content-Type:application/json');
    echo '{ "message": "page not found"}';
}