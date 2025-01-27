.files
---

# Preflight

### Check and install software updates

```shell
sudo softwareupdate -i -a
```

### Install command line tools

```shell
xcode-select --install
```

### Create config and Brewfile

```shell
cp ./config.example ./config
cp ./Brewfile.example ./Brewfile
```

# Run

```shell
./install.sh
```

# Add new bash as a default shell

1. Adding /usr/local/bin/bash to /etc/shells
2. Running chsh -s /usr/local/bin/bash.
