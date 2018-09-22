#!/usr/bin/env bash

# Install license only if it's found

if [ -f 'license.dash-license' ]; then
    cp 'license.dash-license' "$HOME/Library/Application Support/Dash/License/license.dash-license"
fi