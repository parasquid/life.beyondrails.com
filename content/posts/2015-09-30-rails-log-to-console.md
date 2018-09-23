---
categories: [til, rails]
date: 2015-09-29T23:14:07-07:00
description: ""
keywords: []
title: Have Rails.logger Output Sent to the Console (surprise, created_at field is protected from mass-assignment)
---
While working on a feature, I was wondering why my test is returning 0 records when I'm quite sure the query was written properly (it's just a very simple query regarding date range).

<!--more-->

I suspected there was something wrong with the database query, so I looked for a way to redirect the logs that Rails produces into the console where I'm running rspec (and pry).

Surprisingly, it wasn't that the query was wrong (it was just what I wanted). It was this:

> WARN -- : WARNING: Can't mass-assign protected attributes for `OrderLine: created_at`

It does make your tests look messy, so I would only recommend using this configuration just for the times when you want to know exactly what Rails is trying to do.

``` ruby
# config/environments/test.rb

config.logger = Logger.new(STDOUT)
config.logger.level = Logger::DEBUG
```

Note that this is on Rails 3. As the StackOverflow answer by tommes would explain, the configuration is slightly different for Rails 4. See more at http://stackoverflow.com/questions/11770552/how-to-get-rails-logger-printing-to-the-console-stdout-when-running-rspec
