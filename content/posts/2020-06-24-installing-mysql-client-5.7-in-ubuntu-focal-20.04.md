---
title: "Installing MySQL client 5.7 in Ubuntu Focal 20.04"
date: 2020-06-24T20:37:56+08:00
categories: [""]
---
# TLDR;

* download the client from https://dev.mysql.com/downloads/mysql/
* install dependencies

```
sudo apt install libaio1 libtinfo5
```

* install the client
```
sudo dpkg -i mysql-community-client_5.7.30-1ubuntu18.04_amd64.deb
```

* check the client version
```
$ mysql --version
mysql  Ver 14.14 Distrib 5.7.30, for Linux (x86_64) using  EditLine wrapper
```
<!--more-->

As you may have gleaned from the docker-compose configuration I showed [last time][1], my team uses MysQL 5.7 community edition. It works well for us, and we don't really have any urgent reason to upgrade to MySQL 8 so we decided to not rock the boat with an upgrade (at least without a proper migration plan).

I just installed Ubuntu Focal on a Clevo NH57AF1 and it does not have MySQL 5.7 binaries in its repos. Although the version 8 client can work with a MySQL 5.7 server, mysql schema dumps include extra changes that mess with our version tracking. We keep schema dumps checked in to make sure that each developer is able to reset their databases to the standard schema.

It's not as difficult to install a lower version of MySQL, but it's not a walk in the park either. You'll first have to download the community client from https://dev.mysql.com/downloads/mysql/ but it will not show any of the older versions by default; you'll need to click on the link that says "Looking for the latest GA version?

Then you'll get three dropdowns; you should get the latest version, Ubuntu Linux as the operating system, and 18.04 (x86, 64-bit) as the OS version (or whatever architecture you're running on).

There are a number of downloads to choose from; the one I need was the community client (but it's not labeled as such; you'll need to check the filename). After that it's just a matter of installing some dependencies like `libaio1` and `libtinfo5` and then installing the `.deb.` that was just downloaded.


[1]:{{< relref "2020-06-15-advantages-of-using-docker-compose-in-your-projects.md" >}}
