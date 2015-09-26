---
date: 2006-03-19 
title: Reinstalling Kubuntu
categories: [linux, devops]
---

My data drive had some corruption as regards its file system tree, and i was forced to rebuild it. I figured I'll just reinstall Kubuntu too since I inadverdently installed Ubuntu Desktop, which kinda doubled the applications I have on the menu.

Here are some of the things I did in order to remind myself in case my system crashes again:

* Make a dos partition writable - the options in fstab for the partition should be: user,exec,rw,umask=000 0 0
* Get Automatix and install some of the necessary non-free software
* Install packages used for compiling source code: sudo apt-get install build-essential

I'll add to the list as I walk through the rebuilding of my settings.