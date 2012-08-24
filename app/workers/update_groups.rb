class UpdateGroups
  @queue = :groups

  def self.perform
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
end