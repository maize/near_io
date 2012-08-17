class Group
  include Mongoid::Document

  has_one :facebook_group, autosave: true
  has_one :facebook_page, autosave: true

  belongs_to :network

  def name
  	unless facebook_group.nil?
  		facebook_group.name
  	else
  		facebook_page.name
  	end
  end

  def facebook_events
    unless self.facebook_group.nil?
      self.facebook_group.facebook_events
    else
      self.facebook_page.facebook_events
    end
  end
end
