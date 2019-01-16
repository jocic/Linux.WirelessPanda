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

###################
# Other Variables #
###################

package_tars="https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.gz,m4,m4.tar.gz,1.4.18
https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz,autoconf,autoconf.tar.xz,2.69";

##################
# Temp Variables #
##################

download_link="";
package_name="";
package_file="";
package_version="";
package_type="";

#############################
# Step 1 - Check Privileges #
#############################

if [ "$user_id" != "0" ]; then
    printf "Error: You need to run this script with root privileges.\n" && exit;
fi

#########################################
# Step 2 - Perform Initial Preparations #
#########################################

mkdir -p "$source_dir/../temp/packages";

chmod 777 "$source_dir/../temp/packages";

##############################
# Step 3 - Download Packages #
##############################

for package_tar in $package_tars; do
    
    # Determine Package Details
    
    download_link="$(echo "$package_tar" | cut -d ',' -f 1)";
    package_name="$(echo "$package_tar" | cut -d ',' -f 2)";
    package_file="$(echo "$package_tar" | cut -d ',' -f 3)";
    
    # Download Package
    
    if [ ! -f "$source_dir/../temp/packages/$package_file" ]; then
        
        printf "[+] Downloading $package_name...\n\n";
        
        wget "$download_link" -O "$source_dir/../temp/packages/$package_file" \
            > /dev/null 2>&1;
        
    else
        
        printf "[+] Skipping $package_name...\n\n";
        
    fi
    
done

#############################
# Step 4 - Install Packages #
#############################

for package_tar in $package_tars; do
    
    # Determine Package Details
    
    download_link="$(echo "$package_tar" | cut -d ',' -f 1)";
    package_name="$(echo "$package_tar" | cut -d ',' -f 2)";
    package_file="$(echo "$package_tar" | cut -d ',' -f 3)";
    package_version="$(echo "$package_tar" | cut -d ',' -f 4)";
    package_type="$(file --mime-type "$source_dir/../temp/packages/$package_file" \
        | cut -d ' ' -f 2)";
    
    # Install Package
    
    if [ "$package_type" != "inode/x-empty" ]; then
        
        printf "[+] Installing $package_name...\n\n";
        
        rm -rfd "$source_dir/../temp/packages/$package_name";
        rm -rfd "$source_dir/../temp/packages/$package_name-*";
        
        tar -xf "$source_dir/../temp/packages/$package_file" -C \
            "$source_dir/../temp/packages";
        
        mv "$source_dir/../temp/packages/$package_name-$package_version" \
            "$source_dir/../temp/packages/$package_name";
        
        cd "$source_dir/../temp/packages/$package_name";
        
        ./configure && make && make install;
        
    else
        
        printf "[+] Malformed archive for $package_name...\n" && exit;
        
    fi
    
done