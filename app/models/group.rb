class Group
  include Mongoid::Document

  has_one :facebook_group, autosave: true
  has_one :facebook_page, autosave: true

  has_and_belongs_to_many :events, inverse_of: nil, autosave: true
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

  def facebook_id
    if not facebook_group.nil?
      facebook_group.facebook_id
    elsif not facebook_page.nil?
      facebook_page.facebook_id
    end
  end

  def provider
    source = ""
    if not facebook_group.nil?
      source = "Facebook Group"
    elsif not facebook_page.nil?
      source = "Facebook Page"
    end
    source
  end

  def update_details(access_token)
    fb_events = []

    if not self.facebook_group.nil?
      p "Update events of linked Facebook group.."
      fb_events = self.facebook_group.get_facebook_events(access_token)
    elsif not self.facebook_page.nil?
      p "Update events of linked Facebook page.."
      fb_events = self.facebook_page.get_facebook_events(access_token)
    else
      p "Group does not have any links"
    end
    
    self.save
  end
end
