echo "Moving to ~..."
pushd ~

echo "Making share dir..."
mkdir share

echo "binding share dir..."
sudo vmhgfs-fuse -o nonempty -o allow_other .host:/sharedvms ./shared

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
pushd ~

echo "sourcing dot files..."
source .zshrc
source .vimrc
source .tmux.conf

echo "ALL DONE"

