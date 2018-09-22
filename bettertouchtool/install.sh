#!/usr/bin/env bash

# Install license only if it's found

if [ -f 'bettertouchtool.bttlicense' ]; then
    cp 'bettertouchtool.bttlicense' "$HOME/Library/Application\ Support/BetterTouchTool/bettertouchtool.bttlicense"
fi