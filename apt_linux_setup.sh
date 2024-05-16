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

echo "getting ohmyzsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "moving .zshrc"
cp ./.zshrc ~
source ~/.zshrc

echo "moving .vimrc"
cp ./.vimrc ~
