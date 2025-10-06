#!/bin/bash

#---------------#
# define colors #
#---------------#
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Bold and Underlined Text
BOLD='\033[1m'
UNDERLINE='\033[4m'

# Background Colors
BG_BLACK='\033[40m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_MAGENTA='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'

# High Intensity (Bright) Colors
BRIGHT_BLACK='\033[0;90m'
BRIGHT_RED='\033[0;91m'
BRIGHT_GREEN='\033[0;92m'
BRIGHT_YELLOW='\033[0;93m'
BRIGHT_BLUE='\033[0;94m'
BRIGHT_MAGENTA='\033[0;95m'
BRIGHT_CYAN='\033[0;96m'
BRIGHT_WHITE='\033[0;97m'

# Bold High Intensity Colors
BOLD_BRIGHT_BLACK='\033[1;90m'
BOLD_BRIGHT_RED='\033[1;91m'
BOLD_BRIGHT_GREEN='\033[1;92m'
BOLD_BRIGHT_YELLOW='\033[1;93m'
BOLD_BRIGHT_BLUE='\033[1;94m'
BOLD_BRIGHT_MAGENTA='\033[1;95m'
BOLD_BRIGHT_CYAN='\033[1;96m'
BOLD_BRIGHT_WHITE='\033[1;97m'

# Reset Code
RESET='\033[0m'
#-------------------------------#
#get fzf to look as advertised  #
#-------------------------------#
export FZF_DEFAULT_OPTS="--layout=reverse --border=bold --border=sharp --margin=6% "
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --info=inline-right \
  --ansi \
  --border=sharp \
  --margin=3%
  --layout=reverse \
  --color=bg+:#2e3c64 \
  --color=bg:#1E1E2E \
  --color=border:#89B4FA \
  --color=fg:#c0caf5 \
  --color=gutter:#1E1E2E \
  --color=header:#FAB387 \
  --color=hl+:#89B4FA \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#89B4FA \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#89B4FA \
  --color=separator:#FAB387 \
  --color=spinner:#F08AA7 \
"

#----------#
# the loop #
#----------#
while true; do

  #----------------------------------#
  #main thing that displays the files#
  #----------------------------------#
  pwd=$(pwd)
  actionscd=$(echo -e $BLUE"change-dir
"$RESET)
  actionsquit=$(echo -e $RED"quit
"$RESET)
  actionsff=$(echo -e $BLUE"find-files
"$RESET)
  actionslt=$(echo -e $BLUE"list-trash
"$RESET)
  actionsrt=$(echo -e $BLUE"restore-trash
"$RESET)
  actionset=$(echo -e $RED"empty-trash
"$RESET)
  actionscr=$(echo -e $BLUE"create-dir
"$RESET)
  actionscf=$(echo -e $BLUE"create-file
"$RESET)
  actionsft=$(echo -e $BLUE"find-text
"$RESET)
  actionspwd=$(
    echo -e "$BLUE $pwd$RESET"
  )
  actionscdo=$(echo -e $BLUE"
 ..

$RESET")
  actionsaction=("

actions:
")

  file=$(exa --icons=always --color=always --oneline --group-directories-first -a)
  actions1=$(echo "$actionspwd$actionscdo$file $actionsaction$actionscf$actionscr$actionscd$actionset$actionsrt$actionslt$actionsff$actionsft$actionsquit" | fzf --prompt " > ")

  if ! [[ $actions1 =~ ^( ..| $pwd|create-file|create-dir|change-dir|empty-trash|restore-trash|list-trash|find-files|find-text|actions:|quit)$ ]]; then
    actions=$(echo "delete rename move-files trash open-files enter-dir make-file-executeable quit" | tr ' ' '\n' | fzf --prompt " > ")
  fi

  #-------------------------------#
  #the file renaming functionalty #
  #-------------------------------#
  file_rename() {
    wd=$(pwd)
    actions2=$(echo -e "$actions1" | cut -c 5-)
    echo "choose new name for $actions2 "
    read filename
    mv $actions2 $filename
  }

  #------------------------------#
  #the file deleting functionalty#
  #------------------------------#
  file_delete() {
    echo "Are you sure you want to delete $actions1 Y/n"
    read answer
    if [ $answer == "y" ]; then
      rm -rf $actions1 2>/dev/null
      echo "deleted $actions1"
    elif [ $answer == "Y" ]; then
      rm -rf $actions1 2>/dev/null
      echo "deleted $actions1"
    else
      echo "not deleting file"
    fi

  }
  
   
  
  #-------------------------#
  #the trashing functionalty#
  #-------------------------#
  file_trash() {
    trash $actions1
  }
  empty_trash() {
    trash-empty
  }
  restore_trash() {
    trash-restore
  }
  list_trash() {
    trash-list
  }

  #---------------------------#
  #file and directory creating#
  #---------------------------#
  create_file() {
    echo "choose a file name"
    read filename
    touch $filename
  }
  create_dir() {
    echo "choose a directory name"
    read dirname
    mkdir $dirname
  }

  #-------------------------#
  #file and directory moving#
  #-------------------------#

  move_files() {
    filetomv=$(exa --color=always -a | fzf --prompt "choose a file or directory to move")
    wheretomv=$(exa --color=always -d */ .*/ 2>/dev/null | fzf --prompt "choose were to move it")
    mv $filetomv $wheretomv/
  }

  #------------------------#
  #change current directory#
  #------------------------#

  change_dir() {
    whereyoumv=$(exa --color=always -d */ .*/ 2>/dev/null | fzf --prompt "choose a directory to enter")
    cd $whereyoumv
  }

  #----------------------------#
  #the going back functionalty #
  #----------------------------#

  cd_back() {
    cd ..

  }
  #---------------------#
  #make file executeable#
  #---------------------#
  mkfilexe() {
    chmod +x $actions1 2>/dev/null

  }

  #---------------#
  #find file stuff#
  #---------------#

  find_files() {
    if command -v fd >/dev/null; then
      echo "type the file name you want to find"
      read filename
      varfd=$(fd $filename | fzf)
      #  actions=$(echo "delete rename move-files change-dir trash open-files quit" | tr ' ' '\n' |fzf --prompt " >" )
    else
      echo "type the file name you want to find"
      read filename
      varfd=$(fdfind $filename | fzf)
      #   actions=$(echo "delete rename move-files change-dir trash open-files quit" | tr ' ' '\n' |fzf --prompt " >" )
    fi
  }
  
  find_text() {
   echo "write the text you want to find"
   read text
   rg $text
   sleep 5
  }
  #-------------#
  #opening files#
  #-------------#
  open_files() {
    actions2=$(echo -e "$actions1" | cut -c 5-)
    nvim $actions2
  }
  enterdir() {
    actions2=$(echo -e "$actions1" | cut -c 5-)
    cd $actions2
  }

  #------------------------#
  #making the actions work#
  #------------------------#
  if [[ $actions == "rename" ]]; then
    file_rename
  elif [[ $actions == "delete" ]]; then
    file_delete
  elif [[ $actions == "trash" ]]; then
    file_trash
  elif [[ $actions == "move-files" ]]; then
    move_files
  elif [[ $actions == "open-files" ]]; then
    open_files
  elif [[ $actions == "make-file-executeable" ]]; then
    mkfilexe
  elif [[ $actions == "enter-dir" ]];  then
    enterdir 
  elif [[ $actions == "quit" ]]; then
    break
  fi

  if [[ $actions1 == "trash" ]]; then
    file_trash
  elif [[ $actions1 == "find-text" ]]; then
    find_text
  elif [[ $actions1 == "create-file" ]]; then
    create_file
  elif [[ $actions1 == "create-dir" ]]; then
    create_dir
  elif [[ $actions1 == "change-dir" ]]; then
    change_dir
  elif [[ $actions1 == "empty-trash" ]]; then
    empty_trash
  elif [[ $actions1 == "restore-trash" ]]; then
    restore_trash
  elif [[ $actions1 == "list-trash" ]]; then
    list_trash
  elif [[ $actions1 == "find-files" ]]; then
    find_files
  elif [[ $actions1 == " .." ]]; then
    cd_back
  elif [[ $actions1 == "quit" ]]; then
    break
  fi

done
