# shell-theme-upstream
Installs Latest Gnome Shell Theme to make it look like GNOME 42.

# Installation

## :warning: Cautions :warning:

- If the replacement fails, your desktop environment will not work properly. So please **be careful** if doing this.
- When applying this, other third-party GNOME Shell themes would look broken until you restore to the original theme.
- If GNOME Shell has been updated and restored to the original theme, you will need to install this again.

## Requirements

- `glib-compile-resources` — The package name depends on the distro.
  - `glib2` (Arch Linux)
  - `glib2-devel` (Fedora, openSUSE, etc.)
  - `libglib2.0-dev-bin` (Debian, Ubuntu, etc.)
- `sassc`
- `curl`
- `git`
 
 ## Usage
 
 - `git clone https://github.com/sukhmeetbawa/shell-theme-upstream.git`
 - `./install-gdm-theme.sh`
 
# Uninstall
  
  - `./install-gdm-theme.sh restore1
  or
  - `sudo mv /usr/share/gnome-shell/gnome-shell-theme.gresource{~,}`


# Screenshots
## GDM
![alt text](./Screenshots/GDM.png)

## Gnome Shell
![alt text](./Screenshots/Gnome-Shell-1.png)

![alt text](./Screenshots/Gnome-Shell-2.png)
