<h2>OpenSSL-PHP Protocol</h2>
<h3>Two-way Encryption</h3>
OpenSSL Command for Encrypt:<BR>
<pre>
echo 8JtNu7+sqTM6EesPcLE=|base64 -d|edgetk -crypt dec -cipher rc4 -key 38303631373936633363393733383634
</pre>

PHP Code:<BR>
<pre>
&lt;?php
$plaintext = 'Secret Message';
$key = '8061796c3c973864';
$r = openssl_encrypt(
    $plaintext,
    'rc4',
    $key, 
    OPENSSL_RAW_DATA | OPENSSL_NO_PADDING,
    ""
);

echo base64_encode($r);

echo "<br>";

$t = openssl_decrypt(
    $r,
    'rc4',
    $key, 
    OPENSSL_RAW_DATA | OPENSSL_NO_PADDING,
    ""
);
echo $t;
?&gt;
</pre>

<pre>
<?php
$plaintext = 'Secret Message';
$key = '8061796c3c973864';
$r = openssl_encrypt(
    $plaintext,
    'rc4',
    $key, 
    OPENSSL_RAW_DATA | OPENSSL_NO_PADDING,
    ""
);

echo base64_encode($r);

echo "<br>";

$t = openssl_decrypt(
    $r,
    'rc4',
    $key, 
    OPENSSL_RAW_DATA | OPENSSL_NO_PADDING,
    ""
);
echo $t;
?>
</pre>