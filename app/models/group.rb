class Group
  include Mongoid::Document

  has_one :facebook_group, autosave: true
  has_one :facebook_page, autosave: true

  has_and_belongs_to_many :networks

  def name
  	if not facebook_group.nil?
  		facebook_group.name
    elsif not facebook_page.nil?
      facebook_page.name
    else
      "N/A"
  	end
  end

  def facebook_events
    unless facebook_group.nil?
      facebook_group.facebook_events
    else
      facebook_page.facebook_events
    end
  end
end
