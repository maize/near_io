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

  def self.get_by_hash(hash)
    fb_user = FacebookUser.where(facebook_id: hash["id"].to_i).first

    if fb_user.nil? || fb_user.gender.nil?
      p "Getting details of Facebook user.."
      hash = @graph.get_object(hash["id"])

      user_details = FacebookUser.new(
        :facebook_id  => hash["id"],
        :name         => hash["name"],
        :first_name   => hash["first_name"],
        :last_name    => hash["last_name"],
        :link         => hash["link"],
        :username     => hash["username"],
        :gender       => hash["gender"],
        :locale       => hash["locale"],
        :updated_time => hash["updated_time"])
      
      
      if fb_user.nil?
        p "Saving new Facebook user.."
        fb_user = user_details
        fb_user.save
      else
        p "Update details of Facebook user.."
        fb_user.update_attributes(user_details)
      end
    else
      p "Found Facebook user with details.."
    end
    fb_user
  end
end
