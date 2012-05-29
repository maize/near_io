class ChangeNameOfAllocationTabke < ActiveRecord::Migration
    def self.up
        rename_table :allocations, :locations_notes
    end 
    def self.down
        rename_table :locations_notes, :allocations
    end
end
