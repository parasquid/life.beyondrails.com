---
title: "Install ruby-2.0.0-p195 on Ubuntu 12.04"
date: 2013-06-08
category: [devops, ubuntu]
---
It's always easier to deal with a ruby binary that's installed server-wide rather than a local user installation (done via [rvm](http://rvm.io/) or [rbenv](http://rbenv.org/)). Server initialization scripts don't need to do path magic and profile sourcing in order to find the correct binary. Here I how to install ruby-2.0.0-p195 in a way that your system administrator will love you for.

<!--more-->

System administrators maintain their servers like they would maintain a well-tended garden: clean, organized, and everything in its place. It's no surprise then that when we developers start compiling "stuff" left and right, our sysadmins get annoyed out of their minds.

There is a common ground though, and that's through using [checkinstall](https://help.ubuntu.com/community/CheckInstall). This allows us to:

  * compile the ruby binary that we want (even the latest and greatest)
  * allow the sysadmin to remove the package using the distro's package manager
  * allows a "one-build-multiple-deploy" scenario where the binary used for a server can simply be copied over and installed at a similarly configured server (think staging to production deploys)
  * simplifies `init.d` and other capistrano tasks by not having to remember to source the correct `.profile` to find the correct ruby binary
  * sidesteps the `rvm` vs `rbenv` argument by allowing the developers to choose whatever they want to use on their local, but the ruby version is standardized in production

For the impatient, it's as easy as copy-pasting this line in your terminal:

``` bash
curl -Lo- https://gist.github.com/parasquid/5624732/raw/install-ruby-2-ubuntu.sh | bash
```

> Caveat
> My preferred deployment environment uses passwordless login through SSH keys; you might need to run this script as root. Your mileage may vary depending on how different your environment is from mine.

This may not work on situations where a single server will need to host multiple ruby versions. In that case, you'd definitely need a ruby versioning manager such as `rvm` or `rbenv`. But if you don't need to support multiple ruby versions in one server, simplify your life (and save your sysadmin's sanity) by using a ruby binary that's installed server-wide through checkinstall.

Here's the whole script:

{{% gist id="5624732" file="install-ruby-2-ubuntu.sh" %}}
