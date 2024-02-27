require 'rails_helper'

RSpec.describe "SpendTransactions", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/spend_transactions/show"
      expect(response).to have_http_status(:success)
    end
  end

end
