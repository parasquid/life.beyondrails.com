---
categories: []
date: 2016-09-18T06:43:40+07:00
title: Timelapse with the Sony DSC RX 100 M2
draft: true
---
<iframe width="560" height="315" src="https://www.youtube.com/embed/KqzWTMBI4cQ" frameborder="0" allowfullscreen></iframe>

The Sony DSC RX 100 M2 is a great compact camera. It takes amazing pictures for its form factor, and gives amazing value for money.

I've taken really good timelapse pictures with a Samsung Galaxy S4 Zoom before, and wanted to do the same with the RX100 because of the bump in quality. However, I wasn't able to find any camera settings to allow me to do that. The only instructions I could find at the time was a hack based on [pressing down the camera trigger and hoping for the best](http://lederfotoblog.blogspot.com/2013/01/sony-rx100-timelapse-solution.html).

<!--more-->

There are also custom intervalometers [you can make by yourself](https://www.youtube.com/watch?v=Rms1A-SUmHc) (see [pinouts](http://www.doc-diy.net/photo/remote_pinout/#sony)) but the problem with this kind of intervalometer is that you are limited to the battery charge in the camera (since you won't be able to charge the camera through the same micro-usb port that the intervalometer is plugged into). This limits the amount of time you can do your timelapse for, so it rules out whole day, or multi-day timelapses.

Searching around, I found that the newer models of the RX100 series (M3 and M4) have a [remote camera api](https://developer.sony.com/downloads/camera-file/sony-camera-remote-api-beta-sdk/) whihch is used for their PlayMemories app. This remote API works through wifi.

Wait a minute. The RX100M2 _also_ has wifi, but it doesn't support PlayMemories applications (just a basic subset of it). So like a good curious developer I decided to peek at the network traffic and figure out how the app communicates with the camera, and possibly design a timelapse solution.

I tried looking for a nmap like application for Android, and found an app called [ezNetScan](http://www.eznetscan.net/features.php). Running it while connected to the camera's wifi access point told me that the camera is listening at the ip address 10.0.0.1 port 10000 with an http protocol.

That's more than enough information; that means I can connect my wifi to that address and have access to a lot more powerful tools (like nmap).

Sony Timelapse app: https://play.google.com/store/apps/details?id=com.thibaudperso.sonycamera&hl=en
GNURoot Debian app: https://play.google.com/store/apps/details?id=com.gnuroot.debian&hl=en

Code: https://github.com/parasquid/RX100M2/

Points for improvement:
* Use SNMP to automatically detect the ip address and port of the camera access point. Some of the cameras don't use the same endpoint, and using SNMP will standardize the access by returning the correct access endpoints.
* Use [darktable](http://www.darktable.org/) to postprocess pictures first before stitching the timelapse, instead of the othe rway around (stitch the timelapse then postprocess the video).