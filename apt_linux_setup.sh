echo "updating..."
sudo apt-get update

echo "getting git"
sudo apt-get install git

echo "getting vim"
sudo apt-get install vim

echo "getting zsh"
sudo apt-get install zsh

echo "getting curl"
sudo apt-get install curl

echo "moving .zshrc"
cp ./.zshrc ~
chsh -s $(which zsh)

echo "moving .vimrc"
cp ./.vimrc ~

echo "configuring fancy git features for auto remote setting and 'git st' for status"
git config --global alias.st status
git config --global --add --bool push.autoSetupRemote true

echo "setting up Castle's git user info"
git config --global user.name "Castle"
git config --global user.email "castlez93@gmail.com"

echo "setup pyenv"
curl https://pyenv.run | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
pyenv install 3.11.9
pyenv global 3.11.9

echo "getting ohmyzsh (run 'source ~/.zshrc' to finish setup, im to lazy to make this fancy"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
