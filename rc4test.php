RC4:
<Pre>
&lt;?php
   require_once( "rc4.php" );
   $key = "12345";
   $key = "0123456789abcdef";
   $plaintext = "Hello World!";
   $ciphertext = rc4( $key, $plaintext );
   $decrypted = rc4( $key, $ciphertext );
   echo bin2hex($ciphertext) . "&lt;BR&gt;";
   echo $decrypted . " = " . $plaintext . "&lt;BR&gt;";
?&gt;
</pre>

<?php
   require_once( "rc4.php" );
   $key = "12345";
   $key = "0123456789abcdef";
   $plaintext = "Hello World!";
   $ciphertext = rc4( $key, $plaintext );
   $decrypted = rc4( $key, $ciphertext );
   echo bin2hex($ciphertext) . "<BR>";
   echo $decrypted . " = " . $plaintext . "<BR>";
?>