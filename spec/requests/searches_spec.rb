# spec/requests/searches_spec.rb
require 'rails_helper'

RSpec.describe "Searches", type: :request do
  let(:ip_address) { "1.1.1.1" }

  before do
    allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(ip_address)
  end

  describe "POST /searches" do
    it "creates a new search if term is valid" do
      post "/searches", params: { term: "good car" }, as: :json
      expect(response).to have_http_status(:ok)
      expect(Search.last.term).to eq("good car")
      expect(Search.last.ip_address).to eq(ip_address)
    end

    it "does not create if term is too short" do
      post "/searches", params: { term: "go" }, as: :json
      expect(response).to have_http_status(:bad_request)
    end

    it "does not duplicate search consecutively from same IP" do
      post "/searches", params: { term: "good car" }, as: :json
      expect(response).to have_http_status(:ok)

      expect {
        post "/searches", params: { term: "good car" }, as: :json
      }.not_to change(Search, :count)
    end
  end

  describe "GET /searches/analytics" do
    before do
      Search.create!(term: "ruby", ip_address: "1.1.1.1")
      Search.create!(term: "rails", ip_address: "1.1.1.1")
      Search.create!(term: "ruby", ip_address: "2.2.2.2")
    end

    it "returns most common terms" do
      get "/searches/analytics", as: :json
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.first["term"]).to eq("ruby").or eq("rails")
      expect(json.first["count"]).to be >= 1
    end

    # it "returns filtered results by IP" do
    #   get "/searches/analytics", params: { ip: "1.1.1.1" }, as: :json
    #   expect(response).to have_http_status(:ok)
    #   json = JSON.parse(response.body)
    #   terms = json.map { |e| e["term"] }
    #   expect(terms).to include("ruby", "rails")
    #   expect(terms).not_to include("unknown")
    # end
  end
end
