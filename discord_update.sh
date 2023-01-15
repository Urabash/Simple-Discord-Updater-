#!/bin/bash
POST=$(curl -sI 'https://discord.com/api/download?platform=linux&format=deb' | grep location | sed 's/\r//g') # Get Url from Discord API  
filename=$(echo $POST | cut -c55-) # Get Filename of latest version
url=$(echo $POST | cut -c11-) # Get url for file location
last_version=$(echo $POST | cut -c63-68) # Get the last version number of Discord.

if dpkg -s discord &> /dev/null; then # Check if Discord are installed.
    current_version=$(dpkg -s discord | grep Version | cut -c10-) # Get installed version
    if [ "$current_version" != "$last_version" ]; then # Compare version
        wget "$url" # Download new update
        dpkg -i $filename # install update
        rm $filename # delete .deb file
        echo "Discord version $current_version updated to $last_version" >> log.txt  
    fi
else
    echo "Discord is not installed"
fi
