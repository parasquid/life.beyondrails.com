---
title: "Ruby Development in Windows"
date: 2014-03-09
categories: [ruby, windows, virtualbox]
---
I've done the unthinkable and I have a confession to make.

I've switched my development machines to Windows.

Here's the story of my heresy ... and my possible salvation.

<!--more-->

### A History Lesson

A couple of years ago my bosses realized that me and my colleague had been using an underpowered machine (mine was my personal Macbook Air mid 2010 and my colleague was a Dell XPS 13) and had offered to get me a new development machine.

I would have wanted the latest and greatest, fully upgraded Macbook Pro but we had a budget. Actually we didn't -- we were told that as one of the top value producers in the team, we can have (and should have) _any_ machine that we wanted -- but I didn't want to push my luck. Besides, the servers I administer and target my development for are running Linux; I believe my development environment should closely match that of production to minimize bugs due to architectural mistmatches.

So I got quite a nice beastly desktop with a nice graphics card (an i7 Sandy Bridge and 16GB of ram, SSD and a terabyte 7200rpm disk drive). Since most of my colleagues used Macs, I hackintoshed.

It was smooth sailing but a bit inconvenient. I was stuck using 10.7 when everyone had upgraded to Mountain Lion. I had to decline all system updates and point patches. Then disaster struck, a driver was causing a kernel panic.

I switched fully to Ubuntu 12.04 for about half a year. It was an okay experience.

Then my colleague resigned. I cannibalized his desktop and found he ahd a really good graphics card (I couldn't get that graphics card because it wasn't hackintosh friendly). I installed it but my Ubuntu machine is having problems with my multi monitor setup with that card.

### Trying Out Windows

So I decided to try out Windows. I thought I could still use cygwin, but it wasn't an easy ride. After a full day of non-productivity just trying to get things running, I thought maybe I can try Virtualization.

Here's what I had:

<pre>
VirtualBox - Ubuntu 14.04
Shared folders
extension pack
guest additions
https://www.virtualbox.org/wiki/Downloads
inconsolata
</pre>

In order to make sure I'm able to access the network share, I had to add myself to the `vboxsf` group:

    sudo adduser xxx vboxsf

