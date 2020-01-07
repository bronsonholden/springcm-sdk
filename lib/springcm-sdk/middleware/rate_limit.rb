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
          return response_env if response_env[:response].env.response_headers["Content-Type"] != "application/json"
          body = JSON.parse(response_env[:body])
          if body.fetch("Error", {}).fetch("ErrorCode", nil) == 103
            raise Springcm::RateLimitExceededError.new
          end
        end
      end
    end
  end
end
