<?php

function sendTo($mailTo, $subject, $body)
{

    require("../PHPMailer/src/PHPMailer.php");
    require("../PHPMailer/src/SMTP.php");

    $mail = new PHPMailer\PHPMailer\PHPMailer();
    $mail->IsSMTP(); // enable SMTP

    $mail->SMTPDebug = 1; // debugging: 1 = errors and messages, 2 = messages only
    $mail->SMTPAuth = true; // authentication enabled
    $mail->SMTPSecure = 'ssl'; // secure transfer enabled REQUIRED for Gmail
    $mail->Host = "nocotine.app";
    $mail->Port = 465; // or 587
    $mail->IsHTML(true);
    $mail->Username = "nocotine@nocotine.app";
    $mail->Password = "NOcotine1234";
    $mail->SetFrom("nocotine@nocotine.app");
    $mail->Subject = $subject;
    $mail->Body = $body;
    $mail->AddAddress($mailTo);

    if (!$mail->Send()) {
         // print error 
            http_response_code(500);
            header('Content-Type:application/json');
            echo '{ "message": "send Email error"}';
    } else {
        // print successfully 
            http_response_code(200);
            header('Content-Type:application/json');
            echo '{ "message": "send Email successfully"}';
    }
}
?>