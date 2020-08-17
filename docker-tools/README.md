## list-child-docker-images.sh
Lists all children for a given parent docker image. It shows which other images depend on the parent. Useful if you want to remove an image but it is in use by another one. In order to list all docker images use
```bash
docker images
```

## Usage
```bash
./list-child-docker-images.sh -h
Usage: ./list-child-docker-images.sh <PARENT_IMAGE_ID> - lists all children images for the parent
Usage: ./list-child-docker-images.sh                   - lists all images and their children
```
