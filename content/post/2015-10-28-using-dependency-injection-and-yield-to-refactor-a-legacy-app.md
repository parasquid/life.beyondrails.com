---
categories: [til, rails, refactoring, dependency injection]
date: 2015-10-28
keywords: []
title: Using Dependency Injection and `yield` to Refactor a Legacy App
---
I had to create an automated report for finance and accounting that will send particular columns and their data in a csv once a month.

Being the [lazy][1] developer that I am, I tried looking for code that already existed. I was planning to wrap up that code in a rake task and use [whenever](https://github.com/javan/whenever) to schedule a cron job to send the report monthly.

While I was able to find pre-existing code that did what finance wanted (I checked with them as well if the output showed what they needed), the code itself wasn't easily convertible to a rake task.

<!-- more -->

### Original Code

Let me show you what I mean. Here is the original code (with redactions):

``` ruby
class EmailJob::Accounting < BaseJob
  include SuckerPunch::Job

  def perform(payments, email)
    filename = "/tmp/accounting_report_#{Time.now.to_i}.csv"

    SuckerPunch.logger.info "#{self.class}: Compiling accounting report..."

    CSV.open filename, 'w' do |csv|
      csv << %w(email first_name last_name order_date order_datetime order_number order_line_state tags
      payment_amount payment_state payment_date ... ) do |payment|

# ...

      rescue Exception => e
        SuckerPunch.logger.info "#{self.class}: Payment id #{payment.id} crashed with error #{e.inspect}"
      end

      row = [

# ...

      ]
      csv << row

# ...

    end

    SuckerPunch.logger.info "#{self.class}: Report compiled, will upload and email it"
    email(email, "accounting report", File.open(filename))
  end
 end
```

There are a couple of things that make it quite difficult to reuse this method:

* There is a dependence on the `SuckerPunch` class name (mostly used for the logger), which may be great on a worker context but does not make sense in a rake task.
* It tries to do many things at once: create the report, save it to a file, and email someone with the attachment.

Like many legacy applications, this is already used in production so there really isn't much leeway to refactor the method. However, using [Dependency Injection][2] and ruby's [keyword arguments][3], we can easily add on to the method without changing its apparent signature to old clients.

### Injecting a logger

First, we need to take care of the logger.

``` ruby
# original
def perform(payments, email)
  # ...
  SuckerPunch.logger.info "#{self.class}: Compiling accounting report..."
  # ...
end

# refactored
def perform(payments, email_address, log: SuckerPunch)
  # ...
  log.logger.info "#{self.class}: Compiling accounting report..."
  # ...
end
```

You'll notice that I've changed a few things:

* I used a keyword argument `log` and assigned it a default value of SuckerPunch.
* I replaced all occurrences of `SuckerPunch` with `log`
* I changed one of the parameter names from `email` to `email_address`. This isn't fully related to the refactoring of the logger object, but since I was already changing the method definition, I might as well make the var names more intention-revealing and less confusing.

By using a keyword argument that has a default value, the refactored method is functionally equivalent to the original method. Older clients expecting to call the method without having to change their call signatures.

Of course, it would have also been alright to not rely on a keyword argument and instead just put a positional argument that is assigned a default value. However, I felt that having three positional arguments (with one of them optional) was a bit too confusing. Having a keyword argument for the optional parameter reveals my intention that:

* I'm passing an object that has a logger (I use `Rails` for my rake task)
* This parameter is optional since it looks different from the first two parameters.

There are also multiple reasons why keywork arguments are better. Here's a [video of Jim Weirich][4] talking about the concept of `connascence`. I highly recommend you to watch this; it helped me a lot in putting a finger and naming a concept that I knew was there but couldn't quite grasp nor explain.

### Yielding to a block

One of my favorite ways to "open up" a method for reuse is to yield to an optional block.

``` ruby
yield(payment, count) if block_given?
```

If you need a refresher on ruby blocks and blocks, see an old [post][5] of mine.

By yielding to an optional block, I can do stuff like use a [progress bar][6]:

``` ruby
progress = ProgressBar.create(
  title: 'Payments',
  total: nil,
  format: '%a |%b>>%i| %p%% %t %c of %C %e'
)

EmailJob::Accounting.new.perform do |payment, count|
  progress.total = count
  progress.increment
end
```

Or, during debugging I can also try and inspect each of the payment being interated on:

``` ruby
EmailJob::Accounting.new.perform do |payment, count|
  Rails.logger.debug { "#{payment.inspect} out of #{count} items" }
end
```

All of this done without even touching the original object. As Sandi Metz has said:

> Don't write code that guesses the future, arrange code so you can adapt to the future when it arrives.

> -- <cite>[Sandi Metz (@sandimetz)][7]

In other words, there is no need to load up your objects with functionality that you think will be used, but most likely won't. Instead, write small objects that are flexible and composable such that when a new requirement comes a long, the code you've written can be easily adaptable to the situation. Ruby blocks are a great way to "open up" an object to make them easier to accommodate feature additions or changes.

### If it ain't broke, don't fix it (yet)

Of course, there are even better ways to refactor this method. You can extract out the reporting logic and build an assembler class that takes an input (`payments`) an output (an `email` object) and the logic to create the contents (the reprot generator than can maybe output an `IO` object or something that responds to `result).

However, as I've mentioned before this is a legacy app. This piece of code had been running in production for quite some time now without any problems. This is one of the very rare times when finance asks for a change in the running reports, and it's not even a change in logic -- merely an additional way the results are delivered (regular intervals vs on-demand).

Even though there are some tests that cover this method, it's not very comprehensive. We have very limited resources in my current team and we don't really have time (nor the business need) to do a full refactor (yet).

I'm not advocating to do hackjobs or cowboy code. However, these two small changes are all it takes to make the method flexible enough to finish a (relatively simple) feature, and there is a business decision to be made here. Some recommend to [refactor until it doesn't hurt anymore][8] and then move on to the next feature; I subscribe to this idea.

My personal preference is that of the rule of second encounters: the first time you need to reference badly written or inflexible code, refactor it just enough so it's usable (in the hopes that you don't have to deal with it again). However, the second time you need to reference the same code, do the refactor because it is more likely that you'll need to reference the same code again in the future -- it's already happened once, it can happen again.

### Final form

Here is the refactored code, as well as the code that calls it:

``` ruby
class EmailJob::Accounting < BaseJob
  include SuckerPunch::Job

  def perform(payments, email_address=nil,
    log: SuckerPunch,
    filename: "/tmp/accounting_report_#{Time.now.to_i}.csv
  )

    log.logger.info "#{self.class}: Compiling accounting report..."

    CSV.open filename, 'w' do |csv|
      csv << %w(email first_name last_name order_date order_datetime order_number order_line_state tags
      payment_amount payment_state payment_date ... ) do |payment|

# ...

      rescue Exception => e
        log.logger.info "#{self.class}: Payment id #{payment.id} crashed with error #{e.inspect}"
      end

      row = [

# ...

      ]
      csv << row

      yield(payment, count) if block_given?

# ...

    end

    log.logger.info "#{self.class}: Report compiled, will upload and email it"
    email(email_address, "accounting report", File.open(filename)) if email_address
  end
end
```

``` ruby
payments = PaymentsQuery.all.includes(:order => [:customer, :tags])
count = payments.count

progress = ProgressBar.create(
 title: 'Payment',
 total: nil,
 format: '%a |%b>>%i| %p%% %t %c of %C %e'
)

filename = "report.csv"
EmailJob::Accounting.new.perform(payments, logger: Rails, filename: filename) do |payment, count|
  progress.total = count
  progress.increment
end
progress.finish

uploader = Upcloudify::S3.new
uploader.email(["parasquid""], filename, File.open(filename))
```

Not much has changed, but their flexibility is worlds apart, and it makes all the difference.

[1]:http://threevirtues.com/
[2]:http://www.martinfowler.com/articles/injection.html
[3]:https://bugs.ruby-lang.org/issues/5474
[4]:https://www.youtube.com/watch?v=HQXVKHoUQxY
[5]:{{< relref "2014-03-04-ruby-and-blocks.markdown" >}}
[6]:https://github.com/jfelchner/ruby-progressbar
[7]:https://twitter.com/sandimetz/status/441241600077725697
[8]:http://c2.com/cgi/wiki?WhenToStopRefactoring
