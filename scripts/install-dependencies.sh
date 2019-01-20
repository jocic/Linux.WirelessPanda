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

download_links="https://ftp.gnu.org/gnu/texinfo/texinfo-6.5.tar.xz
https://ftp.gnu.org/gnu/coreutils/coreutils-8.30.tar.xz
https://ftp.gnu.org/gnu/bison/bison-3.2.4.tar.xz";
#https://mirrors.edge.kernel.org/pub/linux/devel/binutils/binutils-2.24.51.0.3.tar.xz
#https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.gz
#https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz";

###################
# Other Variables #
###################

package_file="";
package_name="";
package_type="";
package_dir="";

#########################################
# Step 1 - Perform Initial Preparations #
#########################################

mkdir -p "$LFS/temp/packages";
mkdir -p "$LFS/temp/builds";

chmod 777 "$LFS/temp/packages";
chmod 777 "$LFS/temp/builds";

##############################
# Step 2 - Download Packages #
##############################

printf "[+] Downloading packages...\n\n";

for download_link in $download_links; do
    
    # Determine Package Details
    
    package_file="$(basename "$download_link")";
    package_name="$(echo "$package_file" | grep -oP "^([A-z0-9]+)")";
    
    # Download Package
    
    if [ ! -f "$LFS/temp/packages/$package_file" ]; then
        
        printf "[-] Downloading $package_name...\n";
        
        wget "$download_link" -O "$LFS/temp/packages/$package_file" \
            > /dev/null 2>&1;
        
    else
        
        printf "[-] Skipping $package_name...\n";
        
    fi
    
done

############################################
# Step 3 - Compile & Install Core Packages #
############################################

printf "\n[+] Compiling & installing packages...\n\n";

for download_link in $download_links; do
    
    # Determine Package Details
    
    package_file="$(basename "$download_link")";
    package_name="$(echo "$package_file" | grep -oP "^([A-z0-9]+)")";
    package_type="$(file --mime-type "$LFS/temp/packages/$package_file" \
        | cut -d ' ' -f 2)";
    
    # Install Package
    
    if [ -n "$(grep "$package_name" < "$LFS/temp/installed.txt")" ]; then
        
        printf "[+] Skipping $package_name...\n\n";
        
    elif [ "$package_type" != "inode/x-empty" ] && [ "$package_type" != "cannot" ]; then
        
        printf "[+] Installing $package_name...\n\n";
        
        rm -rfd "$LFS/temp/builds/$package_name";
        
        tar -xf "$LFS/temp/packages/$package_file" -C "$LFS/temp/builds";
        
        package_dir="$(ls -A "$LFS/temp/builds" | grep "$package_name")";
        
        cd "$LFS/temp/builds/$package_dir";
        
        ./configure --prefix="$LFS/tools"
                    --disable-nls;
        
        make && make install;
        
        printf "%s\n" "$package_name" >> "$LFS/temp/installed.txt";
        
    else
        
        printf "[+] Malformed archive for $package_name...\n" && exit;
        
    fi
    
done