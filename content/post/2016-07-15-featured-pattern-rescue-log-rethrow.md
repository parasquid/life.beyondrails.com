---
categories: [featured, pattern]
date: 2016-07-15T15:16:02+08:00
title: "Featured Pattern: Rescue, Log, Rethrow"
---

Whenever you use a method that you know might throw an exception but shouldn't, the rescue-log-rethrow pattern is useful to figure out what happened while preserving the contracts implied in the code.
<!--more-->

For example, we were recently investigating a payload from our ecommerce provider that is throwing a `KeyError` exception. Official documentation doesn't provide any information about this, so we had to break out the debugger's favorite tool: the logger.

Here's the original method:

``` ruby
def initialize(account_id, api_response)
  @account_id = account_id
  @signature = api_response.fetch("signature")
  @token = api_response.fetch("token")
  @key = api_response.fetch("key")
end
```

For some reason we were getting a 500 error and looking at the available logs:

```
status=500 error='KeyError: key not found: "signature"'
```

Here's the `rescue-log-rethrow` pattern in action:

``` ruby
def initialize(account_id, api_response)
  @account_id = account_id,
  begin
    @signature = api_response.fetch("signature")
    @token = api_response.fetch("token")
    @key = api_response.fetch("key")
  rescue KeyError => e
    logger.error "response does not have the required key: #{response.inspect}"
    raise e
  end
end
```

In the end we found out that one of the environment variables necessary for connecting to the ecommerce platform was misconfigured and had to be properly set.

Rethrowing the exception is important, because the original intention of the code was to enforce the contract that none of these keys should be `nil` (hence the `#fetch` method).

Never swallow exceptions! Yes, even if you're logging them anyway. If the exception wasn't rethrown, it is possible that a response missing one of the necessary keys will trigger the rescue block and log the message. However, the object now has an undefined state. An object with an undefined state is a recipe for long hours debugging and trying to figure out where the bug might be hiding.

Immediately rethrowing the exception after logging allows you to keep the context of the exception closer to its origin. This makes it so much easier to trace where the possible bug might have come from.
