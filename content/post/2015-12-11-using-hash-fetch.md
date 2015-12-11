---
date: 2015-12-11
title: Using Hash Fetch
categories: [til]
---

I fat-finger my code **a lot** and produce a lot of typos. I do test driven development so it's not as bad, but what's annoying is when I typo a hash key and the test blows up with a failure due to a `nil` -- resulting in a very confusing error message.

<!--more-->


# The issue

One of my tests look like this:

```ruby
Given(:instance) { klass.new(payment: payment, signup: signup) }
context "payment data" do
  When(:line) { instance.payment_hash }
  Then { line[:amount] == 99.0 }
  Then { line[:shipment_address] == "999 papaya triangle windsor alabama 06040 united states" }
  Then { line[:bundle_ids] == "88 44" }
  Then { line[:bundle_names] == "test_bundle_88 test_bundle_44" }
  Then { line[:payment_id] == 859017 }
  Then { line[:payment_state] == "paid" }
  Then { line[:payment_date] == "2015-11-11" }
end
```

Can you see the typo?

I couldn't -- not immediately. At least, not until I saw the code implementation:

```ruby
def payment_hash
  {
    amount: @payment.amount,
    shipping_address: address_to_s(@payment.order.shipping_address),
    bundle_ids: @payment.order_lines.map {|o| o.bundle.id}.join(' '),
    bundle_names: @payment.order_lines.map {|o| o.bundle.name}.join(' '),
    payment_id: @payment.id,
    payment_state: @payment.state,
    payment_date: date_to_excel_string(@payment.created_at),
  }
end
```

Can you see it now?

# The soultion

I eventually figured out where the typo was, and was super annoyed that I changed all my hash key access for this test to `Hash#fetch`:

```ruby
Given(:instance) { klass.new(payment: payment, signup: signup) }
context "payment data" do
  When(:line) { instance.payment_hash }
  Then { line.fetch(:amount) == 99.0 }
  Then { line.fetch(:shipping_address) == "999 papaya triangle windsor alabama 06040 united states" }
  Then { line.fetch(:bundle_ids) == "88 44" }
  Then { line.fetch(:bundle_names) == "test_bundle_88 test_bundle_44" }
  Then { line.fetch(:payment_id) == 859017 }
  Then { line.fetch(:payment_state) == "paid" }
  Then { line.fetch(:payment_date) == "2015-11-11" }
end
```

`Hash#fetch` is way to get the value from a hash, given a hash key. It's very similar to `#[]` with some slight (and in this case, effective) differences.

From the [documentation](http://ruby-doc.org/core-2.2.0/Hash.html#method-i-fetch):

> `fetch(key [, default] ) → obj`

> `fetch(key) {| key | block } → obj`

> Returns a value from the hash for the given key. If the key can’t be found, there are several options: With no other arguments, it will raise an `KeyError` exception; if default is given, then that will be returned; if the optional code block is specified, then that will be run and its result returned.

```ruby
h = { "a" => 100, "b" => 200 }
h.fetch("a")                            #=> 100
h.fetch("z", "go fish")                 #=> "go fish"
h.fetch("z") { |el| "go fish, #{el}"}   #=> "go fish, z"
```

> The following example shows that an exception is raised if the key is not found and a default value is not supplied.

```ruby
h = { "a" => 100, "b" => 200 }
h.fetch("z")
```

> produces:

```ruby
prog.rb:2:in `fetch': key not found (KeyError)
 from prog.rb:2
 ```

 The last example is what I gain the most benefit from: it clarifies exactly where I went wrong. In the first code example I gave, the issue was I was using `shipment_address` instead of `shipping_address` and since they both **looked almost the same** I initially thought that the value was indeed `nil`.

 By using `Hash#fetch` I completely sidestep the problem of confusing error messages and get a clearer one that tells me the key I'm trying to access does not actually exist.

 # FAQ

 > You said you're doing TDD, bu I can see that the typo is in the middle of the test! If you're really doing TDD then you should have caught the bug at the last line!!

 It's true, I caught the bug at the last line (and catching the typo was a lot easier because I knew exactly where to look). You'll notice that the hash keys are alphabetically arranged; I moved the typo'd line in the middle as an artistic decision. As Mark Twain famously said: never let the truth get in the way of a good story. :P

 > How can this be used to avoid `&&` like this:

 ```ruby
hash = {foo:{bar: {baz: "hello world"}}}
puts hash[:foo][:bar][:baz] if hash[:foo] && hash[:foo][:bar]
```

You can use the `default` value option during the call:
```ruby
hash = {foo:{bar: {baz: "hello world"}}}
puts hash.fetch(:foo, {}).fetch(:bar, {}).fetch(:baz, nil)
```

Or, if you're using Ruby 2.3 you can use `Hash#dig`
```ruby
hash = {foo:{bar: {baz: "hello world"}}}
puts hash.dig(:foo, :bar, :baz)
```

If you're not yet using Ruby 2.3 (which is true at the time of this post's publication) then you can use a [gem](https://github.com/Invoca/ruby_dig) to add that method call.
