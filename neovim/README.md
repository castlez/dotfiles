# Simple NEOVIM setup

## Install
```
# make sure you are in a temp dir incase you accidentally unzip wrong
tar -xvf neovim_setup.tar.gz neovim
cd neovim

# install these deps in the base python if you dont want to have to do it for every venv
pip install -r requirements.txt

chmod +x nvim.appimage
./nvim.appimage ~/.local/bin/nvim

# install npm with your package manager, for instance on deb
sudo apt install npm

cp -R nvim ~/.config/

nvim

# let it install everything
# once its done type the following while in nvim
:MasonInstallAll
:TSInstall python
:qa

# DONE you should now be able to
cd ./project_dir
nvim

# and it will open nvim in the current directory
# remake your venv's now that nvims deps are in your base python
# be sure to source the venv/bin/activate before opening nvim for full features
```

# Keybinds
"leader" is space in this config, hit it when in normal mode to open the menu of options

| action | Bind | Notes |
|--------|------|-------|
| Open file explorer (mouse enabled) | ctrl+n ||
| Toggle breakpoint | space+d+b ||
| Debug current file | space+d+p+l | file needs to have a function. The debugger runs the function NOT the file |
| go back | ctrl+o ||
| go forward | ctrl+i ||
| split vertically | ctrl+w+v | this creates a split in the windows. Not that this isn't opening the file in the other split. Click a window, then click a file you have open at the top to put the file in that window|
| create a file | ctrl+a | make sure focus is in the tree view |
