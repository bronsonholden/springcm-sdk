module Springcm
  module Middleware
    class RetryConnectionFailed
      attr_reader :options

      def initialize(app, options={ retries: 5 })
        @app = app
        @options = options
      end

      def call(env)
        retries = @options[:retries]
        delay = 1
        begin
          @app.call(env).on_complete do |response_env|
          end
        rescue Faraday::ConnectionFailed => err
          if retries > 0
            retries -= 1
            sleep delay
            delay *= 2
            retry
          else
            raise err
          end
        end
      end
    end
  end
end
