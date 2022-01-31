#!/usr/bin/env bash
set -eux
if [[ $# -ne 0 ]]; then
	if [ "$1" == 'restore' ]; then
		sudo mv /usr/share/gnome-shell/gnome-shell-theme.gresource{~,}
	fi
else
	mkdir -p $(pwd)/output/
	curl -L -o $(pwd)/output/gnome-shell-theme.gresource.xml https://gitlab.gnome.org/GNOME/gnome-shell/-/raw/main/data/gnome-shell-theme.gresource.xml
	curl -L -o theme.zip https://gitlab.gnome.org/GNOME/gnome-shell/-/archive/main/gnome-shell-main.zip?path=data/theme
	unzip $(pwd)/theme.zip
	cp -r $(pwd)/gnome-shell-main-data-theme/data/theme/*.svg $(pwd)/output/
	sassc -a $(pwd)/gnome-shell-main-data-theme/data/theme/gnome-shell.scss $(pwd)/output/gnome-shell.css
	sassc -a $(pwd)/gnome-shell-main-data-theme/data/theme/gnome-shell-high-contrast.scss $(pwd)/output/gnome-shell-high-contrast.css
	cp $(pwd)/gnome-shell-main-data-theme/data/theme/pad-osd.css $(pwd)/output/pad-osd.css
	cd $(pwd)/output
	glib-compile-resources $(pwd)/gnome-shell-theme.gresource.xml
	sudo mv /usr/share/gnome-shell/gnome-shell-theme.gresource{,~}
	if [[ $(ls -l /usr/share/gnome-shell/gnome-shell-theme.gresource~ | wc -l) == 0 ]]; then
		sudo cp /usr/share/gnome-shell/gnome-shell-theme.gresource{,~}
	fi
	sudo cp $(pwd)/gnome-shell-theme.gresource /usr/share/gnome-shell/gnome-shell-theme.gresource
	cd ..
	rm -rf $(pwd)/theme.zip
	rm -rf $(pwd)/output
	rm -rf $(pwd)/gnome-shell-main-data-theme
fi
