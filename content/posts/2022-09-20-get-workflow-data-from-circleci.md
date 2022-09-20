
---
title: "Get Workflow Data From CircleCI"
date: 2022-09-20
---

I needed to analyze some data regarding the costs of my client's current CI system, and CircleCI's insights dashboard--while itself is impressive--isn't quite up to task.

Sometimes you just need the plain old "spreadsheet analysis technique" to make progress.

Here's a quick ruby script I've written to get data from all the workflows for a particular project, and write them down into a csv for easy importation into a spreadsheet program.

<!--more-->

``` ruby
#!/usr/bin/env ruby

require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require 'csv'

def get_data(next_page_token)
  project_slug="gh/org/repo"
  all_branches=true
  start_date="2022-08-15T00:00:00Z"
  end_date="2022-09-15T00:00:00Z"
  workflow="build-workflow"

  url = URI("https://circleci.com/api/v2/insights/#{project_slug}/workflows/#{workflow}?all-branches=#{all_branches}&start-date=#{start_date}&end-date=#{end_date}#{next_page_token && '&page-token=' + next_page_token}")
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  request["Circle-Token"] = ENV["CIRCLE_TOKEN"]

  response = http.request(request)
  JSON.parse(response.read_body)
end

next_page_token=nil
items = []

loop do
  payload = get_data(next_page_token)
  items = items + payload["items"]
  next_page_token = payload["next_page_token"]
  break if next_page_token.nil?
end

puts items.count

# id, duration, status, created_at, stopped_at, credits_used, branch, is_approval
File.write("out.csv", items.first.keys.to_csv)
File.write("out.csv", items.map { |item| item.values.to_csv }.join, mode: 'a')
```
