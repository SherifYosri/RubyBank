class CreateBankAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :bank_accounts do |t|
      t.float :amount
      t.string :currency, default: "usd"
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
