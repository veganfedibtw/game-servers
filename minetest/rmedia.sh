#!/bin/bash

collect_from () {
	echo "Processing media from: $1"
	find -L "$1" -type f -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.ogg" -o -name "*.x" -o -name "*.b3d" | while read f; do
		basename "$f"
		hash=`openssl dgst -sha1 <"$f" | cut -d " " -f 2`
		cp "$f" media/$hash
	done
}

mkdir -p media/
# Change this 'collect_from' or add more lines of 'collect_from', the script will recursively
# search for files with extensions of Minetest media in this folder.
# This is an example to be run in a game folder, but you can change this to anything to catch
# all textures that a server uses.
# collect_from mods/
# Example for MineClone2 (they put textures in textures/ now)
collect_from games/mineclone2/mods
collect_from games/mineclone2/textures

printf "Creating index.mth... "
printf "MTHS\x00\x01" > media/index.mth
find media/ -type f -not -name index.mth | while read f; do
	openssl dgst -binary -sha1 <$f >> media/index.mth
done