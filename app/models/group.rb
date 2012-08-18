class Group
  include Mongoid::Document

  has_one :facebook_group, autosave: true
  has_one :facebook_page, autosave: true

  belongs_to :network

  def name
  	if not facebook_group.nil?
  		facebook_group.name
    elsif not facebook_page.nil?
      facebook_page.name
    else
      "N/A"
  	end
  end

  def self.update_events
    # TODO: get first user with valid token which is not expired
    user_with_valid_token = User.all.first
    groups = Group.all()
    groups.each do |group|
      p "Update "+group.name
      unless group.facebook_group.nil?
        p "Update events of linked Facebook group.."
        group.facebook_group.get_facebook_events(user_with_valid_token.token)
      end
      unless group.facebook_page.nil?
        p "Update events of linked Facebook page.."
        group.facebook_page.get_facebook_events(user_with_valid_token.token)
      end
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
