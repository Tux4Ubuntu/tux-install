#!/bin/bash
# 
# install-ubuntu.sh - Tux4Ubuntu Installer
#                                                   
# Copyright (C) 2018 Tux4Ubuntu <https://tux4ubuntu.org>
#
# For CREDITS AND ATTRIBUTION see README 
# For LICENSE see LICENSE :)

# Change directory to same as script is running in
cd "$(dirname "$0")"
# Adds error handling by exiting at first error
set -e
# Cleans the screen
# printf "\033c"

# Set global values
VERSION="2.0";
STEPCOUNTER=false # Changes to true if user choose to install Tux Everywhere
OS_VERSION="";
YELLOW='\033[1;33m'
LIGHT_GREEN='\033[1;32m'
LIGHT_RED='\033[1;31m'
NC='\033[0m' # No Color

# Define functions first
function change_boot_loader {
    # Local/Github folder (comment out the other one if you're working locally)
    ../tux-refind-theme-master/install.sh $1
    #~/Projects/Tux4Ubuntu/src/tux-refind-theme/install.sh $1
}

function change_boot_logo {
    # Local/Github folder (comment out the other one if you're working locally)
    ../tux-plymouth-theme-master/install.sh $1
    #~/Projects/Tux4Ubuntu/src/tux-plymouth-theme/install.sh $1
}

function change_desktop {
    # Local/Github folder (comment out the other one if you're working locally)
    ../tux-desktop-theme-master/install.sh $1
    #~/Projects/Tux4Ubuntu/src/tux-desktop-theme/install.sh $1
}

function change_wallpaper {
    # Local/Github folder (comment out the other one if you're working locally)
    #~/Projects/Tux4Ubuntu/src/tux-wallpapers/install.sh $1
    # printf "\033c"
    header "TUX WALLPAPERS" "$1"
    gh_repo="tux4ubuntu-wallpapers"
    printf "This will download TUX's selection of his favorite wallpapers mostly in 4K \nsolution (400+ mb).\n"
    printf "${LIGHT_GREEN}Ready to do this?${NC}\n"
    echo ""
    check_sudo
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes )
                # printf "\033c"
                header "TUX WALLPAPERS" "$1"
                printf "${YELLOW}Initiating download...${NC}\n"

                gh_repo="tux-wallpapers"
                # pic_temp_dir=$(mktemp -d)

                prefix="\$HOME/"                
                pictures_var=$(cat $HOME/.config/user-dirs.dirs | grep "XDG_PICTURES_DIR")
                pictures_folder_uncut=$(echo ${pictures_var/XDG_PICTURES_DIR=/""} | tr -d '"')
                pictures_folder=${pictures_folder_uncut#$prefix}
                


                printf "${YELLOW}Getting the latest version from GitHub...${NC}\n"

                DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
                echo $DIR

                wget -O ~/$pictures_folder/$gh_repo.tar.gz \
                https://github.com/Tux4Ubuntu/$gh_repo/archive/master.tar.gz
                
                printf "${YELLOW}Unpacking archive...${NC}\n"
                sudo tar -xvpf ~/$pictures_folder/tux-wallpapers.tar.gz -C ~/$pictures_folder/ 2>&1 | 
                while read line; do
                    x=$((x+1))
                    echo -en " $x TUX selfies extracted (he's just kidding, these are nice images)...\r"
                done
                printf "\n"
                sudo chmod -R ug+rw ~/$pictures_folder/$gh_repo-master/*
                
                DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
                echo $DIR

                ~/$pictures_folder/tux-wallpapers-master/install.sh $1

                sudo rm -rf ~/$pictures_folder/tux-wallpapers-master
                sudo rm ~/$pictures_folder/tux-wallpapers.tar.gz

                # printf "\033c"
                header "TUX WALLPAPERS" "$1"
                echo "Successfully added Tux's selection of wallpapers."
                break;;
            No ) # printf "\033c"
                header "TUX WALLPAPERS" "$1"
                echo "TUX stares at you with a curious look... Then he smiles and says 'Ok'."
                break;;
        esac
    done
}

function install_games {
    # Local/Github folder (comment out the other one if you're working locally)
    ../tux-games-master/install.sh $1
    #~/Projects/Tux4Ubuntu/src/tux-games/install.sh $1
}

function devtools {
    # Local/Github folder (comment out the other one if you're working locally)
    ../tux-devtools-master/install.sh $1
    #~/Projects/Tux4Ubuntu/src/tux-desktop-theme/install.sh $1
}

function header {
    var_size=${#1}
    # 80 is a full width set by us (to work in the smallest standard terminal window)
    if [ $STEPCOUNTER = false ]; then
        # 80 - 2 - 1 = 77 to allow space for side lines and the first space after border.
        len=$(expr 77 - $var_size)
    else   
        # "Step X/X " is 9
        # 80 - 2 - 1 - 9 = 68 to allow space for side lines and the first space after border.
        len=$(expr 68 - $var_size)
    fi
    ch=' '
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    printf "║"
    printf " ${YELLOW}$1${NC}"
    printf '%*s' "$len" | tr ' ' "$ch"
    if [ $STEPCOUNTER = true ]; then
        printf "Step "${LIGHT_GREEN}$2${NC}
        printf "/5 "
    fi
    printf "║\n"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

function check_sudo {
    if sudo -n true 2>/dev/null; then 
        :
    else
        printf "Oh, TUX will ask below about sudo rights to copy and install everything...\n\n"
    fi
}



# After all the above functions been set we're ready to run the scripts

TEMP_DIR="$1"

header "TUX 4 UBUNTU REQUIREMENTS"
printf "Are you running ${LIGHT_GREEN}UBUNTU${NC} and the lastest LTS release ${LIGHT_GREEN}18.04${NC}?\n"
echo "(if not LTS, google the advantages of using the latest LTS for production use)"
echo ""
select yn in "Yes" "No"; do
    case $yn in
        Yes ) # printf "\033c"
            # We set the plymouth directory here 
            plymouth_dir="/usr/share/plymouth"
            OS_VERSION="18.04"
            break;;
        No ) # printf "\033c"
            header "TUX 4 UBUNTU REQUIREMENTS" "$1"
            printf "Looks like you can't use this installer. But hey, ${LIGHT_GREEN}YOU'RE NOT OUT OF LUCK!${NC}\n"
            printf "We've created ${LIGHT_GREEN}MANUAL GUIDES${NC} that might help.\n"
            printf "${YELLOW}"
cat << "EOF"

                                      .--.      
                                     |o_o |   
                                     |:_/ |            
                                    //   \ \                
                                   (|     | )       
                                  /'\_   _/`\                
                                  \___)=(___/                

EOF
            printf "${NC}\n"
            printf "                            ${LIGHT_GREEN}https://tux4ubuntu.org${NC}\n"
            echo ""
            read -n1 -r -p "Press any key to continue..." key
            exit
            break;;
    esac
done

while :
do
    clear
    # Menu system as found here: http://stackoverflow.com/questions/20224862/bash-script-always-show-menu-after-loop-execution
    printf "╔══════════════════════════════════════════════════════════════════════════════╗\n"
    printf "║ ${YELLOW}TUX 4 UBUNTU ver $VERSION${NC}                                       © 2018 Tux4Ubuntu ║\n"                       
    printf "║ Let's Bring TUX to Ubuntu                              http://tux4ubuntu.org ║\n"
    printf "╠══════════════════════════════════════════════════════════════════════════════╣\n"
    cat<<EOF    
║                                                                              ║
║   Where do you want Tux? (Type in one of the following numbers/letters)      ║
║                                                                              ║
║   A) All places possible                       - Install all of the below    ║
║   ------------------------------------------------------------------------   ║
║   1) Boot Logo                                 - Install Plymouth theme      ║
║   2) Desktop Theme/Icons/Cursors               - Some class to your desktop  ║
║   3) Wallpapers                                - Adds Tux favourite images   ║
║   4) Games                                     - Install games feat. Tux     ║
║   5) Boot Loader                               - Themes OS selection at boot ║
║   ------------------------------------------------------------------------   ║
║   D) Developer Tools                           - See/install Tux's Devtools  ║
║   ------------------------------------------------------------------------   ║
║   Q) I'm done                                  - Quit the installer (Ctrl+C) ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    read -n1 -s
    case "$REPLY" in
    "A")    # Install everything
            STEPCOUNTER=true
            i=1
            change_boot_logo $i
            ((i++))
            change_desktop $i
            ((i++))
            change_wallpaper $i
            ((i++))
            install_games $i
            ((i++))
            change_boot_loader $i
            ((i++)) ;;
    "a")    # Install everything
            STEPCOUNTER=true
            i=1
            change_boot_logo $i
            ((i++))
            change_desktop $i
            ((i++))
            change_wallpaper $i
            ((i++))
            install_games $i
            ((i++))
            change_boot_loader $i
            ((i++)) ;;
    "1")    change_boot_logo ;;
    "2")    change_desktop ;;
    "3")    change_wallpaper ;;
    "4")    install_games ;;
    "5")    change_boot_loader ;;
    "D")    devtools ;;
    "d")    devtools ;;
    "Q")    exit                      ;;
    "q")    exit                      ;;
     * )    echo "invalid option"     ;;
    esac
    sleep 1
done