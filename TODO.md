# TODO

- [x] Handle ssh keys
- [x] Handle gpg keys
- [ ] Handle zsh plugins customization
- [ ] Make a proper `README.md`
- [ ] Consider the possibility of merging this repo with dotfiles (see [this doc](https://www.chezmoi.io/user-guide/advanced/customize-your-source-directory))
- [ ] Make dotfiles use `main` branch instead of `chezmoi`
- [ ] Make a PR to asdf to specify the unit of `plugin_repository_last_check_duration` ([ref](https://github.com/asdf-vm/asdf/search?q=plugin_repository_last_check_duration))
- [ ] Find a way to avoid git using osxkeychain as credential helper to give rbw exclusivity (unset it in `git config --system` or maybe add a `set` handler in rbw credential helper)
- [ ] Find a way to track docker extension in dotfiles
- [ ] Find a better pager than less
- [ ] Change git remote of dotfiles to set it to ssh
- [ ] Make a PR to react-native-debugger to allow another location for config files

## Tools of interest

### Zsh plugins

- <https://github.com/Valiev/almostontop>
- <https://github.com/BuonOmo/yarn-completion>
- <https://github.com/begris/bw-zsh-plugin>
- <https://github.com/lzambarda/hbt>
- <https://github.com/larkery/zsh-histdb> (Find a way to integrate it with zsh-autocomplete)
- <https://github.com/bric3/nice-exit-code>

### Command line tools

- <https://github.com/OJFord/loginitems>
- <https://github.com/denisidoro/navi>
- <https://github.com/mixn/carbon-now-cli>
- <https://github.com/httpie/httpie>
- <https://github.com/zdharma/zsh-lint>
- <https://github.com/r-darwish/topgrade>
- JAX (Javascript for Automation) <https://github.com/JXA-Cookbook/JXA-Cookbook>

### Apps

- <https://alt-tab-macos.netlify.app/>
- <https://authy.com/>
- <https://drive.google.com>
- <https://sipapp.io/>

## rbw

- `rbw config set email elindorath@gmail.com`
