class AddTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token, :string
  end

  User.all.each do |user|
    user.update_column(:token, SecureRandom.urlsafe_base64)
  end
end
