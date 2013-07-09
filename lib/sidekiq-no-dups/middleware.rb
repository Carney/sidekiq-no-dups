require 'sidekiq-no-dups/middleware/client/no_dups'

module SidekiqNoDups
  module Middleware
  end
end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add SidekiqNoDups::Middleware::Client::NoDups
  end
end
