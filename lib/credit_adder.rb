class CreditAdder
  def initialize(user)
    @user = user
  end

  def add(amount, currency = Rails.application.config.default_currency_iso)
    ActiveRecord::Base.transaction do
      create_transaction(amount, currency)
      update_user_balance(amount, currency)
    end
  end

  private
    def create_transaction(amount, currency)
      admin_user = User.where(email: User.admin_email).select(:id).first
      Transaction.create!(amount: amount, currency: currency, credit_receiver: @user.id, credit_sender: admin_user.id)
    end

    def update_user_balance(amount, currency)
      require 'user_balance_updater'
      UserBalanceUpdater.new(@user).update_balance(amount, currency)
    end
end