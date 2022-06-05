class TransactionSerializer < ActiveModel::Serializer
  attributes :amount, :currency, :credit_sender, :credit_receiver

  def credit_sender
    User.find(object.credit_sender)
  end

  def credit_receiver
    User.find(object.credit_receiver)
  end
end