#!/bin/bash
# This installer is inspired by Papirus Development Team: https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/blob/master/install-papirus-home-gtk.sh
set -e

gh_desc="Tux 4 Ubuntu - Let's bring Tux to Ubuntu"

cat <<- EOF


     _____ _   ___  __  _  _     _   _ ____  _   _ _   _ _____ _   _ 
    |_   _| | | \ \/ / | || |   | | | | __ )| | | | \ | |_   _| | | |
      1 | | | | |\  /  | || |_  | | | |  _ \| | | |  \| | | | | | | |
      | | | |_| |/  \  |__   _| | |_| | |_) | |_| | |\  | | | | |_| |
      |_|  \___//_/\_\    |_|    \___/|____/ \___/|_| \_| |_|  \___/ 
                                                                      

  $gh_desc
  https://github.com/Tux4Ubuntu/$gh_repo


EOF

temp_dir=$(mktemp -d)

echo "=> Getting the latest version(s) from GitHub ..."


# Declare an array variable
# We're not downloading tux-wallpapers since thats a huge download which user can decide on later
declare -a arr=("tux-install" "tux-plymouth-theme" "tux-desktop-theme" "tux-icons" "tux-refind-theme" "tux-games" "tux-devtools")


# Now we loop through the above arra
for gh_repo in "${arr[@]}"
do
#  wget -O "$temp_dir/$gh_repo.tar.gz" \
#  https://github.com/Tux4Ubuntu/$gh_repo/archive/master.tar.gz
#  echo "=> Unpacking archive ..."
#  tar -xzf "$temp_dir/$gh_repo.tar.gz" -C "$temp_dir"
  echo "$gh_repo"
  echo "$temp_dir"
done

# For counting downloads
wget -qO- https://tux4ubuntu.org/install-counter/ &> /dev/null

echo "=> Launching installer..."

# LOCAL/GITHUB FOLDER
#$temp_dir/tux-install-master/tux4ubuntu-menu.sh $temp_dir
~/Projects/Tux4Ubuntu/src/tux-install/tux4ubuntu-menu.sh $temp_dir
