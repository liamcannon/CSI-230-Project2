for user in $(cat emails.txt | cut -d "@" -f 1 ); do userdel -r $user; done
