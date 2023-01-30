#!/usr/bin/env bash

export PATH=/usr/local/bin:$PATH
which brew > /dev/null
if [ $? -ne 0 ]; then
    echo "NO HOMEBREW. Install it from brew.sh"
    exit
    return
fi

echo Sliver needs full access to install the dependencies
echo Enter your Mac login password:
sudo -v

sudo rm -rf dependencies
sudo mkdir dependencies
cd dependencies
sudo mkdir libimobiledevice
cd libimobiledevice

xcode-select --install

echo " "
echo Install the Command Line Tools if prompted.
echo If you see an xcode error ignore it.
echo " "
echo :::: Dependencies for MacOS Mojave, Catalina, Big Sur, Monterey ::::

echo " "
echo NOTE: The code scrolls by very fast. Thats normal.
echo You may see odd errors and warnings. Thats normal.
echo DO NOT intervene. Let it run until completion.
echo " "

read -p "Click Enter to Acknowledge and Continue..."

brew install libusb
brew install libtool
brew install automake
brew install curl
brew reinstall libxml2
echo 'export PATH="/usr/local/opt/libxml2/bin:$PATH"' >> ~/.zshrc
export LDFLAGS="-L/usr/local/opt/libxml2/lib"
export CPPFLAGS="-I/usr/local/opt/libxml2/include"
export PKG_CONFIG_PATH="/usr/local/opt/libxml2/lib/pkgconfig"
brew install gnutls
brew install libgcrypt
brew install pkg-config
brew link pkg-config

echo "[*]Installing openssl ..."
sudo rm -r -f openssl
sudo git clone https://github.com/openssl/openssl.git
cd openssl
sudo ./config
sudo make
sudo make install
cd ..

echo "[*]Installing libplist ..."
sudo rm -r -f libplist
sudo git clone https://github.com/libimobiledevice/libplist.git
cd libplist
sudo ./autogen.sh --without-cython
sudo make
sudo make install
cd ..

echo "[*]Installing libimobiledevice-glue ..."
sudo rm -r -f libimobiledevice-glue
sudo git clone https://github.com/libimobiledevice/libimobiledevice-glue.git
cd libimobiledevice-glue
sudo ./autogen.sh
sudo make
sudo make install
cd ..

echo "[*]Installing libusbmuxd ..."
sudo rm -r -f libusbmuxd
sudo git clone https://github.com/libimobiledevice/libusbmuxd.git
cd libusbmuxd
sudo ./autogen.sh
sudo make
sudo make install
cd ..

echo "[*]Installing libimobiledevice ..."
sudo rm -r -f libimobiledevice
sudo git clone https://github.com/libimobiledevice/libimobiledevice.git
cd libimobiledevice
sudo ./autogen.sh --without-cython --disable-openssl
sudo make
sudo make install
cd ..

echo "[*]Installing patched libideviceactivation by OliTheRepairDude ... "
sudo rm -r -f libideviceactivation
sudo git clone https://github.com/OliTheRepairDude/libideviceactivation.git
cd libideviceactivation
sudo ./autogen.sh
sudo make 
sudo make clean
sudo make install
cd ..

echo "[*]Installing libirecovery ... "
sudo rm -r -f libirecovery
sudo git clone https://github.com/libimobiledevice/libirecovery.git
cd libirecovery
sudo ./autogen.sh
sudo make
sudo make install
cd ..

echo "ALL DONE. Everything should be working now."