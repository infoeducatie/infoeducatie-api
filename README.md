infoeducatie-api
================

[![Build Status](https://travis-ci.org/infoeducatie/infoeducatie-api.svg?branch=master)](https://travis-ci.org/infoeducatie/infoeducatie-api) [![Dependency Status](https://gemnasium.com/infoeducatie/infoeducatie-api.svg)](https://gemnasium.com/infoeducatie/infoeducatie-api) [![Code Climate](https://codeclimate.com/repos/550c2ace69568065e600302d/badges/d588df22f658c95f89bb/gpa.svg)](https://codeclimate.com/repos/550c2ace69568065e600302d/feed) [![Test Coverage](https://codeclimate.com/repos/550c2ace69568065e600302d/badges/d588df22f658c95f89bb/coverage.svg)](https://codeclimate.com/repos/550c2ace69568065e600302d/feed)

## Installation

### Prerequisites

* Ruby 2.2.1 - check out [rbenv](https://github.com/sstephenson/rbenv) and
  ruby-build.
* For development and testing - mysql server + bindings.
* Make sure you have _nodejs_ installed since it's necessary for the assets
  pipeline.

### Getting Started

After you have pulled the repo run:

1. ```bundle install```
2. ```cp config/database.yml.sample config/database.yml``` - and make the proper
   edits (like the development database name etc).
3. ```bundle exec rake db:migrate```
3. ```bundle exec rake db:seed``` - for the moment seeds are _disabled_
4. ```bundle exec rails server```
5. Have Fun
