#!/bin/bash
# 
# install-ubuntu.sh - Tux4Ubuntu Installer
#                                                   
# Copyright (C) 2016 Tux4Ubuntu Initiative <http://tux4ubuntu.blogspot.com>
#
# Permission is hereby granted, free of charge, 
# to any person obtaining a copy of this software and 
# associated documentation files (the "Software"), to 
# deal in the Software without restriction, including 
# without limitation the rights to use, copy, modify, 
# merge, publish, distribute, sublicense, and/or sell 
# copies of the Software, and to permit persons to whom 
# the Software is furnished to do so, 
# subject to the following conditions:
#
# The above copyright notice and this permission notice 
# shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR 
# ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# 
# Written and designed by: Tuxedo Joe <http://github.com/tuxedojoe>
# for The Tux4Ubuntu Initiative <http://tux4ubuntu.blogspot.com>
#
# For CREDITS AND ATTRIBUTION see README 

# Change directory to same as script is running in
cd "$(dirname "$0")"
# Adds error handling by exiting at first error
set -e
# Cleans the screen
printf "\033c"
# Set global values
STEPCOUNTER=false # Sets to true if user choose to install Tux Everywhere
OS_VERSION="";
# Here we check if OS is supported
# More info on other OSes regarding plymouth: http://brej.org/blog/?p=158
if [[ `lsb_release -rs` == "16.04" ]]
then
    # The plymouth dir was moved in one update, therefore we have prepared for this one here
	plymouth_dir="/usr/share/plymouth"
    OS_VERSION="16.04"
elif [[ `lsb_release -rs` == "16.10" ]]
    plymouth_dir="/usr/share/plymouth"
    OS_VERSION="16.10"
then
	plymouth_dir="/usr/share/plymouth"
else
	echo "Sorry! We haven't tried installing Tux4Ubuntu on your Linux distrubtion."
    echo "Make sure you have the latest version at http://tux4ubuntu.blogspot.com"	
    echo "(Or fork/edit our project/install-ubuntu.sh for your system, and then make a"
    echo "pull request/send it to us so that more people can use it)"
    echo ""
    echo "Want to go ahead anyway? (Can be a bumby ride, but it might work flawless)"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"            
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) printf "\033c"
                echo "Ahh, a brave one! Tux salutes you!"
                echo "(If you get any error message, copy/paste on our website/stackoverflow"
                echo "and if it works, please write a comment on our start page and let us know)"
                echo ""
                read -n1 -r -p "Press any key to continue..." key
               	# We set the plymouth directory here 
                plymouth_dir="/usr/share/plymouth"
                break;;
            No ) printf "\033c"
                echo "Feel free to try when you're ready. Tux will be waiting."
                echo ""
                read -n1 -r -p "Press any key to continue..." key
                exit
                break;;
        esac
    done
fi

function change_boot_loader { 
    printf "\033c"
    header "Adding Tux to BOOT LOADER" "$1"
    echo "DO NOT INSTALL IF YOU ARE ONLY RUNNING ONE OPERATIVE SYSTEM"
    echo "(since this is a tool for dual booting)"
    echo ""
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    printf "${RED}WARNING! Before you continue backup all your data${NC}\n"                       
    echo ""
    echo "Do you understand that changing bootloader theme (and potentially the boot"
    echo "loader as well if you don't have rEFInd installed) is not without risk and"
    echo "that we can't be hold responsible if you proceed? (Our website and internet"
    echo "can help but nothing is 100% safe)"
    echo ""
    check_sudo
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes )
                if [ -d /sys/firmware/efi ]
                then 
                    # The rEFInd ppa is not registered. Ask if user wants it installed.
                    echo "Installing rEFInd bootloader"
                    sudo apt-add-repository ppa:rodsmith/refind
                    sudo apt-get update
                    # Check if refind is installed
                    install_if_not_found "refind"
                    echo "Initiating to copy folder tux-refind-theme."
                    check_sudo
                    sudo rm -rf /boot/efi/EFI/refind/themes/tux-refind-theme
                    sudo mkdir -p /boot/efi/EFI/refind/themes
                    sudo cp -rf tux-refind-theme /boot/efi/EFI/refind/themes/tux-refind-theme
                    # Here we add a last line if it not already exists (If other themes exists doesn't matter since our line ends up last and will therefore be used)
                    sudo grep -q -F 'include themes/tux-refind-theme/theme.conf' /boot/efi/EFI/refind/refind.conf || echo 'include themes/tux-refind-theme/theme.conf' | sudo tee -a /boot/efi/EFI/refind/refind.conf
                    echo "Successfully copied 'tux-refind-theme' to your rEFInd themes folder."
                else
                    printf "\033c"
                    header "Adding Tux to BOOT LOADER" "$1"
                    echo "BIOS boot noticed."
                    echo ""
                    echo "If you're running a newer system that support EFI, check your BIOS settings."
                    echo "Switching from Legacy to UEFI/EFI might do the trick and will enable a lot"
                    echo "more customization to your boot loader. But if that's not possible, you can"
                    echo "still add Tux to everywhere else."


                fi
                break;;
            No ) printf "\033c"
                echo "It's not that dangerous though! Feel free to try when you're ready. Tux will be waiting..."

                break;;
        esac
    done
    echo ""
    read -n1 -r -p "Press any key to continue..." key
}

function change_boot_logo {
    printf "\033c"
    header "Adding Tux as BOOT LOGO" "$1"
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║ NOTE:  Because of a bug in Ubuntu 16.04 & 16.10 encrypted home folders is    ║" 
    echo "║        not supported with a boot logo theme.                                 ║"
    echo "║                                                                              ║"
    echo "║ TIPS:  We're working on it, but for now the easiest way seems to be to not   ║"   
    echo "║        encrypt and work on encrypting specific folders instead.              ║"
    echo "║                                                                              ║"
    echo "║        We're sorry for the inconvinience, keep checking our website for      ║"
    echo "║        updates and the click on the bug at Ubuntu that it affects you:       ║"
    echo "║        https://bugs.launchpad.net/ubuntu/+source/ecryptfs-utils/+bug/1655180 ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Do you understand that changing boot logo is not without risk and that we can't"  
    echo "be hold responsible if you proceed? (Our website and internet can help but"
    echo "nothing is 100% safe). And do you also agree that Tux will install apt-packages"
    echo "'xclip' and 'plymouth-themes' if not found since they are needed for the"
    echo "installation?"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"            
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) 
                printf "\033c"
                header "Adding Tux as BOOT LOGO" "$1"
                check_sudo
                
                if [[ OS_VERSION == "16.04" ]]; then
                    # Workaround what we think is an Ubuntu Plymouth bug that doesn't seem to allow foreign plymouth themes
                    # so instead of simply sudo cp -r tux-plymouth-theme/ $plymouth_dir/themes/tux-plymouth-theme we 
                    # have to (6 steps):
                        
                    # 1) Add other themes through the apt-get package 'plymouth-themes' that seem to work as well as 'xclip'
                    # -package to successfully copy the internals of tux.script, tux.plymouth to a copy of the plymouth-themes's
                    # 'script'-theme. To do this, we first check if xclip and plymouth-themes is installed, and if not, we ask the user if they
                    # are okey with installing them. As found here: http://askubuntu.com/questions/319307/reliably-check-if-a-package-is-installed-or-not
                    install_if_not_found "plymouth-themes xclip"

                    # 2) Copy one of these themes, the theme called script.
                    sudo cp -r $plymouth_dir/themes/script $plymouth_dir/themes/tux-plymouth-theme;  
                    
                    # 3) Add tux-plymouth-theme files
                    sudo cp -r tux-plymouth-theme/* $plymouth_dir/themes/tux-plymouth-theme;
                    
                    # 4) Copy the internals of our files to existing using xclip
                    sudo xclip $plymouth_dir/themes/tux-plymouth-theme/tux.script;
                    sudo bash -c '> '$plymouth_dir'/themes/tux-plymouth-theme/script.script';
                    xclip -out | sudo tee -a $plymouth_dir/themes/tux-plymouth-theme/script.script;
                    sudo xclip $plymouth_dir/themes/tux-plymouth-theme/tux.plymouth;
                    sudo bash -c '> '$plymouth_dir'/themes/tux-plymouth-theme/script.plymouth';
                    xclip -out | sudo tee -a $plymouth_dir/themes/tux-plymouth-theme/script.plymouth;                          
                    
                    # 5) Remove our own files
                    sudo rm $plymouth_dir/themes/tux-plymouth-theme/tux.plymouth;
                    sudo rm $plymouth_dir/themes/tux-plymouth-theme/tux.script;
                    
                    # 6) And rename the newly created copies
                    sudo mv $plymouth_dir/themes/tux-plymouth-theme/script.script $plymouth_dir/themes/tux-plymouth-theme/tux.script
                    sudo mv $plymouth_dir/themes/tux-plymouth-theme/script.plymouth $plymouth_dir/themes/tux-plymouth-theme/tux.plymouth
                else
                    sudo cp -r tux-plymouth-theme $plymouth_dir/themes/
                fi

                # Then we can add it to default.plymouth and update update-initramfs accordingly
                sudo update-alternatives --install $plymouth_dir/themes/default.plymouth default.plymouth $plymouth_dir/themes/tux-plymouth-theme/tux.plymouth 100;
                printf "\033c"
                header "Adding Tux as BOOT LOGO" "$1"
                echo "Below you will see a list with all themes available to choose tux in the "
                echo "Plymouth menu next (if you want Tux that is ;)";
                echo ""
                read -n1 -r -p "Press any key to continue..." key
                sudo update-alternatives --config default.plymouth;
                echo "Updating initramfs. This could take a while."
                sudo update-initramfs -u;
                printf "\033c"
                header "Adding Tux as BOOT LOGO" "$1"
                echo "Tux successfully moved in as your new Boot Logo."
                break;;
            No )
                printf "\033c"
                header "Adding Tux as BOOT LOGO" "$1"
                echo "It's not that dangerous though! Feel free to try when you're ready. Tux will be waiting."
            break;;
        esac
    done
    echo ""
    read -n1 -r -p "Press any key to continue..." key
}

function change_login_screen {
    printf "\033c"
    header "Adding tuxedo class to your LOGIN SCREEN" "$1"
    echo "This will disable the standard Ubuntu background and the grid with dots on your"
    echo "login screen. By doing this the background will stay black all the way from the"
    echo "boot loader to where the users background will load (which it does at the login" 
    echo "screen). Ready to do this?"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) 
                echo "Starting configure dconf login settings..."
                check_sudo
                # To configure dconf we need to run as su, and then lightdm. 
                # But first we put it in tmp for easier access
                sudo cp tux-login-cleanup/tux-login-gsettings.sh /tmp
                # Make it executable by all so that lightdm can run it
                sudo chmod 0755 /tmp/tux-login-gsettings.sh
                # As already mentioned, we need to do it as su, otherwise changes don't take effect
                sudo bash tux-login-cleanup/tux-login-script.sh 
                # Now we can remove the script from tmp
                sudo rm /tmp/tux-login-gsettings.sh
                printf "\033c"
                header "Adding tuxedo class to your LOGIN SCREEN" "$1"
                echo "Successfully tuxedoed up your Login Screen."
                break;;
            No ) printf "\033c"
                header "Adding tuxedo class to your LOGIN SCREEN" "$1"
                echo "Tux stares at you with a curious look... Then he smiles and says 'Ok'."
                break;;
        esac
    done
    echo ""
    read -n1 -r -p "Press any key to continue..." key
}

function change_desktop {
    printf "\033c"
    header "Adding tuxedo class to your DESKTOP" "$1"
    echo "Tux has scanned the web for the best themes and he likes:"
    echo "   - Arc Theme by horst3180 <https://github.com/horst3180/arc-theme>"
    echo "   - Paper Icon & Cursor Theme at snwh.org <https://snwh.org/paper>"
    echo "   - Roboto Font by Google <https://www.fontsquirrel.com/fonts/roboto>"
    echo ""
    echo "He plans to install these and 'Unity Tweak Tool' (if non of these are installed"
    echo "already). THEN, he plans to set himself as your 'Search your computer'-icon in"
    echo "the launcher (the icon furthest up or left depending on where your launcher is)."
    echo "Are you okay with that?"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) 
                printf "\033c"
                header "Adding tuxedo class to your DESKTOP" "$1"
                echo "Installing packages..."
                check_sudo
                # Check if ppa's exists, otherwise add them
                if [[ OS_VERSION == "16.04" ]]; then
                    echo "/etc/apt/sources.list.d/arc-theme.list not found, adding it now."
                    sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' >> /etc/apt/sources.list.d/arc-theme.list"
                    arc_ppa_added=true
                    echo "arc-theme's Release.key is being installed to get secure downloads and updates"
                    arc_temp_dir=$(mktemp -d)
                    wget -O $arc_temp_dir/Release.key http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key
                    sudo apt-key add - < $arc_temp_dir/Release.key
                fi
                sudo add-apt-repository ppa:snwh/pulp
                # Update apt-get
                echo "Tux will now update your apt-get lists before install (which may take a while)."
                echo ""
                sleep 1
                sudo apt-get update
                # Install packages
                install_if_not_found "arc-theme paper-icon-theme paper-cursor-theme unity-tweak-tool"
                # Download and install Roboto Fonts (as described here: https://wiki.ubuntu.com/Fonts)
                if fc-list | grep -i roboto >/dev/null; then
                    echo "Roboto fonts already installed"
                else
                    echo "Installing Roboto fonts by Google."
                    roboto_temp_dir=$(mktemp -d)
                    wget -O $roboto_temp_dir/roboto.zip https://www.fontsquirrel.com/fonts/download/roboto
                    unzip $roboto_temp_dir/roboto.zip -d $roboto_temp_dir
                    sudo mkdir -p ~/.fonts
                    sudo cp $roboto_temp_dir/*.ttf ~/.fonts/
                    echo "Successfully installed Roboto Font by Google."
                    echo ""
                    echo "Tux will now update your font cache (may take a while)"
                    echo ""
                    sleep 1
                    fc-cache -f -v
                fi
                # Copy an image of Tux to be your default launcher icon
                sudo mv /usr/share/unity/icons/launcher_bfb.png /usr/share/unity/icons/launcher_bfb.bak
                sudo cp tux-icon-theme/launcher_bfb.png /usr/share/unity/icons/
                printf "\033c"
                header "Adding tuxedo class to your DESKTOP" "$1"
                echo "Installed theme, icons, cursors and fonts (and Tux on your launcher)." 
                echo "We'll open Unity Tweak Tool for you and there you can choose"
                echo "(as suggested by Tux):"
                echo ""
                echo "1. Under Themes      ->      Choose 'Arc'"
                echo "2. Under Icons       ->      Choose 'Paper'"
                echo "3. Under Cursors     ->      Choose 'Paper'"
                echo "4. Under Fonts       ->      Default Font -> 'Roboto Regular'"
                echo "                                Window Title Font -> 'Roboto Black'"
                echo ""
                echo "IMPORTANT: Close Unity Tweak Tool to continue installation."
                read -n1 -r -p "Press any key to open Unity Tweak Tool..." key
                unity-tweak-tool -a
                printf "\033c"
                header "Adding tuxedo class to your DESKTOP" "$1"
                echo "Successfully added some theming options á la Tux. It's highly recommended to reboot soon to make everything look properly (especially regarding the Arc-theme)."
                echo ""
                echo "(However, it's still safe to continue installation)"
                break;;
            No ) printf "\033c"
                header "Adding tuxedo class to your DESKTOP" "$1"
                echo "Tux stares at you with a curious look... Then he smiles and says 'Ok'."
                break;;
        esac
    done
    echo ""
    read -n1 -r -p "Press any key to continue..." key
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
                temp_dir=$(mktemp -d)
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

function get_the_tshirt {
    printf "\033c"
    header "Get the T-SHIRT" "$1"
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
                                                                         
              17% PROMOTION CODE (January 6th - January 12th): HAPPY17
EOF
    echo ""
    echo "Launching website in your favourite browser."
    x-www-browser https://tux4ubuntu.blogspot.com/p/web-shop.html &
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

function uninstall_boot_loader { 
    printf "\033c"
    header "Removing Tux in BOOT LOADER" "$1"
    echo "Are you sure you want to remove Tux from your bootloader?"
    echo ""
    echo "WARNING! Before you continue, we also strongly recommend to backup all your data"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) echo "Do you wish to remove the rEFInd bootloader as well?"
                select yn in "Yes" "No"; do
                    case $yn in
                        Yes ) printf "\033c"
                            header "Removing Tux in BOOT LOADER" "$1"
                            echo "Uninstalling rEFInd."
                            sudo apt-get remove -y "refind"
                            sudo add-apt-repository --remove ppa:rodsmith/refind
                            sudo rm -r /boot/efi/EFI/refind
                            echo "Successfully removed rEFInd bootloader and the Tux4Ubuntu theme." 
                            break;;
                        No ) printf "\033c"
                            header "Removing Tux to BOOT LOADER" "$1"
                            # Let the user choose if they want to install GRUB2 theme instead
                            echo "Ok, rEFInd will be spared but Tux removed."
                            last_line="$(sudo awk '/./{line=$0} END{print line}' /boot/efi/EFI/refind/refind.conf)"                            
                            theme_line="include themes/tux-refind-theme/theme.conf"
                            if [ "$last_line" == "$theme_line" ] 
                            then
                                echo "Removing theme from rEFInd."
                                sudo sed -i '$ d' /boot/efi/EFI/refind/refind.conf
                                sudo rm -f -r /efi/EFI/boot/refind/themes/tux-refind-theme   
                                echo "Successfully removed the theme from rEFInd."                                 
                            else
                                printf "\033c"
                                header "Removing Tux to BOOT LOADER" "$1"
                                echo "Seems like someone edited the refind.conf file, uninstallation must be done"
                                echo "manually (or you may removed the theme already). Go to:"
                                echo "tux4ubuntu.blogspot.com/2016/11/tux-boot-loader-theme-for-ubuntu-refind.html"
                                echo "and read the instructions on how to uninstall Tux4Ubuntu rEFInd theme."
                            fi
                        break;;
                    esac
                done
                break;;
            No ) printf "\033c"
                header "Removing Tux to BOOT LOADER" "$1"
                echo "Awesome! Tux smiles and gives you a pat on the shoulder."
            break;;
        esac
    done

    
    echo ""
    read -n1 -r -p "Press any key to continue..." key
}

function uninstall_boot_logo {
    printf "\033c"
    header "Removing Tux as BOOT LOGO" "$1"
    echo "Really sure you want to uninstall Tux as your boot logo?"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"            
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) 
                printf "\033c"
                header "Uninstalling Tux as BOOT LOGO" "$1"
                # uninstall_not_found "plymouth-themes xclip"
                folder_to_delete=$plymouth_dir/themes/tux-plymouth-theme
                if [ -f $folder_to_delete ] ; then
                    sudo rm -r $folder_to_delete
                fi
                printf "\033c"
                header "Removing Tux as BOOT LOGO" "$1"
                echo "Below you will see a list with all themes available, choose a new theme to view"
                echo "on boot when Tux is removed."
                echo ""
                read -n1 -r -p "Press any key to continue..." key
                sudo update-alternatives --config default.plymouth;
                echo "Updating initramfs. This could take a while."
                sudo update-initramfs -u;
                printf "\033c"
                header "Removing Tux as BOOT LOGO" "$1"
                echo "Tux is successfully removed from your boot."
                break;;
            No )
                printf "\033c"
                header "Removing Tux as BOOT LOGO" "$1"
                echo "Awesome! Tux smiles and gives you a pat on the shoulder."
            break;;
        esac
    done
    echo ""
    read -n1 -r -p "Press any key to continue..." key
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

function uninstall_desktop {
    printf "\033c"
    header "Removing tuxedo class to your DESKTOP" "$1"
    echo "This will bring back the original Ubuntu launcher symbol, and ask seperately if"
    echo "you want to uninstall the packages that came with it. Ready to proceed?"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) 
                echo "Uninstalling packages..."
                if [ -f /usr/share/unity/icons/launcher_bfb.bak ]; then
                    sudo mv /usr/share/unity/icons/launcher_bfb.bak /usr/share/unity/icons/launcher_bfb.png
                else
                    sudo cp tux-icon-theme/launcher_bfb.bak /usr/share/unity/icons/launcher_bfb.png
                fi
                check_sudo

                if dpkg --get-selections | grep -q "^arc-theme[[:space:]]*install$" >/dev/null; then
                    echo "The following packages will be REMOVED:"
                    echo "  arc-theme"
                    read -p "Do you want to continue? [Y/n] " prompt
                    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
                    then
                        sudo apt-get remove -y arc-theme
                        if grep -q arc-theme /etc/apt/sources.list /etc/apt/sources.list.d/*; then
                            echo "/etc/apt/sources.list.d/arc-theme.list found, removing it now."
                            sudo rm /etc/apt/sources.list.d/arc-theme.list

                        fi
                    else
                        echo ""
                    fi

                else
                    echo "Arc Theme not installed."
                fi



                if dpkg --get-selections | grep -q "^paper-icon-theme[[:space:]]*install$" >/dev/null; then
                    echo "The following packages will be REMOVED:"
                    echo "  paper-icon theme paper-cursor-theme"
                    read -p "Do you want to continue? [Y/n] " prompt
                    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
                    then
                        sudo apt-get remove -y paper-icon-theme paper-gtk-theme paper-cursor-theme 
                        sudo add-apt-repository --remove ppa:snwh/pulp
                    fi
                    
                else
                    echo "paper-icon-theme not installed."
                fi

                uninstall_if_found "unity-tweak-tool"
                sudo apt -y autoremove

                mkdir -p /tmp/theme
                sudo cp tux-desktop-themes/tux-theme-gsettings.sh /tmp/theme/
                # Make it executable by all so that lightdm can run it
                sudo chmod 0755 /tmp/theme/tux-theme-gsettings.sh
                # As already mentioned, we need to do it as su, otherwise changes don't take effect
                sudo bash tux-desktop-themes/tux-theme-script.sh 
                # Now we can remove the script from tmp
                sudo rm -r /tmp/theme


                echo ""
                echo "Successfully uninstalled the packages you chose"
                break;;
            No ) printf "\033c"
            header "Removing tuxedo class to your DESKTOP" "$1"
                echo "Awesome! Tux smiles and gives you a pat on the shoulder."
                break;;
        esac
    done
    echo "Set your themes in System settings > Appearance and then reboot for chances to take effect."
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

while :
do
    clear
    # Menu system as found here: http://stackoverflow.com/questions/20224862/bash-script-always-show-menu-after-loop-execution
    cat<<EOF    
╔══════════════════════════════════════════════════════════════════════════════╗
║ TUX 4 UBUNTU ver 1.3                            © 2016 Tux4Ubuntu Initiative ║
║ Let's Bring Tux to Ubuntu                     http://tux4ubuntu.blogspot.com ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║   Where do you want Tux? (Type in one of the following numbers)              ║
║                                                                              ║
║   1) Everywhere                                - Install all of the below    ║
║   ------------------------------------------------------------------------   ║
║   2) Boot Loader                               - Themes OS selection at boot ║
║   3) Boot Logo                                 - Install Plymouth theme      ║
║   4) Login Screen                              - Remove grid and wallpaper   ║
║   5) Desktop Theme/Icons/Cursors/Fonts + Tux   - Some class to your desktop  ║
║   6) Wallpapers                                - Adds Tux favourite images   ║
║   7) Games                                     - Install games feat. Tux     ║
║   8) On my belly!                              - Buy the t-shirt             ║
║   ------------------------------------------------------------------------   ║
║   9) Uninstall Tux (partialy done)             - Uninstall the above         ║
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
            change_login_screen $i
            ((i++))
            change_desktop $i
            ((i++))
            change_wallpaper $i
            ((i++))
            install_games $i
            ((i++))
            get_the_tshirt $i
            ;;
    "2")    change_boot_loader ;;
    "3")    change_boot_logo ;;
    "4")    change_login_screen ;;
    "5")    change_desktop ;;
    "6")    change_wallpaper ;;
    "7")    install_games ;;
    "8")    get_the_tshirt ;;
    "9")    uninstall ;;
    "Q")    exit                      ;;
    "q")    exit                      ;;
     * )    echo "invalid option"     ;;
    esac
    sleep 1
done