module Springcm
  module Middleware
    class AuthExpire
      attr_reader :options

      def initialize(app, options={})
        @app = app
        @options = options
      end

      def call(env)
        @app.call(env).on_complete do |response_env|
          if response_env[:status] == 401
            raise Springcm::AuthExpiredError.new
          end
        end
      end
    end
  end
end
