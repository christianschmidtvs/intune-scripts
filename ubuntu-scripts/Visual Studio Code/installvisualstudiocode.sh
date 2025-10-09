#!/bin/bash

# Check if VSCode is already installed
if ! command -v code &> /dev/null; then
    # Install prerequisites wget and gpg
    apt-get install -y wget gpg

    # Download and install Microsoft's GPG key
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    install -D -o root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg

    # Add VSCode repository
    sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg

    # Install apt-transport-https
    apt-get install -y apt-transport-https

    # Update apt repositories
    apt-get update -y

    # Install VSCode
    apt-get install -y code
else
    echo "Visual Studio Code is already installed."
fi