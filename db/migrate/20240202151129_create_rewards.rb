class CreateRewards < ActiveRecord::Migration[7.0]
  def change
    create_table :rewards do |t|
      t.string :name
      t.integer :point_value
      t.decimal :dollar_price
      t.integer :inventory

      t.timestamps
    end
  end
end
