class RenameOauthExpirationInUsers < ActiveRecord::Migration
  def change
    rename_column("users", "oauth_expires_at", "oauth_expiry")
  end
end
