#!/bin/bash

#checking root

if [[ "$EUID" != 0 ]]; then
    echo "Must Run as Root"
    exit
fi

file=$1
if [ -f $file ]; then
    echo "${file} exists"
else
    echo "File Does not Exist"
    exit 1
fi

#functions

# generating random passwords
#generates a password 10 long with only letters and numbers
randompaswd() {
    head /dev/urandom | tr -dc A-Za-z0-9 | head -c 10

    #https://unix.stackexchange.com/questions/230673/how-to-generate-a-random-stringcat
}

for l in $(cat $file); do
    user=$(echo $l | cut -d"@" -f1)
    pass=$(randompaswd)
    #
    if useradd --badnames $user -p $(echo $pass | openssl passwd -1 -stdin); then 
        echo "${user} your password is ${pass}" | sendmail $l
        echo "Created ${user}"
    else
        echo -e "${pass}\n${pass}" | passwd $user
        echo "${user} your password has been changed to ${pass}" | sendmail $l
    fi
done
#https://websiteforstudents.com/force-ubuntu-users-to-change-password-at-next-logon/#:~:text=At%20create%20a%20new%20user,corner%E2%80%A6%20than%20Add%20User..&text=This%20setting%20should%20allow%20the%20user%20change%20password%20at%20the%20next%20login.
#https://vitux.com/three-ways-to-send-email-from-ubuntu-command-line/
