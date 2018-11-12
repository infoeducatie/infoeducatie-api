# infoeducatie-api

[![Build Status](https://travis-ci.org/infoeducatie/infoeducatie-api.svg?branch=master)](https://travis-ci.org/infoeducatie/infoeducatie-api)

## Installation

### Prerequisites

Check out:
* [rbenv](https://github.com/sstephenson/rbenv)
* [rvm](https://rvm.io/)

### Getting Started

After you have pulled the repo run:

1. `bundle install`
3. `rake db:migrate`
3. `rake db:seed`
4. `rails server`

### Docker

There are two docker images built from the source. A production one and a staging one. They are published on [Docker Hub](https://hub.docker.com/r/infoeducatie/infoeducatie-api/).

When new code is pushed to any of the two branches the corresponding images are built.

### New contest edition

Due to a missing feature after creating a new edition, all the existing users need to be updated.

 ```
 User.joins("contestants":"edition").where("contestants":{"edition":1}).each {|u| u.update_attribute(:registration_step_number, 1)}
 ```
