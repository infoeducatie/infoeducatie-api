require "rails_helper"

RSpec.describe ContestantsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/contestants").to route_to("contestants#index")
    end

    it "routes to #show" do
      expect(:get => "/contestants/1").to route_to("contestants#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/contestants").to route_to("contestants#create")
    end

    it "routes to #update" do
      expect(:put => "/contestants/1").to route_to("contestants#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/contestants/1").to route_to("contestants#destroy", :id => "1")
    end

  end
end
