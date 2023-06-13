```bash
> docker images                       
REPOSITORY            TAG       IMAGE ID       CREATED         SIZE
frontend-less-layer   latest    a420ad955c09   3 minutes ago   1.26GB
backend-less-layer    latest    427fca929000   3 minutes ago   1.07GB
frontend              latest    ccb0d987a182   2 days ago      1.26GB
backend               latest    0b872fec9122   2 days ago      1.07GB
```

We can go and examine further.

```bash
> docker inspect --format='{{.RepoTags}} {{.Size}} bytes'  $(docker images -q)   
[frontend-less-layer:latest] 1261145251 bytes
[backend-less-layer:latest] 1065754597 bytes
[frontend:latest] 1261102601 bytes
[backend:latest] 1065754597 bytes
```

## Dockerfile.backend
```docker
FROM golang:1.16

WORKDIR /usr/src/app

RUN adduser appuser

COPY . .

RUN go test ./... &&\
    go build &&\
    rm -rf /var/lib/apt/lists/*

ENV PORT=8080
#ENV REQUEST_ORIGIN=http://localhost:5000

EXPOSE 8080

USER appuser

CMD [ "./server" ]
```

## Dockerfile.frontend

```docker
FROM node:16

#ENV REACT_APP_BACKEND_URL=http://localhost:8080

WORKDIR /usr/src/app

COPY . .

RUN adduser appuser &&\
    node -v && npm -v &&\
    npm install &&\
    npm run build &&\
    npm install -g serve

USER appuser

CMD [ "serve", "-s", "-l", "5000", "build" ]
```

