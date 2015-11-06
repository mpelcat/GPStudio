#/bin/bash

# run as sudo !
if [ "$(whoami)" != "root" ]; then
	echo "Sorry, you are not root. Please exec as root with sudo."
	exit 1
fi

# check if php is installed, install else
command -v php >/dev/null 2>&1 || { echo "installing php..."; apt-get install --force-yes --yes php5-cli >/dev/null; } && { echo "php is installed"; }

# check if dot is installed, install else
command -v dot >/dev/null 2>&1 || { echo "installing dot..."; apt-get install --force-yes --yes graphviz >/dev/null; } && { echo "dot is installed"; }

# copy bash completion file for gpnode
cp gpnode_completion /usr/share/bash-completion/completions/gpnode

echo "To add permanently GPStudio in your path, add this to your bashrc file :"
echo "export PATH=\$PATH:$(pwd)"
