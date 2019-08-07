require "simplecov"

SimpleCov.start

require "bundler/setup"
require "webmock/rspec"
require "uuid"
require "springcm"
require "support/fake_springcm"
require "support/fake_springcm_auth"
require "support/builders/builder"
require "support/builders/account_builder"
require "support/builders/folder_builder"
require "support/builders/document_builder"
require "support/builders/page_builder"

if ENV.key?("SPEC_SPRINGCM_LIVE")
  WebMock.allow_net_connect!
else
  WebMock.disable_net_connect!(allow_localhost: true)
end

module GlobalContext
  extend RSpec::SharedContext

  let(:data_center) { ENV["SPEC_SPRINGCM_DATA_CENTER"] || "uatna11" }
  let(:client_id) { ENV["SPEC_SPRINGCM_CLIENT_ID"] || "client_id" }
  let(:client_secret) { ENV["SPEC_SPRINGCM_CLIENT_SECRET"] || "client_secret" }
end

RSpec.configure do |config|
  config.include GlobalContext

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  if !ENV.key?("SPEC_SPRINGCM_LIVE")
    config.before(:each) do
      stub_request(:any, /api(download|upload)?(uat)?na11.*\.springcm\.com/).to_rack(FakeSpringcm)
      stub_request(:any, /auth(uat)?\.springcm\.com/).to_rack(FakeSpringcmAuth)
    end
  end
end
