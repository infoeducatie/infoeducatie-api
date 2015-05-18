require 'rails_helper'

RSpec.describe ContestantsController, type: :controller do

  let(:valid_attributes) {
    FactoryGirl.build(:contestant).attributes.symbolize_keys
  }

  let(:invalid_attributes) {
    { :non_valid_address => "Hello test param" }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all contestants as @contestants" do
      contestant = Contestant.create! valid_attributes
      get :index, { :format => 'json' }, valid_session
      expect(assigns(:contestants)).to eq([contestant])
    end
  end

  describe "GET #show" do
    it "assigns the requested contestant as @contestant" do
      contestant = Contestant.create! valid_attributes
      get :show, {
        :id => contestant.to_param,
        :format => 'json'
      }, valid_session
      expect(assigns(:contestant)).to eq(contestant)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Contestant" do
        expect {
          post :create, {
            :contestant => valid_attributes,
            :format => 'json'
          }, valid_session
        }.to change(Contestant, :count).by(1)
      end

      it "assigns a newly created contestant as @contestant" do
        post :create, {
          :contestant => valid_attributes,
          :format => 'json'
        }, valid_session
        expect(assigns(:contestant)).to be_a(Contestant)
        expect(assigns(:contestant)).to be_persisted
      end
    end

    context "with invalid params" do
      # TODO(hurrycane): #38 Investigate what is the best way to handle invalid
      #it "assigns a newly created but unsaved contestant as @contestant" do
      #  post :create, {
      #    :contestant => invalid_attributes,
      #    :format => 'json'
      #  }, valid_session
      #  expect(assigns(:contestant)).to be_a_new(Contestant)
      #end

      #it "re-renders the 'new' template" do
      #  post :create, {
      #    :contestant => invalid_attributes,
      #    :format => 'json'
      #  }, valid_session
      #  expect(response).to render_template("new")
      #end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
          cnp: '1231231230'
        }
      }

      it "updates the requested contestant" do
        contestant = Contestant.create! valid_attributes
        put :update, {
          :id => contestant.to_param,
          :contestant => new_attributes,
          :format => 'json'
        }, valid_session
        contestant.reload
        expect(contestant.cnp).to eq('1231231230')
      end

      it "assigns the requested contestant as @contestant" do
        contestant = Contestant.create! valid_attributes
        put :update, {
          :id => contestant.to_param,
          :contestant => valid_attributes,
          :format => 'json'
        }, valid_session
        expect(assigns(:contestant)).to eq(contestant)
      end

      it "render 200 if update was succesful" do
        contestant = Contestant.create! valid_attributes
        put :update, {
          :id => contestant.to_param,
          :contestant => valid_attributes,
          :format => 'json'
        }, valid_session
        expect(response.status).to eq(200)
      end
    end

    context "with invalid params" do
      # TODO(hurrycane): #38 Investigate what is the best way to handle invalid
      # attributes
      #it "assigns the contestant as @contestant" do
      #  contestant = Contestant.create! valid_attributes
      #  put :update, {
      #    :id => contestant.to_param,
      #    :contestant => invalid_attributes,
      #    :format => 'json'
      #  }, valid_session
      #  expect(assigns(:contestant)).to eq(contestant)
      #end

      #it "renders 422 - unprocessable entry" do
      #  contestant = Contestant.create! valid_attributes
      #  put :update, {
      #    :id => contestant.to_param,
      #    :contestant => invalid_attributes,
      #    :format => 'json'
      #  }, valid_session
      #  expect(response.status).to eq(200)
      #end
    end
  end
end
