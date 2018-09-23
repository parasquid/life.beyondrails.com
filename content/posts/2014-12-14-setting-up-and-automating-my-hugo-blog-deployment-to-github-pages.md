---
date: 2014-12-14T07:16:31-08:00
title: Setting Up and Automating my Hugo Blog Deployment to Github Pages
categories: [meta]
---
> Update

> This is largely obsolete. I have setup a new [process]({{< relref "2015-09-26-moving-hosts-from-github-pages-to-amazon-s3.md" >}}) to deploy to Amazon S3 amd I recommend it over Github Pages.

I'm currently moving my blog posts (and collecting all my blog entries from various blogging platforms) and putting them into Hugo. In case you're wondering how I've set mine up, here's a guide of what I've done.

<!--more-->

## Choosing the hosting platform

## Setting up the blog

* `sudo aptitude install golang`
* `sudo aptitude install -y mercurial`
* `go get -v github.com/spf13/hugo`

## Setting up the github pages
There's a really cool guide over at the official [Hugo documentation](http://gohugo.io/tutorials/github_pages_blog/) and I advise everyone to check it out.

``` bash
git checkout source

# Delete the master branch
git branch -D master
git push origin :master

# Create an orphaned master branch
git checkout --orphan master
rm -rf *
git rm --cached $(git ls-files)

# Grab one file from the master branch so we can make a commit
git checkout source .gitignore
git commit -m "INIT: initial commit on master branch"
git push origin master

# Return to the source branch
git checkout source

# Remove the public folder to make room for the master subtree
rm -rf public
git add -A
git commit -m 'remove stale public folder'

# Add the master  branch of the repository.
# It will look like a folder named public
git subtree add --prefix\
	public git@github.com:parasquid/parasquid.github.io.git master --squash

# Pull down the file we just committed. This helps avoid merge conflicts
git subtree pull --prefix=public origin master -m 'merge origin'

# Add the CNAME
touch public/CNAME
echo "life.beyondrails.com" > public/CNAME
```

## Scripting the deployment
Again I refered back to the hugo documentation on [setting up hugo for guthub hosting](http://gohugo.io/tutorials/github_pages_blog/) and I used it as the basis for my own deployment script.

My workflow however is unlike the any of the trhee recommended workflows (more like a hybrid):

- I do use Github pages, but as a Personal/Organization page. That means my repository is at `parasquid/parasquid.github.io`
- Instead of two repositories, I prefer to have a single repository containing both the source files and the cooked files.
- Because I'm using Github Pages for Personal/Organization I need to have the cooked pages inside the master branch. I had to modify the deployment script a little bit to ensure that my sources remain in the source branch, the subtree is located at the master branch (prefixed with public), and that all the pushing and pulling are seamless so it's all automatic (and there's no need for manual merging).

In the end I went for a `git subtree pull` before regenerating the blog. **And never trying to touch the master branch.**

However, the `git subtree` command is only present in the 1.7.11 version of git. Ubuntu Precise (12.04) only comes with 1.7.9.5 so in order to use this, a [PPA](https://launchpad.net/~git-core/+archive/ubuntu/ppa) must be installed:

<pre>
  deb http://ppa.launchpad.net/git-core/ppa/ubuntu precise main
  deb-src http://ppa.launchpad.net/git-core/ppa/ubuntu precise main
</pre>

While trying to do deployment I ran into numerous problems with errors like:

<pre>
error: failed to push some refs to
       'git@github.com:parasquid/parasquid.github.io.git'
hint: Updates were rejected because a pushed branch tip is behind its remote
hint: counterpart. Check out this branch and integrate the remote changes
hint: (e.g. 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
</pre>

Apparently this message comes up when you already have files in the remote branch and for some reason pushing will cause a merge conflict. Eventually I settled in for a bit of brutish action: deleting the master branch and recreating it as an orphan page every deploy. I'm not sure if this is something that Github will frown upon; sure it's okay to delete and recreate branches, but since this is a hosted page it may screw up their bots trying to retrieve the latest version of the branch (since I'm messing up with git history).

In order to delete the master branch, there needs to be some pre-work done. Github does not allow you to delete the default branch (which is master) so you'd need to first set the default branch to something else, then delete master. Matthew Brett has a very good [article](http://matthew-brett.github.io/pydagogue/gh_delete_master.html) that explains the procedure in full.

The downside here is that the site goes down for around 30 minutes everytime there's a deployment :( Not cool. So I had to look for a different way.

After struggling for quite a few hours this is the best I can come up with:

``` bash
#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

git checkout source
git pull origin source
git add -A
git commit -m 'committing work in progress'

# Pull down the file we just committed. This helps avoid merge conflicts
git subtree pull --prefix=public origin master -m 'merge origin'

# Build the project.
hugo -t hyde-x

# Add the CNAME
touch public/CNAME
echo "life.beyondrails.com" > public/CNAME

# Add changes to git.
git add -A

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin source
git subtree push --prefix=public\
	git@github.com:parasquid/parasquid.github.io.git master
```
It's a combination of the initial setup and the default deployment script from the hugo documentation. Now the only downside left (and this is a very minor thing for me) is that post updates can take a number of minutes before they are seen live. But I can live with that.

Also, there will be times when the master branch just won't deploy because of merge conflicts (and there's no way to do a force push on `git subtree`). So far all I have to do is to run `deploy.sh` one more time and it's all cool.

## Porting old blog entries to hugo
I've blogged on and off for quite some time in various domains and platforms. There really isn't much I can do to automate the importing of the entries. Luckily I only have a handful of published posts, but I probably lost most of my drafts and idea dumps.

## Blogging workflow
So now that everything's set and deployed, how do I continue writing?

## Questions?
If any of the instructions above are confusing, feel free to comment and I'll try my best to answer the question in the comments as well as update the instructions :)
