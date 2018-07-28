#!/bin/sh
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


## declare an array variable
declare -a arr= ( "tux-install" "tux-devtools" "tux-games" )

## now loop through the above arra
for gh_repo in "${arr[@]}"
do
  wget -O "/tmp/$gh_repo.tar.gz" \
  https://github.com/Tux4Ubuntu/$gh_repo/archive/master.tar.gz
  echo "=> Unpacking archive ..."
  tar -xzf "/tmp/$gh_repo.tar.gz" -C "$temp_dir"
  echo "=> Launching installer..."
  $temp_dir/$gh_repo-master/install-tux4ubuntu.sh
  echo "$gh_repo"
  echo "$temp_dir"
  # or do whatever with individual element of the array
done

# You can access them using echo "${arr[0]}", "${arr[1]}" also
