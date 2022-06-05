class BankAccount < ApplicationRecord
  belongs_to :user

  #-Validations-----
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  # Initially only USD is supported but a wide currencies range can be supported using rails-money gem
  validates :currency, inclusion: Rails.application.config.supported_currencies
  #-----
end