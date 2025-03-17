#!/bin/bash

# Get all dependencies
#dependencies=$(apt-cache depends --recurse --no-conflicts --no-breaks --no-replaces --no-enhances remmina | grep "^\w" | sort -u)
dependencies="remmina-plugin-secret"

mkdir -p $HOME/.local/lib/remmina-deps

for lib in $dependencies; do
	deb_file="${lib}_*.deb"
	if [ ! -f "$deb_file" ]; then
		apt download "$lib"
	else	
		echo "$deb_file already exists, skipping download."
	fi
	echo "Extracting $deb_file."
	dpkg -x ${lib}_*.deb "$HOME/.local/lib/remmina-deps/"
done

# Set the LD_LIBRARY_PATH
export LD_LIBRARY_PATH="$HOME/.local/lib/remmina-deps/usr/lib/x86_64-linux-gnu/:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib/remmina-deps/usr/lib/x86_64-linux-gnu/remmina/plugins/:$LD_LIBRARY_PATH"


# # Now download remmina
# apt download remmina
# dpkg -x remmina*.deb "$HOME/.local/share/remmina"

# Run it
#$HOME/.local/share/remmina/usr/bin/remmina
