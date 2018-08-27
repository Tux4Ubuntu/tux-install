#!/bin/bash
# This installer is inspired by Papirus Development Team: https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/blob/master/install-papirus-home-gtk.sh
set -e

gh_desc="Tux 4 Ubuntu - Let's bring Tux to Ubuntu"
YELLOW='\033[1;33m'
LIGHT_GREEN='\033[1;32m'
LIGHT_RED='\033[1;31m'
NC='\033[0m' # No Color

printf "\n\n${YELLOW}"
printf "     _____ _   ___  __  _  _     _   _ ____  _   _ _   _ _____ _   _ \n"
printf "    |_   _| | | \ \/ / | || |   | | | | __ )| | | | \ | |_   _| | | |\n"
printf "      | | | | | |\  /  | || |_  | | | |  _ \| | | |  \| | | | | | | |\n"
printf "      | | | |_| |/  \  |__   _| | |_| | |_) | |_| | |\  | | | | |_| |\n"
printf "      |_|  \___//_/\_\    |_|    \___/|____/ \___/|_| \_| |_|  \___/\n\n\n${NC}"

cat <<- EOF
  $gh_desc
  https://github.com/Tux4Ubuntu/$gh_repo

EOF

temp_dir=$(mktemp -d)

printf "${YELLOW}=> Getting the latest version(s) from GitHub...${NC}\n"

# Declare an array variable
# We're not downloading tux-wallpapers since thats a huge download which user can decide on later
declare -a arr=("tux-install" "tux-plymouth-theme" "tux-desktop-theme" "tux-icons" "tux-refind-theme" "tux-games" "tux-devtools")


# Now we loop through the above arra
for gh_repo in "${arr[@]}"
do
    wget -O "$temp_dir/$gh_repo.tar.gz" \
    https://github.com/Tux4Ubuntu/$gh_repo/archive/master.tar.gz
    echo "=> Unpacking archive ..."
    tar -xzf "$temp_dir/$gh_repo.tar.gz" -C "$temp_dir"
    printf "${YELLOW}=> Downloaded and extracted $gh_repo to $temp_dir${NC}\n"    
done

# For counting downloads
printf "${YELLOW}=> Requesting TUX 4 UBUNTU for download counting...${NC}\n"
# wget -qO- https://tux4ubuntu.org/install-counter/ &> /dev/null

printf "${YELLOW}=> Launching installer...${NC}\n" 
sleep 1

# LOCAL/GITHUB FOLDER
$temp_dir/tux-install-master/tux4ubuntu-menu.sh $temp_dir
#~/Projects/Tux4Ubuntu/src/tux-install/tux4ubuntu-menu.sh $temp_dir
