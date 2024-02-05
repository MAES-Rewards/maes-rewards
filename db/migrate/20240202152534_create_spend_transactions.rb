class CreateSpendTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :spend_transactions do |t|
      t.integer :user_id
      t.integer :reward_id

      t.timestamps
    end
  end
end
