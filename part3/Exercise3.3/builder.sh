#! /bin/sh

repo=$1
hub=$2

github="https://github.com/"
clone_dir=""

# Extract the repository name from the URL
clone_dir=$(basename "$repo" .git)

# Clone the repository
git clone "$github$repo"

# Change to the cloned directory
cd "$clone_dir"

echo "Current directory:"
echo "$(pwd)"

echo "Building Docker image"

# Build the Docker image
docker build -t "$clone_dir" .

# Log in to Docker Hub
docker login

# Tag the image with the Docker Hub repository
docker tag "$clone_dir" "$hub"

# Push the image to Docker Hub
docker push "$hub"

