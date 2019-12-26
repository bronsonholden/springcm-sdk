module Springcm
  module Middleware
    class RateLimit
      attr_reader :options

      def initialize(app, options={})
        @app = app
        @options = options
      end

      def call(env)
        @app.call(env).on_complete do |response_env|
          body = JSON.parse(response_env[:body])
          if body.fetch("Error", {}).fetch("ErrorCode", nil) == 103
            raise Springcm::RateLimitExceededError.new
          end
        end
      end
    end
  end
end
