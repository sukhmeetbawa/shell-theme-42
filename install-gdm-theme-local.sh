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
echo "Installation successful please change shell theme to gnome-42 using user-themes extensions."