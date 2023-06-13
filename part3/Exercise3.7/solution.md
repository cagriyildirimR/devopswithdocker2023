After installing alpine images

```bash
> docker images                    
REPOSITORY            TAG       IMAGE ID       CREATED              SIZE
backend-alpine        latest    1b526417a54f   5 seconds ago        643MB
frontend-alpine       latest    94cd3d649c2f   About a minute ago   470MB
frontend-less-layer   latest    a420ad955c09   5 hours ago          1.26GB
backend-less-layer    latest    427fca929000   5 hours ago          1.07GB
frontend              latest    ccb0d987a182   2 days ago           1.26GB
backend               latest    0b872fec9122   2 days ago           1.07GB
```

## Dockerfile.frontend:
```docker
FROM node:16-alpine

#ENV REACT_APP_BACKEND_URL=http://localhost:8080

WORKDIR /usr/src/app

COPY . .

RUN adduser -D appuser &&\
    node -v && npm -v &&\
    npm install &&\
    npm run build &&\
    npm install -g serve

USER appuser

CMD [ "serve", "-s", "-l", "5000", "build" ]
```

## Dockerfile.backend:
```docker
FROM golang:1.16-alpine

WORKDIR /usr/src/app

RUN adduser -D appuser

COPY . .

RUN apk add build-base &&\
    go test ./... &&\
    go build &&\
    rm -rf /var/cache/apk/*

ENV PORT=8080
#ENV REQUEST_ORIGIN=http://localhost:5000

EXPOSE 8080

USER appuser

CMD [ "./server" ]
```