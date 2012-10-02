class FacebookUser
  include Mongoid::Document
  field :facebook_id, :type => Integer
  field :name, :type => String
  field :first_name, :type => String
  field :last_name, :type => String
  field :link, :type => String
  field :username, :type => String
  field :gender, :type => String
  field :locale, :type => String
  field :updated_time, :type => DateTime

  paginates_per 50

  def self.get_by_hash(hash)
    @graph = Koala::Facebook::API.new

    fb_user = FacebookUser.where(facebook_id: hash["id"]).first

    user_details = {
      :facebook_id  => hash["id"],
      :name         => hash["name"],
      :first_name   => hash["first_name"],
      :last_name    => hash["last_name"],
      :link         => hash["link"],
      :username     => hash["username"],
      :gender       => hash["gender"],
      :locale       => hash["locale"],
      :updated_time => hash["updated_time"]
    }
    
    if fb_user.nil?
      p "Create new Facebook user.."
      fb_user = FacebookUser.new(user_details)
      fb_user.save
    else
      p "Update Facebook user.."
      fb_user.update(user_details)
    end
    fb_user
  end
end
