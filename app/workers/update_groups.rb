class UpdateGroups
  @queue = :groups

  def self.perform
	# TODO: get first user with valid token which is not expired
    user_with_valid_token = User.where(:uid => "687223675").first # Facebook account with UID 687223675
    groups = Group.all()
    groups.each do |group|
      p "Update "+group.name
      group.update_details(user_with_valid_token.token)
    end
  end
end