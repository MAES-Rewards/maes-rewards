class RewardConfirmations < ActiveRecord::Migration[7.0]
  def change
    create_table :reward_confirmations do |t|
      t.references :spend_transaction, null: false, foreign_key: true
      t.boolean :reward_given, default: false

      t.timestamps
    end
  end
end
