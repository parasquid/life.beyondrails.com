---
title: "Docker Compose All The Things"
date: 2023-03-04
---
After getting the GPD Win Max 2 and using it as my everyday machine bothe for work and for personal use, I've started enforcing the philosophy of not installing any project dependencies locally, and instead leverage containerization technology (mostly via docker). I've talked about this in [a previous post](/blog/2020/06/15/advantages-of-using-docker-compose-in-your-projects/) and you can probably think of this post as an improvement on top of that.

I've been successfully using this following pattern both for work projects as well as personal ones, and I thought I'd like to share them.
<!--more-->
This particular blog for example is using this configuration:

``` yaml
version: '3.2'
services:
  default: &defaults
    image: klakegg/hugo:0.48
    volumes:
      - ./:/src
    working_dir: /src

  hugo:
    <<: *defaults
    profiles: ["dev"]
    entrypoint: hugo

  app:
    <<: *defaults
    ports:
      - "1313:1313"
    command: server -D --bind=0.0.0.0
    tty: true
```
This is then augmented by a bash alias:

    alias dcr='docker compose run --rm -u 1000:1000

I would usually have at least two services:

1. the first one would be named the same as the primary executable (in this case `hugo` but in JS projects it can be `yarn` or in Rails projects, `rails`) and instead of a command, I use an entrypoint. This allows me to do something like `dcr yarn add @faker-js/faker` for example which keeps the semantics of the binary, and all I need to remember is to prefix the command with dcr (short for docker compose run).
2. the second service would usually be called app and it is what I would like to run when I do `docker compose up`

Note that the more recent versions of `docker compose` configuration supports the service key "profiles" and I put the first service in that profile. That way when I do `docker compose up` it only brings up the default services (the ones that don't have their profiles set) and does not try to bring up the services I'm only expecting to run transactionally.

With this, I haven't had to install any dependencies locally in my projects, and migrating to a different machine is much easier as well as the only dependency becomes docker; as long as docker is installed, I can continue working on the project without having to remember how to install the dependencies.
