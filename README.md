# veracryptcrack2

VeraCrypt container cracker using hashcat and wordlist/dictionary.  Linux-only.

You DO need to know the encryption algorithm settings of the VeraCrypt volume to decrypt it.

May be useful if you forget PIM, which keyfile you used, or mixed up a few characters in a password.

When done, use 'wipe' or 'srm' to securely overwrite your wordlist.

Good luck recovering.


### Run via:

```shell
# This takes around 500 MB of disk space !
sudo apt install hashcat

chmod u+x veracrypt_crack2.sh

# Make sure you have necessary software installed:
hashcat --version

# To check that everything works correctly before spending more time,
# run script as given.  It will run against test2.container.
# It shouldn't take more than a minute or two (because the fourth
# line in the wordlist is the correct password).
./veracrypt_crack2.sh
# You should see a "Cracked" message and "test2.container:THECRACKEDPASSWORD"

# Then, edit veracrypt_crack2.sh to specify the container you need
# to crack.  The main thing to know is what hash and encryption algorithms
# were specified when creating the container; see comments in veracrypt_crack2.sh
# You also can edit wordlist.txt or specify a different wordlist file.
```



#### Notes

Inspired by https://github.com/BillDietrich/veracryptcrack and 
https://github.com/BillDietrich/keepasscrack

```shell
# see all TrueCrypt/VeraCrypt configuration values
hashcat --help | grep -i "FDE" | grep -e X -e Y

# test.container: SHA512   AES-Twofish-Serpent   password crackmeifyoucan   PIM 1337
hashcat --force --status --hash-type=13722 --veracrypt-pim=1337 --attack-mode=0 --workload-profile=2 test.container wordlist.txt
# fails: I think "AES-Twofish-Serpent" is not supported by hashcat

# test1.container:  hash SHA-256   encryption Camellia 256    password 123456789   no PIM no keyfile
# use hash-type 13751
hashcat --force --status --hash-type=13731 --attack-mode=0 --workload-profile=2 test1.container wordlist.txt
# see:		test1.container:123456789                        
#			Session..........: hashcat                       
#			Status...........: Cracked

# These are VeraCrypt 1.24 default settings when you create a container:
# test2.container:  hash SHA-512   encryption AES    password 123456789   no PIM no keyfile
# use hash-type 13721
hashcat --force --status --hash-type=13721 --attack-mode=0 --workload-profile=2 test2.container wordlist.txt
# see:		test2.container:123456789                        
#			Session..........: hashcat                       
#			Status...........: Cracked


# https://gist.github.com/GabMus/4b6f7167730a4a274cdee19696783e72
# https://pastebin.com/R8stQCCy
# https://web.archive.org/web/20161026005447/0x31.de/cracking-truecrypt-container-non-system-system/
```



## Privacy Policy

This code doesn't collect, store or transmit your identity or personal information in any way.
