module V1
  class TransactionsController < ApplicationController
    before_action :load_credit_receiver, only: :create

    def create
      parameters = validate_create_params!
      begin
        transaction = Transaction.transfer(
          parameters[:money], from: parameters[:credit_sender], to: parameters[:credit_receiver]
        )
      rescue ActiveRecord::RecordInvalid => e
        errors_message = "Validation failed: Amount must be greater than or equal to 0"
        if e.message == errors_message && e.record.user && e.record.user == parameters[:credit_sender]
          # Raise clearer error message
          raise Errors::UnprocessableEntity.new(["Insufficient balance"])
        end
      end

      render json: transaction, status: :ok
    end

    private

    def validate_create_params!
      create_params = %w(amount currency_iso credit_receiver_email)
      validate_params_presence!(create_params)
      permitted_params = params.permit(create_params)
      
      {
        money: { amount: permitted_params[:amount].to_i, currency: permitted_params[:currency_iso] },
        credit_sender: current_user,
        credit_receiver: load_credit_receiver
      }
    end

    def load_credit_receiver
      @user ||= User.find_by_email!(params[:credit_receiver_email])
    end
  end
end