require "faraday"

module Springcm
  class Client
    def initialize(data_center:, client_id:, client_secret:)
      if !['na11', 'uatna11'].include?(data_center)
        raise Springcm::ConnectionInfoError.new("Invalid data center '#{data_center.to_s}'")
      end

      @data_center = data_center
      @client_id = client_id
      @client_secret = client_secret
    end
  end
end
