require "simplecov"

SimpleCov.start

require "bundler/setup"
require "webmock/rspec"
require "uuid"
require "springcm-sdk"
require "support/fake_springcm"
require "support/fake_springcm_auth"
require "support/fake_springcm_content"
require "support/builders/builder"
require "support/builders/account_builder"
require "support/builders/folder_builder"
require "support/builders/document_builder"
require "support/builders/page_builder"
require "support/builders/history_item_builder"
require "support/builders/attribute_group_builder"
require "support/builders/group_builder"
require "support/builders/user_builder"
require "support/builders/change_security_task_builder"

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
      stub_request(:any, /api(download|upload)?(uat)?na11.*\.springcm\.com/).to_rack(FakeSpringcmContent)
      stub_request(:any, /api(uat)?na11.*\.springcm\.com/).to_rack(FakeSpringcm)
      stub_request(:any, /auth(uat)?\.springcm\.com/).to_rack(FakeSpringcmAuth)
    end
  end
end
