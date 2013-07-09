module SidekiqNoDups
  module Middleware
    module Client
      class NoDups

        def call(worker_class, item, queue)
          klass = worker_class_constantize(worker_class)
          no_dups = klass.get_sidekiq_options['no_dups'] || item['no_dups']

          if no_dups
            queue = if item['at']
                Sidekiq::ScheduledSet.new
              elsif 'default' != item['queue']
                Sidekiq::Queue.new(item['queue'])
              else
                Sidekiq::Queue.new
              end

            job_exists = queue.select do |job|
              job.item['class'].to_s == worker_class.to_s &&
              job.item['args'] == item['args']
            end.any?

            yield unless job_exists
          else
            yield
          end
        end

        private

          # Attempt to constantize a string worker_class argument, always
          # failing back to the original argument.
          # Duplicates Rails' String.constantize logic for non-Rails cases.
          def worker_class_constantize(worker_class)
            if worker_class.is_a?(String)
              if worker_class.respond_to?(:constantize)
                worker_class.constantize
              else
                # duplicated logic from Rails 3.2.13 ActiveSupport::Inflector
                # https://github.com/rails/rails/blob/9e0b3fc7cfba43af55377488f991348e2de24515/activesupport/lib/active_support/inflector/methods.rb#L213
                names = worker_class.split('::')
                names.shift if names.empty? || names.first.empty?
                constant = Object
                names.each do |name|
                  constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
                end
                constant
              end
            else
              worker_class
            end
          rescue
            worker_class
          end

      end
    end
  end
end
