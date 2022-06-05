class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.float :amount
      t.string :currency, default: "usd"
      t.bigint :credit_receiver, null: false, foreign_key: true
      t.bigint :credit_sender, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
