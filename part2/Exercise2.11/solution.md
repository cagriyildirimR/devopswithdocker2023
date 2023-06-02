```yaml
version: "3.9"

services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    environment:
      - REACT_APP_API_URL=https://localhost:8080/api
    volumes:
      - ./frontend:/app
      - /app/node_modules
    networks:
      - ako-network

  backend:
    build: ./backend
    ports:
      - "8080:8080"
    volumes:
      - ./backend:/app
      - ./backend/key/server.crt:/app/server.crt
    networks:
      - ako-network

  database:
    build:
      context: ./database
      dockerfile: Dockerfile.database
    ports:
      - "5432:5432"
    networks:
      - ako-network

  keycloak:
    build:
      context: ./authentication
      dockerfile: Dockerfile.keycloak
    ports:
      - "8443:8443"
    environment:
      - KEYCLOAK_ADMIN=admin
      - KEYCLOAK_ADMIN_PASSWORD=password
      - KEYCLOAK_LOGLEVEL=DEBUG
      - KEYCLOAK_ALLOW_UPLOAD_SCRIPTS=true
    depends_on:
      - database
    networks:
      - ako-network
      
networks:
  ako-network:
```

This `docker-compose.yml` file is used to define and configure the services required for an automation application. The application consists of a frontend React application, a backend written in Golang, a PostgreSQL database, and Keycloak for authentication.

Here's a summary of what's going on in the `docker-compose.yml`:

1. Services: The file defines the following services:
   - Frontend: This service is built from the `./frontend` directory. It exposes port 3000 on the host and forwards requests to the React application. The environment variable `REACT_APP_API_URL` is set to `https://localhost:8080/api`. The frontend code is mounted as a volume, as well as the `/app/node_modules` directory.
   - Backend: This service is built from the `./backend` directory. It exposes port 8080 on the host and forwards requests to the Golang backend. The backend code is mounted as a volume, and a self-signed SSL certificate (`server.crt`) is also mounted. 
   - Database: This service is built from the `./database` directory. It exposes port 5432 on the host for communication with the PostgreSQL database.
   - Keycloak: This service is built from the `./authentication` directory. It exposes port 8443 on the host for accessing the Keycloak server. Environment variables are set to configure Keycloak, including the admin username, password, log level, and allowing upload of scripts. It depends on the `database` service.

2. Networks: The file defines a network called `ako-network`. All the services are connected to this network, allowing them to communicate with each other.

## Dockerfiles

### Dockerfile.keycloak
```dockerfile
# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
ENV KC_DB=postgres

WORKDIR /opt/keycloak

# RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,DNS:keycloak,IP:127.21.0.1" -keystore conf/server.keystore
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

COPY "./realm-export.json" /opt/keycloak/data/import/

ENV KC_DB=postgres
ENV KC_DB_URL=jdbc:postgresql://database:5432/postgres
ENV KC_DB_USERNAME=postgres
ENV KC_DB_PASSWORD=postgrespw
ENV KC_HOSTNAME=localhost

EXPOSE 8443

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--import-realm"]
```

### Dockerfile.backend

I use reflex because changes in my local environment are reflected in container as well.

```Dockerfile
# Start from the official golang image
FROM golang:1.20

# Install reflex
RUN go install github.com/cespare/reflex@latest

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the code
COPY . .

COPY server.crt /usr/local/share/ca-certificates/server.crt
RUN update-ca-certificates

# Expose the backend port
EXPOSE 8080

# Build the Go app
RUN go build -o main ./cmd/server/main.go

# Command to run reflex to watch for changes and restart the server
CMD ["reflex", "-r", "\\.(go)$", "-s", "--", "go", "run", "./cmd/server/main.go"]
```

### Dockerfile.frontend

```Dockerfile
# Use the official Node.js image as the base image
FROM node:20-alpine3.16

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package.json package-lock.json ./

# Install npm dependencies
RUN npm ci

# Copy the rest of the app's source code to the working directory
COPY . .

# Expose the port that the app will run on
EXPOSE 3000

ENV HTTPS=true

# Start the app
CMD ["npm", "start"]
```

### Dockerfile.database

```Dockerfile
FROM postgres:latest

# Set environment variables
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD postgrespw
ENV POSTGRES_DB postgres

# Expose the default PostgreSQL port
EXPOSE 5432
```