---
title: "Rolling Restarts with Capistrano and Linode"
date: 2013-06-01
categories: [devops]
---

Here I show how to perform a rolling restart using Capistrano, and making sure that the load balancer (in this case Linode) properly reroutes traffic to the still-running servers while the others are being restarted.

> WARNING
> I'm still ironing out a few bugs for the rolling deployments. The issue appears to be that Capistrano executes <code>deploy:create_symlink</code> in parallel so the apps still experience downtime before the restart happens. The concept itself is sound but the code is not yet production ready!!

<!--more-->

It is generally recommended in high-availability setups (usually with a cluster of machines behind a proxy or a load balancer) to perform a rolling restart of the services. Restarting all of your services at the same time will generally cause downtime for your users, and depending on your use case this situation is not very desirable.

However, Capistrano by default runs tasks in parallel and it mostly isn't obvious how to perform capistrano tasks serially with all of your hosts. Furthermore, communication with the load balancer during the restart is vital to proactively stop incoming connections to the application server being restarted.

``` ruby
# config/deploy.rb
namespace :deploy do
  task :restart, :roles => :app, except: { no_release: true } do
    if self.roles[:app].count == 1
      run "/etc/init.d/rainbows_#{application} restart"
    else
      self.roles[:app].each do |host|
        # execute a rolling restart
        address = "#{host.options[:private_ip]}:80"
        label = 'NodebalancerConfiguration'
        api = LinodeApi.new

        puts "rejecting connections for #{address}"
        api.reject_connections_from_node_with_label_and_address(label, address)

        puts "performing restart"
        run "/etc/init.d/rainbows_#{application} restart", hosts: host

        puts "accepting connections for #{address}"
        api.accept_connections_from_node_with_label_and_address(label, address)

        puts "sleeping for 90 seconds to allow for status propagation"
        sleep(90)
      end
    end
  end
end
```

``` ruby
# config/deploy/production.rb
server '10.0.0.2', :web, :app, private_ip: '192.168.0.1'
server '10.0.0.3', :web, :app, private_ip: '192.168.0.2'
server '10.0.0.4', :web, :app, private_ip: '192.168.0.3'
server '10.0.0.5', :db, no_release: true, primary: true
set :port, 20022
set :server_name, 'your.domain.com'
set :branch, 'production'
```

``` ruby
# lib/linode_api.rb
class LinodeApi
  require 'linode'
  LINODE_API_KEY =  ENV['LINODE_API_KEY']
  def initialize
    @l = Linode.new(api_key: LINODE_API_KEY)
  end

  def first_nodebalancer_id_with_label(label)
    @l.nodebalancer.list.select{|n| n.label == label}.first.nodebalancerid
  end

  def first_config_id_with_label(label)
    nodebalancer_id = first_nodebalancer_id_with_label(label)
    @l.nodebalancer.config.list(:NODEBALANCERID => nodebalancer_id).first.configid
  end

  def first_node_id_with_label_and_address(label, address)
    config_id = first_config_id_with_label(label)
    @l.nodebalancer.node.list(:ConfigID => config_id).select{|n| n.address == address}.first.nodeid
  end

  def reject_connections_from_node_with_label_and_address(label, address)
    node_id = first_node_id_with_label_and_address(label, address)
    @l.nodebalancer.node.update(:NodeID => node_id, :Mode => 'reject')
  end

  def accept_connections_from_node_with_label_and_address(label, address)
    node_id = first_node_id_with_label_and_address(label, address)
    @l.nodebalancer.node.update(:NodeID => node_id, :Mode => 'accept')
  end
end
```

``` ruby
# Gemfile
group :development do
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'linode'
end
```

* [https://www.linode.com/api/nodebalancer](https://www.linode.com/api/nodebalancer) - documentation for the linode nodebalancer api
* [https://github.com/rick/linode](https://github.com/rick/linode) - linode gem that wraps the linode api

The default [capistrano deploy:restart](http://capitate.rubyforge.org/recipes/deploy.html#deploy:restart) recipe is a [blank task](https://github.com/capistrano/capistrano/blob/master/lib/capistrano/recipes/deploy.rb#L357) that you have to override depending on your application server's needs. For example, Passenger users would need to `touch tmp/restart.txt` and in my case, I have a custom `init.d` script that I can call to restart my application.

Let's walk through the deployment recipe.

``` ruby
if self.roles[:app].count == 1
  run "/etc/init.d/rainbows_#{application} restart"
```

The `self.roles` hash contains the different [roles](http://stackoverflow.com/questions/1155218/what-exactly-is-a-role-in-capistrano) you have defined in your deployment file. In this case, we're only interested in the `:app` role (i.e. we want to limit our script to only the servers we tagged as having `:app` role).

In this case, if there is only one `:app` defined (which usually is the case -- as in mine -- for staging servers) it makes no sense to do a rolling restarts since there is nothing to roll. There will be downtime when the single server restarts, so we might as well optimize this usecase away by calling the restart script directly.

Note that this line: `run "/etc/init.d/rainbows_#{application} restart"` when called by itself with no arguments will cause the task to run in parallel.

How do you know if a task is being run in parallel? Take a look at your deployment logs:
```
tristan (master)$ cap production deploy
  * 2013-06-01 15:31:48 executing `production'
    triggering start callbacks for `deploy'
  * 2013-06-01 15:31:48 executing `multistage:ensure'
  * 2013-06-01 15:31:48 executing `deploy'
  * 2013-06-01 15:31:48 executing `deploy:update'
 ** transaction: start
  * 2013-06-01 15:31:48 executing `deploy:update_code'
    triggering before callbacks for `deploy:update_code'
  * 2013-06-01 15:31:48 executing `sidekiq:quiet'
  * executing multiple commands in parallel
```
Capistrano will inform you that it will be executing the task in parallel (in this case, the task is `sidekiq:quiet`)

In order to deploy in serial, we have to loop through the hosts:

```ruby
else
  self.roles[:app].each do |host|
    # execute a rolling restart
    address = "#{host.options[:private_ip]}:80"
    label = 'OathkeeperTest'
    api = LinodeApi.new

    puts "rejecting connections for #{address}"
    api.reject_connections_from_node_with_label_and_address(label, address)

    puts "performing restart"
    run "/etc/init.d/rainbows_#{application} restart", hosts: host

    puts "accepting connections for #{address}"
    api.accept_connections_from_node_with_label_and_address(label, address)

    puts "sleeping for 90 seconds to allow for status propagation"
    sleep(90)
  end
end
```

We'll get back to the `address` and `label` variables later when we discuss the linode api. For now, all we need to know is that the api can update the nodebalancer configuration to reject and accept connections.

Our deployment pattern then looks like this:

`reject` `->` `restart` `->` `accept` `->` `sleep`

Then it goes on to the next server for the same cycle. This allows us to maintain application availability: before the app goes down to restart, the node balancer stops accepting connections, then will start accepting connections again after a restart. Due to the way the Linode Nodebalancer system works, updating the node to accept doesn't begin accepting connections from users until it can verify that the host is up and able to process requests.

You might notice that in the server definitions I've added the option `private_ip`. When defining a host, you are able to add custom options that can be later be retrieved. That's what we are doing in this line:

``` ruby
address = "#{host.options[:private_ip]}:80"
```

Why do I need to pass in the private IP of the host? This is because in the linode api, there is no real connection between the concept of a server and an address a nodebalancer points to.

Hence, we have to go in a rather round-about way to figure out which node to modify to reject/accept connections. The most reliable way I've found is to use the configuration label and the private IP address to locate the node configuration.

You're going to need your linode api key that can be generated in your Linode [My Profile](https://manager.linode.com/profile/) page. Here we set it as an environment variable as a security measure. We also use the `linode` gem to make requests to the linode api. Lastly, we wrap the whole thing into a simple object to abstract out the nittygritty of dealing with the api.

The meat of this wrapper object is contained in these methods:
``` ruby
def reject_connections_from_node_with_label_and_address(label, address)
  node_id = first_node_id_with_label_and_address(label, address)
  @l.nodebalancer.node.update(:NodeID => node_id, :Mode => 'reject')
end

def accept_connections_from_node_with_label_and_address(label, address)
  node_id = first_node_id_with_label_and_address(label, address)
  @l.nodebalancer.node.update(:NodeID => node_id, :Mode => 'accept')
end
```

Given a label and an address, they will hunt down the nodebalancer configuration that matches those parameters and update it to reject or accept connections.
