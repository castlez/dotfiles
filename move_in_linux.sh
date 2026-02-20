mkdir -p ~/src

echo "installing deps"
sudo dnf install autojump -y
sudo dnf install git -y
sudo dnf install vim -y
sudo dnf install ctags -y

echo "setting vim as editor"
sudo dnf install vim-default-editor --allowerasing -y
git config --global core.editor "vim"
sudoers_snippet='
# --- BEGIN: make vim default for sudo/visudo ---
Defaults        env_reset
Defaults        env_keep += "EDITOR VISUAL SUDO_EDITOR"
Defaults        env_editor
Defaults        editor=/usr/bin/vim
# --- END: make vim default for sudo/visudo ---
'

cat <<EOF

******************************************************************
To make Vim the default editor for sudo/visudo, add this to sudoers:

$sudoers_snippet

It is strongly recommended to use visudo for this edit.
The script will now run:  sudo visudo
Paste the above block into an appropriate place (near other Defaults).
******************************************************************

EOF

read -rp "Press Enter to run 'sudo visudo' and apply this change..." _
sudo visudo

# my gitconfig
echo """
[user]
        email = castlez93@gmail.com
        name = Castle
[push]
        autoSetupRemote = true
[pull]
        rebase = true
[core]
        hooksPath = /home/$USER/.git-hooks
[credential "https://github.com"]
        helper = 
        helper = !/usr/bin/gh auth git-credential
[credential "https://gist.github.com"]
        helper = 
        helper = !/usr/bin/gh auth git-credential
[alias]
        amend = commit --amend --no-edit
        lg = log --graph --oneline --all --decorate
        crush = !git fetch && git reset --hard @{u}
        st = status
        up = !git add . && git commit --amend --no-edit && git push -f
""" > ~/.gitconfig
echo "Wrote ~/.gitconfig"

echo """
Git Cheatsheet
================
check local branches - git branch
check all branches - git branch -a
check remote branches - git branch -r

TMUX
================

Leader: Ctrl-b

### Navigation
Leader + o           : next pane (cycle through panes)
Leader + ;           : previous pane (toggle between current and previous)
Leader + arrow keys  : select pane by direction
Leader + n           : next window/tab
Leader + p           : previous window/tab
Leader + 0-9         : select window by number
Leader + q           : show pane numbers (then press number to switch)

### With mouse enabled (set -g mouse on)
Click pane           : select pane
Click window name    : switch window
Drag pane border     : resize pane

### With Option+arrow bindings (bind -n M-Left select-pane -L)
Option + arrow keys  : select pane by direction (no prefix needed)

### Splitting Panes
Leader + \"           : split horizontally (one above the other)
Leader + %           : split vertically (side by side)

### Closing/Exiting
Ctrl-d               : close current pane (or type 'exit')
Leader + x           : kill current pane (prompts for confirmation)
Leader + &           : kill current window (prompts for confirmation)
Leader + d           : detach from session (keeps it running)

### Session Management
tmux ls              : list sessions
tmux attach -t name  : reattach to session
tmux kill-session -t name : kill entire session

### Other Useful Operations
Leader + z           : zoom/unzoom pane (fullscreen toggle)
Leader + ,           : rename window
Leader + :           : command prompt
Leader + ?           : list all keybindings
Leader + Ctrl-o      : swap panes
Ctrl-b :source-file ~/.tmux.conf : reload config

Vim (some of these require my vimrc)
================
CTAGS
----------------
To generate ctags for a Python project, run the following command in the root directory of your project:

    ctags -R --languages=python --python-kinds=-i --exclude=.git --exclude='*.pyc' --exclude=__pycache__ . ./venv/lib/python*/site-packages

In Vim
- ctrl + ] : Jump to the definition of the word under the cursor
- ctrl + o : Jump back from the definition in current tab
- ctrl + t : Jump back from the definition in previous tab and close the current tab
- \ + u : find usages

Navigation
----------------
- h, j, k, l : Move left, down, up, right
- gg : Go to the beginning of the file
- G : Go to the end of the file
- :n : Go to line number n
- w : Move to the beginning of the next word
- b : Move to the beginning of the previous word
- Ctrl + f : Move forward one page
- Ctrl + b : Move backward one page
- click on the fold column to the left of the line numbers to fold/unfold code blocks (requires ctags?)
-- NOTE: you have to click the "-" or "+" symbol to fold/unfold, clicking the line number itself won't work
- zM : Fold all code blocks
- zR : Unfold all code blocks
- zo : Open fold at the cursor
- zc : Close fold at the cursor
- \ + f: alias for zM (in vimrc)
- ":help fold-commands" to learn more about folding

Editing
-------
- i : Insert mode before the cursor
- a : Insert mode after the cursor
- o : Open a new line below the current line and enter insert mode
- O : Open a new line above the current line and enter insert mode
- r : Replace a single character
- x : Delete the character under the cursor
- dd : Delete the current line
- yy : Yank (copy) the current line
- p : Paste after the cursor
- P : Paste before the cursor
- u : Undo the last action
- Ctrl + r : Redo the last undone action

Searching
---------
- /pattern : Search for 'pattern' forward
- ?pattern : Search for 'pattern' backward
- n : Repeat the last search in the same direction
- N : Repeat the last search in the opposite direction

Saving and Exiting
-------------------
- :w : Save the file
- :q : Quit Vim
- :wq or :x : Save and quit
- :q! : Quit without saving

Visual Mode
-----------
- v : Enter visual mode (character-wise selection)
- V : Enter visual line mode (line-wise selection)
- Ctrl + v : Enter visual block mode (block-wise selection)
- y : Yank (copy) the selected text
- d : Delete the selected text
- > : Indent the selected text
- < : Unindent the selected text

Help
----
- :help : Open Vim help documentation
""" > ~/cheatsheet.txt
cat ~/cheatsheet.txt
