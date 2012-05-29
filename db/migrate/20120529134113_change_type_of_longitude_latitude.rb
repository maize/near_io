class ChangeTypeOfLongitudeLatitude < ActiveRecord::Migration
  def up
    change_table :locations do |t|
      t.change :longitude, :float
      t.change :latitude, :float
    end
  end
  def down
    change_table :tablename do |t|
      t.change :longitude, :integer
      t.change :latitude, :integer
    end
  end
end
