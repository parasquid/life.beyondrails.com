---
date: 2006-04-03
title: Having Fun With Remote Shells
categories: [devops]
---

I just bought a VPS (virtual private server) a couple of days ago, and I'm enjoying tinkering with it. It's not the most powerful beast though; it only has 64MB RAM and 128MB swap. I won't say the name of the company I'm subscribed to since my box isn't exactly the bastion of security, but you should be able to discern the shell provider from how I describe my escapades :D

The most important lesson I've learned while playing sysadmin is: learn how to take notes. I had to take down, reload, reboot, reconfigure, and do it over and over again during the last couple of days. In the end, I settled for a no-frills Ubuntu Breezy, and decided to just scrap the webmin idea and learn how to hand-configure the daemons myself. But everything would have been much easier from the start had I taken down notes. Now I have them, and should I need to reinstall the thing (hope I do not) I have a copy of it :)

I'll post it here too just in case I lose that piece pf paper (which I'm expecting is going to happen).

* Disable root SSH login: nano /etc/ssh/sshd_config
* Create a normal user account: useradd -m -s /bin/bash -g users username
* Create a password for normal user account: passwd username
* Add username to list of sudoers: visudo
* Test account and sudo access, then remove root login: sudo passwd root -l
* Relog as normal user and restart the SSH daemon: /etc/init.d/ssh restart
* Add /bin/false to /etc/shells
* Update apt-get package list: sudo apt-get update
* Upgrade the whole system to the latest programs: sudo apt-get dist-upgrade

That should take care of the initial setup.

Now what am I using the remote shell for? Since I still haven't figured out how to configure a webserver, I'm currently running my bot on it ^_^ Here are the steps I did:

* Install an ftp daemon: sudo apt-get install vsftpd
* Configure ftp daemon to accept uploads: sudo nano /etc/vsftpd.conf
	* anonymous_enable=NO
	* local_enable=YES
	* write_enable=YES
* Restart ftp daemon: sudo /etc/init.d/vsftpd restart
* Install GNU Screen: sudo apt-get install screen
* Install compilers and development headers: sudo apt-get install build-essential
* Install subversion: sudo apt-get install subversion
* Install development headers for readline: sudo apt-get install libreadline5-dev
* FTP over configuration files from local computer
* Placeholder for the webserver stuff (Yay! It works~)

http://rimuhosting.com/howto/virtualhosting.jsp

libapache2-mod-php5

php5-mysql

phpyadmin

So far, that's all I've done. I'll be updating this page when I do more with my box.