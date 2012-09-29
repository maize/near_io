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

  def provider
    sources = ""
    if not facebook_group.nil?
      sources += "Facebook Group"
    elsif not facebook_page.nil?
      sources += ", Facebook Page"
    end
    sources
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

    unless fb_events.empty?
      fb_events.each do |fb_event|
        event = Event.where(:external_id => fb_event.facebook_id, :provider => "facebook").first
        if event.nil?
          event = Event.new
          event.external_id = fb_event.facebook_id
          event.facebook_event = fb_event
          event.provider = "facebook"
          event.start_time = fb_event.start_time
          event.end_time = fb_event.end_time
          unless self.events.include?(event)
            self.events.push(event)
          end
        end
      end
      self.save
    end
  end
end
