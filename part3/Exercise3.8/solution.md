```bash
> docker images 
REPOSITORY            TAG       IMAGE ID       CREATED              SIZE
frontend-multi        latest    7d0b40b18dfa   About a minute ago   129MB
backend-alpine        latest    1b526417a54f   47 hours ago         643MB
frontend-alpine       latest    94cd3d649c2f   47 hours ago         470MB
frontend-less-layer   latest    a420ad955c09   2 days ago           1.26GB
backend-less-layer    latest    427fca929000   2 days ago           1.07GB
frontend              latest    ccb0d987a182   4 days ago           1.26GB
backend               latest    0b872fec9122   4 days ago           1.07GB
````


## Dockerfile.frontend

```docker
FROM node:16-alpine as builder

WORKDIR /usr/src/app

COPY . .

RUN node -v && npm -v &&\
    npm install &&\
    npm run build

# Second container
FROM node:16-alpine

RUN adduser -D appuser

WORKDIR /usr/src/app

EXPOSE 5000

COPY --from=builder /usr/src/app/build ./build
COPY package.json .
RUN npm install -g serve
USER appuser

CMD [ "serve", "-s", "-l", "5000", "build" ]
```