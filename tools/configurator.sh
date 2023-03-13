#!/bin/bash

# VARIABLES SECTION

source /app/libexec/global.sh
source /app/libexec/functions.sh

# DIALOG SECTION

# Configurator Option Tree

# Welcome
#     - Move RetroDECK
#     - Change RetroArch Options
#       - Enable/Disable Rewind Setting
#       - RetroAchivement Login
#         - Login prompt
#     - Change Standalone Emulator Options (Behind one-time power user warning dialog)
#       - Launch RetroArch
#       - Launch Citra
#       - Launch Dolphin
#       - Launch Duckstation
#       - Launch MelonDS
#       - Launch PCSX2
#       - Launch PPSSPP
#       - Launch Primehack
#       - Launch RPCS3
#       - Launch XEMU
#       - Launch Yuzu
#     - Compress Games
#       - Manual single-game selection
#     - Troubleshooting Tools
#       - Multi-file game check
#     - Reset
#       - Reset Specific Emulator
#           - Reset RetroArch
#           - Reset Citra
#           - Reset Dolphin
#           - Reset Duckstation
#           - Reset MelonDS
#           - Reset PCSX2
#           - Reset PPSSPP
#           - Reset Primehack
#           - Reset RPCS3
#           - Reset Ryujinx
#           - Reset XEMU
#           - Reset Yuzu
#       - Reset All Emulators
#       - Reset Tools
#       - Reset All

# Code for the menus should be put in reverse order, so functions for sub-menus exists before it is called by the parent menu

# DIALOG TREE FUNCTIONS

configurator_reset_dialog() {
  choice=$(zenity --list --title="RetroDECK Configurator Utility - Reset Options" --cancel-label="Back" \
  --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" --width=1200 --height=720 \
  --column="Choice" --column="Action" \
  "Reset Specific Emulator" "Reset only one specific emulator to default settings" \
  "Reset All Emulators" "Reset all emulators to default settings" \
  "Reset Tools" "Reset Tools menu entries" \
  "Reset All" "Reset RetroDECK to default settings" )

  case $choice in

  "Reset Specific Emulator" )
    emulator_to_reset=$(zenity --list \
    --title "RetroDECK Configurator Utility - Reset Specific Standalone Emulator" --cancel-label="Back" \
    --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" --width=1200 --height=720 \
    --text="Which emulator do you want to reset to default?" \
    --column="Emulator" --column="Action" \
    "RetroArch" "Reset RetroArch to default settings" \
    "Citra" "Reset Citra to default settings" \
    "Dolphin" "Reset Dolphin to default settings" \
    "Duckstation" "Reset Duckstation to default settings" \
    "MelonDS" "Reset MelonDS to default settings" \
    "PCSX2" "Reset PCSX2 to default settings" \
    "PPSSPP" "Reset PPSSPP to default settings" \
    "Primehack" "Reset Primehack to default settings" \
    "RPCS3" "Reset RPCS3 to default settings" \
    "XEMU" "Reset XEMU to default settings" \
    "Yuzu" "Reset Yuzu to default settings" )

    case $emulator_to_reset in

    "RetroArch" )
      if [[ check_network_connectivity == "true" ]]; then
        ra_init
        configurator_process_complete_dialog "resetting $emulator_to_reset"
      else
        configurator_generic_dialog "You do not appear to be connected to a network with internet access.\n\nThe RetroArch reset process requires some files from the internet to function properly.\n\nPlease retry this process once a network connection is available."
        configurator_reset_dialog
      fi
    ;;

    "Citra" )
      citra_init
      configurator_process_complete_dialog "resetting $emulator_to_reset"
    ;;

    "Dolphin" )
      dolphin_init
      configurator_process_complete_dialog "resetting $emulator_to_reset"
    ;;

    "Duckstation" )
      duckstation_init
      configurator_process_complete_dialog "resetting $emulator_to_reset"
    ;;

    "MelonDS" )
      melonds_init
      configurator_process_complete_dialog "resetting $emulator_to_reset"
    ;;

    "PCSX2" )
      pcsx2_init
      configurator_process_complete_dialog "resetting $emulator_to_reset"
    ;;

    "PPSSPP" )
      ppssppsdl_init
      configurator_process_complete_dialog "resetting $emulator_to_reset"
    ;;

    "Primehack" )
      primehack_init
      configurator_process_complete_dialog "resetting $emulator_to_reset"
    ;;

    "RPCS3" )
      rpcs3_init
      configurator_process_complete_dialog "resetting $emulator_to_reset"
    ;;

    "XEMU" )
      if [[ check_network_connectivity == "true" ]]; then
        xemu_init
        configurator_process_complete_dialog "resetting $emulator_to_reset"
      else
        configurator_generic_dialog "You do not appear to be connected to a network with internet access.\n\nThe Xemu reset process requires some files from the internet to function properly.\n\nPlease retry this process once a network connection is available."
        configurator_reset_dialog
      fi
    ;;

    "Yuzu" )
      yuzu_init
      configurator_process_complete_dialog "resetting $emulator_to_reset"
    ;;

    "" ) # No selection made or Back button clicked
      configurator_reset_dialog
    ;;

    esac
  ;;

"Reset All Emulators" )

  if [[ check_network_connectivity == "true" ]]; then
    ra_init
    standalones_init
    configurator_process_complete_dialog "resetting all emulators"
  else
    configurator_generic_dialog "You do not appear to be connected to a network with internet access.\n\nThe all-emulator reset process requires some files from the internet to function properly.\n\nPlease retry this process once a network connection is available."
    configurator_reset_dialog
  fi
;;

"Reset Tools" )
  tools_init
  configurator_process_complete_dialog "resetting the tools menu"
;;

"Reset All" )
  zenity --icon-name=net.retrodeck.retrodeck --info --no-wrap \
  --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" \
  --title "RetroDECK Configurator Utility - Reset RetroDECK" \
  --text="You are resetting RetroDECK to its default state.\n\nAfter the process is complete you will need to exit RetroDECK and run it again, where you will go through the initial setup process again."
  rm -f "$lockfile"
  configurator_process_complete_dialog "resetting RetroDECK"
;;

"" ) # No selection made or Back button clicked
  configurator_welcome_dialog
;;

  esac
}

configurator_retroachivement_dialog() {
  login=$(zenity --forms --title="RetroDECK Configurator Utility - RetroArch RetroAchievements Login" --cancel-label="Back" \
  --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" --width=1200 --height=720 \
  --text="Enter your RetroAchievements Account details.\n\nBe aware that this tool cannot verify your login details and currently only supports logging in with RetroArch.\nFor registration and more info visit\nhttps://retroachievements.org/\n" \
  --separator="=SEP=" \
  --add-entry="Username" \
  --add-password="Password")

  if [ $? == 0 ]; then # OK button clicked
    arrIN=(${login//=SEP=/ })
    user=${arrIN[0]}
    pass=${arrIN[1]}

    set_setting_value $raconf cheevos_enable true retroarch
    set_setting_value $raconf cheevos_username $user retroarch
    set_setting_value $raconf cheevos_password $pass retroarch

    configurator_process_complete_dialog "logging in to RetroArch RetroAchievements"
  else
    configurator_welcome_dialog
  fi
}

configurator_power_user_warning_dialog() {
  if [[ $power_user_warning == "true" ]]; then
    choice=$(zenity --icon-name=net.retrodeck.retrodeck --info --no-wrap --ok-label="Yes" --extra-button="No" --extra-button="Never show this again" \
    --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" \
    --title "RetroDECK Desktop Mode Warning" \
    --text="Making manual changes to an emulators configuration may create serious issues,\nand some settings may be overwitten during RetroDECK updates.\n\nSome standalone emulator functions may not work properly outside of Desktop mode.\n\nPlease continue only if you know what you're doing.\n\nDo you want to continue?")
  fi
  rc=$? # Capture return code, as "Yes" button has no text value
  if [[ $rc == "0" ]]; then # If user clicked "Yes"
    configurator_power_user_changes_dialog
  else # If any button other than "Yes" was clicked
    if [[ $choice == "No" ]]; then
      configurator_welcome_dialog
    elif [[ $choice == "Never show this again" ]]; then
      set_setting_value $rd_conf "power_user_warning" "false" retrodeck # Store desktop mode warning variable for future checks
      configurator_power_user_changes_dialog
    fi
  fi
}

configurator_power_user_changes_dialog() {
  emulator=$(zenity --list \
  --title "RetroDECK Configurator Utility - Power User Options" --cancel-label="Back" \
  --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" --width=1200 --height=720 \
  --text="Which emulator do you want to configure?" \
  --hide-header \
  --column=emulator \
  "RetroArch" \
  "Citra" \
  "Dolphin" \
  "Duckstation" \
  "MelonDS" \
  "PCSX2" \
  "PPSSPP" \
  "Primehack" \
  "RPCS3" \
  "XEMU" \
  "Yuzu")

  case $emulator in

  "RetroArch" )
    retroarch
  ;;

  "Citra" )
    citra-qt
  ;;

  "Dolphin" )
    dolphin-emu
  ;;

  "Duckstation" )
    duckstation-qt
  ;;

  "MelonDS" )
    melonDS
  ;;

  "PCSX2" )
    pcsx2-qt
  ;;

  "PPSSPP" )
    PPSSPPSDL
  ;;

  "Primehack" )
    primehack-wrapper
  ;;

  "RPCS3" )
    rpcs3
  ;;

  "XEMU" )
    xemu
  ;;

  "Yuzu" )
    yuzu
  ;;

  "" ) # No selection made or Back button clicked
    configurator_welcome_dialog
  ;;

  esac
}

configurator_retroarch_rewind_dialog() {
  if [[ $(get_setting_value $raconf rewind_enable retroarch) == "true" ]]; then
    zenity --question \
    --no-wrap --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" \
    --title "RetroDECK Configurator - Rewind" \
    --text="Rewind is currently enabled. Do you want to disable it?."

    if [ $? == 0 ]
    then
      set_setting_value $raconf "rewind_enable" "false" retroarch
      configurator_process_complete_dialog "disabling Rewind"
    else
      configurator_retroarch_options_dialog
    fi
  else
    zenity --question \
    --no-wrap --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" \
    --title "RetroDECK Configurator - Rewind" \
    --text="Rewind is currently disabled, do you want to enable it?\n\nNOTE:\nThis may impact performance expecially on the latest systems."

    if [ $? == 0 ]
    then
      set_setting_value $raconf "rewind_enable" "true" retroarch
      configurator_process_complete_dialog "enabling Rewind"
    else
      configurator_retroarch_options_dialog
    fi
  fi
}

configurator_retroarch_options_dialog() {
  choice=$(zenity --list --title="RetroDECK Configurator Utility - RetroArch Options" --cancel-label="Back" \
  --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" --width=1200 --height=720 \
  --column="Choice" --column="Action" \
  "Change Rewind Setting" "Enable or disable the Rewind function in RetroArch." \
  "Log in to RetroAchivements" "Log into the RetroAchievements service in RetroArch." )

  case $choice in

  "Change Rewind Setting" )
    configurator_retroarch_rewind_dialog
  ;;

  "Log in to RetroAchivements" )
    configurator_retroachivement_dialog
  ;;

  "" ) # No selection made or Back button clicked
    configurator_options_dialog
  ;;

  esac
}

configurator_compress_single_game_dialog() {
  file_to_compress=$(file_browse "Game to compress")
  if [[ ! -z $file_to_compress ]]; then
    if [[ $(validate_for_chd $file_to_compress) == "true" ]]; then
      (
      filename_no_path=$(basename $file_to_compress)
      filename_no_extension=${filename_no_path%.*}
      compress_to_chd $(dirname $(realpath $file_to_compress))/$(basename $file_to_compress) $(dirname $(realpath $file_to_compress))/$filename_no_extension
      ) |
      zenity --icon-name=net.retrodeck.retrodeck --progress --no-cancel --pulsate --auto-close \
        --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" \
        --title "RetroDECK Configurator Utility - Compression in Progress" \
        --text="Compressing game $filename_no_path, please wait."
    else
      configurator_generic_dialog "File type not recognized. Supported file types are .cue, .gdi and .iso"
      configurator_compress_single_game_dialog
    fi
  else
    configurator_generic_dialog "No file selected, returning to main menu"
    configurator_welcome_dialog
  fi
}

configurator_compress_games_dialog() {
  # This is currently a placeholder for a dialog where you can compress a single game or multiple at once. Currently only the single game option is available, so is launched by default.

  configurator_generic_dialog "This utility will compress a single game into .CHD format.\n\nPlease select the game to be compressed in the next dialog: supported file types are .cue, .iso and .gdi\n\nThe original game files will be untouched and will need to be removed manually."
  configurator_compress_single_game_dialog
}

configurator_check_multifile_game_structure() {
  local folder_games=($(find $roms_folder -maxdepth 2 -mindepth 2 -type d ! -name "*.m3u" ! -name "*.ps3"))
  if [[ ${#folder_games[@]} -gt 1 ]]; then
    echo "$(find $roms_folder -maxdepth 2 -mindepth 2 -type d ! -name "*.m3u" ! -name "*.ps3")" > $logs_folder/multi_file_games_"$(date +"%Y_%m_%d_%I_%M_%p").log"
    zenity --icon-name=net.retrodeck.retrodeck --info --no-wrap \
    --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" \
    --title "RetroDECK" \
    --text="The following games were found to have the incorrect folder structure:\n\n$(find $roms_folder -maxdepth 2 -mindepth 2 -type d ! -name "*.m3u" ! -name "*.ps3")\n\nIncorrect folder structure can result in failure to launch games or saves being in the incorrect location.\n\nPlease see the RetroDECK wiki for more details!\n\nYou can find this list of games in ~/retrodeck/.logs"
  else
    configurator_generic_dialog "No incorrect multi-file game folder structures found."
  fi
  configurator_troubleshooting_tools_dialog
}

configurator_check_bios_files_basic() {
  configurator_generic_dialog "This check will look for BIOS files that RetroDECK has identified as working.\n\nThere may be additional BIOS files that will function with the emulators that are not checked.\n\nSome more advanced emulators such as Yuzu will have additional methods for verifiying the BIOS files are in working order."
  bios_checked_list=()

  while IFS="^" read -r bios_file bios_subdir bios_hash bios_system bios_desc
  do
    bios_file_found="No"
    bios_hash_matched="No"
    if [[ -f "$bios_dir/$bios_subdir$bios_file" ]]; then
      bios_file_found="Yes"
      if [[ $bios_hash == "Unknown" ]]; then
        bios_hash_matched="Unknown"
      elif [[ $(md5sum "$bios_dir/$bios_subdir$bios_file" | awk '{ print $1 }') == "$bios_hash" ]]; then
        bios_hash_matched="Yes"
      fi
    fi
    if [[ $bios_file_found == "Yes" && ($bios_hash_matched == "Yes" || $bios_hash_matched == "Unknown") && ! " ${bios_checked_list[*]} " =~ " ${bios_system} " ]]; then
      bios_checked_list=("${bios_checked_list[@]}" "$bios_system" )
    fi
  done < $bios_checklist
  systems_with_bios=${bios_checked_list[@]}

  configurator_generic_dialog "The following systems have been found to have at least one valid BIOS file.\n\n$systems_with_bios\n\nFor more information on the BIOS files found please use the Advanced check tool."

  configurator_troubleshooting_tools_dialog
}

configurator_check_bios_files_advanced() {
  configurator_generic_dialog "This check will look for BIOS files that RetroDECK has identified as working.\n\nThere may be additional BIOS files that will function with the emulators that are not checked.\n\nSome more advanced emulators such as Yuzu will have additional methods for verifiying the BIOS files are in working order."
  bios_checked_list=()

  while IFS="^" read -r bios_file bios_subdir bios_hash bios_system bios_desc
  do
    bios_file_found="No"
    bios_hash_matched="No"
    if [[ -f "$bios_dir/$bios_subdir$bios_file" ]]; then
      bios_file_found="Yes"
      if [[ $bios_hash == "Unknown" ]]; then
        bios_hash_matched="Unknown"
      elif [[ $(md5sum "$bios_dir/$bios_subdir$bios_file" | awk '{ print $1 }') == "$bios_hash" ]]; then
        bios_hash_matched="Yes"
      fi
    fi
    bios_checked_list=("${bios_checked_list[@]}" "$bios_file" "$bios_system" "$bios_file_found" "$bios_hash_matched" "$bios_desc")
  done < $bios_checklist

  zenity --list --title="RetroDECK Configurator Utility - Verify BIOS Files" --cancel-label="Back" \
  --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" --width=1200 --height=720 \
  --column "BIOS File Name" \
  --column "System" \
  --column "BIOS File Found" \
  --column "BIOS Hash Match" \
  --column "BIOS File Description" \
  "${bios_checked_list[@]}"

  configurator_troubleshooting_tools_dialog
}

configurator_troubleshooting_tools_dialog() {
  choice=$(zenity --list --title="RetroDECK Configurator Utility - Change Options" --cancel-label="Back" \
  --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" --width=1200 --height=720 \
  --column="Choice" --column="Action" \
  "Multi-file game structure check" "Verify the proper structure of multi-file or multi-disc games" \
  "Basic BIOS file check" "Show a list of systems that BIOS files are found for" \
  "Advanced BIOS file check" "Show advanced information about common BIOS files" )

  case $choice in

  "Multi-file game structure check" )
    configurator_check_multifile_game_structure
  ;;

  "Basic BIOS file check" )
    configurator_check_bios_files_basic
  ;;

  "Advanced BIOS file check" )
    configurator_check_bios_files_advanced
  ;;

  "" ) # No selection made or Back button clicked
    configurator_welcome_dialog
  ;;

  esac
}

configurator_move_dialog() {
  if [[ -d $rdhome ]]; then
    destination=$(configurator_destination_choice_dialog "RetroDECK Data" "Please choose a destination for the RetroDECK data folder.")
    case $destination in

    "Back" )
      configurator_move_dialog
    ;;

    "Internal Storage" )
      if [[ ! -L "$HOME/retrodeck" && -d "$HOME/retrodeck" ]]; then
        configurator_generic_dialog "The RetroDECK data folder is already at that location, please pick a new one."
        configurator_move_dialog
      else
        configurator_generic_dialog "Moving RetroDECK data folder to $destination"
        unlink $HOME/retrodeck # Remove symlink for $rdhome
        move $rdhome "$HOME"
        if [[ ! -d $rdhome && -d $HOME/retrodeck ]]; then # If the move succeeded
          rdhome="$HOME/retrodeck"
          roms_folder="$rdhome/roms"
          saves_folder="$rdhome/saves"
          states_folder="$rdhome/states"
          bios_folder="$rdhome/bios"
          media_folder="$rdhome/downloaded_media"
          themes_folder="$rdhome/themes"
          emulators_post_move
          conf_write

          configurator_process_complete_dialog "moving the RetroDECK data directory to internal storage"
        else
          configurator_generic_dialog "The moving process was not completed, please try again."
        fi
      fi
    ;;

    "SD Card" )
      if [[ -L "$HOME/retrodeck" && -d "$sdcard/retrodeck" && "$rdhome" == "$sdcard/retrodeck" ]]; then
        configurator_generic_dialog "The RetroDECK data folder is already configured to that location, please pick a new one."
        configurator_move_dialog
      else
        if [[ ! -w $sdcard ]]; then
          configurator_generic_dialog "The SD card was found but is not writable\nThis can happen with cards formatted on PC or for other reasons.\nPlease format the SD card through the Steam Deck's Game Mode and try the moving process again."
          configurator_welcome_dialog
        else
          if [[ $(verify_space $rdhome $sdcard) == "true" ]]; then
            configurator_generic_dialog "Moving RetroDECK data folder to $destination"
            if [[ -L "$HOME/retrodeck/roms" ]]; then # Check for ROMs symlink user may have created
                unlink "$HOME/retrodeck/roms"
            fi
            unlink $HOME/retrodeck # Remove symlink for $rdhome

            (
            dir_prep "$sdcard/retrodeck" "$rdhome"
            ) |
            zenity --icon-name=net.retrodeck.retrodeck --progress --no-cancel --pulsate --auto-close \
            --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" \
            --title "RetroDECK Configurator Utility - Move in Progress" \
            --text="Moving directory $rdhome to new location of $sdcard/retrodeck, please wait."

            if [[ -L $rdhome && ! $rdhome == "$HOME/retrodeck" ]]; then # Clean up extraneus symlinks from previous moves
              unlink $rdhome
            fi

            if [[ ! -L "$HOME/retrodeck" ]]; then # Always link back to original directory
              ln -svf "$sdcard/retrodeck" "$HOME"
            fi

            rdhome="$sdcard/retrodeck"
            roms_folder="$rdhome/roms"
            saves_folder="$rdhome/saves"
            states_folder="$rdhome/states"
            bios_folder="$rdhome/bios"
            media_folder="$rdhome/downloaded_media"
            themes_folder="$rdhome/themes"
            emulators_post_move
            conf_write
            configurator_process_complete_dialog "moving the RetroDECK data directory to SD card"
          else
            zenity --icon-name=net.retrodeck.retrodeck --error --no-wrap \
            --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" \
            --title "RetroDECK Configurator Utility - Move Directories" \
            --text="The destination directory you have selected does not have enough free space for the files you are trying to move.\n\nPlease select a new destination or free up some space."
          fi
        fi
      fi
    ;;

    "Custom Location" )
      configurator_generic_dialog "Select the root folder you would like to store the RetroDECK data folder in.\n\nA new folder \"retrodeck\" will be created in the destination chosen."
      custom_dest=$(directory_browse "RetroDECK directory location")
      if [[ ! -w $custom_dest ]]; then
          configurator_generic_dialog "The destination was found but is not writable\n\nThis can happen if RetroDECK does not have permission to write to this location.\n\nThis can typically be solved through the utility Flatseal, please make the needed changes and try the moving process again."
          configurator_welcome_dialog
      else
        if [[ $(verify_space $rdhome $custom_dest) ]];then
          configurator_generic_dialog "Moving RetroDECK data folder to $custom_dest/retrodeck"
          if [[ -L $rdhome/roms ]]; then # Check for ROMs symlink user may have created
            unlink $rdhome/roms
          fi

          unlink $HOME/retrodeck # Remove symlink for $rdhome if the previous location was not internal

          (
          dir_prep "$custom_dest/retrodeck" "$rdhome"
          ) |
          zenity --icon-name=net.retrodeck.retrodeck --progress --no-cancel --pulsate --auto-close \
          --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" \
          --title "RetroDECK Configurator Utility - Move in Progress" \
          --text="Moving directory $rdhome to new location of $custom_dest/retrodeck, please wait."

          if [[ ! -L "$HOME/retrodeck" ]]; then
            ln -svf "$custom_dest/retrodeck" "$HOME"
          fi

          if [[ -L $rdhome && ! $rdhome == "$HOME/retrodeck" ]]; then # Clean up extraneus symlinks from previous moves
            unlink $rdhome
          fi

          rdhome="$custom_dest/retrodeck"
          roms_folder="$rdhome/roms"
          saves_folder="$rdhome/saves"
          states_folder="$rdhome/states"
          bios_folder="$rdhome/bios"
          media_folder="$rdhome/downloaded_media"
          themes_folder="$rdhome/themes"
          emulators_post_move
          conf_write
          configurator_process_complete_dialog "moving the RetroDECK data directory to SD card"
        else
          zenity --icon-name=net.retrodeck.retrodeck --error --no-wrap \
          --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" \
          --title "RetroDECK Configurator Utility - Move Directories" \
          --text="The destination directory you have selected does not have enough free space for the files you are trying to move.\n\nPlease select a new destination or free up some space."
        fi
      fi
    ;;

    esac
  else
    configurator_generic_dialog "The RetroDECK data folder was not found at the expected location.\n\nThis may have happened if the folder was moved manually.\n\nPlease select the current location of the RetroDECK data folder."
    rdhome=$(directory_browse "RetroDECK directory location")
    roms_folder="$rdhome/roms"
    saves_folder="$rdhome/saves"
    states_folder="$rdhome/states"
    bios_folder="$rdhome/bios"
    media_folder="$rdhome/downloaded_media"
    themes_folder="$rdhome/themes"
    emulator_post_move
    conf_write
    configurator_generic_dialog "RetroDECK data folder now configured at $rdhome. Please start the moving process again."
    configurator_move_dialog
  fi
}

configurator_welcome_dialog() {
  # Clear the variables
  destination=

  choice=$(zenity --list --title="RetroDECK Configurator Utility" --cancel-label="Quit" \
  --window-icon="/app/share/icons/hicolor/scalable/apps/net.retrodeck.retrodeck.svg" --width=1200 --height=720 \
  --column="Choice" --column="Action" \
  "Move Files" "Move files between internal/SD card or to custom locations." \
  "Change RetroArch Options" "Change RetroArch presets, log into RetroAchievements etc." \
  "Change Standalone Emulator Options" "Run emulators standalone to make advanced config changes." \
  "Compress Games" "Compress games to CHD format for systems that support it." \
  "Troubleshooting Tools" "Run RetroDECK troubleshooting tools for common issues." \
  "Reset" "Reset specific parts or all of RetroDECK." )

  case $choice in

  "Move Files" )
    configurator_generic_dialog "This option will move the RetroDECK data folder (ROMs, saves, BIOS etc.) to a new location.\n\nPlease choose where to move the RetroDECK data folder."
    configurator_move_dialog
  ;;

  "Change RetroArch Options" )
    configurator_retroarch_options_dialog
  ;;

  "Change Standalone Emulator Options" )
    configurator_power_user_warning_dialog
  ;;

  "Compress Games" )
    configurator_compress_games_dialog
  ;;

  "Troubleshooting Tools" )
    configurator_troubleshooting_tools_dialog
  ;;

  "Reset" )
    configurator_reset_dialog
  ;;

  esac
}

# START THE CONFIGURATOR

configurator_welcome_dialog