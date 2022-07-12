#! /usr/bin/env bash

# set -e

if [[ "$OSTYPE" == "darwin"* ]]; then
  xcode-select --install 2> /dev/null || echo "Command line tool are already installed"
  # sudo xcodebuild -license
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sudo apt-get install build-essential
fi

# Install Homebrew, if not already installed
if [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  echo "Installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "Setting homebrew env"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install asdf with its dependencies
echo "Installing asdf"
brew install asdf openssl readline sqlite3 xz zlib

echo "Configuring asdf"
# shellcheck source=/usr/local/opt/asdf/libexec/asdf.sh
source "$(brew --prefix asdf)/libexec/asdf.sh"

# Install Python
echo "Installing python"
asdf plugin add python || echo "python asdf plugin already installed"
asdf install python latest || echo "python version already installed"
asdf global python latest || echo "python version already set globally"

# Install Ansible
echo "Installing ansible"
asdf plugin add ansible-base https://github.com/amrox/asdf-pyapp.git  || echo "ansible asdf plugin already installed"
asdf install ansible-base latest || echo "ansible version already installed"
asdf global ansible-base latest || echo "python version already set globally"






# Install Ansible, if not already installed
# which ansible-playbook > /dev/null || brew install ansible

# Provision machine with ansible

# if [ ! -d "~/.oh-my-zsh" ]; then
#     sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# fi

echo "Installing ansible collections and roles"
ansible-galaxy install -r requirements.yml

echo "Running ansible playbook"
ansible-playbook -i "localhost," -c local --become-method=su playbook.yml
