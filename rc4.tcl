package require rc4
package require base64

set msg [gets stdin]

if { $argc != 2 } {
	puts "Insert the dir, key and IV:"
	puts "    rc4.tcl -e|d 128bitkey"
	puts "\nPlease try again."
	exit 1
} else {
	set key [lindex $argv 1]
}

set mode [lindex $argv 0]
if { $mode eq "-d" } {
	##### DECRYPTION
	set decryptedMsg [::rc4::rc4 -key $key [base64::decode $msg]]
	puts "$decryptedMsg"
} elseif { $mode eq "-e" } {
	##### ENCRYPTION
	set encryptedMsg [::rc4::rc4 -key $key $msg]
	puts "[base64::encode $encryptedMsg]"
}