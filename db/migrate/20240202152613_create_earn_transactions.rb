class CreateEarnTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :earn_transactions do |t|
      t.integer :user_id
      t.integer :activity_id
      t.integer :points

      t.timestamps
    end
  end
end
