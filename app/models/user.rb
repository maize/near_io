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

  # Annotations
  has_and_belongs_to_many :facebook_places, inverse_of: nil, autosave: true
  has_and_belongs_to_many :facebook_likes, inverse_of: nil, autosave: true

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
    user.expires_at = auth.credentials.expires_at
    user.token = auth.credentials.token
    user.save
    user.remember_me!
    user.get_facebook_places
    user.get_facebook_likes
    user
  end

  def get_facebook_places
    unless self.facebook_places.exists?
      @graph = Koala::Facebook::API.new(self.token)

      p "Get Facebook Places via checkins.."
      fb_checkins = @graph.get_connections("me", "checkins")

      loop do
        fb_checkins.each do |hash|
          fb_place = FacebookPlace.where(:facebook_id => hash["place"]["id"]).first
          unless fb_place
            p "Create Facebook place.."
            self.facebook_places.create!(
                :facebook_id        =>hash["place"]["id"],
                :name               =>hash["place"]["name"],
                :location           =>hash["place"]["location"])
          end
        end
        fb_checkins = fb_checkins.next_page
        break if fb_checkins.nil?
      end

      self.save
    end
    self.facebook_places
  end

  def get_facebook_likes
    #unless self.facebook_likes.exists?
      @graph = Koala::Facebook::API.new(self.token)

      p "Get Facebook likes.."
      fb_likes = @graph.get_connections("me", "likes")

      loop do
        fb_likes.each do |hash|
          fb_like = FacebookLike.where(:facebook_id => hash["id"]).first
          unless fb_like
            p "Create Facebook like.."
            l =  self.facebook_places.create!(
                :facebook_id            =>hash["id"],
                :name                   =>hash["name"],
                :facebook_created_time  =>hash["created_time"])
            fb_category = FacebookCategory.where(:name => hash["category"]).first
            unless fb_category
              p "Create Facebook category.."
              fb_category = FacebookCategory.create(name:hash["category"])
            end
            l.facebook_category = fb_category
            l.save
          else
            p "Found Facebook like: "+fb_like.name
            # Update with new category (just in case it changed at some point)
            fb_category = FacebookCategory.where(:name => hash["category"]).first
            unless fb_category
              p "Create Facebook category.."
              fb_category = FacebookCategory.create(name:hash["category"])
            else
              p "Found Facebook category: "+fb_category.name
            end
            fb_like.facebook_category = fb_category
            fb_like.save
          end
        end
        fb_likes = fb_likes.next_page
        break if fb_likes.nil?
      end

      self.save

    #end
    self.facebook_likes
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
