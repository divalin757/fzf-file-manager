# fzf-file-manager
an amazing fzf file manager written in bash

## installtion
installtion is very simple you just need to copy the script from the repo into a file then make it executeable like so

```sh
chmod +x filemanager.sh
```

then you will need to install a couple dependencies

for arch based

```sh
sudo pacman -S fzf exa trash-cli
```
for debian based
```sh
sudo apt install trash-cli fzf exa
```
for fedora based
```sh
sudo dnf install trash-cli fzf exa
```
with brew
```sh
brew install fzf trash-cli exa
```

after you installed the dependencies just run the script like so
```sh
./filemanager.sh
```

and thats it 

## configuration
configuration is done by editing the source code it just one file so its pretty simple i also left comments to tell what each thing does
