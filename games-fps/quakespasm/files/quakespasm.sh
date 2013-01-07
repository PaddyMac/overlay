#!/bin/bash

GAME="quakespasm"
BIN="/usr/games/bin/${GAME}"
ORIGINAL_DIRECTORY="${PWD}"

if [ ! -d ~/quake ] && [ ! -L ~/quake ]; then
	ln -s /usr/share/games/quake1/ ~/quake
fi

cd ~/quake

exec $BIN "$@"

cd ${ORIGINAL_DIRECTORY}
