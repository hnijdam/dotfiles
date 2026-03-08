#!/usr/bin/env bash
set -e

sudo dnf groupinstall "Development Tools" -y

sudo dnf install -y \
python3 \
python3-pip \
nodejs \
npm \
gcc \
gcc-c++ \
make \
cmake \
gdb \
valgrind \
strace \
ltrace \
perf \
gprof \
lldb \
clang \
clang-tools-extra \
cppcheck \
clang-format \
clang-tidy \
gyp \
gyp-next \                          