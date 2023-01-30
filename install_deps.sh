#!/bin/bash


echo ""
echo "INSTALLING DEPENDENCIES required for GUI..."
echo ""

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /dev/null 2>&1
    echo ''
fi

# Check for sshpass, install if we don't have it
if test ! $(which sshpass); then
    echo "Installing sshpass..."
    brew install esolitos/ipa/sshpass > /dev/null 2>&1
    echo ''
fi

# Check for iproxy, install if we don't have it
if test ! $(which iproxy); then
    echo "Installing iproxy, ideviceinfo, ideviceenterrecovery..."
    brew install libimobiledevice > /dev/null 2>&1
    echo ''
fi


# Install pyenv to control python versions on mac
echo "Installing pyenv..."
brew install pyenv
echo ""

echo "Installing Python 3.8 🐍..."
pyenv install 3.8
echo "Installing Python 3.10 🐍..."
pyenv install 3.10
echo "Installing Python 3.11 🐍..."
pyenv install 3.11
echo ""

echo "Installing tk for GUI..."
pip3 install tk
echo ""

echo "Installing pillow..."
pip3 install Pillow
echo ""

#echo "Installing pydub (sounds)..."
#pip3 install pygame
#echo ""

echo ""
echo "Dependencies installed!!!"
echo ""

exit 1
