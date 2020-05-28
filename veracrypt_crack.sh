#!/bin/bash

# Container location
container="test.container"
# Wordlist
wordlist="wordlist.txt"
# Add one or multiple PIMs, use space as delimeter
pims="1234 1337"
# Set timeout to higher number for big containers, if additional or multiple keys are used or a high number PIM is used
# Note if timeout is too low, veracrypt process might get killed and stop mounting process even when container password is correct
timeout="5"
# PIM and NO-PIM support (NO-PIM = cracking without PIM)
pimsupport="1"
nopimsupport="1"
# Set 1 if you want to crack with keyfiles
keyfilesupport="0"
keylocation="keyfile"
# Set 1 if container was created with truecrypt
truecryptsupport="0"

while read line; do

	if [ "$pimsupport" -eq "1" ]; then
		for pim in $pims; do
			echo -e "-----\nPIM: $pim\nPassword: $line\n-----"
			timeout $timeout veracrypt -t `if [ $truecryptsupport -eq "1" ]; then echo " --truecrypt "; fi` --non-interactive --pim=$pim --password="$line" --mount $container

			if [ $keyfilesupport -eq "1" ]; then
				echo -e "-----\nPIM: $pim\nPassword: $line\nKeyfile: $keylocation\n-----"
				timeout $timeout veracrypt -t `if [ $truecryptsupport -eq "1" ]; then echo " --truecrypt "; fi` --non-interactive --keyfiles="$keylocation" --pim=$pim --password="$line" --mount $container
			fi
		done
	fi

	if [ "$nopimsupport" -eq "1" ]; then
		echo -e "-----\nPIM: none\nPassword: $line\n-----"
		timeout $timeout veracrypt -t `if [ $truecryptsupport -eq "1" ]; then echo " --truecrypt "; fi` --non-interactive --password="$line" --mount $container

		if [ $keyfilesupport -eq "1" ]; then
			echo -e "-----\nPIM: none\nPassword: $line\nKeyfile: $keylocation\n-----"
			timeout $timeout --veracrypt -t `if [ $truecryptsupport -eq "1" ]; then echo " --truecrypt "; fi` --non-interactive --keyfiles="$keylocation" --mount $container
		fi
	fi

done < $wordlist
