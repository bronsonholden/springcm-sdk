require "bundler/setup"
require "webmock/rspec"
require "springcm"
require "support/fake_springcm"
require "support/fake_springcm_auth"

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
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
