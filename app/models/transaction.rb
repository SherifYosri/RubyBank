class Transaction < ApplicationRecord
  #-Validations-----
  validates :amount, numericality: { greater_than: 0 }
  # Initially only USD is supported but a wide currencies range can be supported using rails-money gem
  validates :currency, inclusion: Rails.application.config.supported_currencies
  #-----

  def self.transfer(money, from:, to:)
    attrs = {
      amount: money[:amount],
      currency: money[:currency],
      credit_sender: from.id,
      credit_receiver: to.id
    }

    ActiveRecord::Base.transaction do
      transaction = Transaction.create!(attrs)
      update_user_balance(from, money.clone, deduction: true)
      update_user_balance(to, money.clone)
      
      transaction
    end
  end

  def self.update_user_balance(user, money, deduction: false)
    require 'user_balance_updater'
    money[:amount] *= -1 if deduction
    UserBalanceUpdater.new(user).update_balance(money[:amount], money[:currency])
  end
end