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

download_links="$(cat "$LFS/other/core-packages.txt")";
sbu_values="$(cat "$LFS/other/core-sbu-values.txt")";
sbu_time="$(cat "$LFS/temp/sbu-time.txt")";

###################
# Other Variables #
###################

download_link="";
package_file="";
package_time="";
package_sbu="";
package_name="";
package_type="";
package_dir="";

##############################
# Step 1 - Download Packages #
##############################

printf "[+] Downloading packages...\n\n";

for download_link in $download_links; do
    
    # Determine Package Details
    
    package_file="$(basename "$download_link")";
    package_name="$(echo "$package_file" | grep -oP "^([A-z0-9]+)")";
    
    # Download Package
    
    if [ ! -f "$LFS/temp/packages/$package_file" ]; then
        
        printf "[-] Downloading %s...\n" "$package_name";
        
        wget "$download_link" -O "$LFS/temp/packages/$package_file" \
            > /dev/null 2>&1;
        
    else
        
        printf "[-] Skipping %s...\n" "$package_name";
        
    fi
    
done

##########################
# Step 2 - Determine SBU #
##########################

if [ -z "$sbu_time" ]; then
    
    printf "\n[+] Determining SBU...\n\n";
    
    # Determine Package Details
    
    download_link="$(echo "$download_links" | grep acl)";
    package_file="$(basename "$download_link")";
    package_name="$(echo "$package_file" | grep -oP "^([A-z0-9]+)")";
    package_type="$(file --mime-type "$LFS/temp/packages/$package_file" \
        | cut -d ' ' -f 2)";
    
    # Compile Package
    
    if [ "$package_type" != "inode/x-empty" ] && [ "$package_type" != "cannot" ]; then
        
        rm -rfd "$LFS/temp/sbu" && mkdir "$LFS/temp/sbu";
        
        tar -xf "$LFS/temp/packages/$package_file" -C "$LFS/temp/sbu";
        
        package_dir="$(ls -A "$LFS/temp/sbu" | grep -m1 "$package_name-")";
        
        mkdir "$LFS/temp/sbu/$package_name";
        
        cd "$LFS/temp/sbu/$package_name";
        
        sbu_time=$SECONDS;
        
        (
            
            "$LFS/temp/sbu/$package_dir/configure" --prefix="$LFS/tools" \
                --disable-nls;
            
            make && make install;
            
        ) > /dev/null 2>&1;
        
        sbu_time=$(( $SECONDS - $sbu_time ));
        
        if [ "$?" = 0 ]; then
            printf "%d" "$sbu_time" > "$LFS/temp/sbu-time.txt";
        else
            printf "\n[+] Compilation of %s failed...\n" $package_name && exit;
        fi
        
    else
        
        printf "\n[+] Malformed archive for SBU determination...\n" && exit;
        
    fi
    
else
    
    printf "\n[+] SBU was determined, skipping...\n";
    
fi

############################################
# Step 3 - Compile & Install Core Packages #
############################################

printf "\n[+] Compiling & installing packages...\n\n";

printf "[-] Your SBU is: %d seconds...\n\n" $sbu_time;

for download_link in $download_links; do
    
    # Determine Package Details
    
    package_time="$(date +"%T")";
    package_file="$(basename "$download_link")";
    package_name="$(echo "$package_file" | grep -oP "^([A-z0-9]+)")";
    package_sbu="$(echo "$sbu_values" | grep -oP "(?<="$package_name": )([0-9.]+)")";
    package_type="$(file --mime-type "$LFS/temp/packages/$package_file" \
        | cut -d ' ' -f 2)";
    
    # Install Package
    
    if [ -n "$(grep "$package_name" < "$LFS/temp/installed.txt")" ]; then
        
        printf "[%s] Skipping %s...\n" "$package_time" "$package_name";
        
    elif [ "$package_type" != "inode/x-empty" ] && [ "$package_type" != "cannot" ]; then
        
        printf "[%s] Installing %s with SBU %s...\n" "$package_time" \
            "$package_name" "$package_sbu";
        
        rm -rfd "$LFS/temp/builds/$package_name";
        rm -rfd "$LFS/temp/builds/$package_name-*";
        
        tar -xf "$LFS/temp/packages/$package_file" -C "$LFS/temp/builds";
        
        package_dir="$(ls -A "$LFS/temp/builds" | grep -m1 "$package_name-")";
        
        mkdir "$LFS/temp/builds/$package_name";
        
        cd "$LFS/temp/builds/$package_name";
        
        (
            "$LFS/temp/builds/$package_dir/configure" --prefix="$LFS/tools" \
                --disable-nls;
            
            make && make install;
            
        ) > "$LFS/temp/logs/$package_name.log" 2>&1;
            
        
        if [ "$?" = 0 ]; then
            printf "%s\n" "$package_name" >> "$LFS/temp/installed.txt";
        else
            printf "\n[+] Installation of %s failed...\n" "$package_name" && exit;
        fi
        
    else
        
        printf "\n[+] Malformed archive for %s...\n" "$package_name" && exit;
        
    fi
    
done