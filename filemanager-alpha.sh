#!/bin/bash


#-------------------------------#
#get fzf to look as advertised  #
#-------------------------------#
export FZF_DEFAULT_OPTS="--layout=reverse --border=bold --border=sharp --margin=6% "
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --ansi \
  --info=inline-right \
  --layout=reverse \
  --color=bg+:#2e3c64 \
  --color=bg:#1f2335 \
  --color=border:#29a4bd \
  --color=fg:#c0caf5 \
  --color=gutter:#1f2335 \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#29a4bd \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"


#----------#
# the loop #
#----------#
while true; do

#----------------------------------#
#main thing that displays the files#
#----------------------------------#
actionsquit=("quit
")
actionsff=("find-files
")
actionslt=("list-trash
")
actionsrt=("restore-trash
")
actionset=("empty-trash
")
actionscr=("create-dir
")
actionscf=("create-file
")
actionsaction=("

actions:
")

file=$(exa --icons=always --color=always --oneline --group-directories-first )
actions1=$(echo "$file $actionsaction$actionscf$actionscr$actionset$actionsrt$actionslt$actionsff$actionsquit" |fzf --prompt " > ")


if ! [[ $actions1 =~ ^(create-file|create-dir|empty-trash|restore-trash|list-trash|find-files|actions:|quit)$ ]]; then
  actions=$(echo "delete rename move-files change-dir trash open-files quit" | tr ' ' '\n' |fzf --prompt " > " )
fi
  
#-------------------------------#
#the file renaming functionalty #
#-------------------------------#
file_rename() {
  wd=$(pwd)

  echo "choose new name for $actions1 " 
  read filename
  mv $actions1 $filename 
  echo "succusessfully renamed $actions1 to $filename"
}
 
#------------------------------#
#the file deleting functionalty#
#------------------------------#
file_delete() {
  echo "Are you sure you want to delete $actions1 Y/n"
  read answer
  if [ $answer == "y" ]; then
    rm -rf $actions1
    echo "deleted $actions1"
  elif [ $answer == "Y" ]; then 
    rm -rf $actions1
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
 filetomv=$(ls -a |fzf --prompt "choose a file or directory to move")
 wheretomv=$(ls -d */ .*/ |fzf --prompt "choose were to move it")
 mv $filetomv $wheretomv/
}
 
#------------------------#
#change current directory#
#------------------------#
 
change_dir() {
 whereyoumv=$(ls -d */ .*/  |fzf --prompt "choose a directory to enter")
 cd $whereyoumv
}

#---------------#
#find file stuff#
#---------------#

find_files() {
  if command -v fd >/dev/null; then
   echo "type the file name you want to find"
   read filename
   varfd=$(fd $filename |fzf)  
 #  actions=$(echo "delete rename move-files change-dir trash open-files quit" | tr ' ' '\n' |fzf --prompt " >" )
  else
   echo "type the file name you want to find"
   read filename
   varfd=$(fdfind $filename |fzf) 
#   actions=$(echo "delete rename move-files change-dir trash open-files quit" | tr ' ' '\n' |fzf --prompt " >" )
  fi
}
  

#-------------#
#opening files#
#-------------#
open_files() {
 nvim $actions1
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
elif [[ $actions == "create-file" ]]; then
    create_file 
elif [[ $actions == "create-dir" ]]; then
    create_dir 
elif [[ $actions == "empty-trash" ]]; then
    empty_trash 
elif [[ $actions == "restore-trash" ]]; then
    restore_trash 
elif [[ $actions == "list-trash" ]]; then
    list_trash 
elif [[ $actions == "move-files" ]]; then
    move_files 
elif [[ $actions == "change-dir" ]]; then
    change_dir 
elif [[ $actions == "find-files" ]]; then
    find_files 
elif [[ $actions == "open-files" ]]; then
    open_files 
elif [[ $actions == "quit" ]]; then
    break
fi


if [[ $actions1 == "trash" ]]; then
  file_trash
elif [[ $actions1 == "create-file" ]]; then
    create_file 
elif [[ $actions1 == "create-dir" ]]; then
    create_dir 
elif [[ $actions1 == "empty-trash" ]]; then
    empty_trash 
elif [[ $actions1 == "restore-trash" ]]; then
    restore_trash 
elif [[ $actions1 == "list-trash" ]]; then
    list_trash 
elif [[ $actions1 == "find-files" ]]; then
    find_files 
elif [[ $actions1 == "quit" ]]; then
    break
fi


done
