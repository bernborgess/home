#!/bin/bash

# Get the package
wget https://github.com/libsdl-org/SDL_ttf/releases/download/release-2.24.0/SDL2_ttf-2.24.0.tar.gz

# Uncompress
tar -xvzf SDL2_ttf-2.24.0.tar.gz

# Enter folder
cd SDL2_ttf-2.24.0

# Setup user folder
./configure --prefix=$HOME/.local/SDL2

# Compile
make -j$(nproc)

# Install
make install

# Debug errors with
# ldd a_sdl2.out | grep SDL2

# In haskell, debug version with
# ghc-pkg list base

# For cmake remember to
# export SDL2_DIR="$HOME/.local/SDL2/lib/cmake/SDL2"
