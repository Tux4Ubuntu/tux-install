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
printf "\033c"
# Set global values
STEPCOUNTER=false # Changes to true if user choose to install Tux Everywhere
OS_VERSION="";
TEMP_DIR="";

# Define functions first
function change_boot_loader {
    # Local/Github folder (comment out the other one if you're working locally)
    #$TEMP_DIR/tux-refind-theme-master/install.sh $1
    ~/Projects/Tux4Ubuntu/src/tux-refind-theme/install.sh $1
}

function change_boot_logo {
    # Local/Github folder (comment out the other one if you're working locally)
    #$TEMP_DIR/tux-plymouth-theme-master/install.sh $1
    ~/Projects/Tux4Ubuntu/src/tux-plymouth-theme/install.sh $1
}

function change_desktop {
    # Local/Github folder (comment out the other one if you're working locally)
    #$TEMP_DIR/tux-desktop-theme-master/install.sh $1
    ~/Projects/Tux4Ubuntu/src/tux-desktop-theme/install.sh $1
}

function change_wallpaper {
    printf "\033c"
    header "Adding Tux's WALLPAPER COLLECTION" "$1"
    gh_repo="tux4ubuntu-wallpapers"
    echo "This will download Tux 4K wallpapers selection (400+ mb)."
    echo "Ready to do this?"
    echo ""
    check_sudo
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) 
                echo "Initiating download..."
                
                # To configure dconf we need to run as su, and then lightdm. 
                # But first we put it in tmp for easier access
                
                # Uncomment this and comment the other for faster downloading when developing
                #gh_repo="tux4ubuntu"
                gh_repo="tux4ubuntu-wallpapers"
                pic_temp_dir=$(mktemp -d)
                echo "=> Getting the latest version from GitHub ..."
                wget -O "/tmp/$gh_repo.tar.gz" \
                https://github.com/tuxedojoe/$gh_repo/archive/master.tar.gz
                echo "=> Unpacking archive ..."
                sudo tar -xzf "/tmp/$gh_repo.tar.gz" -C /tmp
                sudo chmod -R ug+rw /tmp/$gh_repo-master/*
                # Add Pictures to locale folder
                prefix="\$HOME/"                
                pictures_var=$(cat $HOME/.config/user-dirs.dirs | grep "XDG_PICTURES_DIR")
                pictures_folder_uncut=$(echo ${pictures_var/XDG_PICTURES_DIR=/""} | tr -d '"')
                pictures_folder=${pictures_folder_uncut#$prefix}
                mkdir -p ~/$pictures_folder/"Tux4Ubuntu Wallpapers"
                sudo mv /tmp/$gh_repo-master/* ~/$pictures_folder/"Tux4Ubuntu Wallpapers"
                sudo chown -R $USER: $HOME
                printf "\033c"
                header "Adding Tux's WALLPAPER COLLECTION" "$1"
                echo "Finished downloading and adding wallpapers."
                echo ""
                echo "Once you press any key 'Appearance'-settings will open, then it's up to you to:"
                echo "1. Click '+'"
                echo "2. Double-click on 'Tux4Ubuntu Wallpapers'"
                echo "3. Find a wallpaper of choice"
                echo "4. Click 'Open'"
                echo ""
                echo "IMPORTANT: Close the 'Appearance'-window to continue installation."
                echo ""
                read -n1 -r -p "Press any key to open settings right now..." key
                unity-control-center appearance
                printf "\033c"
                header "Adding Tux's WALLPAPER COLLECTION" "$1"
                echo "Successfully added Tux's selection of wallpapers."
                break;;
            No ) printf "\033c"
                header "Adding Tux's WALLPAPER COLLECTION" "$1"
                echo "Tux stares at you with a curious look... Then he smiles and says 'Ok'."
                break;;
        esac
    done
    echo ""
    read -n1 -r -p "Press any key to continue..." key
}

function install_games {
    printf "\033c"
    header "Adding Tux GAMES" "$1"
    echo "This will install the following classic Tux games:"
    echo "  - SuperTux                          (A lot like Super Mario)"
    echo "  - SuperTuxKart                      (A lot like Mario Kart)"
    echo "  - Extreme Tux Racer                 (Help Tux slide down slopes)"
    echo "  - FreedroidRPG                      (Sci-fi isometric role playing)"
    echo "  - WarMUX                            (A lot like Worms)"
    echo ""
    check_sudo
    echo "Ready to try some gaming with The Tux!?"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) 
                printf "\033c"
                header "Adding Tux GAMES" "$1"
                echo "Initiating Tux Games install..."
                install_if_not_found "supertux supertuxkart extremetuxracer freedroidrpg warmux"
                echo "Successfully installed the Tux Games."
                break;;
            No ) printf "\033c"
                header "Adding Tux GAMES" "$1"
                echo "The sound of Tux flapping with his feets slowly turns silent when he realizes" 
                echo "your response... He shrugs and answer with a lowly voice 'ok'."
                break;;
        esac
    done
    echo ""
    read -n1 -r -p "Press any key to continue..." key
}

function goto_tux4ubuntu_org {
    echo ""
    echo "Launching website in your favourite browser."
    x-www-browser https://tux4ubuntu.org/ &
    read -n1 -r -p "Press any key to continue..." key
    echo ""
}

function temp_uninstall {
    printf "\033c"
    header "UNINSTALLING Tux" "$1"
    echo "We're working on it! See/help at http://github.com/tuxedojoe/tux4ubuntu"
    echo ""
    echo "But for now, check out the website under corresponding subjects. For instance"
    echo "on 'Tux Boot Loader Theme for Ubuntu' you'll find reverse instructions on how to"
    echo "uninstall it. We're sad to see you go, and sorry for the unconvince for no "
    echo "working uninstaller at the moment. But as we said, we're working on it."
    echo ""
    read -n1 -r -p "Press any key to open website..." key
    printf "\033c"
    header "UNINSTALLING Tux" "$1"
    echo "Launching website in your favourite browser."
    x-www-browser https://tux4ubuntu.blogspot.com/;
    echo ""
    read -n1 -r -p "Press any key to continue..." key
}

function uninstall {
    while :
    do
        clear
        printf "\033c"
        # Menu system as found here: http://stackoverflow.com/questions/20224862/bash-script-always-show-menu-after-loop-execution
        RED='\033[0;31m'
        NC='\033[0m' # No Color
        printf "╔══════════════════════════════════════════════════════════════════════════════╗\n"
        printf "║ ${RED}TUX 4 UBUNTU - UNINSTALL${NC}                        © 2016 Tux4Ubuntu Initiative ║\n"                       
        printf "║ Let's Pause Tux a Bit                         http://tux4ubuntu.blogspot.com ║\n"
        printf "╠══════════════════════════════════════════════════════════════════════════════╣\n"
        cat<<EOF    
║                                                                              ║
║   Where do you want to remove Tux? (Type in one of the following numbers)    ║
║                                                                              ║
║   1) Everywhere                                - Uninstall all of the below  ║
║   ------------------------------------------------------------------------   ║
║   2) Boot Loader                               - Themes OS selection at boot ║
║   3) Boot Logo                                 - Remove Plymouth theme       ║
║   4) Login Screen                              - Add grid and wallpaper      ║
║   5) Desktop Theme/Icons/Cursors/Fonts + Tux   - Remove Tux desktop theming  ║
║   6) Wallpapers                                - Remove Tux favourite images ║
║   7) Games                                     - Uninstall games feat. Tux   ║
║   8) Return the t-shirt                        - Return your t-shirt         ║
║   ------------------------------------------------------------------------   ║
║   9) Back to installing Tux                    - Goes back to installer      ║
║   ------------------------------------------------------------------------   ║
║   Q) I'm done                                  - Quit the installer (Ctrl+C) ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
        read -n1 -s
        case "$REPLY" in
        "1")    # Uninstall everything
                STEPCOUNTER=true
                i=1
                uninstall_boot_loader $i
                ((i++))
                uninstall_boot_logo $i
                ((i++))
                uninstall_login_screen $i
                ((i++))
                uninstall_desktop $i
                ((i++))
                uninstall_wallpaper $i
                ((i++))
                uninstall_games $i
                ((i++))
                return_the_tshirt $i
                ;;
        "2")    uninstall_boot_loader ;;
        "3")    uninstall_boot_logo ;;
        "4")    uninstall_login_screen ;;
        "5")    uninstall_desktop ;;
        "6")    uninstall_wallpaper ;;
        "7")    uninstall_games ;;
        "8")    return_the_tshirt ;;
        "9")    break ;;
        "Q")    exit                      ;;
        "q")    exit                      ;;
        * )    echo "invalid option"     ;;
        esac
        sleep 1
    done
}

function uninstall_login_screen {
    printf "\033c"
    header "Removing the tuxedo class to your LOGIN SCREEN" "$1"
    echo "This will enable the standard Ubuntu background and the grid with dots on your"
    echo "login screen. Ready to do this?"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) 
                echo "Starting configure dconf login settings..."
                mkdir -p /tmp/reclutter

                sudo cp tux-login-reclutter/tux-login-gsettings.sh /tmp/reclutter/
                # Make it executable by all so that lightdm can run it
                sudo chmod 0755 /tmp/reclutter/tux-login-gsettings.sh
                # As already mentioned, we need to do it as su, otherwise changes don't take effect
                sudo bash tux-login-reclutter/tux-login-script.sh 
                # Now we can remove the script from tmp
                sudo rm -r /tmp/reclutter
                printf "\033c"
                header "Removing the tuxedo class to your LOGIN SCREEN" "$1"
                echo "Successfully recluttered your Login Screen. :)"
                break;;
            No ) printf "\033c"
                header "Removing the tuxedo class to your LOGIN SCREEN" "$1"
                echo "Awesome! Tux smiles and gives you a pat on the shoulder."
                break;;
        esac
    done
    echo ""
    read -n1 -r -p "Press any key to continue..." key
}

function uninstall_wallpaper {
    printf "\033c"
    header "Removing Tux's WALLPAPER COLLECTION" "$1"
    gh_repo="tux4ubuntu-wallpapers"
    echo "This will remove all Tux 4K wallpapers."
    echo "Ready to do this?"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) 
                echo "Starting to delete..."
                # Added locale dependent Pictures folder
                prefix="\$HOME/"                
                pictures_var=$(cat $HOME/.config/user-dirs.dirs | grep "XDG_PICTURES_DIR")
                pictures_folder_uncut=$(echo ${pictures_var/XDG_PICTURES_DIR=/""} | tr -d '"')
                pictures_folder=${pictures_folder_uncut#$prefix}
                sudo rm -rf ~/$pictures_folder/Tux4Ubuntu\ Wallpapers

                printf "\033c"
                header "Removing Tux's WALLPAPER COLLECTION" "$1"
                echo "Successfully removed the Tux's wallpapers."
                break;;
            No ) printf "\033c"
                header "Removing Tux's WALLPAPER COLLECTION" "$1"
                echo "Tux stares at you with a curious look... Then he smiles and says 'Ok'."
                break;;
        esac
    done
    echo ""
    read -n1 -r -p "Press any key to continue..." key
}

function uninstall_games {
    printf "\033c"
    header "Removing Tux GAMES" "$1"
    echo "This will ask to uninstall the following classic Tux games:"
    echo "  - SuperTux                          (A lot like Super Mario)"
    echo "  - SuperTuxKart                      (A lot like Mario Kart)"
    echo "  - ExtremeTuxRacer                   (Help Tux slide down slopes)"
    echo "  - FreedroidRPG                      (Sci-fi isometric role playing)"
    echo "  - WarMUX                            (A lot like Worms)"
    echo ""
    check_sudo
    echo "Ready to start deleting them?"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) 
                printf "\033c"
                header "Removing Tux GAMES" "$1"
                echo "Initiating Tux Games uninstall..."
                uninstall_if_found "supertux supertuxkart extremetuxracer freedroidrpg warmux"
                sudo apt -y autoremove
                echo "Successfully uninstalled the Tux Games."
                break;;
            No ) printf "\033c"
                header "Removing Tux GAMES" "$1"
                echo "The sound of Tux flapping with his feets slowly turns silent when he realizes" 
                echo "your response... He shrugs and answer with a lowly voice 'ok'."
                break;;
        esac
    done
    echo ""
    read -n1 -r -p "Press any key to continue..." key
}

function return_the_tshirt {
    printf "\033c"
    header "Return the T-SHIRT" "$1"
    # Original T-shirt art by Joan Stark found here: http://www.ascii-code.com/ascii-art/clothing-and-accessories/shirts.php
    # Tux painted by ppa package 'cowsay'
cat << "EOF"
                             .-""`'-..____..-'`""-.            
                           /`\                    /`\          
                          /`  |                  |  `\         
                         /`   |       .--.       |   `\        
                        /     |      |o_o |      |     \       
                        '-.__.|      |:_/ |      |.___.-'            
                              |     //   \ \     |            
                              |    (|     | )    |    
                              |   /'\_   _/`\    |             
                              |   \___)=(___/    |             
                              |                  |                     
                              |                  |             
                              '._              _.'             
                                 `""--------""`                
EOF
    echo ""
    echo "Launching website in your favourite browser."
    x-www-browser https://tux4ubuntu.blogspot.com/p/web-shop.html &
    read -n1 -r -p "Press any key to continue..." key
    echo ""
}

function check_sudo {
    if sudo -n true 2>/dev/null; then 
        :
    else
        echo "Oh, and Tux will need sudo rights to copy and install everything, so he'll ask" 
        echo "about that soon."
        echo ""
    fi
}

function install_if_not_found { 
    # As found here: http://askubuntu.com/questions/319307/reliably-check-if-a-package-is-installed-or-not
    for pkg in $1; do
        if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; then
            echo -e "$pkg is already installed"
        else
            echo "Installing $pkg."
            if sudo apt-get -qq --allow-unauthenticated install $pkg; then
                echo "Successfully installed $pkg"
            else
                echo "Error installing $pkg"
            fi        
        fi
    done
}

function uninstall_if_found { 
    # As found here: http://askubuntu.com/questions/319307/reliably-check-if-a-package-is-installed-or-not
    for pkg in $1; do
        if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; then
            echo "Uninstalling $pkg."
            if sudo apt-get remove $pkg; then
                echo "Successfully uninstalled $pkg"
            else
                echo "Error uninstalling $pkg"
            fi        
        else
            echo -e "$pkg is not installed"
        fi
    done
}

function change_grub2_theme { 
    # Install grub2 theme
    echo "Copying tux-grub2-theme to /boot/grub/themes/"
    sudo cp -r tux-grub2-theme /boot/grub/themes/
    echo "Adding 'GRUB_THEME=/boot/grub/themes/tux-grub2-theme/theme.txt' to '/etc/default/grub'"
    sudo grep -q -F 'GRUB_THEME="' /etc/default/grub || sudo sh -c "echo 'GRUB_THEME="/boot/grub/themes/tux-grub2-theme/theme.txt"' >> /etc/default/grub"
    sudo grub-mkconfig -o /boot/grub/grub.cfg
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
    printf " $1"
    printf '%*s' "$len" | tr ' ' "$ch"
    if [ $STEPCOUNTER = true ]; then
        printf "Step "$2
        printf "/7 "
    fi
    printf "║\n"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}


# After all the above functions been set we're ready to run the scripts

TEMP_DIR="$1"

header "Setting up INSTALLATION"
echo "Are you running UBUNTU and the lastest LTS release UBUNTU 18.04?"
echo "(if not LTS, google the advantages of using the latest LTS for production use)"

select yn in "Yes" "No"; do
    case $yn in
        Yes ) printf "\033c"
            # We set the plymouth directory here 
            plymouth_dir="/usr/share/plymouth"
            OS_VERSION="18.04"
            break;;
        No ) printf "\033c"
            header "Tux suggests the MANUAL INSTALLATION method" "$1"
            echo "If you're not running the latest UBUNTU LTS or if you're running another Linux"
            echo "based OS you're not out of luck (TUX loves you!)"
            echo ""
            echo "Just read the manual install instructions at:"
            echo "https://tux4ubuntu.org"
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
    cat<<EOF    
╔══════════════════════════════════════════════════════════════════════════════╗
║ TUX 4 UBUNTU ver 2.0                                       © 2018 Tux4Ubuntu ║
║ Let's Bring Tux to Ubuntu                             https://tux4ubuntu.org ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║   Where do you want Tux? (Type in one of the following numbers)              ║
║                                                                              ║
║   1) Everywhere                                - Install all of the below    ║
║   ------------------------------------------------------------------------   ║
║   2) Boot Loader                               - Themes OS selection at boot ║
║   3) Boot Logo                                 - Install Plymouth theme      ║
║   4) Desktop Theme/Icons/Cursors               - Some class to your desktop  ║
║   5) Wallpapers                                - Adds Tux favourite images   ║
║   6) Games                                     - Install games feat. Tux     ║
║   7) On my belly!                              - Buy the t-shirt             ║
║   ------------------------------------------------------------------------   ║
║   D) Developer Tools                           - See/install Tux's Devtools  ║
║   ------------------------------------------------------------------------   ║
║   Q) I'm done                                  - Quit the installer (Ctrl+C) ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    read -n1 -s
    case "$REPLY" in
    "1")    # Install everything
            STEPCOUNTER=true
            i=1
            change_boot_loader $i
            ((i++))
            change_boot_logo $i
            ((i++))
            change_desktop $i
            ((i++))
            change_wallpaper $i
            ((i++))
            install_games $i
            ((i++))
            goto_tux4ubuntu_org $i
            ;;
    "2")    change_boot_loader ;;
    "3")    change_boot_logo ;;
    "4")    change_desktop ;;
    "5")    change_wallpaper ;;
    "6")    install_games ;;
    "8")    goto_tux4ubuntu_org ;;
    "9")    uninstall ;;
    "Q")    exit                      ;;
    "q")    exit                      ;;
     * )    echo "invalid option"     ;;
    esac
    sleep 1
done