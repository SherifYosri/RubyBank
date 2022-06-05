require 'rails_helper'
require 'devise/jwt/test_helpers'

describe V1::TransactionsController, type: :controller do
  describe "POST #create" do
    before(:example) do
      @credit_sender = FactoryBot.create(:user, :with_bank_account)
      @credit_receiver = FactoryBot.create(:user, :with_bank_account)
      add_auth_headers(@credit_sender)
    end

    context 'success' do
      it "should respond with 200" do
        post :create, params: {
          amount: 100,
          currency_iso: "usd",
          credit_receiver_email: @credit_receiver.email
        }
        
        expect(response).to have_http_status(:ok)
        expect(data).to be_an_instance_of(Hash)
      end

      it "should create a transaction and respond with its data" do
        transactions_count_before_calling_endpoint = Transaction.count
        post :create, params: {
          amount: 100,
          currency_iso: "usd",
          credit_receiver_email: @credit_receiver.email
        }
        
        transactions_count_after_calling_endpoint = Transaction.count

        expect(data[:type]).to eq("transactions")
        expect(transactions_count_after_calling_endpoint - transactions_count_before_calling_endpoint).to eq(1)
      end

      it "should increase credit receiver balance by the transfered amount" do
        balance_before_transfer = @credit_receiver.balance[:amount]
        amount = 100

        post :create, params: {
          amount: amount,
          currency_iso: "usd",
          credit_receiver_email: @credit_receiver.email
        }

        balance_after_transfer = @credit_receiver.reload.balance[:amount]

        expect(balance_after_transfer - balance_before_transfer).to eq(amount)
      end

      it "should decrease credit sender balance by the transfered amount" do
        balance_before_transfer = @credit_sender.balance[:amount]
        amount = 100

        post :create, params: {
          amount: amount,
          currency_iso: "usd",
          credit_receiver_email: @credit_receiver.email
        }

        balance_after_transfer = @credit_sender.reload.balance[:amount]

        expect(balance_before_transfer - balance_after_transfer).to eq(amount)
      end
    end

    context 'failure' do
      it "should respond with 400 status code if there are missing parameters" do
        post :create, params: {
          amount: 100,
          credit_receiver_email: @credit_receiver.email
        }

        expect(response).to have_http_status(:bad_request)
      end

       it "should respond with 401 if access token isn't valid" do
        request.headers["Authorization"] = "dummy string"
        post :create, params: {
          amount: 100,
          currency_iso: "usd",
          credit_receiver_email: @credit_receiver.email
        }
        
        expect(response).to have_http_status(:unauthorized)
      end

      it "should respond with 404 status code if credit receiver is not found" do
        post :create, params: {
          amount: 100,
          currency_iso: "usd",
          credit_receiver_email: "dummy"
        }

        expect(response).to have_http_status(:not_found)
      end

      it "should respond with 422 status code if credit sender has insufficient balance" do
        post :create, params: {
          amount: 1e+9,
          currency_iso: "usd",
          credit_receiver_email: @credit_receiver.email
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
