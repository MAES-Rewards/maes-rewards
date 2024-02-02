class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :points
      t.string :name
      t.string :email
      t.boolean :is_admin

      t.timestamps
    end
  end
end
