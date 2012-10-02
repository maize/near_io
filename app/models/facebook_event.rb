class FacebookEvent
  include Mongoid::Document

  has_and_belongs_to_many :attending_facebook_users, class_name: "FacebookUser", inverse_of: nil
  has_many :maybe_facebook_users, class_name: "FacebookUser", inverse_of: nil
  has_many :invited_facebook_users, class_name: "FacebookUser", inverse_of: nil

  belongs_to :event

  field :facebook_id, :type => Integer
  field :owner, :type => Hash
  field :name, :type => String
  field :description, :type => String
  field :start_time, :type => DateTime
  field :end_time, :type => DateTime
  field :updated_time, :type => DateTime
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

  def self.get_all_by_facebook_id(facebook_id, access_token)
	@graph = Koala::Facebook::API.new(access_token)

	p "Get Facebook Events.."
	results = @graph.get_connections(facebook_id, "events", :fields => "name, description, owner, venue, location, timezone, start_time, end_time, updated_time, privacy, attending.fields(gender, name, first_name, last_name, link, username, updated_time)")
	fb_events = []

	loop do
		results.each do |hash|
			fb_event = FacebookEvent.where(:facebook_id => hash["id"]).first

			if fb_event.nil?
				p "Create new Facebook event"
        fb_event = FacebookEvent.create(FacebookEvent.parse_details(hash))
			else
				p "Update Facebook event"
        fb_event.update(FacebookEvent.parse_details(hash))
			end

      # Attending
      unless hash["attending"].nil?
        attending = FacebookEvent.parse_event_users(hash["attending"]["data"])
        fb_event.attending = attending.size
        fb_event.attending_facebook_users = attending
        fb_event.save
      end

			fb_events.push(fb_event)
		end

		results = results.next_page
		break if results.nil?
	end

	fb_events
  end

  def self.parse_details(hash)
    parsed_hash = {
      :name => hash["name"],
      :description => hash["description"],
      :owner => hash["owner"],
      :location => hash["location"],
      :venue => hash["venue"],
      :timezone => hash["timezone"],
      :start_time => hash["start_time"],
      :end_time => hash["end_time"],
      :updated_time => hash["updated_time"],
      :privacy => hash["privacy"]
    }
    parsed_hash
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