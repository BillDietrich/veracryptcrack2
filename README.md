# veracryptcrack

Simple veracrypt container cracker using wordlist

All configuration is done from veracrypt_crack.sh

Install 'timeout' package before running

When password is cracked - container will be mounted

Give your user permissions to mount or run as root

To check everything works correctly before spending more time, run script against veracrypt test.container, it shouldn't take more than 1 minute

Often useful when you forget PIM, which keyfile you used, or mixed up a few characters in a password

When done, use 'wipe' or 'srm' to securely overwrite your wordlist

Good luck recovering


## Notes by Bill Dietrich

### Source

Originally from https://github.com/RhZjQyMWI/veracryptcrack

Found it from https://pay.reddit.com/r/VeraCrypt/comments/fatkq2/forgot_my_password_earlier_today_so_wrote/ by /u/IndependentHorror5 :

> Managed to get back into the container within ~45 minutes of automated cracking which was preceded with ~2 hours of manual trying.
>
> This was not a pure bruteforce, but rather speeding up based on some possibly known parameters about the container which was not opened for a while.
>
> Knew there was a PIM but did not know which one and a long password which I couldn't remember clearly. So i've added 20-25 possible PIM combinations to PIM list, numbers that have some meaning to me and generated a wordlist from multiple combinations of passwords I could have used for that container. wordlist.txt had around 500 or more combinations. Came back from lunch and saw a warning that the volume can't be mounted, because it's already mounted. :)

### Run via:

```shell
chmod a+x veracrypt_crack.sh

# Make sure you have software installed:
timeout --version
veracrypt --text --version

sudo ./veracrypt_crack.sh
# Only way to stop it running is to close the terminal !

# On my slow laptop, with 5-second timeout, it ran for 52 minutes and failed to open the test container.
# Wordlist has 208 passwords in it, multiplied by 3 PIM values for each password.

# Launched VeraCrypt GUI app and left it open.
# Changed timeout to 10 seconds and tried again.
# Worked in 3 minutes.
# Correct password/PIM are not the ones just above the "Error: already mounted" message, but the next ones above that.

# Left VeraCrypt GUI app open.
# Changed timeout back to 5 seconds and tried again.
# Again it ran for 52 minutes and failed.
```

## Misc

Relevent: https://github.com/NorthernSec/VeraCracker


## Privacy Policy

This code doesn't collect, store or transmit your identity or personal information in any way.
