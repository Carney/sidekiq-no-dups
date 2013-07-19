# SidekiqNoDups

Checks for the existnace of a job on the queue with the same args and doesn't add duplicate jobs.

## Installation

Add this line to your application's Gemfile:

    gem 'sidekiq-no-dups'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sidekiq-no-dups

## Usage

Add `sidekiq_options no_dups: true` to the workers you want to have unique jobs.

```
class MyWorker
  include Sidekiq::Worker
  sidekiq_options no_dups: true

  def perform
    ...
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
