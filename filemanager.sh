#!/bin/bash


#-------------------------------#
#get fzf to look as advertised  #
#-------------------------------#
export FZF_DEFAULT_OPTS="--layout=reverse --border=bold --border=rounded --margin=6% "
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --info=inline-right \
  --ansi \
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

#------------------------------------------#
#get the find files to work on debian based#
#------------------------------------------#
fd() {
 fdfind
}

#----------#
# the loop #
#----------#
while true; do
#----------------------------------#
#main thing that displays the files#
#----------------------------------#
file=$(exa --icons --no-permissions -la --no-filesize --no-time --no-user  | tr ' ' '\n' |fzf --prompt " > " )
actions=$(echo "delete rename create-file create-dir trash empty-trash restore-trash list-trash move-files change-dir find-files open-files quit" | tr ' ' '\n' |fzf --prompt " >" )




#-------------------------------#
#the file renaming functionalty #
#-------------------------------#
file_rename() {
  wd=$(pwd)

  echo "choose new name for $file "
  read filename
  mv $file $filename
  echo "succusessfully renamed $file to $filename"
}
 
#------------------------------#
#the file deleting functionalty#
#------------------------------#
file_delete() {
  echo "Are you sure you want to delete $file Y/n"
  read answer
  if [ $answer == "y" ]; then
    rm -rf $file  
    echo "deleted $file"
  elif [ $answer == "Y" ]; then 
    rm -rf $file
    echo "deleted $file"
  else 
   echo "not deleting file"
  fi

}

#-------------------------#
#the trashing functionalty#
#-------------------------#
file_trash() {
  trash $file
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
 echo "type the file name you want to find"
 read filename
 fd $filename |fzf

}

#-------------#
#opening files#
#-------------#
open_files() {
 nvim $file
}

#------------------------#
#makeing the actions work#
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





done

