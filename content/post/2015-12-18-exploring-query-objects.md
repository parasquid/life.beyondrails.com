---
date: 2015-12-18
title: Exploring Query Objects
categories: [til]
---
A [CodeClimate Article](http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/) gave a number of ways to decompose fat ActiveRecord models, and one of them was: Extract Query Objects. I've been trying to explore and get myself familiar with a good standard of how to implement Qeuery Objects, and here is my take.

I'll be trying out a new format in these articles. I'll be using something of a Q/A style similar to [Socratic Questioning](https://en.wikipedia.org/wiki/Socratic_questioning)

<!--more-->

Here is one of the Query Objects I have in one of my production apps:

```ruby
module Subscription
  module Calculations
    class OrderLineQueries
      extend Forwardable

      def_delegators :relation, :map, :count, :to_sql

      def initialize(relation = OrderLine.all)
        @relation = relation
      end

      def is_cancelled
        @relation = @relation.
          where('order_lines.cancelled_at is not null')
        self
      end

      def non_test_order_lines
        @relation = @relation.
          joins(:order).
            where(
              orders: {
                test_transaction: false
              }
            )
        self
      end

      def non_tax_payments
        @relation = @relation.
          joins(:order_line_transactions => :payment).
          joins("LEFT OUTER JOIN tax_payments on payments.id = tax_payments.payment_id").
            where("tax_payments.payment_id IS NULL").
            distinct
        self
      end

      def created_before_reporting_range(time_range: nil)
        raise ArgumentError, "time_range is required" unless !!time_range
        @relation = @relation.
          where(
            'order_lines.created_at <= ?', time_range.start_time
          )
        self
      end
    end
  end
end
```

Why are you returning `self`? It looks very strange.
: I'm returning `self` to allow method chaining. It is similar to [Fluent Interfaces](http://martinfowler.com/bliki/FluentInterface.html) but with a very tight focus on query building.

Since you're returning self, that means you're mutating the object when you're chaining the methods. That means the object can't be reused to create a different query, and you'll need to start with a new object, right?
: Yes, that is correct. It was a common mistake for me in the past to do something like this:

```ruby
# NOTE: DON'T DO THIS
class OrderReporter
  def initialize
    @query = OrderLineQueries.new
  end

  def cancelled
    @query.non_test_order_lines.is_cancelled
  end

  def test_orders_before_december_31_2015
    @query.created_before_reporting_range(time_range: time_range.new("<= Dec 31 2015"))
  end
end
```

: It took some time to figure out that since I've been sharing `@query` with two methods, `#cancelled` is actually modifying the query object such that `#test_orders_before_december_31_2015` won't ever have test order lines in its resultset.

: Furthermore, the **individual unit tests** for these methods are _green_; the only way to expose the bug was to have **both methods** called in a single test example. You can imagine how frustrating the debugging must have been.

: That's a caveat that you'll need to remember when using self-mutating objects like these.

: I did have an experiment where each method is immutable:

```ruby
def paid(relation = Payment.all)
  relation.
    where("payments.state = ?", "paid")
end

def paid_or_refunded(relation = Payment.all)
  relation.
    where("payments.state" => %w(paid refunded))
end

def non_declined(relation = Payment.all)
  relation.
    where("payments.state != ?", "declined")
end

def non_shipping(relation = Payment.all)
  relation.
    where("payments.reference_number NOT LIKE ?", "-shipping")
end
```
: and you'd do a `golang`-like composition when filtering the query:
```ruby
def report
  query = paid
  query = non_declined(query)
  query = non_shipping(query)
  query
end
```

: or something like:
```ruby
def report
  paid(non_declined(non_shipping))
end
```

: but I never really got around to exploring this further (too many parentheses!!!) as the fluent interface looked so much nicer:
```ruby
def report
  paid.
    non_declined.
    non_shipping
end
```

What's up with `Forwardable`? If you want to call `ActiveRelation` methods on the query object, why not just expose something like `#relation` then you can call it with something like `query.is_cancelled.relation.to_sql`
: I did expose the internal `@relation` object before to do exactly what you are suggesting, and it was all good for a while. Then something really terrible happened. I haven't been working on the project for sometime so I wasn't able to do much code review, and I was a bit aghast when I saw these:

```ruby
query = ProductLinesQuery.new
product_lines_with_paypal = query.with_paypal_or_paypal_express
  .with_english_currency
  .with_english_language
  .relation.where(id: product_lines_id)  # wtf ...
```

: I felt it was an abuse of the exposed `relation` attribute beause it completely undermines the point of the query object (which was to encapsulate queries). Using `Forwardable` I can delegate specific methods to the internal `ActiveRelation` object without having to expose the whole `ActiveRecord` [API footprint](http://tenderlovemaking.com/2014/06/02/yagni-methods-are-killing-me.html).

I see a lot of modules. Where do you put these query objects?
: I used to put them in a folder named `app/queries` but as the application grew (and the number of query objects also grew) I realized this isn't the best way to organize the files. Now I put them just beside the files that use them.

```
app
 ├─ controllers
 └─ models
     ├─ subscription
     │   ├─ calculations
     │   │   ├─ customers.rb
     │   │   └─ order_line_queries.rb
     │   └─ calculators
     └─ cohort
```

Hm, so you mean you have multiple folders of query objects? Isn't that confusing? If you put them all in just one folder, then you know that all your queries are in one place.
: On the contrary, putting the query object near the calling file makes it a lot lss confusing. When I look at a folder structure, I know exactly what queries this particular object needs.

How about code reuse? Since you're spreading all your query objects around, you'll eventually have to duplicate code that does the same thing.
: Surprisingly there are very few generic queries that I need to duplicate, because each of the querying logic I need are very specific to the task. However, there are indeed a few queries that are more used than others. I usually have them included as a module in the query object.

What's up with the separate `customers.rb`?
: Oh that? I prefer my query objects to focus on **composable** methods, while separating out another object that **composes** these queries. It looks something like this:

```ruby
module Subscription
  module Calculations
    class Customers
      def initialize(start_date, end_date, bundle: nil)
        @time_query = TimeQuery.new(start_date, end_date)
        @bundle = bundle
      end

      def beginning
        Calculations::OrderLineQueries.new.
          non_test_order_lines.
          money_received.
          specific_bundle(ids: @bundle.id).
          created_before_reporting_range(time_query: @time_query).
          not_cancelled_or_cancelled_after_reporting_range(time_query: @time_query)
      end

      def second_payment
        Calculations::OrderLineQueries.new.
          non_test_order_lines.
          money_received.
          specific_bundle(ids: @bundle.id).
          trial.

          paid_payments.
          non_tax_payments.
          non_shipping_payments.

          created_before_reporting_range(time_query: @time_query).
          created_after_30_days_before_reporting_range(time_query: @time_query).
          not_cancelled_or_cancelled_after_reporting_range(time_query: @time_query).
          more_than_one_payment
      end

      def new_in_reporting_range
        Calculations::OrderLineQueries.new.
          non_test_order_lines.
          money_received.
          specific_bundle(ids: @bundle.id).
          created_during_reporting_range(time_query: @time_query)
      end
    end
  end
end
```

: Then the calculators in the `calculators` folder use the methods in `customers.rb` to further compose a full report.

: Bonus: whenever the feature requester asks me "what exactly goes on with each of these columns" I just point her to the github page for this file. The fluent interface is one way for me to easily explain what goes into calculating an entry, without having to resort to a detailed explanation.

Why don't you just use scopes? They have almost the exact syntax that you're proposing, and it's built-in to Rails!
: Scopes are great when your project is still small, but eventually you'll end up with a lot of scopes in your model. The [Single Responsibility Principle](https://drive.google.com/file/d/0ByOwmqah_nuGNHEtcU5OekdDMkk/view) says that there should only be one reason for an object to change, and putting these type of queries into the model as scopes violates that principle. The change in how a tax payment is queried is different from the change in how tax payments are calculated.

: Even if I don't appeal to higher authority by mentioning SRP, separating the queries from the `ActiveRecord` model is still a good idea. It just makes the whole thing easier to work with because I don't have to scroll through a huge file with the scopes on the first half and the business logic on the second half.
<hr />

There you have it. I'm still exploring query objects and figuring out a more generlized solution that I can implement in all my projects. Feedback and comments are highly appreciated!