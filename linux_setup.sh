echo "Moving to ~..."
pushd ~

echo "installing zsh..."
sudo yum install zsh

echo "installing ohmyzsh..."
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "installing tmux..."
sudo yum install tmux

echo "copying dot file files..."
popd 
cp .zshrc ~/
cp .tmux.conf ~/
cp .vimrc ~/
cp .gitconfig ~/
pushd ~

echo "sourcing dot files..."
source .zshrc

echo "ALL DONE"

