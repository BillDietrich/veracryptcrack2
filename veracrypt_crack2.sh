#!/bin/sh
#------------------------------------------------------------------------------
# veracrypt_crack2.sh


#------------------------------------------------------------------------------

# Container location
container="test2.container"		# hash SHA-512   encryption AES
#container="test1.container"	# hash SHA-256   encryption Camellia 256

# hashcat hash-type value (derived from encryption algorithm settings of the VeraCrypt volume)
hashtype="13721"		# hash SHA-512   encryption AES    (VeraCrypt 1.24 default)
#hashtype="13751"		# hash SHA-256   encryption Camellia 256
# to see all supported TrueCrypt/VeraCrypt configuration values, run this:
#		hashcat --help | grep -i "FDE" | grep -e X -e Y

# Wordlist
wordlist="wordlist.txt"

# PIM and NO-PIM support (NO-PIM = cracking without PIM)
pimsupport="0"
nopimsupport="1"

# Add one or multiple PIMs, use space as delimeter
pims="1234 1337"

# Set 1 if you want to crack with keyfiles
keyfilesupport="0"
keylocation="keyfile"	# actually a comma-separated list of filenames

# how much performance impact to let hashcat put on the desktop system
# 1 = "Minimal", 2 = "Noticeable", 3 = "Unresponsive", 4 = "Headless"
workloadprofile="2"


#------------------------------------------------------------------------------

wc -l "$wordlist" >tmp1.txt
sed -i "s/ .*//" tmp1.txt
count=`cat tmp1.txt`
echo "Wordlist file $wordlist contains $count words."
echo

if [ "$nopimsupport" -eq "1" ]; then
	echo "-----------------------------------"
	echo "PIM: none     Keyfile: none"
	set -x
	hashcat --force --status --hash-type="$hashtype" --attack-mode=0 --workload-profile="$workloadprofile" "$container" wordlist.txt >tmp1.txt
	set +x
	grep -e "$container": -e 'Status...' tmp1.txt
	grep ': Cracked' tmp1.txt >/dev/null
	if [ "$?" -eq "0" ]; then
		echo "Worked !  Done !"
		rm -f tmp1.txt
		exit
	fi

	if [ $keyfilesupport -eq "1" ]; then
		# note: apparently even if you specify a keyfile,
		# hashcat always tries the no-keyfile case too
		echo "-----------------------------------"
		echo "PIM: none     Keyfile: $keylocation"
		set -x
		hashcat --force --status --hash-type="$hashtype" --veracrypt-keyfiles="$keylocation" --attack-mode=0 --workload-profile="$workloadprofile" "$container" wordlist.txt >tmp1.txt
		set +x
		grep -e "$container": -e 'Status...' tmp1.txt
		grep ': Cracked' tmp1.txt >/dev/null
		if [ "$?" -eq "0" ]; then
			echo "Worked !  Done !"
			rm -f tmp1.txt
			exit
		fi
	fi
fi

if [ "$pimsupport" -eq "1" ]; then
	for pim in $pims; do
		# note: apparently even if you specify a PIM,
		# hashcat always tries the no-PIM case too
		echo "-----------------------------------"
		echo "PIM: $pim     Keyfile: none"
		set -x
		hashcat --force --status --hash-type="$hashtype" --veracrypt-pim="$pim" --attack-mode=0 --workload-profile="$workloadprofile" "$container" wordlist.txt >tmp1.txt
		set +x
		grep -e "$container": -e 'Status...' tmp1.txt
		grep ': Cracked' tmp1.txt >/dev/null
		if [ "$?" -eq "0" ]; then
			echo "Worked !  Done !"
			rm -f tmp1.txt
			exit
		fi

		if [ $keyfilesupport -eq "1" ]; then
			# note: apparently even if you specify a PIM and a keyfile,
			# hashcat always tries the no-PM-no-keyfile case too
			echo "-----------------------------------"
			echo "PIM: $pim     Keyfile: $keylocation"
			set -x
			hashcat --force --status --hash-type="$hashtype" --veracrypt-pim="$pim" --veracrypt-keyfiles="$keylocation" --attack-mode=0 --workload-profile="$workloadprofile" "$container" wordlist.txt >tmp1.txt
			set +x
			grep -e "$container": -e 'Status...' tmp1.txt
			grep ': Cracked' tmp1.txt >/dev/null
			if [ "$?" -eq "0" ]; then
				echo "Worked !  Done !"
				rm -f tmp1.txt
				exit
			fi
		fi
	done
fi

rm -f tmp1.txt

echo "Finished.  Not found."


#------------------------------------------------------------------------------
