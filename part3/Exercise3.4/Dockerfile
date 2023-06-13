FROM docker:23.0.6-git

WORKDIR /usr/src/app

COPY . .

RUN chmod +x ./builder.sh

ENTRYPOINT ["./builder.sh"]