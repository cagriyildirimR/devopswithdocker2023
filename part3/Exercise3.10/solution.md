# Exercise3.10 Solution
I am utilizing the Good Fortune app that I previously used in exercise 1.16, and I have deployed it on a cloud provider. You can access the app at the following link: [Good Fortune App](https://good-fortune.fly.dev/). You can access the repo with the following link: [cagriyildirimR/good-fortune](https://github.com/cagriyildirimR/good-fortune)

## Old Dockerfile

```docker
FROM golang:1.18-alpine
LABEL authors="cagriyildirim"

WORKDIR /usr/src/app

COPY . .

RUN go build

EXPOSE 8080

CMD ["./GoodFortune"]

```

### Size

```bash
docker images
REPOSITORY            TAG       IMAGE ID       CREATED              SIZE
good-fortune          latest    e72e4aa01ab6   About a minute ago   347MB
```

## New Dockerfile
```docker
FROM golang:1.18-alpine as builder

WORKDIR /usr/src/app

COPY . .

RUN adduser -D appuser &&\
    CGO_ENABLED=0 go build -o GoodFortune

FROM scratch

LABEL authors="cagriyildirim"
EXPOSE 8080

COPY --from=builder /usr/src/app/GoodFortune /
COPY --from=builder /etc/passwd /etc/passwd
USER appuser

ENTRYPOINT ["./GoodFortune"]
```

### Result

```bash
docker images
REPOSITORY            TAG       IMAGE ID       CREATED             SIZE
good-fortune-multi    latest    1dfc36f2b083   4 seconds ago       6.25MB
good-fortune          latest    e72e4aa01ab6   4 minutes ago       347MB
```

Size is significantly reduced.

## Sources

[Non-privileged containers based on the scratch image](https://medium.com/@lizrice/non-privileged-containers-based-on-the-scratch-image-a80105d6d341)