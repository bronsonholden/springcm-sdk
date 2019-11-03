require "faraday"
require "springcm-sdk/account"
require "springcm-sdk/folder"
require "springcm-sdk/document"

module Springcm
  class Client
    attr_reader :access_token

    # @param data_center [String] Data center name, e.g. uatna11
    # @param client_id [String] Your API client ID
    # @param client_secret [String] Your API client secret
    def initialize(data_center, client_id, client_secret)
      if !["na11", "uatna11", "eu11", "eu21", "na21", "us11"].include?(data_center)
        raise Springcm::ConnectionInfoError.new("Invalid data center '#{data_center.to_s}'")
      end

      @data_center = data_center
      @client_id = client_id
      @client_secret = client_secret
      @api_version = "201411"
      @auth_version = "201606"
      @access_token
    end

    # Connect to the configured SpringCM API service
    # @param safe If truthy, connection failure does not raise an exception
    # @return [Boolean] Whether connection was successful
    def connect(safe=true)
      conn = Faraday.new(url: auth_url)
      res = conn.post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = {
          client_id: @client_id,
          client_secret: @client_secret
        }.to_json
      end
      if res.success?
        data = JSON.parse(res.body)
        @access_token = data.fetch("access_token")
        @expiry = Time.now + data.fetch("expires_in")
      else
        @access_token = nil
        @expiry = nil
        raise Springcm::InvalidClientIdOrSecretError.new if !safe
        return false
      end
    end

    def get_account_info
      conn = authorized_connection(url: object_api_url)
      res = conn.get do |req|
        req.headers["Content-Type"] = "application/json"
        req.url "accounts/current"
      end
      if res.success?
        data = JSON.parse(res.body)
        @account = Springcm::Account.new(data, self)
        true
      else
        false
      end
    end

    def account
      if @account.nil?
        get_account_info
      end
      @account
    end

    # Shorthand for connecting unsafely
    def connect!
      connect(false)
    end

    # Retrieve the root folder in SpringCM
    # @return [Springcm::Folder] The root folder object.
    def root_folder
      conn = authorized_connection(url: object_api_url)
      res = conn.get do |req|
        req.url "folders"
        req.params["systemfolder"] = "root"
      end
      if res.success?
        data = JSON.parse(res.body)
        return Folder.new(data, self)
      else
        nil
      end
    end

    def folder(hash = {})
      if hash.keys.size != 1
        raise ArgumentError.new("Specify exactly one of: path, uid")
      end
      conn = authorized_connection(url: object_api_url)
      res = conn.get do |req|
        if !hash[:path].nil?
          req.url "folders"
          req.params["path"] = hash[:path]
        elsif !hash[:uid].nil?
          req.url "folders/#{hash[:uid]}"
        end
      end
      if res.success?
        data = JSON.parse(res.body)
        return Folder.new(data, self)
      else
        nil
      end
    end

    # Check if client is successfully authenticated
    # @return [Boolean] Whether a valid, unexpired access token is held.
    def authenticated?
      !!@access_token && @expiry > Time.now
    end

    # Get the URL for object API requests
    def object_api_url
      "https://api#{@data_center}.springcm.com/v#{@api_version}"
    end

    # Get the URL for content upload API requests
    def upload_api_url
      "https://apiupload#{@data_center}.springcm.com/v#{@api_version}"
    end

    # Get the URL for content download requests
    def download_api_url
      "https://apidownload#{@data_center}.springcm.com/v#{@api_version}"
    end

    # Get the URL for authentication requests
    def auth_url
      "https://auth#{auth_subdomain_suffix}.springcm.com/api/v#{@auth_version}/apiuser"
    end

    def authorized_connection(*options)
      Faraday.new(*options) do |conn|
        options = [{
          max: 10,
          interval: 1,
          interval_randomness: 0.5,
          backoff_factor: 2,
          retry_statuses: [429]
        }]
        conn.request :retry, *options
        conn.adapter :net_http
        conn.authorization('bearer', @access_token)
      end
    end

    private

    def auth_subdomain_suffix
      if @data_center.start_with?("uat")
        "uat"
      else
        ""
      end
    end
  end
end
