require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "admin screenshot management" do
    it "allows screenshots to be added and removed through nested attributes" do
      nested_options = described_class.nested_attributes_options.fetch(:screenshots)

      expect(nested_options[:allow_destroy]).to eq(true)
      expect(nested_options[:reject_if].call("screenshot" => "")).to eq(true)
      expect(nested_options[:reject_if].call("screenshot" => "new-image.png")).to eq(false)
    end

    it "exposes screenshots in the admin edit form" do
      field = RailsAdmin.config(described_class).edit.fields.detect do |admin_field|
        admin_field.name == :screenshots
      end

      expect(field).not_to be_nil
      expect(field.nested_form[:allow_destroy]).to eq(true)

      screenshot_field = field.associated_model_config.edit.fields.detect do |admin_field|
        admin_field.name == :screenshot
      end
      expect(screenshot_field.html_attributes[:accept]).to eq("image/jpeg,image/png,image/webp")
    end
  end
end
