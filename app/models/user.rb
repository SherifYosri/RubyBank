class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  include Devise::JWT::RevocationStrategies::Allowlist

  devise :database_authenticatable, :registerable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  #-Associations-----
  has_one :bank_account, dependent: :destroy
  #-----

  #-Validations-----
  validates :name, presence: true
  #-----

  #-Callbacks-----
  after_create do |user|
    user.create_bank_account!(amount: 0, currency: Rails.application.config.default_currency_iso)
  end
  #-----  

  def self.admin_email
    "super_admin@bank_app.com"
  end

  def add_credit(amount, currency = Rails.application.config.default_currency_iso)
    require 'credit_adder'
    CreditAdder.new(self).add(amount, currency)
  end

  def balance
    account = self.bank_account
    balance = if account.present? 
      { amount: account.amount, currency: account.currency}
    else
      { amount: 0, currency: Rails.application.config.default_currency_iso }
    end
    
    balance
  end

  def transactions
    positive_transactions.or(negative_transactions)
  end

  def positive_transactions
    Transaction.where(credit_receiver: self.id)
  end

  def negative_transactions
    Transaction.where(credit_sender: self.id)
  end
end