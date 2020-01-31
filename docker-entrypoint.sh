#!/bin/ash

if [ ! -e ./saves/world.zip ]; then
    ./bin/x64/factorio --create ./saves/world.zip
fi

./bin/x64/factorio --start-server world
