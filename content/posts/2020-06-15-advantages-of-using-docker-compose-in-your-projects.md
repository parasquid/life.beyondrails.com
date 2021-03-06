---
title: "Advantages of Using Docker Compose in Your Projects"
date: 2020-06-15
categories: [""]
---
It's that time of the year again when I get a larger drive, refresh my operating system, and back up important files.

Ever since I've settled on having my `home` folder always be on a separated drive, it's been really easy to change operating systems, and even moving to a different (more powerful) computer isn't as much of a chore. If I need to upgrade storage capacity, I just copy everything in my home folder onto the new drive (either by imaging or rsync) and then make sure that when I setup the new OS, that new drive is mounted in `/home`.

One thing that's been really convenient for me is the ability to even move database data along with my home folder. This has been largely because I've been using docker (and docker-compose) more and more on my projects.
<!--more-->
For example, one of the `docker-compose.yml` configurations I have for work looks like this:

``` yaml
version: '3.2'
services:
  mysql:
    # image: circleci/mysql:5.7-ram # no persistence, but very fast
    image: circleci/mysql:5.7
    command: --ssl=0
    restart: always
    expose:
      - "3306"
    ports:
      - '13306:3306'
    shm_size: '2gb'
    environment:
      MYSQL_DATABASE: ejbdev
      MYSQL_ROOT_PASSWORD: toor
    volumes:
      - ./mysql-data:/var/lib/mysql
      # - /usr/local/var/mysql:/var/lib/mysql # use data from local mysql service

  adminer:
    image: adminer
    restart: always
    ports:
      - 8888:8080
    environment:
      ADMINER_DEFAULT_SERVER: mysql

  redis:
    image: "redis:alpine3.11"
    restart: always
    ports:
      - "16379:6379"
    volumes:
      - ./redis-data:/var/lib/redis
      - ./redis.conf:/usr/local/etc/redis/redis.conf
    environment:
      - REDIS_REPLICATION_MODE=master
```
You'll notice that the postgres and the redis data volumes are being mounted on the same folder as the `docker-compose.yml` file. This makes it so the data is located along with the code; that means whenever I have to move drives or move the work folder into another location, the data I've been working on comes along with it.

This makes for really fast setup times whenever I need to switch work machines: either just move the drive or copy the contents, do `docker-compose up` and have docker download the images, and once the services go online everything works as before. The only thing different is that I now have faster/larger storage :)

I can wholeheartedly recommend the advice given by https://hackernoon.com/dont-install-postgres-docker-pull-postgres-bee20e200198 but would add that aside from docker, use docker-compose so you don't have to memorize all that fancy command line invocation. Write it once and just do a `docker-compose up`.
