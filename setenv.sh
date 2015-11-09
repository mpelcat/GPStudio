#/bin/bash

ABSOLUTEPATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
echo "$ABSOLUTEPATH"

if [ -e "$ABSOLUTEPATH/bin/gpviewer" ]; then
	export PATH=$PATH:$ABSOLUTEPATH/bin
else
	echo "Build before setenv with make install"
fi
