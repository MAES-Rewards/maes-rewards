require 'rails_helper'

RSpec.describe "Rewards", type: :request do
  describe "GET /view" do
    it "returns http success" do
      get "/rewards/view"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/rewards/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/rewards/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /delete" do
    it "returns http success" do
      get "/rewards/delete"
      expect(response).to have_http_status(:success)
    end
  end

end
