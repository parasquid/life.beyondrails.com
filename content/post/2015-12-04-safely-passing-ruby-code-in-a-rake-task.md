---
title: "Safely Passing Ruby Code in a Rake Task"
date: 2015-12-04
categories: [ruby, meta-programming, til]
---

I wanted to make a rake task that would accept something like `1.month` or `1.day` as one of it's arguments. The immediate tool I reached for was `eval` and it worked like a charm. However, Code Climate (the tool we use to check for static analysis) complains about `eval` and understandably so; the use of `eval` is a practice wrought with danger and security vulnerabilities.

I'm using it inside a rake task that is never exposed to third parties, and anyone malicious enough to run the rake task with a bad parameter to be eval'd would already have had access to the system anyway, and able to wreak even greater havoc than by running the malicious code through the rake task. I believe this is an accepted risk scenario, and Crystal (one of my colleagues who was reviewing my code) suggested that since I had a valid point, I can just turn off the Code Climate check for this particular instance.

I thought that was justified, but I also thought it was a slippery slope. I'm sure there are ways to pass in a string and have it dynamically interpreted, without having to expose the system to a security vulnerability.

<!--more-->

more text here