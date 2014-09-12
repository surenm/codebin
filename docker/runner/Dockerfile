FROM ubuntu:trusty
MAINTAINER Surendran Mahendran <surenspost@gmail.com>
RUN apt-get update && apt-get install -y gcc
ADD ./slow_start.c /tmp/slow_start.c
RUN gcc /tmp/slow_start.c -o /bin/run