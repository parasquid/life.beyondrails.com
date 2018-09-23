---
date: 2014-08-19
title: Getting Data From a Join Table in Rails
---

A friend asked in my [Ruby Facebook group](https://www.facebook.com/groups/klxrb) about a [problem](https://www.facebook.com/groups/klxrb/permalink/515838138548150/) he was having that I feel I've encountered before (or will be encountering in the future). It's about having to retrieve data that is associated with a join table.

Here's the question:

> I have set ActiveRecords models like these

{{% gist id="87abbf74e8020ca7e95c" %}}

> I want to do something like current_user.boards.first.role which I expect to load the membership details of current_user AND the first board. Do you have any idea how can I achieve this? Do you suggest another approach?

<!--more-->

In other words, he wants to be able to get at the `current_user`'s boards and retrieve the role assigned to the first board.

At first it was a bit difficult to search google for the corrent keywords, but there's [StackOverflow](http://stackoverflow.com/a/8874831) to the rescue. There needs to be a custom SQL select query to expose the role_mask attribute of the join table

I felt that it was a very interesting question, so I made a sample app for him to show the technique. It can be found here: https://github.com/parasquid/reach-into-habtm-example/

For the lazy and impatient:

``` ruby
# app/models/user.rb
class User < ActiveRecord::Base
  has_many :memberships
  has_many :boards, through: :memberships, :select => 'memberships.role_mask as role_mask'
end
```

``` ruby
# spec/models/membership_spec.rb
require 'spec_helper'

MAX_USERS = 2
MAX_BOARDS = 5

describe Membership do
  context 'access through a user instance' do
    before :each do
      1.upto MAX_USERS do
        User.create
      end

      1.upto MAX_BOARDS do
        Board.create
      end

      # associate two boards to the first user
      user1 = User.first
      user1.memberships.create(role_mask: 1, board: Board.first)
      user1.memberships.create(role_mask: 4, board: Board.last)

      # associate two boards to the second user in reverse order
      user2 = User.last
      user2.memberships.create(role_mask: 4, board: Board.first)
      user2.memberships.create(role_mask: 1, board: Board.last)
    end

    context 'first user' do
      let(:current_user) { User.first }

      it 'returns the current user\'s board\'s membership role' do
        expect(current_user.boards.first.role).to eq :admin
        expect(current_user.boards.last.role).to eq :member
      end
    end

    context 'second user' do
      let(:current_user) { User.last }

      it 'returns the current user\'s board\'s membership role' do
        expect(current_user.boards.first.role).to eq :member
        expect(current_user.boards.last.role).to eq :admin
      end
    end

  end
end
```

And of course, as Milad's comment (and the StackOverflow guy) says, the `:select` hash is already deprecated in Rails 4 and you'd need to do use a lambda instead:

``` ruby
has_many :boards,
         -> { select 'boards.*, memberships.role_mask as role_mask'},
         :through => :memberships
```
