#!/bin/sh

# This script builds a clang, git, and emacs as user files and then
# removes them from the base system.  This is done because debian and
# its children (ubuntu) don't have updated versions of theses programs
# and I reliy on their "newer" (2 year old) features. (And backports
# (the "correct" solution) don't always exist.)

mkdir -p ~/bin
export PATH="$HOME/bin:$PATH"
mkdir -p ~/build_dir

##
#  Install old Versions
##
sudo apt install -y git
sudo apt install -y gcc

##
#  Install Clang
##
if [ $(( `awk '/^MemTotal:/{print $2}' /proc/meminfo` / 1024 / 1024 )) -ge 20 ]
then
cd ~/build_dir
git clone https://github.com/llvm/llvm-project.git
cd llvm-project
mkdir build
cd build
cmake -DLLVM_ENABLE_PROJECTS=clang -G "Unix Makefiles" ../llvm
make
cd bin
for file in $(ls)
do
    ln -sf ~/build_dir/llvm-project/build/bin/$file ~/bin
done
ln -sf ~/bin/clang ~/bin/cc
sudo apt remove gcc -y
sudo apt remove clang -y
fi

##
#  Install Git
##
cd ~/build_dir
git clone git@github.com:git/git
cd git
sudo apt install -y libssl-dev zlib1g-dev libcurl4-openssl-dev gettext libexpat1-dev
make
ln -sf ~/build_dir/git/bin-wrappers/git ~/bin
sudo apt remove git -y

##
#  Install Emacs
##
cd ~/build_dir
git clone git://git.sv.gnu.org/emacs.git
cd emacs
git checkout emacs-26.3
sudo apt install -y libxpm-dev libjpeg-dev libgif-dev libtiff-dev gnutls-dev autoconf texinfo libpng-dev
./autogen.sh
./configure --with-x-toolkit=no
make
ln -sf ~/build_dir/emacs/src/emacs ~/bin
ln -sf ~/build_dir/emacs/lib-src/ctags ~/bin
ln -sf ~/build_dir/emacs/lib-src/etags ~/bin
ln -sf ~/build_dir/emacs/lib-src/emacsclient ~/bin
sudo apt remove emacs -y
