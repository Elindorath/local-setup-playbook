# Local Setup Playbook

This repository install and configure most of the software I use on my machines.
It provides a small script to install brew (Homebrew on Mac, Linuxbrew on other Unix) or Chocolatey on windows and Ansible then do all the work with an ansible playbook.
All software whose versions do not need to vary from one project to another are installed with brew, the other with asdf (when available)

## TODO

The installation flow goes like this:
- We need `ansible` to run playbook, but `ansible` version itself should be managed by a tool version manager. We chose `asdf`
- So we need to install `asdf`. It depends on `curl` and `git` but we might want to use `brew` to avoid maintaining the dependencies install.
- So we need to install `brew`. It depends on `git v2.7`, `ruby v2.6`, `glibc v2.13` and `curl v7.41`

Install `brew` with `curl`
Install `asdf` with `brew`
Install `ansible` with `asdf`
Run playbook

### Brew > asdf > ansible setup

bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install asdf openssl readline sqlite3 xz zlib
asdf plugin add python
asdf install python latest
asdf global python latest
asdf plugin add ansible-base https://github.com/amrox/asdf-pyapp.git
asdf install ansible-base latest
asdf global ansible-base latest

### Shell startup scripts structure

.shell
├── bash
│   ├── env
│   ├── interactive
│   ├── login
│   └── logout
├── zsh
│   ├── env
│   ├── interactive
│   ├── login
│   └── logout
└── common
    ├── env
    ├── interactive
    ├── login
    └── logout

### GUI to install

Google chrome


'THIS_SHELL_INTERACTIVE_TYPE=''non-interactive''; THIS_SHELL_LOGIN_TYPE=''non-login''; if tty -s; then THIS_SHELL_INTERACTIVE_TYPE=''interactive''; fi; if echo $0 | grep -e ^\- 2>&1>/dev/null; then THIS_SHELL_LOGIN_TYPE=''login''; fi; echo "$THIS_SHELL_INTERACTIVE_TYPE/$THIS_SHELL_LOGIN_TYPE"'
