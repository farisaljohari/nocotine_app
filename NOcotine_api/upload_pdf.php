<?php 

$target_dir = "pdf/";

$target_file = $target_dir .  $_FILES['image']['name'];
$uploadOk = 1;
$imageFileType = strtolower(pathinfo($target_file,PATHINFO_EXTENSION));

// Check if image file is a actual image or fake image

//   $check = getimagesize($_FILES["image"]["tmp_name"]);
//   if($check !== false) {
//     echo "File is an image - " . $check["mime"] . ".";
//     $uploadOk = 1;
//   } else {
//     echo "File is not an image.";
//     $uploadOk = 0;
//   }


// Check if file already exists
if (file_exists($target_file)) {
  echo "Sorry, file already exists.";
  $uploadOk = 0;
}

// Check file size
// if ($_FILES["image"]["size"] > 100000000) {
//      http_response_code(500);
//     header('Content-Type:application/json');
//     echo '{ "message": "Sorry, your file is too large."}';
//   $uploadOk = 0;
// }

// // Allow certain file formats
// if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg"
// && $imageFileType != "pdf" ) {
//     http_response_code(500);
//     header('Content-Type:application/json');
//     echo '{ "message": "Sorry, only JPG, JPEG, PNG & GIF files are allowed."}';
//   $uploadOk = 0;
// }

// Check if $uploadOk is set to 0 by an error
if ($uploadOk == 0) {
    http_response_code(500);
    header('Content-Type:application/json');
    echo '{ "message": "Sorry, your file was not uploaded."}';
// if everything is ok, try to upload file
} else {

    
  if (move_uploaded_file($_FILES['image']['tmp_name'],$target_file)) {
    http_response_code(200);
    header('Content-Type:application/json');
    echo '{ "message": "has been uploaded"}';
    
  } else {
      http_response_code(500);
    header('Content-Type:application/json');
    echo '{ "message": "Sorry, there was an error uploading your file."}';
  }
}
?>