---
date: 2012-01-23
title: My Development Setup
categories: [hardware]
---

At [Mindvalley](http://www.mindvalley.com/) employees can have any kind of hardware/software they want, provided that they can prove it is necessary for the work they’re doing, or at least it increases their productivity. In my case, I opted for the setup as seen here (picture courtesy of my colleague):

<a href="http://instagr.am/p/h_EQp/"><img src="http://distilleryimage1.s3.amazonaws.com/8bd5621a40f411e180c9123138016265_7.jpg" alt="Look, Ma! Four eyes!!"></a>

(the blank monitor on the left was an Ubuntu VM on screensaver mode)

<!--more-->

## A Brief History of my Development Machines

Before I describe the whole setup, allow me to provide a bit of a backgrounder. Vishen – Mindvalley’s CEO – has decreed that every employee be issued a Mac, be it a MacBook/MacBook Pro/MacBook Air/Mac Pro (yes, we have four of those). Only in special cases does the company get anything other than a Mac. Not only are employees to be A-players, they have to be cool and look cool as well :)

Before my setup, I used to use a MacBook Air 2010 for development (and before that, a MacBook Pro 2010). The only person in the company that uses something other than a mac is Calvin (he runs Linux on a Dell XPS laptop). All’s well and good, but then when Mindvalley experienced a renaissance and shifted from merely being an internet marketing company into a internet services company, Calvin and I realized that our current workhorses are insufficient for the kind of work we will be doing.

And so we went about trying to get a quote for some hardware. I preferred the Mac type of environment (I loved my MacBook Air) so I thought maybe I’d get the newer MacBook Pro 2011. Calvin, of course isn’t restricted to Apple hardware since he prefers to develop on Linux anyway. That was well and good, but I when it was time to do the requisition email, I noticed that my machine was waaaay pricier than his, and I had lower specs. It was then that I had an idea.

“What if,” I thought to myself, “I can convince Vishen to get me a fast non-Apple desktop computer to save on price, then install Macintosh on it to somewhat retain the standard?” Long story short, I got my hackintosh (my very first, and it was quite an adventure making it). I have a sweet machine and I don’t have to unlearn and relearn my way through the OS.

## The Pivot

Fast forward to a lazy Friday afternoon when the Apple software updater prompted me to install a few software updates. I’ve been working with Macs for so long that it was second nature to me to install software updates without thinking about it. Needless to say, during my next reboot, my Mac sputtered during the boot sequence.

Now before all this, when I first started my foray into the forbidden world of Hackintoshes, I thought to myself that it would be such a waste if I couldn’t play any of the nice games on my machine. So I installed Windows 7 as a dual-boot option (we had a few unused licenses lying around). It was fortunate that I had this setup, because when the Mac OS refused to boot, I was still able to do basic stuff (like email and skype and some cloud-related tasks – thank you Google Docs!) with the Windows portion.

One lucky side effect of being in Windows was that I can actually use both the discrete graphics card and the onboard graphics processor at the same time - giving me the ability to use four monitors concurrently. I wasn’t able to do that with the Hackintosh; I was limited to just two screens (three if I use a DVI-USB adapter but the screen refresh on that monitor is too low for comfort). I realized that maybe I might enjoy this nice side effect, if only I can get a decent development environment set up.

## Making it Work

Everyone knows that Windows isn’t the best environment to do web development. There are lots of things that I missed when I was in a unix-like environment like that with the Mac – a sane terminal and shell, development headers, web servers, and generally a dev environment that is close to that in production.

What would be the best way to have such an environment? Make one in a virtual machine of course.

I installed Ubuntu 10.04 in VirtualBox (we use 10.04 in production as well, so that’s perfect because when I deploy I know I can mimic the same packages I’ve been using). In order to access the vm, I also installed cygwin (but I mostly just use the ssh cygwin provides). That solves the issue of the shell – I have bash inside screen and I get the benefits of multiplexing and tab completion – but still I’m stuck with the horrible terminal. So I also got XMing and ran gnome-terminal off the XServer. Bit by bit I’m getting the benefits of a Unix environment – almost there.

My editor of choice is NetBeans (I’ll explain why in a future post) and I’d prefer to run it inside Windows - running NetBeans inside Ubuntu isn’t that pretty and is pretty clunky with copy-paste. I thought I’d just be able to use VirtualBox’s shared folder capabilities, but when I tried that I realized that the Windows filesystem doesn’t respect the file permissions – all files become 777. In order to preserve the file permissions while still being able to run my editor natively (outside the VM) I used [ExpanDrive](http://www.expandrive.com/) to mount my VM’s filesystem through SSH. It’s $40 well spent – I tried using some free ssh filesystem software like [Dokan](http://dokan-dev.net/en/) but wasn’t able to make it work.

To wrap things up, I used port forwarding to expose port 3000 and port 80 from the guest to the host. That way, I can run the servers from Ubuntu while still being able to access them from a native browser. Take note that Webrick is slow when run this way – you’d need to disable reverse lookups as seen in this [gist](https://gist.github.com/1524036) to speed it up, or just use thin.

## Summary

I think the setup is pretty sweet, and I have no complaints so far (aside from having to relearn my shortcut keys). I have a Windows machine that I don’t have to reboot for gaming, and I’m able to have a development environment very close to what we have on our production machines.

The ability to use four monitors was also very productive. I have NetBeans running on the left most monitor, the middle left monitor is for my terminal (with shells being multiplexed by screen), middle right is for the current site preview, and the far right is for viewing documentation. I think four screens is just right – any more and I’d be confused where to look at (maybe one more small monitor for and extra console output?)

One additional advantage of this setup is that the whole thing is in files. That means when I get to upgrade my machine in the future, I don’t have to redo my environment – it’s in a VM so I just transplant the required files and that’s it. What I’m planning to do next is to get extra space in DropBox or [Insync](https://www.insynchq.com/) and put the VM image on it. I should be able to access everything from my different workstations, as long as I keep to the discipline of suspending or shutting down the VM whenever I leave.

What do you think of this setup? Any suggestions how to improve on this? Would love to hear how you would solve this if you called the shots :)