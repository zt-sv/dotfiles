# .files

## Before instalation
```bash
sudo softwareupdate -i -a
xcode-select --install
sudo xcodebuild -license
chmod a+x install.sh
```

## Package overview
Configure OSX, bash profile, mackup and git.

Install:
* [Homebrew](http://brew.sh/) and packages:
    - [mackup](https://github.com/lra/mackup)
    - git
    - bash-completion
    - [node](https://nodejs.org/en/)
    - [dockutil](https://github.com/kcrawford/dockutil)
    - midnight-commander
    - mongodb
    - redis
* [NPM](https://www.npmjs.com/) packages:
    - [grunt](http://gruntjs.com/)
    - grunt-cli
    - [n](https://www.npmjs.com/package/n)
* [Cask](http://caskroom.io/) and applications:
    - [webstorm](https://www.jetbrains.com/webstorm/)
    - [nylas-n1](https://www.nylas.com/n1)
    - evernote
    - dropbox
    - firefox
    - virtualbox
    - iterm2
    - skype
    - sublime-text3
    - vlc
    - google-chrome
    - lastfm
    - sourcetree
    - utorrent
    - [xld](http://sourceforge.net/projects/xld/)
    - [Quicklook plugins](https://github.com/sindresorhus/quick-look-plugins)

## After install
Setup your Dropbox application and run `mackup restore` for restore your application settings on a newly installed workstation.
