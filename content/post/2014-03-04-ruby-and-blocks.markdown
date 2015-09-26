---
title: "Ruby and Blocks"
date: 2014-03-04
categories: [ruby, basics]
---

One of the most often used and ironically least understood concepts in the Ruby programming language is the block. If you've used one of the Enumerable mixed-in objects, you've encountered the block syntax.

<!--more-->

For example:

``` ruby
array = [1, 2, 3, 4, 5]

# returns all the odd numbers of the array
array.delete_if { |e| e.even? }

#  => [1, 3, 5]
```

Or the more common:

``` ruby
array = [1, 2, 3, 4, 5]

# prints out all of the array's elements
array.each do |element|
  puts element
end

# 1
# 2
# 3
# 4
# 5
#  => [1, 2, 3, 4, 5]    
```

Ruby blocks also enable a lot of the functional programming DSL such as:

``` ruby
array = [1, 2, 3, 4, 5]

# returns the sum of the squares of each element of the array
array.map { |e| e ** 2 }.reduce(:+)

#  => 55
```

Robert Sosinski has written a really awesome [tutorial](http://www.robertsosinski.com/2008/12/21/understanding-ruby-blocks-procs-and-lambdas/) about ruby blocks and I'm encouraging you to go through it.

All of these however are just skimming over the power of blocks. Sure, they're good for eye candy -- we won't be able to use such an elegant looping syntax without the use of blocks, but it's not just another way to loop over a collection!

In fact, blocks (and its related concepts Procs and lambdas) enable a very important programming concept: [loose coupling.](http://en.wikipedia.org/wiki/Loose_coupling) For instance, suppose you do:

``` ruby
def print_name
  puts "Hello there. I've got your name:"
  yield
end

print_name do
  puts "Tristan"
end

# Hello there. I've got your name:
# Tristan
#  => nil
```

I could just have as easily done this:

``` ruby
def print_name(name)
  puts "Hello there. I've got your name:"
  puts name
end

print_name("Tristan")

# Hello there. I've got your name:
# Tristan
#  => nil
```

Which does exactly the same thing.

Well not exactly, because with the second example, the method explicitly defined that the name be printed out to STDOUT whereas in the first example, I could have done:

``` ruby
print_name do
  File.open(local_filename, 'w') {|f| f.write(name) }
end
```

Which writes the name into a file. I could have just as easily logged it using `Rails.logger`, or sent it over a TCP Socket, or save it in a database entry (granted `print_name` is a bad method name for this purpose, but hey -- with great power comes great responsibility).

Rob Sobers had an epiphany that many people seeking to understand blocks have had. As mentioned in Rob's [article](http://robsobers.com/struggle-ruby-blocks/), you are an active participant in the method you're calling. The method is basically doing a cop-out and telling you "hey, I'm gonna do this and this but I'm giving you the option to also do something else while I'm doing that (which I heavily encourage you to do so because you're actually doing the heavy lifting)"

This allows you to be quite flexible when you're writing reusable code or libraries, of which you don't really know (or care) what the client code would do. That's the case for the [Snoopka Gem](https://github.com/parasquid/snoopka) I wrote, which does the work of connecting to a Kafka stream but defers the processing of the messages to client code.

``` ruby
puts 'Starting the Kafka listener'

listener = Snoopka::Listener.new host: "localhost", port: 9092

handler = Handler.new
listener.add_observer 'test', &handler
# or alternatively you can also do
#
# listener.add_observer 'test' do |message|
#   puts "your handler code here"
#   puts message
# end

loop do
  listener.consume
end
```

Here is another neat way to use blocks in your code. Have you ever written a migration script or Rakefile and you wanted to know how long it will take at a particular point in time? There's this gem called [ProgressBar](https://github.com/jfelchner/ruby-progressbar) that does exactly that. I'll show you how to make your task so that it will pipe in information to ProgressBar in order for it to display cool stuff.

This code is, by the way, lifted from production code (of course the implementation details have been mocked out; tangentially, the ability to mock things out is one side-effect of good programming design, but that's a topic for another day):

``` ruby
# tasks/migration.rb
module Tasks
  class Migration
    def self.migrate_all(offset=0,limit=(Tasks::Lead.count - offset))
      Tasks::Lead.offsetted_entries.each do |lead|
        migrate_lead(lead)
        yield lead if block_given?
      end
    end

    def self.migrate_lead(m_lead)
      # mocked response
      # originally copied over the lead from MongoDB to Postgres
      sleep(rand(1..200)/100)
    end
  end
end
```

``` ruby
# tasks/lead.rb
module Tasks
  class Lead
    def self.count
      offsetted_entries.count
    end

    def self.offsetted_entries(skip=0, offset=0)
      # mocked response
      # originally returns leads from the database with a particular
      # skip and offset
      return 1..100
    end
  end
end
```

``` ruby
# Rakefile
namespace :migrations do
  desc 'migrate entries from old mongodb database to postgresql'
  task :migrate_from_mongodb_to_postgres => :environment do
    progress = ProgressBar.create title: 'Leads',
      total: Tasks::Lead.count,
      :format => '%a |%b>>%i| %p%% %t %c of %C %e'
      
    Tasks::Migration.migrate_all { progress.increment }

    progress.finish
  end
end
```

You can also get this code from [github](https://github.com/mindvalley/code_kata).

Blocks are Ruby constructs that provide a very clean and elegant way to provide flexibility to your code. Do you have any other ideas on how to improve your code using blocks?

-------

### Updates ###

I presented this topic to the KL Ruby Brigade meetup in Kuala Lumpur, Malaysia. There have been a few questions after the presentation and I'll try to address them here:

> Q: What's the difference between a block and a Proc?

> A: I think [Robert](http://www.robertsosinski.com/2008/12/21/understanding-ruby-blocks-procs-and-lambdas/) will explain this a lot more comprehensively. In a nutshell: a block and a Proc are conceptually similar but a Proc gives you a handle that allows you to reuse the block later on, whereas a block is similar to an anonymous function in Java or C# (you define them inline and you can't refer to them again later on).

<br />

> Q: What's the difference between the `{}` syntax and the `do...end` syntax?

> A: This has bitten me and many of my colleagues, and the answer has to do with binding precedence. This [Stackoverflow answer](http://stackoverflow.com/a/5587399) can give you more details. In a nutshell, the `{}` syntax binds strongly; that means without parentheses it will bind to the last parameter (in a multi-parameter method) whereas the `do...end` syntax will always bind to the invocation.

----------------

### Further Reading ###

 * http://www.robertsosinski.com/2008/12/21/understanding-ruby-blocks-procs-and-lambdas/
 * http://stackoverflow.com/questions/4911353/best-explanation-of-ruby-blocks
 * http://en.wikipedia.org/wiki/Loose_coupling
 * http://robsobers.com/struggle-ruby-blocks/
 * https://github.com/jfelchner/ruby-progressbar
 * https://github.com/mindvalley/code_kata
 * https://github.com/parasquid/snoopka
 * http://stackoverflow.com/a/5587399