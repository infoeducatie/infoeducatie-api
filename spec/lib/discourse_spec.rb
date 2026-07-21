require "rails_helper"

RSpec.describe Discourse do
  let(:client) { instance_double(DiscourseApi::Client, api_username: "system") }
  subject(:discourse) { described_class.new(client) }

  describe "#publish" do
    it "updates an existing topic with the current client API" do
      allow(client).to receive(:topic).with(42).and_return(
        "post_stream" => {
          "posts" => [{"id" => 7, "username" => "system"}]
        }
      )
      allow(client).to receive(:rename_topic)
      allow(client).to receive(:edit_post)
      allow(client).to receive(:recategorize_topic)

      expect(discourse.publish("Title", "Body", 9, 42)).to eq(42)
      expect(client).to have_received(:rename_topic).with(42, "Title")
      expect(client).to have_received(:edit_post).with(7, "Body")
      expect(client).to have_received(:recategorize_topic).with(42, 9)
    end

    it "creates a replacement when the stored topic no longer exists" do
      allow(client).to receive(:topic).with(42).and_raise(
        DiscourseApi::NotFoundError.new("missing")
      )
      allow(client).to receive(:create_topic).with(
        category: 9,
        title: "Title",
        raw: "Body",
        skip_validations: true
      ).and_return("topic_id" => 77)

      expect(discourse.publish("Title", "Body", 9, 42)).to eq(77)
    end

    it "keeps an existing topic that belongs to a different API user" do
      allow(client).to receive(:create_topic)
      allow(client).to receive(:topic).with(42).and_return(
        "post_stream" => {
          "posts" => [{"id" => 7, "username" => "another-user"}]
        }
      )

      expect(discourse.publish("Title", "Body", 9, 42)).to eq(42)
      expect(client).not_to have_received(:create_topic)
    end
  end

  describe "#delete" do
    it "treats an already removed topic as a successful no-op" do
      allow(client).to receive(:delete_topic).with(42).and_raise(
        DiscourseApi::NotFoundError.new("missing")
      )

      expect(discourse.delete(42)).to be(false)
    end
  end

  describe "without credentials" do
    it "fails closed when publishing" do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("DISCOURSE_API").and_return(nil)
      allow(ENV).to receive(:[]).with("DISCOURSE_USER").and_return(nil)

      expect { described_class.new.publish("Title", "Body", 9) }
        .to raise_error(Discourse::NotConfiguredError)
    end
  end
end
