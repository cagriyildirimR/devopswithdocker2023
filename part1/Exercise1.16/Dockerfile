FROM golang:1.18-alpine
LABEL authors="cagriyildirim"

WORKDIR /usr/src/app

COPY . .

RUN go build

EXPOSE 8080

CMD ["./GoodFortune"]