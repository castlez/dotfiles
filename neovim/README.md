# neovim configuration

To configure neovim in a new environment (linux only right now, also assumes debian distro) run the following steps from this directory

```
sudo apt-get install neovim
cp -R nvim ~/.config/
nvim
# let it install everything
# close and reopen nvim
# in neovim run :TSInstall python
# close neovim, should be good to go
```
