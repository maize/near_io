class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise  :database_authenticatable,
          :registerable,
          :recoverable,
          :rememberable,
          :trackable,
          :validatable,
          :omniauthable

  ## Database authenticatable
  field :email,               :type => String, :default => ""
  field :encrypted_password,  :type => String, :default => ""
  field :provider,            :type => String

  ## Facebook 
  field :uid,                 :type => String
  field :first_name,          :type => String
  field :last_name,           :type => String
  field :username,            :type => String
  field :gender,              :type => String
  field :hometown,            :type => Hash
  field :location,            :type => String
  field :image,               :type => String
  field :token,               :type => String
  field :expires_at,          :type => Time

  validates_presence_of :email
  validates_presence_of :encrypted_password
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                        provider:auth.provider,
                        uid:auth.uid,
                        email:auth.info.email,
                        password:Devise.friendly_token[0,20],
                        expires_at: auth.credentials.expires_at,
                        token: auth.credentials.token)
    end

    begin
      user.token = User.facebook_oauth_client.get_access_token(auth.credentials.token)
    rescue
      #External api call rescue all!
    end
    user.expires_at = auth.credentials.expires_at
    user.token = auth.credentials.token
    user.save
    user.remember_me!
    user.get_facebook_details
    user
  end

  def get_facebook_details
    @graph = Koala::Facebook::API.new(self.token)
    likes = @graph.get_connections("me", "likes")
    checkins = @graph.get_connections("me", "checkins")
    checkins.each do |checkin|
      p checkin["place"]
      place = Place.where(:facebook_id => checkin["place"]["id"]).first
      unless place
        place = Place.create(name:checkin["place"]["name"],
                            facebook_id:checkin["place"]["id"])
        place.save
      end
    end
  end

  def facebook_config
    YAML.load_file("#{Rails.root}/config/facebook.yml")[Rails.env]
  end

  def facebook_oauth_client
    Koala::Facebook::OAuth.new(User.facebook_config['app_id'],
                               User.facebook_config['secret_key'],
                               "#{User.facebook_config['callback']}/users/auth/facebook/callback")
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
