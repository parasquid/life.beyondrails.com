---
date: 2015-09-26
title: Moving Hosts From Github Pages to Amazon S3
categories: [meta]
---
I've decided to simplify the deployment [process]({{< relref "2014-12-14-setting-up-and-automating-my-hugo-blog-deployment-to-github-pages.md" >}}) and instead host the blog at S3.

<!--more-->

Now, my deployment script looks like this:

``` bash
#!/bin/sh
hugo --theme=hyde-x
s3cmd sync public/* s3://life.beyondrails.com -v --no-mime-magic
```

That `--no-mime-magic` switch is because of a [known issue](https://github.com/s3tools/s3cmd/issues/198) that causes css and js files to be uploaded with a mime-type of `text/plain` instead of `text/css` and `text/js` respectively.

Aside from a more streamlined deployment process, I also am able to completely sidestep an intermittent DNS error that sometimes happens when loading the blog when it was hosted on github pages.
