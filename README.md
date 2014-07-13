infoeducatie
============

"Just win baby" - Al Davis

## Installation

### Prerequisites

* Ruby 2.1.0 - check out [rbenv](https://github.com/sstephenson/rbenv) and
  ruby-build.
* For development and testing - mysql server + bindings.
* Make sure you have _nodejs_ installed since it's necessary for the assets
  pipeline.

### Getting Started

After you have pulled the repo run:

1. ```bundle install```
2. ```cp config/database.yml.sample config/database.yml``` - and make the proper
   edits (like the development database name etc).
3. ```rails server``` - Have Fun
