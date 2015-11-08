---
title: "Ruby Development in Windows Revisited"
date: 2015-11-07
categories: [ruby, windows, virtualbox]
---
Some time ago I [wrote about how I set up my machine]({{< relref "2014-03-09-ruby-development-in-windows.markdown" >}}) so I can program hassle-free in ruby while running Windows. It was more of a reminder to myself than anything, if I ever needed to set things up the same way again.

Fast forward to 2015. When a colleague saw my workstation and realized I was running Windows, he was quite surprised and asked me how I was doing it. I thought of pointing him to my old blog post, but I felt that:

  * It was outdated (the setup described was from 2012, written in 2014)
  * It was incomplete (it's just a checklist of what I've installed)

I've improved on the whole setup since, and I thought it's time to share the whole updated setup so that anyone else interested can benefit.

<!--more-->

## The Magic of Virtualization

> Pay no attention to that man behind the curtain!

> [The Wizard of Oz (1939 film)](https://en.wikiquote.org/wiki/The_Wizard_of_Oz_%281939_film%29#The_Wizard)

{{< figure src="/images/ubuntu-plus-x11-forwarding.png" title="Screenshot of my desktop running Windows and having an X11-forwarded gnome-terminal and sublime-text running inside a VM" >}}

It's probably a bit misleading to say I do my ruby development _completely_ in Windows. It's not because of the graphical user interface or the hardware support; I think Windows 10 had really been a great improvement over the past Windows versions. Support for peripherals (like graphic cards, multi-monitor setups, or just [recently](link to follow soon on hackworkplay.com) 4k TV/monitors) is simply heaps better than that of Ubuntu.

Rather, it's because the Windows CLI is absolutely horrible. I've looked into some projects that attempt to alleviate the pain of the Windows CLI like [PowerShell](https://en.wikipedia.org/wiki/Windows_PowerShell) or [Console2](Console2) but for me, nothing still beats the power of a unix tty.