class Note < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :allocations
  has_many :locations, :through => :allocations
end
