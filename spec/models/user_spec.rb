require 'rails_helper'

describe User, type: :model do
  describe "add_credit" do
    before(:example) do
      @user = FactoryBot.create(:user, :with_bank_account)
    end

    it "should increase credit by the given value" do
      balance_before_adding_credit = @user.balance[:amount]
      amount = 100
      @user.add_credit(amount)
      balance_after_adding_credit = @user.reload.balance[:amount]

      expect(balance_after_adding_credit - balance_before_adding_credit).to eq(amount)
    end

    it "should add a positive transaction to credit receiver transactions" do
      transactions_before_adding_credit = @user.positive_transactions.count
      @user.add_credit(100)
      transactions_after_adding_credit = @user.positive_transactions.count

      expect(transactions_after_adding_credit - transactions_before_adding_credit).to eq(1)
    end

    it "should add a transaction with the amount of the added credit" do
      amount = 100
      @user.add_credit(amount)
      transaction = Transaction.last

      expect(transaction.amount).to eq(amount)
    end

    it "should add a transaction that refers to bank admin as credit sender" do
      amount = 100
      @user.add_credit(amount)
      transaction = Transaction.last
      admin_user_id = User.find_by_email(User.admin_email).id

      expect(transaction.credit_sender).to eq(admin_user_id)
    end
  end
end