---
title: "Running PrivatePub/Faye Standalone in Heroku for Free"
date: 2013-05-25
categories: [devops, ruby, heroku]
---

[PrivatePub](https://github.com/ryanb/private_pub) is an awesome gem by the renowned Ryan Bates of [Railscast](http://railscasts.com/) fame. It provides an easy way to use Faye as a pubsub provider. Watch this [episode](http://railscasts.com/episodes/316-private-pub) to see it in action.

You don't have to bundle the gem with a Rails application though; you can deploy PrivatePub standalone as a rack application in Heroku. This allows you to run PrivatePub in a web dyno instead of a worker, allowing for easier maintenance (separation of repositories/codebases) and as a side effect, save on hosting costs.

<!--more-->

[Heroku](https://www.heroku.com/) is well known in the Ruby and Rails community for being the top-of-the-mind platform when it comes to cloud hosting. One of the biggest benefits of Heroku for developers is that they provide -- per application -- your [first web dyno](https://devcenter.heroku.com/categories/billing) for free. It's great for trying out new ideas and services without having to shell out money for a hosting provider.

Heroku supports a [number of languages](https://devcenter.heroku.com/categories/language-support) (including Ruby) and a number of deployment options. What we're interested here is the [Rack application depoyment](https://devcenter.heroku.com/articles/ruby-support#rack-applications) capbility. 

``` ruby
# config.ru
# Run with: rackup private_pub.ru -s thin -E production
require "bundler/setup"
require "yaml"
require "faye"
require "private_pub"

Faye::WebSocket.load_adapter('thin')

PrivatePub.load_config(
  File.expand_path(
    "../config/private_pub.yml", __FILE__
  ), 'production'
)
run PrivatePub.faye_app
```

``` yaml
# config/private_pub.yml
development:
  server: "http://localhost:9292/faye"
  secret_token: "secret"
test:
  server: "http://localhost:9292/faye"
  secret_token: "secret"
production:
  server: "http://example.com/faye"
  secret_token: "secret"
  signature_expiration: 3600 # one hour
```

``` ruby
# Gemfile
source 'https://rubygems.org'
ruby "2.0.0"

gem 'faye'
gem 'private_pub'
gem 'thin'
```

These three files are really all you need to start your PrivatePub standalone server in heroku. You'll notice a few changes from the original instructions.

`rails g private_pub:install` will create a `private_pub.ru` rackup file in your app folder. Since heroku by default will define a web process type at deploy time with the following parameters:

``` bash
web: bundle exec thin start -R config.ru -e $RACK_ENV -p $PORT
```

I simply renamed the file to `config.ru`. You don't need the rest of the Rails application to run PrivatePub (but you still need Rails to use the client portions).

One caveat: Rack and Faye doesn't play well with [running the server in development mode](https://github.com/faye/faye/issues/25#issuecomment-375678). So if you're developing locally, you'd need to make sure you pass in `-E production` to thin. You'd also most likely need to copy the same `secret_token` for the `development` and `production` environments.

The second line of the `Gemfile` is a `bundler` directive only available in version 1.2.0 and above. This is used by [Heroku](https://devcenter.heroku.com/articles/ruby-versions) (and even by [rvm](https://github.com/wayneeseguin/rvm/issues/1517#issuecomment-15007730)) to select the ruby version they will use for your environment. I prefer to make sure my deployment target mimics my development environment as much as possible so I throw that in there.

Another caveat: Heroku does not support WebSockets yet, so Faye will fallback to long-polling. This may or may not be a deal breaker, as this is in fact a desirable behavior -- long-polling ensures that your application is supported even by not-so-current browsers.
