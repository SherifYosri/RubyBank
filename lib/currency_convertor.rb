module CurrencyConvertor
  def convert_amount_to_user_currency(amount, convert_from:, convert_to:)
    raise NotImplementedError.new("Only USD currency is currently supported")
  end
end