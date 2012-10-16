class FacebookEvent
  include Mongoid::Document

  has_and_belongs_to_many :attending_facebook_users, class_name: "FacebookUser", inverse_of: nil
  has_and_belongs_to_many :maybe_facebook_users, class_name: "FacebookUser", inverse_of: nil
  has_and_belongs_to_many :declined_facebook_users, class_name: "FacebookUser", inverse_of: nil
  has_and_belongs_to_many :invited_facebook_users, class_name: "FacebookUser", inverse_of: nil

  embedded_in :event

  field :facebook_id, :type => Integer
  field :name, :type => String
  field :owner, :type => Hash
  field :description, :type => String
  field :start_time, :type => Time
  field :end_time, :type => Time
  field :updated_time, :type => Time
  field :location, :type => String
  field :venue, :type => Hash
  field :timezone, :type => String
  field :privacy, :type => String

  field :attending, :type => Integer
  field :attending_male, :type => Integer
  field :attending_female, :type => Integer
  field :attending_unknown, :type => Integer

  field :maybe, :type => Integer
  field :maybe_male, :type => Integer
  field :maybe_female, :type => Integer
  field :maybe_unknown, :type => Integer

  field :declined, :type => Integer
  field :declined_male, :type => Integer
  field :declined_female, :type => Integer
  field :declined_unknown, :type => Integer

  field :invited, :type => Integer
  field :invited_male, :type => Integer
  field :invited_female, :type => Integer
  field :invited_unknown, :type => Integer

  def self.parse_details(hash)
    p "Processing Facebook event: "+hash["id"].to_s
    p hash.to_s
    parsed_hash = {
      :facebook_id => hash["id"],
      :name => hash["name"],
      :description => hash["description"],
      :owner => hash["owner"],
      :location => hash["location"],
      :venue => hash["venue"],
      :timezone => hash["timezone"],
      :start_time => (FacebookEvent.parseFbTime(hash["start_time"]) unless hash["start_time"].nil?),
      :end_time => (FacebookEvent.parseFbTime(hash["end_time"]) unless hash["end_time"].nil?),
      :updated_time => (FacebookEvent.parseFbTime(hash["updated_time"]) unless hash["updated_time"].nil?),
      :privacy => hash["privacy"]
    }
    parsed_hash
  end

  def self.parseFbTime(str)
    parsed = DateTime.new

    p "Parsing time: "+str.to_s
    
    # TODO: this could be improved
    # Simple check for timezone in timestring, e.g. 2012-10-09T18:30:00+0100
    # if str.include?("+")
    #   parsed = DateTime.strptime(str, "%Y-%m-%dT%H:%M:%S %z")
    # else
    #   parsed = DateTime.strptime(str, "%Y-%m-%dT%H:%M:%S")
    # end
    parsed = DateTime.strptime(str, "%Y-%m-%dT%H:%M:%S")

    parsed

    p Time.zone.to_s
    p Time.zone.now.to_s
    p "Parsed time: "+Time.zone.parse(parsed).to_s
  end

  def self.parse_event_users(hash)
    users = []
    unless hash.nil?
      hash.each do |user|
        begin
          user = FacebookUser.get_by_hash(user)
          users.push(user)
        rescue
          p "Error #{$!}"
        end
      end
    end
    users
  end

  def self.get_all_by_facebook_id(facebook_id, access_token)
  	@graph = Koala::Facebook::API.new(access_token)

  	p "Get Facebook Events.."
  	results = @graph.get_connections(facebook_id, "events", 
      :fields => "name, 
                  description, 
                  owner, 
                  venue, 
                  location, 
                  timezone, 
                  start_time, 
                  end_time, 
                  updated_time, 
                  privacy, 
                  attending.fields(gender, name, first_name, last_name, link, username, updated_time), 
                  maybe.fields(gender, name, first_name, last_name, link, username, updated_time), 
                  declined.fields(gender, name, first_name, last_name, link, username, updated_time), 
                  invited.fields(gender, name, first_name, last_name, link, username, updated_time)")
  	fb_events = []

  	loop do
  		results.each do |hash|
        fb_event = FacebookEvent.new(FacebookEvent.parse_details(hash))

        # Attending
        unless hash["attending"].nil?
          attending = FacebookEvent.parse_event_users(hash["attending"]["data"])
          num_hash = FacebookEvent.num_gender(attending)
          fb_event.attending = attending.size
          fb_event.attending_male = num_hash[:male]
          fb_event.attending_female = num_hash[:female]
          fb_event.attending_unknown = num_hash[:unknown]
          fb_event.attending_facebook_users = attending
        end

        # Maybe
        unless hash["maybe"].nil?
          maybe = FacebookEvent.parse_event_users(hash["maybe"]["data"])
          num_hash = FacebookEvent.num_gender(maybe)
          fb_event.maybe = maybe.size
          fb_event.maybe_male = num_hash[:male]
          fb_event.maybe_female = num_hash[:female]
          fb_event.maybe_unknown = num_hash[:unknown]
          fb_event.maybe_facebook_users = maybe
        end

        # Declined
        unless hash["declined"].nil?
          declined = FacebookEvent.parse_event_users(hash["declined"]["data"])
          num_hash = FacebookEvent.num_gender(declined)
          fb_event.declined = declined.size
          fb_event.declined_male = num_hash[:male]
          fb_event.declined_female = num_hash[:female]
          fb_event.declined_unknown = num_hash[:unknown]
          fb_event.declined_facebook_users = declined
        end

        # Invited
        unless hash["invited"].nil?
          invited = FacebookEvent.parse_event_users(hash["invited"]["data"])
          num_hash = FacebookEvent.num_gender(invited)
          fb_event.invited = invited.size
          fb_event.invited_male = num_hash[:male]
          fb_event.invited_female = num_hash[:female]
          fb_event.invited_unknown = num_hash[:unknown]
          fb_event.invited_facebook_users = invited
        end

        # Venue
        fb_event.venue = fb_event.get_venue_details(access_token)

  			fb_events.push(fb_event)
  		end

  		results = results.next_page
  		break if results.nil?
  	end

  	fb_events
  end

  def get_venue_details(access_token)
    @graph = Koala::Facebook::API.new(access_token)

    if not self.venue.nil? and self.venue.has_key?("id")
      venue = @graph.get_object(self.venue["id"].to_s)
    else
      venue = self.venue
    end
  end

  def self.num_gender(attendees)
    m = 0
    f = 0
    u = 0

    attendees.each do |user|
      unless user.gender.nil? or user.gender.empty?
        if user.gender == "male"
          m += 1
        end

        if user.gender == "female"
          f += 1
        end
      else
        u += 1
      end
    end

    hash = {
      :male => m,
      :female => f,
      :unknown => u
    }

    hash
  end

  def percentage_male
    unless self.attending_male.nil? && self.attending_female.nil?
      total = self.attending_male+self.attending_female
      percentage = self.attending_male.to_f/total.to_f * 100.0
      percentage
    else
      0
    end
  end

  def percentage_female
    unless self.attending_male.nil? && self.attending_female.nil?
      total = self.attending_male+self.attending_female
      percentage = self.attending_female.to_f/total.to_f * 100.0
      percentage
    else
      0
    end
  end
end