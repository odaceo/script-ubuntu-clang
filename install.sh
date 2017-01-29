#!/bin/bash

# Copyright (C) 2017 Odaceo. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LLVM_VERSION=${1:-'3.9'}

# Add the LLVM repository details
cat <<EOF | sudo tee /etc/apt/sources.list.d/llvm.list
deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial main
deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial main
# 3.9
deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-3.9 main
deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-3.9 main
# 4.0
deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-4.0 main
deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-4.0 main
EOF

# Import the public key used by the package management system
wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -

# Update your local package index
sudo apt-get update
    
# Update your local package index
sudo apt-get update

# Install CLang, LLDB & dependencies
sudo apt-get install -y clang-${LLVM_VERSION} lldb-${LLVM_VERSION} build-essential

# Create symblic links
sudo ln -s /usr/bin/clang-${LLVM_VERSION} /usr/local/bin/clang
sudo ln -s /usr/bin/clang++-${LLVM_VERSION} /usr/local/bin/clang++

# Configure the user environment
echo 'source ~/.bash_profile_clang' | tee -a ~/.bash_profile
cat <<EOF > ~/.bash_profile_clang
export CC=clang
export CXX=clang++
EOF

# Init environment
source ~/.bash_profile_clang

# Make sure clang is working properly
clang --version
clang++ --version