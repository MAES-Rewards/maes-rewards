class CreatePointSources < ActiveRecord::Migration[7.0]
  def change
    create_table :point_sources do |t|
      t.string :name
      t.text :description
      t.integer :default_points

      t.timestamps
    end
  end
end
