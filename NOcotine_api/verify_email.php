<!DOCTYPE html>
<html>
<head>
<style>
.center {
  display: block;
  margin-left: auto;
  margin-right: auto;
  text-align: center;
}
h2 {
  color: #373A6D;
  font-family: Helvetica;
  font-size: 32px;
}
</style>
</head>
<body>

<?php
	function redirect() {
	    echo '<div class="center">
  <img class="center" src="images/faild_verfiy .gif" alt="Girl in a jacket" width="300" height="300">
  <h2>Verification Failed</h2>
</div>
';
	}

	if (!isset($_GET['email']) || !isset($_GET['verification_code'])) {
		redirect();
	} else {
		
        require_once 'config.php';
		$email = mysqli_real_escape_string($conn,  $_GET['email']);
		$verification_code = mysqli_real_escape_string($conn,  $_GET['verification_code']);

		if($email != "" && $verification_code != ""){
		    $sql = "SELECT id FROM users WHERE email='$email' AND verification_code='$verification_code' AND verified=0";
        //echo mysqli_query($conn, $sql);
        $result=mysqli_query($conn, $sql);
        
		if (mysqli_num_rows($result) ) {
			$sql2="UPDATE users SET verified=1, verification_code='' WHERE email='$email'";
			if (mysqli_query($conn, $sql2)) {
			    
			    echo '<div class="center">
  <img class="center" src="images/vareification_sucess.gif" alt="Girl in a jacket" width="300" height="300">
  <h2>Your email has been verified! You can log in now!</h2>
</div>
';
			}else{
			    redirect();
			}
			
		} else
			redirect();
	        }
		else{
		   redirect(); 
		}}
?>

</body>
</html>

