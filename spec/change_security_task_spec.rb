require "uuid"

RSpec.describe Springcm::ChangeSecurityTask do
  let(:client) { Springcm::Client.new("uatna11", "client_id", "client_secret") }
  let(:uid) { UUID.generate }
  let(:folder) { FolderBuilder.new(client).build }
  let(:group) { GroupBuilder.new(client).group_type("Security").build }
  let(:builder) { ChangeSecurityTaskBuilder.new(client).uid(uid).folder(folder).group(group) }
  let(:task) { builder.build }

  describe "#await" do
    it "returns false on timeout" do
      expect(task.await(tries: 0)).to eq(false)
    end
  end

  describe "#await!" do
    it "raises error on timeout" do
      expect { task.await!(tries: 0) }.to raise_error(Springcm::ChangeSecurityTaskAwaitTimeout)
    end
  end
end
