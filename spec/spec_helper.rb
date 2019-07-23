require "simplecov"

SimpleCov.start

require "bundler/setup"
require "webmock/rspec"
require "uuid"
require "springcm"
require "support/fake_springcm"
require "support/fake_springcm_auth"
require "support/builders/builder"
require "support/builders/folder_builder"
require "support/builders/page_builder"

WebMock.disable_net_connect!(allow_localhost: true)

module GlobalContext
  extend RSpec::SharedContext

  let(:data_center) { "uatna11" }
  let(:client_id) { "client_id" }
  let(:client_secret) { "client_secret" }
end

RSpec.configure do |config|
  config.include GlobalContext

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    stub_request(:any, /api(download|upload)?(uat)?na11.*\.springcm\.com/).to_rack(FakeSpringcm)
    stub_request(:any, /auth(uat)?\.springcm\.com/).to_rack(FakeSpringcmAuth)
  end
end
