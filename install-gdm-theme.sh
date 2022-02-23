#!/usr/bin/env bash
set -e

revert()
{
	commit=(a619eb55bf685f1e99140baf07e04f5dcd5c7b3b
		1944af4013075acc8ae349d647de44eb27364791
		0e3ddb1f020ff81cfa38540926f8c34130d25303)
	cd $(pwd)/gnome-shell
	git reset --hard a619eb55bf685f1e99140baf07e04f5dcd5c7b3b
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

fix_dash()
{
	sed -i 's/margin-bottom: 15px/margin-bottom: 0px/g' $(pwd)/gnome-shell/data/theme/gnome-shell-sass/widgets/_dash.scss
}

install_local()
{
	mkdir -p $HOME/.local/share/themes/gnome-42/gnome-shell
	cp $(pwd)/* $HOME/.local/share/themes/gnome-42/gnome-shell
}
install_system()
{
	glib-compile-resources $(pwd)/gnome-shell-theme.gresource.xml
	sudo mv /usr/share/gnome-shell/gnome-shell-theme.gresource{,~}
	if [[ $(ls -l /usr/share/gnome-shell/gnome-shell-theme.gresource~ | wc -l) == 0 ]]; then
		sudo cp /usr/share/gnome-shell/gnome-shell-theme.gresource{,~}
	fi
	sudo cp $(pwd)/gnome-shell-theme.gresource /usr/share/gnome-shell/gnome-shell-theme.gresource
}
if [[ $# -ne 0 ]]; then
	if [ "$1" == 'restore' ]; then
		sudo mv /usr/share/gnome-shell/gnome-shell-theme.gresource{~,}
	fi
else
	mkdir -p $(pwd)/output/
	git clone -b 42.beta https://gitlab.gnome.org/GNOME/gnome-shell.git
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
	INSTALL=0
	PS3='Enter Option Number: '
    options=("Install Local" "Install System")
    select opt in "${options[@]}"
    do
        case $opt in
		"Install Local")
		fix_dash
		break
		;;
		"Install System")
		INSTALL=1
		break
		;;
		esac
    done
	sassc -a $(pwd)/gnome-shell/data/theme/gnome-shell.scss $(pwd)/output/gnome-shell.css
	sassc -a $(pwd)/gnome-shell/data/theme/gnome-shell-high-contrast.scss $(pwd)/output/gnome-shell-high-contrast.css
	cp $(pwd)/gnome-shell/data/theme/pad-osd.css $(pwd)/output/pad-osd.css
	cd $(pwd)/output
	if [ $INSTALL == 0 ]; then
		install_local
		echo "Please change shell theme to gnome-42 from user themes extensions"
	else
		install_system
		echo "Please Reboot for Changes to Apply or Alt + F2 and enter rt"
	fi
	cd ..
	rm -rf $(pwd)/theme.zip
	rm -rf $(pwd)/output
	rm -rf $(pwd)/gnome-shell
fi