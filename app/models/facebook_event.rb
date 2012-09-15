class FacebookEvent
  include Mongoid::Document

  has_and_belongs_to_many :attending_facebook_users, class_name: "FacebookUser"
  has_many :maybe_facebook_users, class_name: "FacebookUser"
  has_many :invited_facebook_users, class_name: "FacebookUser"

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
	results = @graph.get_connections(facebook_id, "events")
	fb_events = []

	loop do
		results.each do |hash|
			fb_event = FacebookEvent.where(:facebook_id => hash["id"]).first
			if fb_event.nil?
				p "Create Facebook event.."
				fb_event = FacebookEvent.get_by_hash(hash)
			else
				p "Found Facebook event in database.."
			end
      fb_event.update_details(access_token)
      fb_event.save

			fb_events.push(fb_event)
		end

		results = results.next_page
		break if results.nil?
	end

	fb_events
  end

  def self.get_by_hash(hash)
    @event = FacebookEvent.new(
      :facebook_id  => hash["id"],
      :name         => hash["name"],
      :location     => hash["location"],
      :timezone     => hash["timezone"],
      :start_time   => hash["start_time"],
      :end_time     => hash["end_time"])

    @find_event = FacebookEvent.where(:facebook_id => @event.facebook_id).first
    
    unless @find_event.nil?
      p "Found Facebook event in database.."
      @event = @find_event
    end

    @event
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

  def update_details(access_token)
  	@graph = Koala::Facebook::API.new(access_token)

  	hash = @graph.get_object(self.facebook_id)
  	hash_details = {
  		:name => hash["name"].to_s,
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

    p "Update details of Facebook event: "+hash["id"].to_s

    self.get_attending

  	self.update(hash_details)
  end

  def get_attending
    attending = @graph.get_connections(self.facebook_id, "attending")
    unless attending.empty? || attending.nil?
      attending_male = []
      attending_female = []
      attending_unknown = []

      p "Getting attending users"
      attending.each do |attending_user|
        user = FacebookUser.get_by_hash(attending_user)
        
        if user.gender == "male"
          attending_male.push(user)
        elsif user.gender == "female"
          attending_female.push(user)
        elsif user.gender.nil? || user.gender.empty?
          attending_unknown.push(user)
        end

        self.attending_facebook_users.push(user)
      end

      self.attending = attending.size
      self.attending_male = attending_male.size
      self.attending_female = attending_female.size
      self.attending_unknown = attending_unknown.size
    end
  end
end