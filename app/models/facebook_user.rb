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
    user = FacebookUser.new(
      :facebook_id  => hash["id"],
      :name         => hash["name"],
      :first_name   => hash["first_name"],
      :last_name    => hash["last_name"],
      :link         => hash["link"],
      :username     => hash["username"],
      :gender       => hash["gender"],
      :locale       => hash["locale"],
      :updated_time => hash["updated_time"])

    find_user = FacebookUser.where(:facebook_id => user.facebook_id).first
    
    unless find_user.nil?
      user = find_user
    else
      p "Saving new Facebook user.."
      user.save
    end

    user
  end
end
