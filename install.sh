#! /usr/bin/env bash

set -e

if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! xcode-select -p 1>/dev/null 2>&1; then
    echo "Installing command line tools"
    xcode-select --install
  fi

  if which xcodebuild 1>/dev/null 2>&1; then
    xcode_version=$(xcodebuild -version | grep '^Xcode\s' | sed -E 's/^Xcode[[:space:]]+([0-9\.]+)/\1/')
    accepted_license_version=$(defaults read /Library/Preferences/com.apple.dt.Xcode 2> /dev/null | grep IDEXcodeVersionForAgreedToGMLicense | cut -d '"' -f 2)

    if [ "$xcode_version" != "$accepted_license_version" ]; then
      echo "Accepting Xcode license"
      sudo xcodebuild -license accept
    fi
  fi

  if ! /usr/bin/pgrep oahd 1>/dev/null 2>&1; then
    echo "Installing rosetta 2"
    softwareupdate --install-rosetta --agree-to-license || echo "Rosetta is already installed"
  else
    echo "rosetta 2 is already installed"
  fi
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
# shellcheck source=/opt/homebrew/opt/asdf/libexec/asdf.sh
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
ansible-playbook -i "localhost," -c local --become-method=sudo -K -u "$(whoami)" playbook.yml

echo "\
You still need to do a few things:

--- Alfred ---
- Set hotkey
- Set search scope
- Request permissions
- Fill the license field

--- Google Chrome ---
- Connect to your accounts
- Allow notifications permission

--- Teamviewer ---
- Request permissions

--- Slack ---
- Connect to your accounts

--- Docker ---
- Allow privileged access at first start
- Allow \"Always download update\" in preferences
- Connect to Docker Hub

--- Spectacle ---
- Allow it to open at startup
- Set \"Launch it as a background process\"

--- Bartender ---
- Fill the license field
- Allow it to open at startup
- Configure it

--- iStat Menu ---
- Fill the license field
- Configure it
- Request permissions for calendar access

--- Notion ---
- Connect to your accounts

--- Postico ---
- Fill the license field  (TODO)

--- Tooth Fairy
- Allow it to open at startup
- Connect your bluetooth devices

--- General ---
- In System Preferences > Dock && menu bar > Monitor, remove it from the menu bar
- In System Preferences > Dock && menu bar > Sound, remove it from the menu bar
- In System Preferences > Dock && menu bar > Listening, remove it from the menu bar
- In System Preferences > Dock && menu bar > Battery, remove it from the menu bar
- In System Preferences > Dock && menu bar > Spotlight, remove it from the menu bar
- In System Preferences > Keyboard > Shortcuts > Spotlight, remove the shortcut to show the search bar
- In System Preferences > Siri, hide it in the menu bar
- In System Preferences > Bluetooth, display it in the menu bar
- If you have the notification icons crossed out, run \`killall NotificationCenter\`
"

echo "Some settings need you to re-log into your session"
while true; do
  read -r -p "Do you want to be logged out? (y/n) " yn
  case "$yn" in
    [yY])
      echo "Logging out in 5s..."
      sleep 5
      launchctl bootout "gui/$(id -u "$(whoami)")"
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
