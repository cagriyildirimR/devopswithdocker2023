FROM ubuntu:20.04

WORKDIR /usr/src/app

COPY search.sh .

RUN chmod +x search.sh

RUN apt-get update
RUN apt-get install -y curl

CMD ./search.sh