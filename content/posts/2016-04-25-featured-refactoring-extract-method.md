---
categories: [featured, refactoring]
date: 2016-04-25T13:55:34+08:00
title: "Featured Refactoring: Extract Method"
---

I work with [really awesome people who do really amazing work](http://www.mindvalley.com). I came upon this commit recently while I was reviewing a pull request, and I thought I'd share them with you.

Note that some of the information on the diff presented here has been redacted or removed, due to it being proprietary. But the full idea of the refactoring is present.
<!--more-->

Here's the diff:

``` diff
From: Wei Lih Loh <willie@mindvalley.com>
Date: Mon, 25 Apr 2016 11:34:01 +0800
Subject: [PATCH] better naming & break into smaller method

---
 app/support/apis/awesome_commerce.rb       | 39 ++++++++++++++--------------
 spec/support/apis/awesome_commerce_spec.rb | 41 ++++++++++++++++++++----------
 2 files changed, 47 insertions(+), 33 deletions(-)

diff --git a/app/support/apis/awesome_commerce.rb b/app/support/apis/awesome_commerce.rb
index 61be997..6ea162b 100644
--- a/app/support/apis/awesome_commerce.rb
+++ b/app/support/apis/awesome_commerce.rb
@@ -1,30 +1,16 @@
 module Apis
   class AwesomeCommerce

     def get_payment_history_from_email(email)
-      order_ids = get_order_ids_from_email(email)
       payments = []

-      order_ids.each do |order_id|
-        order = order(number: order_id)
+      order_numbers(email: email).each do |order_number|
+        order = order(number: order_number)

         payments += order['order_lines'].map do |order_line|
           next if order_line['state'] == 'migrated_to_zuora'
-
-          amount =  "#{order_line['amount_currency']}$"
-          amount += "#{(order_line['amount_paid'] / 100.0).round}"
-          date = order_line['created_at'].to_date.try(:strftime, '%e %b %Y')
-
-          {
-            amount:         amount,
-            payment_date:   date,
-            product_order:  order_id,
-            product_name:   order_line.dig('bundle', 'name'),
-            billing_method: nil, #todo no awc api for this yet
-            receipt_url:    nil  #todo no such feature in awc
-          }
+          summarize_order_line(order_number, order_line)
         end
       end
       payments
@@ -42,9 +28,24 @@ module Apis
       JSON.parse(payload.body)
     end

-    def get_order_ids_from_email(email)
+    def order_numbers(email:)
       payload = from_customer(email: email)
       payload['orders'].map { |order| order['number'] }
     end
+
+    def summarize_order_line(order_number, order_line)
+      amount =  "#{order_line['amount_currency']}$"
+      amount += "#{(order_line['amount_paid'] / 100.0).round}"
+      date = order_line['created_at'].to_date.try(:strftime, '%e %b %Y')
+
+      {
+        amount:         amount,
+        payment_date:   date,
+        product_order:  order_number,
+        product_name:   order_line.dig('bundle', 'name'),
+        billing_method: nil, #todo no awc api for this yet
+        receipt_url:    nil  #todo no such feature in awc
+      }
+    end
   end
 end
diff --git a/spec/support/apis/awesome_commerce_spec.rb b/spec/support/apis/awesome_commerce_spec.rb
index b663eed..16bb4c1 100644
--- a/spec/support/apis/awesome_commerce_spec.rb
+++ b/spec/support/apis/awesome_commerce_spec.rb
@@ -4,6 +4,8 @@ require 'active_support/core_ext/hash'

 describe Apis::AwesomeCommerce do
   Given(:klass) { Apis::AwesomeCommerce }
+  Given(:instance) { klass.new }
+  Given(:customer_email) { 'john@example.com' }
   before do
     stub_const('AWC_CLIENT',
       Faraday.new(url: 'redacted')
@@ -288,8 +290,6 @@ describe Apis::AwesomeCommerce do
   end

-  describe '#get_order_ids_from_email' do
-    Given(:instance) { klass.new }
-    Given(:customer_email) { 'john@example.com' }
-
+  describe '#order_numbers' do
     Given do
       allow_any_instance_of(klass).to(
         receive(:from_customer).with(email: customer_email)
@@ -337,15 +334,31 @@ describe Apis::AwesomeCommerce do
       )
     end

-    When(:result) { instance.send(:get_order_ids_from_email, customer_email) }
+    When(:result) { instance.send(:order_numbers, email: customer_email) }

     Then { result == ['redacted'] }
   end

+  describe '#summarize_order_line' do
+    Given(:order_number) { 'redacted' }
+    Given(:order_line) { JSON.parse(order_payload).dig('order_lines', 0) }
+    Given(:amount_paid) { (order_line['amount_paid'] / 100.0).round }
+
+    When(:payment_summary) do
+      instance.summarize_order_line(order_number, order_line)
+    end
+
+    Then { payment_summary[:amount] =~ /^#{order_line['amount_currency']}/ }
+    Then { payment_summary[:amount] =~ /#{amount_paid}$/ }
+    Then { payment_summary[:payment_date].to_date.kind_of? Date }
+    Then { payment_summary[:product_order] == order_number }
+    Then { payment_summary[:product_name] == order_line.dig('bundle', 'name') }
+    Then { payment_summary.keys.include?(:billing_method) }
+    Then { payment_summary.keys.include?(:receipt_url) }
+  end

```

There are a couple of things are going on here:

### Inline method (http://refactoring.com/catalog/inlineMethod.html)

Take a look at this section of the diff:

``` ruby
-      order_ids = get_order_ids_from_email(email)
       payments = []

-      order_ids.each do |order_id|
-        order = order(number: order_id)
+      order_numbers(email: email).each do |order_number|
+        order = order(number: order_number)
```

You can see that instead of creating a new variable to get order numbers from an email (which feels very procedural) he instead iterated over the results of the method call itself, as if it's just another variable.

When you have very descriptive method names, inlining like this can actually add to the expressiveness of your code.

### Extract method (http://refactoring.com/catalog/extractMethod.html)

In this case, the operations inside the loop were taken out of the loop and put in a seperate method. This makes the loop a lot clearer because at one glance we can see that it loops through order lines and generates an array of summarized order lines.

What makes it even cooler is that because he extracted out the method, he can test it separately--now that's a proper unit test.
