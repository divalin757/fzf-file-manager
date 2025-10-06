
# fzf-file-manager
an amazing fzf file manager written in bash

## installtion
installtion is very simple you just need to install all the dependencies like so 

for arch based
```sh
sudo pacman -S fzf exa trash-cli fd ripgrep
```
for debian based
```sh
sudo apt install trash-cli fzf exa fd-find ripgrep
```

for fedora based
```sh
sudo dnf install trash-cli fzf eza fd-find ripgrep
```
for centos
```sh
sudo yum install trash-cli fzf eza ripgrep
```
with Zypper
```sh
sudo zypper install trash-cli fzf exa fd ripgrep
```
with apk
```sh
sudo apk add trash-cli fzf exa fd ripgrep
```

with brew
```sh
brew install trash-cli fzf eza fd ripgrep
```


after you installed the dependencies you can clone the script onto your machine 
```sh
curl -L -o filemanager.sh https://raw.githubusercontent.com/divalin757/fzf-file-manager/main/filemanager.sh
```

then you need to make the script executeable like so

```sh
chmod +x filemanager.sh
```

after you made the script executable just run the script like so
```sh
./filemanager.sh
```

## Usage


## Screenshots


<details>
  <summary>file selection</summary>
  <img src="imgs/Screenshot%20from%202025-09-23%2020-58-24.png" alt="Screenshot 1" width="600"/>
</details>

<details>
  <summary>Actions</summary>
  <img src="imgs/Screenshot%20from%202025-09-23%2020-58-28.png" alt="Screenshot 2" width="700"/>
</details>


# Known bugs
* when an action is choosen then an action after it it will repeat the last action before doing the one you choose

# Road Map For file manager
* add file compressing decompressing for zip and tar 
* add file actions with find files
* add file copy paste


If you want to contribute, please see [CONTRIBUTING.md](CONTRIBUTING.md).
