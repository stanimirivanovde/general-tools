#!/bin/bash
parent=$1

if [ "$parent" == "-h" ]; then
	echo "Usage: $0 <PARENT_IMAGE_ID> - lists all children images for the parent"
	echo "Usage: $0                   - lists all images and their children"
	exit 0
fi


if ! [ -z $parent ]; then
	echo "Listing children of $parent"
	docker inspect --format='{{.Id}} {{.Parent}} {{.RepoTags}}' $(docker images --filter since=$parent --quiet)
	exit $?
fi

# Some bash fu
# List all images: docker images
# Treat replace all repeating spaces with a single space: tr -s ' '
# Get the image ID field: cut -d' ' -f 3
# Skip the first line and print the rest: tail -n +2
IFS=$'\n'
images=$(docker images | tr -s ' ' | cut -d' ' -f 1,3 | tail -n +2)
for image in ${images[@]}; do
	name=$(echo $image | cut -d' ' -f 1)
	imageId=$(echo $image | cut -d' ' -f 2)
	echo "Working on parent image $name:$imageId"
	docker inspect --format='{{.Id}} {{.Parent}} {{.RepoTags}}' $(docker images --filter since=$imageId --quiet)
done
