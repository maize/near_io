class UpdateGroups
  @queue = :groups

  def self.perform
	# TODO: get first user with valid token which is not expired
    user_with_valid_token = User.all.first
    groups = Group.all()
    groups.each do |group|
      p "Update "+group.name
      group.update_details(user_with_valid_token.token)
    end
  end
end