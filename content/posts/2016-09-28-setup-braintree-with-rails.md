---
date: 2016-09-28T09:16:23+08:00
title: Setup Braintree with Rails
---
Braintree has just recently released [v3 of their Javascript SDK](https://www.braintreepayments.com/blog/introducing-a-modernized-braintree-javascript-sdk/) offering [a lot of improvements](https://developers.braintreepayments.com/guides/client-sdk/migration/javascript/v3#why-upgrade-to-v3). Searching online for tutorials on how to integrate Braintree with Rails tend to show older articles, so I decided to write an updated one :)

<!--more-->
For the impatient:

* the code for this tutorial (rails 4.2) can be found on Github.
* a lot of the example code was from the official [Braintree developer's documentation](https://developers.braintreepayments.com/start/overview).

Assuming you have just created a new rails project, the first thing we want to do is to be able to show hosted fields in a page. We'll create a `HomeController` with a single action `index` and set it as the `root` route to make things simple.

``` bash
rails g controller Home index
```

``` ruby
# routes.rb
Rails.application.routes.draw do
  root to: "home#index"
end
```

We'll then create a simple form that adds placeholders for the credit card number, cvv, and expiration date, as well as a button to submit the form.

``` erb
<!-- views/home/index.html.erb -->
<% if flash[:notice] %>
  <div class="notice"><%= flash[:notice] %></div>
<% end %>

<div class="credit-card-form">
  <%= form_for :checkout_form, {}, html: { id: "checkout-form" } do |form| %>
    <div id="error-message"></div>

    <%= form.label :card_number, "Credit Card Number" %>
    <div class="hosted-field" id="card-number">
    </div>

    <%= form.label :cvv, "CVV" %>
    <div class="hosted-field" id="cvv">
    </div>

    <%= form.label :expiration_date, "Expiration Date" %>
    <div class="hosted-field" id="expiration-date">
    </div>

    <%= form.hidden_field "payment_method_nonce" %>
    <%= form.submit "Give me $10.00", disabled: true, class: "btn btn-primary" %>
    <div class="clearfix"></div>
  <% end %>
</div>
```

``` scss
// app/assets/stylesheets/home.scss
div.credit-card-form {
  margin-top: 1em;
  width: 300px;
  position: relative;
  left: 50%;
  margin-left: -150px;

  form {
    border: 1px solid #ddd;
    padding: 2em 1em 1.5em;
    font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
    background-color: whitesmoke;

    div.hosted-field {
      position: relative;
      border: 1px solid #ddd;
      height: 34pt;
      padding: 1em;
      background-color: white;
      margin-bottom: 2em;
    }

    input[type=submit] {
      margin-top: .5em;
      float: right;
    }

  }
}

.clearfix {
  clear: both;
  overflow: auto;
}
```
Here comes the fun part.

In order to create the Braintree client, you'd need to have a server-generated token. Right now we don't have one (as we still haven't touched the server side) so thankfully Braintree provided an example authorization token to use. This authorization token will only work to generate the hosted fields and cannot be used to create a transaction.

Later when we're setting up the server side of the app, we'll configure this so the authorization is not hardcoded but instead generated by the server's credentials.

``` javascript
// app/assets/javascripts/home.js
jQuery(document).ready(function() {
  var authorization = 'eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiIwNDE0ODJkZDgyY2ZjY2JlMzA3MTAzZDliMmNmYzU4ZmY1MDdlOTEzZWM3ZDU3YTRhODcwNTI2OTdjZWZjYmZkfGNyZWF0ZWRfYXQ9MjAxNi0wOS0yOFQwMToyMjo0MS44NDI4NDY3NDArMDAwMFx1MDAyNm1lcmNoYW50X2lkPTM0OHBrOWNnZjNiZ3l3MmJcdTAwMjZwdWJsaWNfa2V5PTJuMjQ3ZHY4OWJxOXZtcHIiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzLzM0OHBrOWNnZjNiZ3l3MmIvY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tLzM0OHBrOWNnZjNiZ3l3MmIifSwidGhyZWVEU2VjdXJlRW5hYmxlZCI6dHJ1ZSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjp0cnVlLCJtZXJjaGFudEFjY291bnRJZCI6ImFjbWV3aWRnZXRzbHRkc2FuZGJveCIsImN1cnJlbmN5SXNvQ29kZSI6IlVTRCJ9LCJjb2luYmFzZUVuYWJsZWQiOmZhbHNlLCJtZXJjaGFudElkIjoiMzQ4cGs5Y2dmM2JneXcyYiIsInZlbm1vIjoib2ZmIn0=';

    braintree.client.create({
      authorization: authorization
    }, braintreeClientCreateHandler);
  })
});
```
``` javascript
// app/assets/javascripts/braintree.js
let braintreeClientCreateHandler = function (clientErr, clientInstance) {
  if (clientErr) {
    alert(clientErr);
    console.log(clientErr);
    return;
  }

  braintree.hostedFields.create({
    client: clientInstance,
    styles: hostedFieldsStyle,
    fields: {
      number: {
        selector: '#card-number',
        placeholder: '4111 1111 1111 1111'
      },
      cvv: {
        selector: '#cvv',
        placeholder: '123'
      },
      expirationDate: {
        selector: '#expiration-date',
        placeholder: '10 / 2019'
      }
    }
  }, hostedFieldsHandler);

  let submit = document.querySelector('input[type="submit"]');
  submit.removeAttribute('disabled');

};

let hostedFieldsStyle = {
  'body,form,input': {
    'font-size': '14pt',
  },
  'input.invalid': {
    'color': 'red'
  },
  'input.valid': {
    'color': 'green'
  }
}

let hostedFieldsHandler = function (hostedFieldsErr, hostedFieldsInstance) {
  if (hostedFieldsErr) {
    // Handle error in Hosted Fields creation
    alert();
    return;
  }

  let form = document.querySelector('#checkout-form');
  form.addEventListener('submit', function (event) {
    event.preventDefault();

    hostedFieldsInstance.tokenize(function (tokenizeErr, payload) {
      if (tokenizeErr) {
        // Handle error in Hosted Fields tokenization
        alert(tokenizeErr.message);
        console.log(tokenizeErr);
        return;
      }

      // Put `payload.nonce` into the `payment-method-nonce` input, and then
      // submit the form. Alternatively, you could send the nonce to your server
      // with AJAX.
      document.querySelector('input[name="checkout_form[payment_method_nonce]"]').value = payload.nonce;
      form.submit();
    });
  }, false);
};
```
Install braintree gem
rails g controller braintree client_token checkout

``` ruby
class BraintreeController < ApplicationController
  def client_token
    client_token = Braintree::ClientToken.generate
    render json: {client_token: client_token}
  end
end
```

Use ajax to retrieve the client_token

``` javascript
jQuery(document).ready(function() {
  var authorization;
  $.ajax({
    dataType: "json",
    url: "/braintree/client_token",
    success: function(data) {
      authorization = data.client_token;
      braintree.client.create({
        authorization: authorization
      }, braintreeClientCreateHandler);
    }
  })
});
```

parse the nonce from the client and create a transaction in braintree

``` ruby
  def checkout
    nonce_from_the_client = params[:checkout_form][:payment_method_nonce]
    result = Braintree::Transaction.sale(
      :amount => "10.00",
      :payment_method_nonce => nonce_from_the_client,
      :options => {
        :submit_for_settlement => true
      }
    )
    transaction = result.transaction
    logger.ap transaction

    redirect_to :root, flash: {notice: transaction && transaction.status}
  end
```