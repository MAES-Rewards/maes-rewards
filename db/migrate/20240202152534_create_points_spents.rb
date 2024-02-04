class CreatePointsSpents < ActiveRecord::Migration[7.0]
  def change
    create_table :points_spents do |t|

      t.timestamps
    end
  end
end
