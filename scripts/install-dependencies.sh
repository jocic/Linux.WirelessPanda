#!/bin/bash

###################################################################
# Script Author: Djordje Jocic                                    #
# Script Year: 2018                                               #
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

package_tars="http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz,autoconf,autoconf.tar.xz";

##################
# Temp Variables #
##################

download_link="";
package_name="";
package_file="";

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
        
        printf "[+] Skipping $package_name as it's already downloaded...\n\n";
        
    fi
    
done

##############################
# Step 3 - Install: Autoconf #
##############################

printf "[+] Installing autoconf...\n\n";

rm -rfd "$source_dir/../temp/packages/autoconf";

tar -xf "$source_dir/../temp/packages/$package_file" -C \
    "$source_dir/../temp/packages";

mv "$source_dir/../temp/packages/autoconf-2.69" \
    "$source_dir/../temp/packages/autoconf";

cd "$source_dir/../temp/packages/autoconf";

./configure && make;







