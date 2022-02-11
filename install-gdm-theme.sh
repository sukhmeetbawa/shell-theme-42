#!/usr/bin/env bash
set -e

revert()
{
	commit=(a619eb55bf685f1e99140baf07e04f5dcd5c7b3b
		1944af4013075acc8ae349d647de44eb27364791
		0e3ddb1f020ff81cfa38540926f8c34130d25303)
	cd $(pwd)/gnome-shell
	for i in "${commit[@]}"
	do
		git revert -n $i
	done
	cd ..
}
corner()
{
	cd $(pwd)/gnome-shell
	git revert -n 4f27a6e52056bf1f486b49c2909c94c612c38f75
	cd ..
}

if [[ $# -ne 0 ]]; then
	if [ "$1" == 'restore' ]; then
		sudo mv /usr/share/gnome-shell/gnome-shell-theme.gresource{~,}
	fi
else
	mkdir -p $(pwd)/output/
	git clone https://gitlab.gnome.org/GNOME/gnome-shell.git
	revert
	cp -r $(pwd)/gnome-shell/data/theme/*.svg $(pwd)/output/
	cp -r $(pwd)/gnome-shell/data/gnome-shell-theme.gresource.xml $(pwd)/output/gnome-shell-theme.gresource.xml
	while true; do
		read -p "Do you want rounded panel corners? [y/N] : " yn
		case $yn in
			[Yy]* ) corner; break;;
		        * ) break;;
		esac
	done	
	sassc -a $(pwd)/gnome-shell/data/theme/gnome-shell.scss $(pwd)/output/gnome-shell.css
	sassc -a $(pwd)/gnome-shell/data/theme/gnome-shell-high-contrast.scss $(pwd)/output/gnome-shell-high-contrast.css
	cp $(pwd)/gnome-shell/data/theme/pad-osd.css $(pwd)/output/pad-osd.css
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
	rm -rf $(pwd)/gnome-shell
fi
echo "Please Reboot for Changes to Apply or Alt + F2 and enter rt"
