# shell-theme-42
Installs GNOME 42 Shell Theme for GNOME 40 & GNOME 41.

# Installation

## Cautions (Only for System Wide Installation i.e. for GDM)

- If the replacement fails, your desktop environment will not work properly. So please **be careful** if doing this.
- When applying this, other third-party GNOME Shell themes would look broken until you restore to the original theme.
- If GNOME Shell has been updated and restored to the original theme, you will need to install this again.

## Requirements

- `glib-compile-resources` — The package name depends on the distro. This is only needed for systemwide install.
  - `glib2` (Arch Linux)
  - `glib2-devel` (Fedora, openSUSE, etc.)
  - `libglib2.0-dev-bin` (Debian, Ubuntu, etc.)
- `sassc`
- `git`


 ##  Usage

 - `git clone https://github.com/sukhmeetbawa/shell-theme-42.git`
 - `cd ./shell-theme-42/`
 - `./install-gdm-theme.sh` For system-wide install\
 - `./install-gdm-theme-local.sh` For local-install\
 Local Install can be used for immutable systems like fedora silverblue.\
 For local install you can get rid of rounded corners using [just-perfection](https://extensions.gnome.org/extension/3843/just-perfection/) extension.
 
# Uninstall
  
For System-wide Install
  - `./install-gdm-theme.sh restore`
  or
  - `sudo mv /usr/share/gnome-shell/gnome-shell-theme.gresource{~,}`
 
For Local Install
  - `rm -rf $HOME/.local/share/themes/gnome-42`


# Screenshots
## GDM
![alt text](./Screenshots/GDM.png)

## Gnome Shell
![alt text](./Screenshots/Gnome-Shell-1.png)

![alt text](./Screenshots/Gnome-Shell-2.png)
