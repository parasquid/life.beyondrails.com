---
title: "Ruby Development in Windows"
date: 2014-03-09
categories: [ruby, windows, git]
draft: true
---

I've done the unthinkable and I have a confession to make.

I've switched my development machines to Windows.

Here's the story of my heresy ... and my possible salvation.

A couple of years ago my bosses realized that me and my colleague had been using an underpowered machine (mine was my personal Macbook Air mid 2010 and my colleague was a Dell XPS 13) and had offered to get me a new development machine.

I would have wanted the latest and greatest, fully upgraded Macbook Pro but we had a budget. Actually we didn't, but I didn't want to push my luck.

So I got quite a nice beastly desktop with a nice graphics card (an i7 Sandy Bridge and 16GB of ram, SSD and a terabyte 7200rpm disk drive). Since most of my colleagues used Macs, I hackintoshed.

It was smooth sailing but a bit inconvenient. I was stuck using 10.7 when everyone had upgraded to Mountain Lion. I had to decline all system updates and point patches. Then disaster struck, a driver was causing a kernel panic.

I switched fully to Ubuntu 12.04 for about half a year. It was an okay experience.

Then my colleague resigned. I cannibalized his desktop and found he ahd a really good graphics card (I couldn't get that graphics card because it wasn't hackintosh friendly). I installed it but my Ubuntu machine is having problems with my multi monitor setup with that card.

So I decided to try out Windows. I thought I could still use cygwin, but it wasn't an easy ride. After a full day of non-productivity just trying to get things running, I thought maybe I can try Virtualization.

VirtualBox - Ubuntu 14.04
Shared folders
Network forwards
git config --global core.autocrlf=input

.

guard switch for polling

https://github.com/fgrehm/vagrant-lxc for vagrant

http://askubuntu.com/questions/207813/why-does-a-ubuntu-guest-in-virtualbox-run-very-very-slowly
extension pack
guest additions
https://www.virtualbox.org/wiki/Downloads

inconsolata

sudo adduser xxx vboxsf

sed -i 's/local   all             postgres                                peer/local   all             all                                peer/' /etc/postgresql/9.3/main/pg_hba.conf


sed -i 's/host    all             all             127.0.0.1\/32            md5/host    all             all             127.0.0.1\/32            trust/' /etc/postgresql/9.3/main/pg_hba.conf

/etc/init.d/postgresql restart

sudo su postgres -c "psql -c \"CREATE ROLE vagrant SUPERUSER LOGIN;\" "