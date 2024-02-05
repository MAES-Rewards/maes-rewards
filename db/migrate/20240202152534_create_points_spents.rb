class CreatePointsSpents < ActiveRecord::Migration[7.0]
  def change
    create_table :points_spents do |t|
      t.integer :user_id
      t.integer :merchandise_id

      t.timestamps
    end
  end
end
