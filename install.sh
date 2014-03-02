REMOTE_DIR=https://github.com/xdbr/stub.git
INSTALL_DIR=~/.stub
SHELL_RC=~/.$(basename $SHELL)rc

if [[ -e $INSTALL_DIR ]]; then
    echo "Installation directory $INSTALL_DIR already exists, updating"
    cd $INSTALL_DIR
    git pull
else
    echo "Installation directory $INSTALL_DIR doesn't exist"
    git clone https://github.com/xdbr/stub.git ~/.stub
fi

type stub 2>/dev/null >/dev/null
if [[ $? -gt 0 ]]; then
    echo
    echo "Please add stub to your ~/.$(basename $SHELL)rc"
    echo "by running"
    echo
    echo "\techo PATH=~/.stub:\$PATH >> ~/.$(basename $SHELL)rc"
    echo "\t. ~/.$(basename $SHELL)rc"
else
    echo
    echo "\`stub'-command available"
fi

echo "\nsee stub -T for available tasks"
