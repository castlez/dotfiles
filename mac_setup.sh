# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

exec $SHELL

# homebrew

sudo chmod 777 /usr/local

cd /usr/local
mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 C homebrew

echo 'export PATH=/usr/local/homebrew/bin:$PATH' >> ~/.zshrc
