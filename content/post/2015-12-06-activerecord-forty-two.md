---
date: 2015-12-06
title: ActiveRecord and Forty Two
categories: [activerecord, til]
---
I was making a gem to have Google Spreadsheets as the backing store for an `ActiveRecord` adapter when I came upon this interesting method:

<!--more-->

```ruby
# Same as +first+ except returns only the fourth record.
def fourth(*args)
  @association.fourth(*args)
end

# Same as +first+ except returns only the fifth record.
def fifth(*args)
  @association.fifth(*args)
end

# Same as +first+ except returns only the forty second record.
# Also known as accessing "the reddit".
def forty_two(*args)
  @association.forty_two(*args)
end
```

Today I learned that `ActiveRecord` has methods first until fifth, and also forty_two.

It's even in the [documentation](https://github.com/rails/rails/blob/master/guides/source/active_support_core_extensions.md#extensions-to-array):

> The methods second, third, fourth, and fifth return the corresponding element (first is built-in). Thanks to social wisdom and positive constructiveness all around, forty_two is also available.

It seems to have been added by [jeremy](https://github.com/jeremy) on March 21, 2009 puportedly to "[Convert array extension modules to class reopens](https://github.com/rails/rails/commit/83fd1ae122cf1ee4ea2c52e0bd963462163516ca).