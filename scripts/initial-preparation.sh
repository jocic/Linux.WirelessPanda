#!/bin/bash

###################################################################
# Script Author: Djordje Jocic                                    #
# Script Year: 2019                                               #
# Script License: MIT License (MIT)                               #
# =============================================================== #
# Personal Website: http://www.djordjejocic.com/                  #
# =============================================================== #
# Permission is hereby granted, free of charge, to any person     #
# obtaining a copy of this software and associated documentation  #
# files (the "Software"), to deal in the Software without         #
# restriction, including without limitation the rights to use,    #
# copy, modify, merge, publish, distribute, sublicense, and/or    #
# sell copies of the Software, and to permit persons to whom the  #
# Software is furnished to do so, subject to the following        #
# conditions.                                                     #
# --------------------------------------------------------------- #
# The above copyright notice and this permission notice shall be  #
# included in all copies or substantial portions of the Software. #
# --------------------------------------------------------------- #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, #
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES #
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND        #
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT     #
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,    #
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, RISING     #
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR   #
# OTHER DEALINGS IN THE SOFTWARE.                                 #
###################################################################

##################
# Core Variables #
##################

user_id="$(id -u)";
source_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)";
root_dir="$source_dir/..";

#############################
# Step 1 - Check Privileges #
#############################

if [ "$user_id" != "0" ]; then
    printf "Error: You need to run this script with root privileges.\n" && exit;
fi

################################
# Step 2 - Prepare Directories #
################################

printf "[+] Preparing directories...\n\n";

# Create Tools Directory

if [ -d "$root_dir/tools" ]; then
    
    printf "[-] Skipping creation of the \"tools\" directory...\n";
    
else
    
    printf "[-] Creating the \"tools\" directory...\n";
    
    mkdir "$root_dir/tools";
    
fi

# Create Tools Symlink In System's Root Directory

if [ -d "/tools" ]; then
    
    printf "[-] Skipping creation of the \"tools\" symlink...\n";
    
else
    
    printf "[-] Creating the \"tools\" symlink...\n";
    
    ln -s "$root_dir/tools" "/tools";
    
fi

# Create Sources Directory

if [ -d "$root_dir/sources" ]; then
    
    printf "[-] Skipping creation of the \"sources\" directory...\n";
    
else
    
    printf "[-] Creating the \"sources\" directory...\n";
    
    mkdir "$root_dir/sources";
    
fi

# Create Sources Symlink In System's Root Directory

if [ -d "/sources" ]; then
    
    printf "[-] Skipping creation of the \"sources\" symlink...\n";
    
else
    
    printf "[-] Creating the \"sources\" symlink...\n";
    
    ln -s "$root_dir/sources" "/sources";
    
fi

# Create Temp Directory & It's Subdirectories

if [ -d "$root_dir/temp" ]; then
    
    printf "[-] Skipping creation of the \"temp\" directory...\n";
    
else
    
    printf "[-] Creating the \"temp\" directory...\n";
    
    mkdir "$root_dir/temp";
    
    mkdir "$root_dir/temp/packages";
    mkdir "$root_dir/temp/builds";
    mkdir "$root_dir/temp/logs";
    
fi

##########################
# Step 4 - Prepare Files #
##########################

printf "\n[+] Preparing files...\n";

if [ ! -f "$root_dir/temp/installed.txt" ]; then
    touch "$root_dir/temp/installed.txt";
fi

############################################
# Step 5 - Prepare Required Groups & Users #
############################################

printf "\n[+] Preparing groups & users...\n\n";

# Create LFS Group

if [ -n "$(grep lfs < /etc/group)" ]; then
    
    printf "[-] Skipping creation of the \"lfs\" group...\n";
    
else
    
    printf "[-] Creating the \"lfs\" group...\n";
    
    groupadd lfs;
    
fi

# Create LFS User

if [ -n "$(grep lfs < /etc/passwd)" ]; then
    
    printf "[-] Skipping creation of the \"lfs\" user...\n";
    
else
    
    printf "[-] Creating the \"lfs\" user...\n";
    
    [ -d "/home/lfs" ] && rm -rfd "/home/lfs";
    
    useradd -s "/bin/bash" \
            -g "lfs" \
            -k "/dev/null" \
            -p "$(openssl passwd lfs)" \
            -m "lfs";
    
fi

# Grant Full Access To Work Directories

printf "[-] Granting full access to work directories...\n";

chmod 777 "$root_dir/../" && chmod 777 "$root_dir/../../";

chown lfs -R "$root_dir/../../";

# Change Environment For LFS User

printf "[-] Setting custom environment for the \"lfs\" user...\n";

printf "exec env -i HOME='%s' TERM='%s' PS1='%s' /bin/bash\n" \
    "$HOME" \
    "$TERM" \
    "\u:\w\\$" > "/home/lfs/.bash_profile";

# Add Custom BASH RC File For LFS User

printf "[-] Adding a custom RC script for the \"lfs\" user...\n";

printf "# Define Environment Variables

LFS=\"$root_dir\";
LC_ALL=\"POSIX\";
PATH=\"/tools/bin:/bin:/usr/bin\";

# Turn Off Hash Function & Set Default File Creation Mask 

set +h && umask 022;

# Export Environment Variables

export LFS LC_ALL PATH;\n" > "/home/lfs/.bashrc";

# Add LFS To Sudoers

if [ -n "$(grep lfs < /etc/sudoers)" ]; then
    
    printf "[-] Skipping adding \"lfs\" user to sudoers...\n";
    
else
    
    printf "[-] Adding the \"lfs\" user to sudoers...\n";
    
    echo "lfs ALL=(ALL:ALL) ALL" >> "/etc/sudoers";
fi