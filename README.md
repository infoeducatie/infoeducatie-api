# infoeducatie-api

[![Build Status](https://travis-ci.org/infoeducatie/infoeducatie-api.svg?branch=master)](https://travis-ci.org/infoeducatie/infoeducatie-api) [![Dependency Status](https://gemnasium.com/infoeducatie/infoeducatie-api.svg)](https://gemnasium.com/infoeducatie/infoeducatie-api) [![Code Climate](https://codeclimate.com/repos/550c2ace69568065e600302d/badges/d588df22f658c95f89bb/gpa.svg)](https://codeclimate.com/repos/550c2ace69568065e600302d/feed) [![Test Coverage](https://codeclimate.com/repos/550c2ace69568065e600302d/badges/d588df22f658c95f89bb/coverage.svg)](https://codeclimate.com/repos/550c2ace69568065e600302d/feed)

## Installation

### Prerequisites

#### Ruby 2.2.1

Check out:
* [rbenv](https://github.com/sstephenson/rbenv)
* [rvm](https://rvm.io/)

### Getting Started

After you have pulled the repo run:

1. `bundle install`
3. `rake db:migrate`
3. `rake db:seed`
4. `rails server`

#### Resetare la trecerea de la o editie la alta
 ```
 User.joins("contestants":"edition").where("contestants":{"edition":1}).each {|u| u.update_attribute(:registration_step_number, 1)}
 ```
 
