Result is 18MB

```bash
ocker images
REPOSITORY            TAG       IMAGE ID       CREATED             SIZE
backend-multi         latest    302abed2d052   3 minutes ago       18MB
frontend-multi        latest    7d0b40b18dfa   About an hour ago   129MB
backend-alpine        latest    1b526417a54f   2 days ago          643MB
frontend-alpine       latest    94cd3d649c2f   2 days ago          470MB
frontend-less-layer   latest    a420ad955c09   2 days ago          1.26GB
backend-less-layer    latest    427fca929000   2 days ago          1.07GB
frontend              latest    ccb0d987a182   4 days ago          1.26GB
backend               latest    0b872fec9122   4 days ago          1.07GB
```

## Dockerfile.backend
```docker
FROM golang:1.16-alpine as builder

WORKDIR /usr/src/app

RUN adduser -D appuser

COPY . .

RUN CGO_ENABLED=0 go build -o server

FROM scratch

EXPOSE 8080

COPY --from=builder /usr/src/app/server /
COPY --from=builder /etc/passwd /etc/passwd

USER appuser

CMD [ "/server" ]
```