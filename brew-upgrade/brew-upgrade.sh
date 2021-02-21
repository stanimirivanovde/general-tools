#!/bin/bash
# This script will upgrade homebrew packages, including the casks

# Upgrade Mac OS X Software
softwareupdate --all --install

# Make sure that mas is installed: https://github.com/mas-cli/mas
# It helps us manage App Store apps
brew install mas
masOutdated=$(mas outdated)
if [ -n "$masOutdated" ]; then
	./mac-notification.py -t "App Store Packages" -m "$masOutdated"
	mas upgrade
else
	echo "No App Store packages need to be upgraded $masOutdated"
fi

# This installs helper software for building packages on Mac OS X
# For example python requires it if we're going to build it from source.
xcode-select --install

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
if [ -z "$toUpdate" ]; then
	echo "No packages to upgrade."
	exit
fi
./mac-notification.py -t "Upgrading Packages" -m "The following applications will be upgraded: ${toUpdate[@]}"
brew upgrade --greedy --casks && brew cleanup
if [ $? -ne "0" ]; then
	echo "Failed to upgrade the casks."
	./mac-notification.py -t "Upgrade Error" -m "There was an error upgrading the applications."
	exit 1
fi
echo "Upgraded the following casks:"
cat $filesToUpgrade
./mac-notification.py -t "Upgrade Complete" -m "The following applications were upgraded: ${toUpdate[@]}"

brew doctor
