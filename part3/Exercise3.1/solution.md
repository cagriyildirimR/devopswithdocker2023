# Exercise3-1

## Actions
```yaml
name: Exercise3-1

on:
  push:
    branches:
      - main
    paths:
      - 'part3/Exercise3.1/express-app/**'

jobs:
  publish-docker-hub:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Login to DockerHub
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v2
        with:
          context: part3/Exercise3.1/express-app
          push: true
          tags: cagriyildirim/express-app:latest
```

## Compose
```yaml
version: '3.9'

services:
  watchtower:
    image: containrrr/watchtower
    environment:
      - WATCHTOWER_POLL_INTERVAL=60 # Poll every 60 seconds
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    container_name: watchtower
  app:
    image: cagriyildirim/express-app
    ports:
      - 8080:8080
```