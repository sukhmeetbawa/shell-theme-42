#!/usr/bin/env bash
set -e

rrevert()
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

INSTALL_LOCAL=1

echo "Detecting Gnome Shell Version"
shellVersion=$(gnome-shell --version | cut -f3 -d ' ' | cut -f1 -d '.')
shellRelease=$(gnome-shell --version | cut -f3 -d ' ' | cut -f2 -d '.')
if [ $shellVersion -ge 40 ]; then
	while true; do
		read -p "Do you want to install system-wide? [y/N] : " yn
		case $yn in
			[Yy]* ) INSTALL_LOCAL=0; break;;
			* ) break;;
		esac
	done
	if [ $shellVersion -ge 42 ]; then
		echo "Installing Vanilla Gnome Shell Theme"
		curl -LO https://gitlab.gnome.org/GNOME/gnome-shell/-/archive/$shellVersion.$shellRelease/gnome-shell-$shellVersion.$shellRelease.tar.gz
		tar -xf $(pwd)/gnome-shell-$shellVersion.$shellRelease.tar.gz
		cd $(pwd)/gnome-shell-$shellVersion.$shellRelease/
		sassc -a $(pwd)/data/theme/gnome-shell.scss $(pwd)/data/theme/gnome-shell.css
		sassc -a $(pwd)/data/theme/gnome-shell-high-contrast.scss $(pwd)/data/theme/gnome-shell-high-contrast.css
		if [ $INSTALL_LOCAL == 0 ]; then 
			glib-compile-resources $(pwd)/data/gnome-shell-theme.gresource.xml --sourcedir=$(pwd)/data/theme
			glib-compile-resources $(pwd)/data/gnome-shell-icons.gresource.xml --sourcedir=$(pwd)/data/icons
			if [[ $(ls -l /usr/share/gnome-shell/gnome-shell-theme.gresource~ | wc -l) == 0 ]]; then
				sudo mv /usr/share/gnome-shell/gnome-shell-theme.gresource{,~}
			fi
			sudo cp $(pwd)/data/gnome-shell-theme.gresource /usr/share/gnome-shell/gnome-shell-theme.gresource
			sudo cp $(pwd)/data/gnome-shell-icons.gresource /usr/share/gnome-shell/gnome-shell-icons.gresource
			echo -e "Theme Installed Successfully. Press Alt + F2 and enter rt to reload theme or reboot"
		else
			THEMEDIR=$HOME/.local/share/themes/vanilla-theme/gnome-shell
			mkdir -p $THEMEDIR/assets
			cp $(pwd)/data/theme/*.svg $THEMEDIR/assets
			sed -i 's/resource:\/\/\/org\/gnome\/shell\/theme/assets/g' $(pwd)/data/theme/gnome-shell.css
			cp $(pwd)/data/theme/gnome-shell.css $THEMEDIR
			echo -e "Installation successful please change shell theme to vanilla-theme using user-themes extensions."
		fi
		cd ..
		rm -rf gnome-shell-$shellVersion.$shellRelease.tar.gz
		rm -rf gnome-shell-$shellVersion.$shellRelease/
	else
		if [ $INSTALL_LOCAL == 0 ]; then
			mkdir -p $(pwd)/output/
			git clone -b 42.beta https://gitlab.gnome.org/GNOME/gnome-shell.git
			revert
			cp -r $(pwd)/gnome-shell/data/theme/*.svg $(pwd)/output/
			cp -r $(pwd)/gnome-shell/data/gnome-shell-theme.gresource.xml $(pwd)/output/gnome-shell-theme.gresource.xml
			cd $(pwd)/gnome-shell
			git checkout 4b56acb7753dfa96562cdfc5038ee1f17834cc44 data/theme/gnome-shell-sass/widgets/_dash.scss
			git checkout 4b56acb7753dfa96562cdfc5038ee1f17834cc44 data/theme/gnome-shell-sass/widgets/_message-list.scss
			git checkout 4b56acb7753dfa96562cdfc5038ee1f17834cc44 data/theme/gnome-shell-sass/widgets/_popovers.scss
			git checkout 4b56acb7753dfa96562cdfc5038ee1f17834cc44 data/theme/gnome-shell-sass/widgets/_scrollbars.scss
			git checkout 4b56acb7753dfa96562cdfc5038ee1f17834cc44 data/theme/gnome-shell-sass/*.scss
			cd ..
			sassc -a $(pwd)/gnome-shell/data/theme/gnome-shell.scss $(pwd)/output/gnome-shell.css
			sassc -a $(pwd)/gnome-shell/data/theme/gnome-shell-high-contrast.scss $(pwd)/output/gnome-shell-high-contrast.css
			cp $(pwd)/gnome-shell/data/theme/pad-osd.css $(pwd)/output/pad-osd.css
			cd $(pwd)/output
			glib-compile-resources $(pwd)/gnome-shell-theme.gresource.xml
			if [[ $(ls -l /usr/share/gnome-shell/gnome-shell-theme.gresource~ | wc -l) == 0 ]]; then
				sudo mv /usr/share/gnome-shell/gnome-shell-theme.gresource{,~}
			fi
			sudo cp $(pwd)/gnome-shell-theme.gresource /usr/share/gnome-shell/gnome-shell-theme.gresource
			cd ..
			rm -rf $(pwd)/output
			rm -rf $(pwd)/gnome-shell
			echo -e "Theme Installed Successfully. Press Alt + F2 and enter rt to reload theme or reboot"
		else
			mkdir -p $(pwd)/output/
			git clone -b 42.beta https://gitlab.gnome.org/GNOME/gnome-shell.git
			revert
			cp -r $(pwd)/gnome-shell/data/theme/*.svg $(pwd)/output/
			sed -i 's/margin-bottom: 15px/margin-bottom: 0px/g' $(pwd)/gnome-shell/data/theme/gnome-shell-sass/widgets/_dash.scss
			sassc -a $(pwd)/gnome-shell/data/theme/gnome-shell.scss $(pwd)/output/gnome-shell.css
			sassc -a $(pwd)/gnome-shell/data/theme/gnome-shell-high-contrast.scss $(pwd)/output/gnome-shell-high-contrast.css
			cd $(pwd)/output
			mkdir -p $HOME/.local/share/themes/gnome-42/gnome-shell/assets
			cp $(pwd)/*.svg $HOME/.local/share/themes/gnome-42/gnome-shell/assets
			sed -i 's/resource:\/\/\/org\/gnome\/shell\/theme/assets/g' $(pwd)/gnome-shell.css
			cp $(pwd)/gnome-shell.css $HOME/.local/share/themes/gnome-42/gnome-shell
			cd ..
			rm -rf $(pwd)/gnome-shell
			rm -rf $(pwd)/output
			echo -e "Installation successful please change shell theme to gnome-42 using user-themes extensions."
		fi
	fi
else
	echo -e "Shell Version Not Supported"
fi
