#! /usr/bin/env bash

set -e

if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! xcode-select -p 1>/dev/null 2>&1; then
    echo "Installing command line tools"
    xcode-select --install
  fi

  # sudo xcodebuild -license

  echo "Installing rosetta 2"
  softwareupdate --install-rosetta --agree-to-license || echo "Rosetta is already installed"
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "Installing build-essential"
  sudo apt-get install build-essential
fi

# Install Homebrew, if not already installed
if [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  echo "Setting homebrew env for linux"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -x "/opt/homebrew/bin/brew" ]]; then
  echo "Setting homebrew env for mac (M1)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
  echo "Setting homebrew env for mac (Intel)"
  eval "$(/usr/local/bin/brew shellenv)"
else
  echo "Installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install asdf with its dependencies
if ! which asdf 1>/dev/null 2>&1; then
  echo "Installing asdf"
  brew install asdf openssl readline sqlite3 xz zlib
else
  echo "asdf is already installed"
fi

echo "Configuring asdf"
# shellcheck source=/usr/local/opt/asdf/libexec/asdf.sh
source "$(brew --prefix asdf)/libexec/asdf.sh"

# Install Python
if ! asdf which python 1>/dev/null 2>&1; then
  echo "Installing python"
  asdf plugin add python || echo "python asdf plugin already installed"
  asdf install python latest || echo "python version already installed"
  asdf global python latest || echo "python version already set globally"
else
  echo "python is already installed"
fi

if [ ! -f "$HOME/.tool-versions" ] || ! grep python < ~/.tool-versions; then
  asdf global python latest
fi

# Install Ansible
if ! asdf which ansible 1>/dev/null 2>&1; then
  echo "Installing ansible"
  ASDF_PYAPP_INCLUDE_DEPS=1 asdf plugin add ansible https://github.com/amrox/asdf-pyapp.git  || echo "ansible asdf plugin already installed"
  asdf install ansible latest || echo "ansible version already installed"
  asdf global ansible latest || echo "python version already set globally"
else
  echo "ansible is already installed"
fi

if [ ! -f "$HOME/.tool-versions" ] || ! grep ansible < ~/.tool-versions; then
  asdf global ansible latest
fi

if [ ! -d ".ansible/collections/ansible_collections/community/general" ]; then
  echo "Installing ansible requirements"
  ansible-galaxy install -r requirements.yml
else
  echo "ansible requirements are already installed"
fi

echo "Running ansible playbook"
ansible-playbook -i "localhost," -c local --become-method=su -u "$(whoami)" playbook.yml

echo "\
You still need to do a few things:

--- Alfred ---
- Set hotkey
- Set search scope
- Request permissions

--- Google Chrome ---
- Connect to your accounts
- Allow notifications permission

--- Teamviewer ---
- Request permissions

--- General ---
- If you have the notification icons crossed out, run `killall NotificationCenter`
"

echo "Some settings need you to re-log into your session"
while true; do
  read -p "Do you want to be logged out? (y/n) " yn
  case "$yn" in
    [yY])
      echo "Logging out in 5s..."
      sleep 5
      launchctl bootout "gui/$(id -u $(whoami))"
      break
      ;;
    [nN])
      echo "Quitting without logging out"
      exit
      ;;
    *)
      echo "Invalid response"
      ;;
  esac
done
