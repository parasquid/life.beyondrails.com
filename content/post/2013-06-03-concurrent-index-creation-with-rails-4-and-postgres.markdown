---
title: "Concurrent Index Creation with Rails 4 and Postgres"
date: 2013-06-03
category: devops
draft: true
---

$ RAILS_ENV=production rake db:migrate
==  AddCreatedAtIndexToSignups: migrating =====================================
-- add_index(:signups, :created_at, {:algorithm=>:concurrently})

http://reefpoints.dockyard.com/ruby/2013/03/26/concurrent-indexes-in-postgresql-for-rails-4-and-postgres_ext.html

https://github.com/rails/rails/pull/9923

class AddCreatedAtIndexToSignups < ActiveRecord::Migration
  self.disable_ddl_transaction!
  def change
    add_index :signups, :created_at, algorithm: :concurrently
    add_index :leads, :created_at, algorithm: :concurrently
  end
end

http://postgresguide.com/performance/indexes.html








http://ilikestuffblog.com/2012/09/21/establishing-a-connection-to-a-non-default-database-in-rails-3-2-2/