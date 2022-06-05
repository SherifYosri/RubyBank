require 'currency_convertor'
include CurrencyConvertor

class UserBalanceUpdater
  def initialize(user)
    @user = user
  end

  def update_balance(amount, currency)
    bank_account = @user.bank_account
    if currency != bank_account.currency
      amount = convert_amount_to_user_currency(amount, convert_from: currency, convert_to: bank_account.currency)
    end
    bank_account.amount += amount
    bank_account.save!

    bank_account
  end
end
