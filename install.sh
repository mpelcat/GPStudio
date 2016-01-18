#/bin/bash

# run as sudo !
if [ "$(whoami)" != "root" ]; then
	echo "Sorry, you are not root. Please exec as root with sudo."
	exit 1
fi

# check if php is installed, install else
command -v make >/dev/null 2>&1 || { echo "installing make..."; apt-get install --force-yes --yes make >/dev/null; } && { echo "make is installed"; }

# check if php is installed, install else
command -v php >/dev/null 2>&1 || { echo "installing php5-cli..."; apt-get install --force-yes --yes php5-cli >/dev/null; } && { echo "php5-cli is installed"; }

# check if dot is installed, install else
command -v dot >/dev/null 2>&1 || { echo "installing dot..."; apt-get install --force-yes --yes graphviz >/dev/null; } && { echo "dot is installed"; }

# copy bash completion file for gpnode
echo "install bash completion";
cp gpnode_completion /usr/share/bash-completion/completions/gpnode
cp gplib_completion /usr/share/bash-completion/completions/gplib

# udev rules for dreamcam
sh -c 'echo "ATTR{idVendor}==\"04b4\", ATTR{idProduct}==\"1003\", MODE=\"666\"" > /etc/udev/rules.d/dreamcam.rules'
sh -c 'echo "ATTR{idVendor}==\"09fb\", ATTR{idProduct}==\"6001\", MODE=\"666\"" > /etc/udev/rules.d/usb_blaster.rules'
udevadm trigger

echo "To add permanently GPStudio in your path, add this to your bashrc file :"
echo "export PATH=\$PATH:$(pwd)/bin"
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$(pwd)/bin"
