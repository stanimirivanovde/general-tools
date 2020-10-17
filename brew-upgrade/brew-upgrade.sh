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
brew outdated -v --fetch-HEAD --cask --greedy &> $filesToUpgrade
echo "Upgrading the following casks:"
cat $filesToUpgrade
# Extract only the package name without the version
toUpdate=$( cat $filesToUpgrade | cut -d' ' -f 1 | tr '\n' ' ' )
echo "Upgrading packages: ${toUpdate[@]}"
./mac-notification.py -t "Upgrading Packages" -m "The following applications will be upgraded: ${toUpdate[@]}"
brew reinstall ${toUpdate[@]}
if [ $? -ne "0" ]; then
	echo "Failed to upgrade the casks."
	./mac-notification.py -t "Upgrade Error" -m "There was an error upgrading the applications."
	exit 1
fi
brew cleanup
echo "Upgraded the following casks:"
cat $filesToUpgrade
./mac-notification.py -t "Upgrade Complete" -m "The following applications were upgraded: ${toUpdate[@]}"
