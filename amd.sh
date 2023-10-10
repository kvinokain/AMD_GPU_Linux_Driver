#!/bin/bash

# Проверка наличия прав sudo
if [ $(id -u) -ne 0 ]; then
  echo "You need sudo. Try sudo ./amd.sh (sudo)."
  exit 1
fi

# Stopping the script in case of an error (-e)
set -e

# New var
download_file="amdgpu-install_5.5.50503-1_all.deb"

# Check file in dir
if [ -e "$download_file" ]; then
  echo "File $download_file exist. Skip download."
else
  # Update && upgrade system
  apt update && apt upgrade -y

  # Download .deb
  wget https://repo.radeon.com/amdgpu-install/23.10.3/ubuntu/focal/amdgpu-install_5.5.50503-1_all.deb
fi

# Install deb
sudo apt-get install ./$download_file

# Reupdate
sudo apt-get update

# Install GPU driver
sudo amdgpu-install -y --accept-eula --usecase=opencl --opencl=rocr,legacy

# Off set
set +e

# Check status
if [ $? -eq 0 ]; then
  echo "Installing successfully. Please reboot system"
else
  echo "Something wrong. Check terminal and log. Please report me about this"
fi

