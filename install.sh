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
    echo "The installation directory $INSTALL_DIR needs to"
    echo "be made available to \$PATH in your ~/.$(basename $SHELL)rc:"
    echo "\tPATH=$INSTALL_DIR:\$PATH"
    echo
    echo "Do you want me to add that line for you?"

    read answer
    case $answer in
        y|Y|yes|Yes|YES)
            echo PATH=$INSTALL_DIR:\$PATH >> $SHELL_RC
        ;;
        n|N|no|No|NO)
            echo
            echo "Please add the following line to your "
            echo "~/.$(basename $SHELL)rc:" 
            echo
            echo "\tPATH=$INSTALL_DIR:\$PATH"
        ;;
    esac
    echo "Please restart your shell by running"
    echo "source ~/.$(basename $SHELL)rc"
else
    echo
    echo "\`stub'-command available"
fi

echo "\nsee stub -T for available tasks"
