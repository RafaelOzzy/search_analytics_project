require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe "POST #create" do
    let(:ip_address) { "123.123.123.123" }

    before do
      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(ip_address)
    end

    it "creates a new search with valid term" do
      expect {
        post :create, params: { term: "good car" }, as: :json
      }.to change(Search, :count).by(1)
    end

    it "does not create search for short term" do
      expect {
        post :create, params: { term: "go" }, as: :json
      }.not_to change(Search, :count)
      expect(response).to have_http_status(:bad_request)
    end

    it "does not duplicate same term for same IP consecutively" do
      post :create, params: { term: "good car" }, as: :json
      expect {
        post :create, params: { term: "good car" }, as: :json
      }.not_to change(Search, :count)
    end
  end

  describe "GET #analytics" do
    before do
      Search.create!(term: "ruby", ip_address: "1.1.1.1")
      Search.create!(term: "rails", ip_address: "1.1.1.1")
      Search.create!(term: "ruby", ip_address: "2.2.2.2")
    end

    it "returns top searched terms" do
      get :analytics, params: { limit: 2 }, as: :json
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      terms = body.map { |item| item["term"] }
      expect(terms).to include("ruby")
    end

    it "filters by IP if param is given" do
      get :analytics, params: { ip: "1.1.1.1" }, as: :json
      body = JSON.parse(response.body)
      terms = body.map { |item| item["term"] }
      expect(terms).to include("ruby", "rails")
      expect(terms).not_to include("unknown")
    end
  end
end
