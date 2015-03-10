# capistrano-shoryuken
Shoryuken integration for Capistrano.  Loosely based on `capistrano-sidekiq`

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-shoryuken', github: 'joekhoobyar/capistrano-shoryuken'

or:

    gem 'capistrano-shoryuken', group: :development

And then execute:

    $ bundle


## Usage
```ruby
    # Capfile

    require 'capistrano/shoryuken'
```


Configurable options, shown here with defaults:

```ruby
    # config/deploy.rb
    :shoryuken_default_hooks => true
    :shoryuken_pid => File.join(shared_path, 'tmp', 'pids', 'shoryuken.pid')
    :shoryuken_env => fetch(:rack_env, fetch(:rails_env, fetch(:stage)))
    :shoryuken_log => File.join(shared_path, 'log', 'shoryuken.log')
    :shoryuken_config => File.join(release_path, 'config', 'shoryuken.yml')
    :shoryuken_options => ['--rails']
    :shoryuken_queue => nil
    :shoryuken_role => :app
```

## Changelog
- 0.1.1: Default --rails option. Support Capistrano 3
- 0.1.0: Support Capistrano 2

## Contributors

- [Joe Khoobyar] (https://github.com/joekhoobyar)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
