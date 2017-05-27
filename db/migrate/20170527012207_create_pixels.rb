class CreatePixels < ActiveRecord::Migration[5.1]
  def change
    create_table :pixels do |t|
      t.float :north
      t.float :south
      t.float :east
      t.float :west
      t.string :colour

      t.timestamps
    end
  end
end
