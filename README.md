# Eventide::Rails

The purpose of this gem is to allow flawless integration of eventide stack (with postgres event store) with your rails application.

NOTE: This is not part of an official eventide stack and is not maintained, opinionated or advised by eventide team. 
 
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'eventide-rails', git: 'https://github.com/hubbado/eventide-rails'
```

And then execute:

    $ bundle

## Getting started

Create file _config/event_store.yml_, which will store all the configuration for your event database.
Unlike pure eventide configuration, this file should have the same format as already familiar _config/database.yml_ file, 
including different environment settings. All the active record options are supported.

Note: `adapter` option is not required, `pg` is used by default.

## Setup types

`eventide-rails` will automatically detect if you are using same database for eventide and active record.
The gem behaviour, especially rake tasks, will be modified depending on that factor. In further documentation, those setup will be refered as
homo- and hetero-db.

## Features

### Rake tasks

#### New tasks:
  - `es:create` - creates and initializes event store database. Initialize only for homo-db setup.
  - `es:init` - initializes event store.
  - `es:drop` - drops event store database. NO-OP for homo-db setup.
  
#### Enhanced tasks:
  - `db:create` - calls `es:create` after run
  - `db:drop` - calls `es:drop` after run.
  - `db:schema:load` - calls `es:initialize` for a homo-db setup.
  
### Schema

`eventide` message store needs `messages` table in the database. If you selected homo-db setup, this table will not be
present in your _schema.rb_ file.
     

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/eventide-rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

### Testing

To run full spec:
1. `$ cp test/config.yml.example test/config.yml`
1. Modify _test/config.yml_ file with your basic database connection information.  
1. Run `rake test`.

It will take a while as it will install all the supported rails version on 
your machine and create two dummy applications per earch rails verison - one for homo- and hetero-db setup.  

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Eventide::Rails project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/eventide-rails/blob/master/CODE_OF_CONDUCT.md).
