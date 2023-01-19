#!/bin/bash

# Get url for the latest version of Discord from the Discord API
POST=$(curl -sI 'https://discord.com/api/download?platform=linux&format=deb' | grep location | sed 's/\r//g') 

# Get the filename of the latest version
filename=$(echo $POST | cut -c55-) 

# Get the url for the file location
url=$(echo $POST | cut -c11-) 

# Get the last version number of Discord
last_version=$(echo $POST | cut -c63-68) 

# Initialize the counter
init=false

# Loop until the script is interrupted
while true
do
    # Check if Discord is running or if the counter is equal to 0
    if pgrep Discord > /dev/null || [ $init == false ] ; then
        
        # Check if Discord is installed
        if dpkg -s discord &> /dev/null; then 
            
            # Get the current version of Discord that is installed
            current_version=$(dpkg -s discord | grep Version | cut -c10-) 
            
            # Compare the current version to the last version
            if [ "$current_version" != "$last_version" ]; then 
                
                # Kill the running Discord process
                kill $(pgrep Discord)
                
                # Download the new update
                wget "$url" 
                
                # Install the update
                dpkg -i $filename 
                
                # Delete the .deb file
                rm $filename 
                
                # Log the update in a log file
                echo "Discord version $current_version updated to $last_version"
			else
				echo "Nothing to do."  
            fi
        else
            # If Discord is not installed, print a message
            echo "Discord is not installed"
        fi
    fi
    # Increase the counter
    init=true
done
