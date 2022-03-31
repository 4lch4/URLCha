# While this is a Makefile for using Docker, it's a Node.js app underneath so it
# has a package.json file we can pull properties from.

# In order to read the package.json file, you can use this function For nested
# properties, use dot notation (e.g. "dependencies.express").
define GetFromPkg
	$(shell node -p "require('./package.json').$(1)")
endef

# Parses the .env file and sets the environment variables:
# API_PREFIX & API_PORT
include .env

# Variables to pull from the package.json file.
PKG_NAME := $(call GetFromPkg,name)
PKG_VERSION := $(call GetFromPkg,version)
PROJECT_URL := $(call GetFromPkg,homepage)
AUTHOR := $(call GetFromPkg,author.name)

# This is the version of the image to be added to the Docker Image. Such as
# v0.0.1, v0.0.1-alpha, etc. We use the strip function to ensure there are no
# spaces between the v character and the actual version number. Also, just like
# ALL the variables specified in this file, the value can be overwritten. In
# this particular case, you can do so by providing the --IMAGE_VERSION flag.
IMAGE_VERSION:="v$(strip $(PKG_VERSION))"

# The name of the Docker repository (e.g. 4lch4/dashboard). We use the strip
# function to ensure there are no spaces between the author and app names.
DOCKER_REPOSITORY="$(strip $(AUTHOR))/$(strip $(APP_NAME))"

# The full name of the Docker image (e.g. 4lch4/dashboard:0.0.1).
IMAGE_NAME=$(DOCKER_REPOSITORY):$(IMAGE_VERSION)

# A test command to verify the environment variables are being set.
display-variables:
	@echo "PKG_NAME = $(PKG_NAME)"
	@echo "PKG_VERSION = $(PKG_VERSION)"
	@echo "PROJECT_URL = $(PROJECT_URL)"
	@echo "AUTHOR = $(AUTHOR)"
	@echo "IMAGE_VERSION = $(IMAGE_VERSION)"
	@echo "DOCKER_REPOSITORY = $(DOCKER_REPOSITORY)"
	@echo "IMAGE_NAME = $(IMAGE_NAME)"

# Run the following cammands in the following order:
# 1. Stop the container.
# 2. Delete the container and image.
# 3. Build a new version of the image.
# 4. Run the container.
# 5. Tail/follow the container logs.
rebuild: stop clean build start logs

# Delete the Docker container and image.
clean:
	@docker rm $(APP_NAME)
	@rm -rf node_modules package-lock.json yarn.lock pnpm-lock.yaml

# Build a new version of the image with the current package.json version and
# latest as a tag.
build:
	@docker build -t $(IMAGE_NAME) -t $(DOCKER_REPOSITORY):latest .

# For building the code outside of Docker.
build-local:
	@pnpm install
	@pnpm start

# Start the container with the latest tag, passing in the required environment
# variables, and tailing/following the container logs.
start: build
	@docker run -d --name $(APP_NAME) -p $(APP_PORT):$(APP_PORT) \
		-e API_PREFIX=$(API_PREFIX) \
		$(IMAGE_NAME)
	@docker logs -f $(APP_NAME)

# Stop the container using Docker Compose.
stop:
	@docker stop $(APP_NAME)

# Tail/follow the container logs.
logs:
	@docker logs -f $(APP_NAME)

# Add a new tag to the git repository and push it to GitHub.
add-tag:
	@echo "Adding v$(version) tag..."
	@git tag v$(version) -m "Release v$(version)"

# Push all changes and tags to the remote repository.
push:
	@echo "Pushing to GitHub..."
	@git push
	@git push --tags

# Executes the Prettier CLI command to format/clean up the codebase.
pretty:
	@prettier --write .
