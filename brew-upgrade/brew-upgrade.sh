#!/bin/bash
# This script will upgrade homebrew packages, including the casks

# Upgrade Mac OS X Software
softwareupdate --all --install --force

# Disable analytics sharing
brew analytics off

# Make sure that mas is installed: https://github.com/mas-cli/mas
# It helps us manage App Store apps
brew install mas
brew upgrade mas
brew link mas
mas upgrade

# This installs helper software for building packages on Mac OS X
# For example python requires it if we're going to build it from source.
xcode-select --install

#brew update && brew upgrade --greedy && brew cleanup
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
else
	echo "Upgraded the following casks:"
	cat $filesToUpgrade
	./mac-notification.py -t "Upgrade Complete" -m "The following applications were upgraded: ${toUpdate[@]}"
fi

echo Running brew doctor
brew doctor
