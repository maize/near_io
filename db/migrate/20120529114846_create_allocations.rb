class CreateAllocations < ActiveRecord::Migration
  def change
    create_table :allocations do |t|
      t.integer :note_id
      t.integer :location_id

      t.timestamps
    end
  end
end
