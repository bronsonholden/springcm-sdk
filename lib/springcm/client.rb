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
      @api_version = "201411"
      @auth_version = "201606"
    end

    def object_api_url
      "https://api#{@data_center}.springcm.com/v#{@api_version}"
    end

    def upload_api_url
      "https://apiupload#{@data_center}.springcm.com/v#{@api_version}"
    end

    def download_api_url
      "https://apidownload#{@data_center}.springcm.com/v#{@api_version}"
    end

    def auth_url
      "https://auth#{auth_subdomain_suffix}.springcm.com/api/v#{@auth_version}/apiuser"
    end

    private

    def auth_subdomain_suffix
      if @data_center.start_with?('uat')
        'uat'
      else
        ''
      end
    end
  end
end
