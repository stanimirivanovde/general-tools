#!/bin/bash
# This script will upgrade homebrew packages, including the casks

# Disable analytics sharing
brew analytics off

brew update && brew upgrade && brew cleanup
if [ $? -ne "0" ]; then
	echo "Failed to update brew."
	exit 1;
fi
filesToUpgrade=~/files-to-upgrade.txt
brew cask outdated --greedy -v &> $filesToUpgrade
echo "Upgrading the following casks:"
cat $filesToUpgrade
# Extract only the package name without the version
toUpdate=$( cat $filesToUpgrade | cut -d' ' -f 1 | tr '\n' ' ' )
echo "Upgrading packages: ${toUpdate[@]}"
brew cask reinstall ${toUpdate[@]} && brew cleanup
if [ $? -ne "0" ]; then
	echo "Failed to upgrade the casks."
fi
