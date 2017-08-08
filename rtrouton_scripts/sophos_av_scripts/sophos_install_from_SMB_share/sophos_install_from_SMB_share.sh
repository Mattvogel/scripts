#!/bin/sh

# Checks for Sophos Antivirus uninstaller package.
# If present, uninstall process is run

if [ -d "/Library/Sophos Anti-Virus/Remove Sophos Anti-Virus.pkg" ]; then
     /usr/sbin/installer -pkg "/Library/Sophos Anti-Virus/Remove Sophos Anti-Virus.pkg" -target /
elif [ -d "/Library/Application Support/Sophos Anti-Virus/Remove Sophos Anti-Virus.pkg" ]; then
     /usr/sbin/installer -pkg "/Library/Application Support/Sophos Anti-Virus/Remove Sophos Anti-Virus.pkg" -target /    
else
   echo "Sophos Antivirus Uninstaller Not Present"
fi

# Stops the Sophos menu bar process. Sophos icon will disappear.

killall SophosUIServer


# Make an SMB mount directory, after checking for and removing any leftover instances from a broken install

if [ -d /private/tmp/sophos_mount ]; then
	rm -rf /private/tmp/sophos_mount
	mkdir /private/tmp/sophos_mount
	logger "Sophos SMB mount directory created after removing old directory"
else
	mkdir /private/tmp/sophos_mount
	logger "Sophos SMB mount directory created"
fi


# Make a working directory, after checking for and removing any leftover instances from a broken install

if [ -d /private/tmp/sophos_install ]; then
	rm -rf /private/tmp/sophos_install
	mkdir /private/tmp/sophos_install
	logger "Sophos install temp directory created after removing old directory"
else
	mkdir /private/tmp/sophos_install
	logger "Sophos install temp directory created"
fi

# Mount the Sophos client installs share to /private/tmp/sophos_mount
# To make this script work, you will need to edit the mount_smbfs command
# below with the appropriate login information for your environment

mount_smbfs -o nobrowse //'DOMAIN;username:password'@server.name.here/Client_Installs /private/tmp/sophos_mount

# Zips the contents of the ESCOSX directory from 
# the Client_Installs share and stores it
# as /private/tmp/sophos/sophos.zip

ditto -c -k -X /private/tmp/sophos_mount/ESCOSX /private/tmp/sophos_install/sophos.zip

# Unmount the Client_Installs share and remove the SMB mount directory

umount /private/tmp/sophos_mount
rm -rf /private/tmp/sophos_mount

# Decompress the zip file 

cd /private/tmp/sophos_install/
unzip sophos.zip

# Install. Normally, installer requires sudo, but the jamf binary runs with admin rights, and using sudo here breaks the script.

if [ -d /private/tmp/sophos_install/sophos]; then
   logger "Installing Sophos"
   installer -dumplog -verbose -pkg /private/tmp/sophos/sophos/Sophos\ Anti-Virus.mpkg -target /
   logger "Sophos installation process completed"
else
   echo "Sophos Antivirus Installer Not Present. Aborting Install."
fi

# Write configuration file
# Note: Plist file here is only an example. You will
# need to provide your own plist settings between the
# following lines:
#
# /bin/cat > "/Library/Sophos Anti-Virus/com.sophos.sau.plist" << 'SOPHOS_CONFIG'
#
# ....plist data goes here....
#
# SOPHOS_CONFIG
#

/bin/cat > "/Library/Sophos Anti-Virus/com.sophos.sau.plist" << 'SOPHOS_CONFIG'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>PrimaryServerPassword</key>
	<string>iQEHHMzvIdHYUwBJDp01cT3r16od4NZ</string>
	<key>PrimaryServerProxy</key>
	<integer>0</integer>
	<key>PrimaryServerProxyPassword</key>
	<string>AAA=</string>
	<key>PrimaryServerProxyPort</key>
	<integer>0</integer>
	<key>PrimaryServerProxyURL</key>
	<string></string>
	<key>PrimaryServerProxyUserName</key>
	<string>AAA=</string>
	<key>PrimaryServerType</key>
	<integer>2</integer>
	<key>PrimaryServerURL</key>
	<string>smb://server.name.here/SophosUpdate/CIDs/S000/ESCOSX</string>
	<key>PrimaryServerUserName</key>
	<string>oZjoEEiGKwXEg0conDHVQpqFLOXIrAT</string>
	<key>SecondaryServer</key>
	<true/>
	<key>SecondaryServerPassword</key>
	<string>V62NQG3gbqY5CPKSa5VT4TmFA0TOGhj</string>
	<key>SecondaryServerProxy</key>
	<integer>0</integer>
	<key>SecondaryServerProxyPassword</key>
	<string>AAA=</string>
	<key>SecondaryServerProxyPort</key>
	<integer>0</integer>
	<key>SecondaryServerProxyURL</key>
	<string></string>
	<key>SecondaryServerProxyUserName</key>
	<string>AAA=</string>
	<key>SecondaryServerType</key>
	<integer>0</integer>
	<key>SecondaryServerURL</key>
	<string></string>
	<key>SecondaryServerUserName</key>
	<string>a4yKGgTvRuB6vdDLpIp0igr4NVzNA73</string>
	<key>UpdateInterval</key>
	<integer>10</integer>
	<key>UpdateLogIntoFile</key>
	<true/>
	<key>UpdateOnConnection</key>
	<false/>
</dict>
</plist>
SOPHOS_CONFIG

# Restart SophosAutoUpdate to force the Sophos AutoUpdate process
# to read the settings stored in /Library/Sophos Anti-Virus/com.sophos.sau.plist

killall -HUP SophosAutoUpdate

# Cleanup

cd /
rm -rf /private/tmp/sophos_install

exit 0
