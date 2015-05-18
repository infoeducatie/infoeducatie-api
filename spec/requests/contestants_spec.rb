require 'rails_helper'

RSpec.describe "Contestants", type: :request do
  describe "GET /contestants.json" do
    it "Render all the contestants" do
      get "/contestants.json"
      expect(response).to have_http_status(200)
    end
  end
end
