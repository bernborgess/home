# Updating on different distros
- Arch Linux
  ```
  sudo pacman -Syu
  ```
  or if you have an AUR helper just `yay` or `paru`.
- Ubuntu/Debian/Linux Mint/PopOS
  ```
  sudo apt update && sudo apt upgrade -y
  ```
  if some repo fails, check `/etc/apt/sources.list{.d}`
- Fedora/RHEL
  ```
  sudo dnf upgrade
  ```
  > TODO: Avoid having to press `y`
- OpenSUSE
  ```
  sudo zypper refresh && sudo zypper update -y
  ```

