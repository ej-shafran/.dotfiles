# Dependencies

> [!IMPORTANT]
> All the "From source" and "From download" instructions assume that `$HOME/.local/bin` is on your `$PATH`
> This will be set by the `.bashrc` in the `bash` package, but run `export PATH="$PATH:$HOME/.local/bin"` until you've installed that package

## `git`

### Verify

```bash
git -v
```

### Guide

See [here](https://git-scm.com/download)

### Brief

```bash
apt-get update
apt-get install -y git
```

## `curl`

### Verify

```bash
curl -v
```

### Guide

See [here](https://curl.se/download.html)

### Brief

```bash
apt-get update
apt-get install -y curl
```

## `tar`

### Verify

```bash
tar --version
```

### Guide

See [here](https://www.gnu.org/software/tar/)

### Brief

Should already be on your system.

## `xz`

### Verify

```bash
xz -V
```

### Guide

See [here](https://xz.tukaani.org/xz-utils/)

### Depends on

- [`make`](#make) - from download
- [`curl`](#curl) - from download
- [`tar`](#tar) - from download

### Brief

Likely already installed on your system.

```bash
apt-get update
apt-get install xz-utils
```

### From download

```bash
mkdir -p $HOME/build/xz
cd $HOME/build
curl -L https://github.com/tukaani-project/xz/releases/download/v5.6.0/xz-5.6.0.tar.gz -o xz.tar.gz
tar -xzvf xz.tar.gz -C xz --strip 1
rm xz.tar.gz
cd xz
./configure --prefix $HOME/.local
make install
```

## `gcc`

### Verify

```bash
gcc --version
```

### Guide

See [here](https://gcc.gnu.org/)

### Brief

Most likely already on your system.

```bash
apt-get update
apt-get install -y gcc
```

## `make`

### Verify

```bash
make -v
```

### Guide

See [here](https://www.gnu.org/software/make/)

### Brief

```bash
apt-get update
apt-get install -y make
```

## `autoconf`

### Verify

```bash
autoconf --version
```

### Guide

See [here](https://www.gnu.org/software/autoconf/)

### Brief

```bash
apt-get update
apt-get install -y autoconf
```

## `automake`

### Verify

```bash
automake --version
```

### Guide

See [here](https://www.gnu.org/software/automake/)

### Brief

```bash
apt-get update
apt-get install -y automake
```

## `makeinfo`

### Verify

```bash
makeinfo -V
```

### Guide

See [here](https://www.gnu.org/software/texinfo/)

### Brief

```bash
apt-get update
apt-get install -y texinfo
```

## `perl`

### Verify

```bash
perl -v
```

### Guide

See [here](https://www.perl.org/get.html)

### Brief

Should already be on your system.

## `stow`

### Verify

```bash
stow -V
```

### Guide

See [here](https://www.gnu.org/software/stow/)

### Depends on

- [`perl`](#perl)
- [`make`](#make)
- [`curl`](#curl) - from download
- [`tar`](#tar) - from download
- [`git`](#git) - from source
- [`automake`](#automake) - from source
- [`autoconf`](#autoconf) - from source
- [`makeinfo`](#makeinfo) - from source

### From download

```bash
mkdir -p $HOME/build/stow
cd $HOME/build
curl https://ftp.gnu.org/gnu/stow/stow-latest.tar.gz -o stow.tar.gz
tar -xzvf stow.tar.gz -C stow --strip 1
rm stow.tar.gz
cd stow
./configure --prefix $HOME/.local
make install
```

### From source

```bash
mkdir -p $HOME/build
git clone --depth=1 https://git.savannah.gnu.org/git/stow.git $HOME/build/stow
cd $HOME/build/stow
autoconf
aclocal && automake --add-missing
./configure --prefix $HOME/.local
make install
```

## `nvim`

### Verify

```bash
nvim -v
```

### Guide

See [here](https://github.com/neovim/neovim/blob/master/INSTALL.md)

### Depends on

- [`git`](#git)
- [`python`](#python)
- [`curl`](#curl) - from download
- [`tar`](#tar) - from download
- [`stow`](#stow) - from download
- [`make`](#make) - from source
- [`cmake`](#cmake) - from source

### From download

```bash
mkdir -p $HOME/build/nvim
cd $HOME/build
curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz -o nvim.tar.gz
tar -xzvf nvim.tar.gz -C $HOME/.local --strip 1
rm nvim.tar.gz
```

### From source

```bash
mkdir -p $HOME/build
git clone --depth=1 https://github.com/neovim/neovim $HOME/build/nvim
cd $HOME/build/nvim
make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$HOME/.local install
```

## `python`

### Verify

```bash
python3 -V
```

### Guide

See [here](https://wiki.python.org/moin/BeginnersGuide/Download)

### Depends on

- [`gcc`](#gcc) - from download
- [`make`](#make) - from download
- [`curl`](#curl) - from download
- [`xz`](#xz) - from download

### Brief

```bash
apt-get update
apt-get install python3
```

### From download

```bash
mkdir -p $HOME/build/python3
cd $HOME/build
curl -L https://www.python.org/ftp/python/3.12.2/Python-3.12.2.tar.xz -o python3.tar.xz
tar -xvf python3.tar.xz -C python3 --strip 1
rm python3.tar.xz
cd python3
./configure --prefix $HOME/.local
make install
```

## `cmake`

### Verify

```bash
cmake -version
```

### Guide

See [here](https://cmake.org/download/)

### Brief

```bash
apt-get update
apt-get install cmake
```

## `node`

### Also includes

- `npm`

### Verify

```bash
node -v
```

### Guide

See [here](https://nodejs.org/en/download/current)

### Depends on

- [`nvm`](#nvm)

### Via version manager

```bash
nvm install lts/iron # or some other version
nvm use lts/iron
# optionally:
# nvm alias default lts/iron
```

## `nvm`

### Verify

```bash
nvm -v
```

### Guide

See [here](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating)

### From source

```bash
if [ -z $NVM_DIR ]; then
  export NVM_DIR="$HOME/.nvm"
fi
git clone https://github.com/nvm-sh/nvm.git $NVM_DIR
cd $NVM_DIR
git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
source $HOME/.bashrc
```

## `delta`

### Verify

```bash
delta -v
```

### Guide

See [here](https://dandavison.github.io/delta/installation.html)

### Depends on

- [`cargo`](#cargo) - via cargo
- [`curl`](#curl) - from download
- [`tar`](#tar) - from download

### Via `cargo`

```bash
cargo install git-delta
```

### From download

```bash
mkdir -p $HOME/build/delta
cd $HOME/build
curl -L https://github.com/dandavison/delta/releases/download/0.15.0/delta-0.15.0-x86_64-unknown-linux-gnu.tar.gz -o delta.tar.gz
tar -xzvf delta.tar.gz -C delta --strip 1
rm delta.tar.gz
mkdir -p $HOME/.local/bin
install delta/delta $HOME/.local/bin
```

## `cargo`

### Also includes

- `rustup` - via rustup
- `rustc` - via rustup

### Verify

```bash
cargo -v
```

### Guide

See [here](https://www.rust-lang.org/tools/install)

### Depends on

- [`curl`](#curl) - via rustup

### Via `rustup`

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## `bat`

### Verify

```bash
bat --version
```

### Guide

See [here](https://github.com/sharkdp/bat)

### Depends on

- [`cargo`](#cargo) - via cargo

### Via `cargo`

```bash
cargo install bat
```

## `eza`

### Verify

```bash
eza -v
```

### Guide

See [here](https://eza.rocks/)

### Depends on

- [`cargo`](#cargo) - via cargo

### Via `cargo`

```bash
cargo install eza
```

## `rg`

### Verify

```bash
rg --version
```

### Guide

See [here](https://github.com/BurntSushi/ripgrep)

### Depends on

- [`cargo`](#cargo) - via cargo

### Via `cargo`

```bash
cargo install ripgrep
```

## `tldr`

### Verify

```bash
tldr -v
```

### Guide

See [here](https://tldr.sh/#installation)

### Depends on

- [`node`](#node) - via npm

### Via `npm`

```bash
npm i -g tldr
```

## `fzf`

### Verify

```bash
fzf --version
```

### Guide

See [here](https://github.com/junegunn/fzf#installation)

### Depends on

- [`git`](#git) - from source

### From source

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

## `zoxide`

### Verify

```bash
zoxide -V
```

### Guide

See [here](https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation)

### Depends on

- [`cargo`](#cargo) - via cargo

### Via `cargo`

```bash
cargo install zoxide --locked
```
