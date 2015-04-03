require 'rails_helper'

RSpec.describe "Contestants", type: :request do
  describe "GET /contestants" do
    it "works! (now write some real specs)" do
      get contestants_path
      expect(response).to have_http_status(200)
    end
  end
end
