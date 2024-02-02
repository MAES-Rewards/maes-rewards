class CreatePointsEarneds < ActiveRecord::Migration[7.0]
  def change
    create_table :points_earneds do |t|
      t.integer :points

      t.timestamps
    end
  end
end
